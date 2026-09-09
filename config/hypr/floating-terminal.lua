-- Workspace-local floating terminal groups for the bindings in hypr/bindings.lua.
--
-- Design constraints and tested Hyprland 0.56.2 behavior:
-- - Only windows launched here receive the "floating-terminal" tag. Ordinary
--   terminals must never be adopted into these groups.
-- - The first terminal is centered at 80% of its monitor and starts a locked
--   group. Locking prevents subsequently launched unrelated apps from joining.
-- - Additional terminals inherit the existing group's size; never resize them
--   during insertion because resizing one grouped member resizes the container.
-- - The app-aware terminal launcher derives its cwd from the active app, so an
--   existing group member is focused shortly before launching another member.
-- - Hyprland applies focus, group, and lock changes asynchronously. The polling
--   below intentionally performs those transitions across separate timer ticks.
-- - hl.dsp.group.lock({ window = ... }) did not change the requested group in
--   testing. Focus the group and use hl.dsp.group.lock_active() instead.
-- - Do not use a "barred" rule on later terminals: it can make group:add()
--   reject them. Do not use "lock always": it prevents the temporary unlock
--   needed for insertion. "new lock" is intentional.
-- - Moving one grouped member to another workspace moves the whole group.
-- - Hiding uses a special workspace keyed by the home workspace ID. The group
--   can therefore only be restored to the workspace from which it was hidden.

local M = {}

local terminal_command = (os.getenv("HOME") or "") .. "/.local/bin/launch-terminal-from-app-cwd"

-- This is runtime-only state and is reset whenever Hyprland reloads the config.
-- Keying by workspace ID keeps focus restoration independent per home workspace.
local previous_focus = {}

local function window_has_tag(window, expected)
	-- Dynamic tags exposed by Hyprland have a trailing "*"; rule names do not.
	for _, tag in ipairs(window.tags or {}) do
		if tag:gsub("%*$", "") == expected then
			return true
		end
	end

	return false
end

local function find_tagged_window(workspace, tag)
	if not workspace then
		return nil
	end

	for _, window in ipairs(hl.get_workspace_windows(workspace)) do
		if window_has_tag(window, tag) then
			return window
		end
	end

	return nil
end

local function workspace_destination(workspace)
	-- Numeric workspace selectors are bare numbers. Named workspaces require the
	-- "name:" prefix or Hyprland may interpret the destination differently.
	if workspace.name:match("^%d+$") then
		return workspace.name
	end

	return "name:" .. workspace.name
end

local function remember_focus(workspace)
	local active_window = hl.get_active_window()
	-- Opening another group tab must not replace the remembered non-group window.
	if active_window and not window_has_tag(active_window, "floating-terminal") then
		previous_focus[workspace.id] = active_window.address
	end
end

local function restore_focus(workspace)
	local previous_address = previous_focus[workspace.id]
	if not previous_address then
		return
	end

	previous_focus[workspace.id] = nil
	-- Moving the group away changes focus asynchronously. Delay restoration and
	-- verify that the old window still exists on the expected home workspace.
	hl.timer(function()
		local previous_window = hl.get_window("address:" .. previous_address)
		if previous_window and previous_window.workspace and previous_window.workspace.id == workspace.id then
			hl.dispatch(hl.dsp.focus({ window = previous_window }))
		end
	end, { timeout = 50, type = "oneshot" })
end

function M.toggle()
	local home_workspace = hl.get_active_workspace()
	if not home_workspace then
		return
	end

	local hidden_workspace_name = "floating-terminal-" .. tostring(home_workspace.id)
	local visible_terminal = find_tagged_window(home_workspace, "floating-terminal")
	if visible_terminal then
		-- Moving the selected member preserves the active tab across the move.
		visible_terminal = visible_terminal.group and visible_terminal.group.current or visible_terminal
		hl.dispatch(hl.dsp.window.move({
			window = visible_terminal,
			workspace = "special:" .. hidden_workspace_name,
			follow = false,
		}))
		restore_focus(home_workspace)
		return
	end

	local hidden_workspace = hl.get_workspace("special:" .. hidden_workspace_name)
	local hidden_terminal = find_tagged_window(hidden_workspace, "floating-terminal")
	if hidden_terminal then
		hidden_terminal = hidden_terminal.group and hidden_terminal.group.current or hidden_terminal
		-- Save focus immediately before showing the group so hiding it restores the
		-- exact window that was active, not merely Hyprland's next focus candidate.
		remember_focus(home_workspace)
		hl.dispatch(hl.dsp.window.move({
			window = hidden_terminal,
			workspace = workspace_destination(home_workspace),
			follow = true,
		}))
		return
	end

	M.open()
