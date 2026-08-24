-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 0,
	},

	animations = {
		enabled = true,
	},

	decoration = {
		rounding = 8,
		inactive_opacity = 0.9,
		active_opacity = 1.0,
		fullscreen_opacity = 1.0,
		dim_modal = false,
		dim_special = 0.5,
		blur = {
			enabled = true,
			ignore_opacity = true,
			size = 10,
			special = false,
		},
	},
})

o.window({ tag = "default-opacity" }, { opacity = "1 1" })

hl.layer_rule({
	name = "notifications-lr",
	match = { namespace = "notifications" },
	blur = true,
	ignore_alpha = 0,
})
