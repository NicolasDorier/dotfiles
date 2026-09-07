hl.unbind("ALT + TAB")
o.bind("ALT + TAB", nil, hl.dsp.focus({ last = true }))

hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")

local switch_origin_address

o.bind("SUPER + TAB", nil, function()
	local active = hl.get_active_window()
	if not active then
		return
	end

	switch_origin_address = active.address
	if active.fullscreen == 1 then
		hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized" }))
	end

	hl.exec_cmd("notify-send 'Switch mode on'")
	hl.dispatch(hl.dsp.submap("switching"))
end)

hl.define_submap("switching", function()
	local function select_window()
		local selected = hl.get_active_window()

		if switch_origin_address then
			hl.dispatch(hl.dsp.focus({ window = "address:" .. switch_origin_address }))
		end
		if selected then
			hl.dispatch(hl.dsp.focus({ window = "address:" .. selected.address }))
			if selected.fullscreen == 0 then
				hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized" }))
			end
		end

		switch_origin_address = nil
		hl.exec_cmd("notify-send 'Switch mode off'")
		hl.dispatch(hl.dsp.submap("reset"))
	end

	o.bind("SPACE", nil, select_window)
	o.bind("RETURN", nil, select_window)

	o.bind("SUPER + LEFT", "Move focus left", hl.dsp.focus({ direction = "l" }))
	o.bind("SUPER + RIGHT", "Move focus right", hl.dsp.focus({ direction = "r" }))
	o.bind("SUPER + UP", "Move focus up", hl.dsp.focus({ direction = "u" }))
	o.bind("SUPER + DOWN", "Move focus down", hl.dsp.focus({ direction = "d" }))
	o.bind("LEFT", "Move focus left", hl.dsp.focus({ direction = "l" }))
	o.bind("RIGHT", "Move focus right", hl.dsp.focus({ direction = "r" }))
	o.bind("UP", "Move focus up", hl.dsp.focus({ direction = "u" }))
	o.bind("DOWN", "Move focus down", hl.dsp.focus({ direction = "d" }))
	o.bind("H", "Move focus left", hl.dsp.focus({ direction = "l" }))
	o.bind("L", "Move focus right", hl.dsp.focus({ direction = "r" }))
	o.bind("K", "Move focus up", hl.dsp.focus({ direction = "u" }))
	o.bind("J", "Move focus down", hl.dsp.focus({ direction = "d" }))

	o.bind("TAB", "Cycle to next window", hl.dsp.window.cycle_next())
	o.bind("SUPER + TAB", "Cycle to next window", function()
		hl.dispatch(hl.dsp.window.cycle_next())
		hl.dispatch(hl.dsp.window.bring_to_top())
	end)
	o.bind("SUPER + SHIFT + TAB", "Cycle to prev window", function()
		hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
		hl.dispatch(hl.dsp.window.bring_to_top())
	end)
	o.bind("ALT + TAB", "Cycle to next window", hl.dsp.window.cycle_next())
	o.bind("ALT + SHIFT + TAB", "Cycle to prev window", hl.dsp.window.cycle_next({ next = false }))

	o.bind("ESCAPE", nil, function()
		switch_origin_address = nil
		hl.exec_cmd("notify-send 'Switch mode off'")
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	o.bind("D", "Close window", hl.dsp.window.close())
end)