end

function M.open()
	local workspace = hl.get_active_workspace()
	if not workspace then
		return
	end

	local known_floating_terminals = {}
	local target
	for _, window in ipairs(hl.get_workspace_windows(workspace)) do
		if window_has_tag(window, "floating-terminal") then
			-- Addresses distinguish the asynchronously created window from members
			-- that existed before this invocation. Prefer a member already grouped.
			known_floating_terminals[window.address] = true
			if window.group or not target then
				target = window
			end
		end
	end

	if not target then
		-- The first terminal takes focus, so remember what should regain focus when
		-- the new group is hidden.
		remember_focus(workspace)
	end

	local launch_rules = {
		float = true,
		tag = "+floating-terminal",
	}

	if target then
		-- Focus before launch so Omarchy inherits this terminal's cwd. Wait one tick
		-- before exec so the compositor has applied the focus transition.
		hl.dispatch(hl.dsp.focus({ window = target }))
		hl.timer(function()
			hl.exec_cmd(terminal_command, launch_rules)
		end, { timeout = 50, type = "oneshot" })

		local attempts = 0
		local timer
		-- Poll for at most five seconds. A window-open event is not used because the
		-- terminal tag and final rule state must be available before identification.
		timer = hl.timer(function()
			attempts = attempts + 1
			if attempts >= 100 then
				timer:set_enabled(false)
				return
			end

			local new_terminal
			for _, window in ipairs(hl.get_workspace_windows(workspace)) do
				if window_has_tag(window, "floating-terminal") and not known_floating_terminals[window.address] then
					new_terminal = window
					break
				end
			end

			if not new_terminal then
				return
			end

			if new_terminal.group == target.group then
				-- Insertion is complete. Select the newcomer itself before relocking;
				-- accepting any active group member leaves the previous tab visible.
				local active_window = hl.get_active_window()
				if not active_window or active_window.address ~= new_terminal.address then
					hl.dispatch(hl.dsp.focus({ window = new_terminal }))
					return
				end

				if not target.group.locked then
					hl.dispatch(hl.dsp.group.lock_active())
				end
				timer:set_enabled(false)
			elseif new_terminal.group then
				-- Defensive recovery if another rule placed the newcomer elsewhere.
				-- Wait for the move-out dispatcher before attempting insertion again.
				hl.dispatch(hl.dsp.window.move({ window = new_terminal, out_of_group = true }))
			elseif target.group and target.group.locked then
				-- A locked group correctly rejects unrelated apps, but must be unlocked
				-- briefly for this tagged terminal. lock_active requires group focus.
				local active_window = hl.get_active_window()
				if not active_window or active_window.group ~= target.group then
					hl.dispatch(hl.dsp.focus({ window = target }))
				else
					hl.dispatch(hl.dsp.group.lock_active())
				end
			elseif target.group then
				-- Do not resize after this call: the new tab adopts the group's geometry.
				target.group:add(new_terminal)
			end
		end, { timeout = 50, type = "repeat" })
		return
	end

	-- Only the first terminal receives initial geometry. "new lock" creates a
	-- lock that can later be toggled; "lock always" cannot be temporarily opened.
	launch_rules.center = true
	launch_rules.group = "new lock"
	launch_rules.size = { "monitor_w * 0.8", "monitor_h * 0.8" }
	hl.exec_cmd(terminal_command, launch_rules)
end

return M
