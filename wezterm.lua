-- Pull in the wezterm API
local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder()

-- Initial geometry for new windows
config.initial_cols = 120
config.initial_rows = 28

config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14.0

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = true

config.window_padding = {
	left = 0,
	right = 0,
	top = 10,
	bottom = 7.5,
}

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh.exe", "-NoLogo" }

	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "pwsh.exe", "-NoLogo" },
	})

	table.insert(launch_menu, {
		label = "Bash Login",
		args = { "bash", "-l" },
	})

	-- Find installed visual studio version(s) and add their compilation
	-- environment command prompts to the menu
	for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
		local year = vsvers:gsub("Microsoft Visual Studio/", "")
		table.insert(launch_menu, {
			label = "x64 Native Tools VS " .. year,
			args = {
				"cmd.exe",
				"/k",
				"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
			},
		})
	end
end

config.launch_menu = launch_menu

config.front_end = "WebGpu"

-- config.colors = {
-- 	foreground = "#00FF00",
-- 	cursor_bg = "#00FF00",
-- 	cursor_fg = "#000000",
-- }

config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 750

config.window_frame = {
	active_titlebar_bg = "#090909",
	-- font = fonts.font,
	-- font_size = fonts.font_size,
}

config.background = {
	{
		source = {
			File = {
				path = wezterm.config_dir .. "/backdrops/door.png",
			},
		},

		hsb = { brightness = 0.05 },
		opacity = 1,
	},
}

config.keys = {
	-- 1. Splitting Panes (CMD + d for vertical, CMD + SHIFT + d for horizontal)
	{
		key = "d",
		mods = "SUPER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "SUPER|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- 2. Closing Panes (CMD + w closes current pane or tab)
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	-- 3. Navigating Panes using Vim Motions (ALT + h/j/k/l)
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- 4. Resizing Panes (ALT + SHIFT + h/j/k/l)
	{ key = "h", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "l", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "k", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "j", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- 5. Managing Tabs (CMD + t for new tab, CMD + [ or ] to navigate)
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "CMD", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "]", mods = "CMD", action = wezterm.action.ActivateTabRelative(1) },

	{ key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },
}

return config
