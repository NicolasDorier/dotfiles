-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

hl.unbind("SUPER + L")
o.bind("SUPER + L", nil, "omarchy-system-lock")
o.bind("SUPER + SHIFT + L", nil, "systemctl suspend", { locked = true })

hl.unbind("F9")
hl.unbind("SUPER + SHIFT + SLASH")
o.bind("SUPER + SHIFT + SLASH", nil, hl.dsp.focus({ workspace = "name:pwd-manager" }))

hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", nil, hl.dsp.focus({ workspace = "name:evernote" }))

hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", nil, hl.dsp.focus({ workspace = "name:obsidian" }))

hl.unbind("SUPER + SHIFT + X")
o.bind("SUPER + SHIFT + X", nil, hl.dsp.focus({ workspace = "name:social" }))

hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", nil, hl.dsp.focus({ workspace = "name:productivity" }))

hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", nil, hl.dsp.focus({ workspace = "5" }))

hl.unbind("SUPER + R")
o.bind("SUPER + R", nil, hl.dsp.focus({ workspace = "name:scratch" }))

hl.unbind("SUPER + GRAVE")
o.bind("SUPER + GRAVE", nil, hl.dsp.focus({ workspace = "name:terminal" }))

hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", nil, hl.dsp.focus({ workspace = "name:music" }))

hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", nil, hl.dsp.focus({ workspace = "name:img" }))

hl.unbind("SUPER + SHIFT + N")
o.bind("SUPER + SHIFT + N", nil, hl.dsp.window.move({ workspace = "empty" }))

hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", "uwsm-app -- typora --enable-wayland-ime")

hl.config({
  binds = {
    workspace_back_and_forth = true,
    hide_special_on_workspace_change = true,
  },
  misc = {
    middle_click_paste = true,
    background_color = "0x000000",
  },
})

hl.unbind("ALT + TAB")
o.bind("ALT + TAB", nil, "~/.config/hypr/scripts/swap_focus.sh focusactivetolast")

hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.bind("SUPER + TAB", nil, "~/.config/hypr/scripts/swap_focus.sh switch")
o.bind("SUPER + TAB", nil, hl.dsp.submap("switching"))

hl.define_submap("switching", function()
  o.bind("SPACE", nil, "~/.config/hypr/scripts/swap_focus.sh select")
  o.bind("SPACE", nil, hl.dsp.submap("reset"))
  o.bind("RETURN", nil, "~/.config/hypr/scripts/swap_focus.sh select")
  o.bind("RETURN", nil, hl.dsp.submap("reset"))

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
  o.bind("SUPER + TAB", "Cycle to next window", hl.dsp.window.cycle_next())
  o.bind("SUPER + SHIFT + TAB", "Cycle to prev window", hl.dsp.window.cycle_next({ next = false }))
  o.bind("ALT + TAB", "Cycle to next window", hl.dsp.window.cycle_next())
  o.bind("ALT + SHIFT + TAB", "Cycle to prev window", hl.dsp.window.cycle_next({ next = false }))

  o.bind("SUPER + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
  o.bind("SUPER + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
  o.bind("ESCAPE", nil, o.notify("Switch mode off"))
  o.bind("ESCAPE", nil, hl.dsp.submap("reset"))
  o.bind("D", "Close window", hl.dsp.window.close())
end)
