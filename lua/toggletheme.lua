---@diagnostic disable: undefined-global

-- ╔══════════════════════════════════════════════════════════╗
-- ║                       TOGGLE THEME                       ║
-- ╚══════════════════════════════════════════════════════════╝
-- ╭──────────────────────────────────────────────────────────╮
-- │ Toggle between light and dark themes.                    │
-- │ Pro tip: This plugin does not change your default        │
-- │  theme which can be used as a fallback.                  │
-- ╰──────────────────────────────────────────────────────────╯


local M = {}


-- ┌       ┐
-- │ FLAGS │
-- └       ┘
local IS_CONFIG_WRITABLE = false

-- ┌         ┐
-- │ GLOBALS │
-- └         ┘
local CONFIG_DIR = vim.fn.stdpath("config")
local CONFIG_FILE = CONFIG_DIR .. "/default_themes.txt"

local LIGHT_THEME = "NULL"
local DARK_THEME  = "NULL"
local CURRENT_THEME = vim.g.colors_name	--will be modified within the setup()


-- ┌           ┐
-- │ FUNCTIONS │
-- └           ┘
-- https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
local function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then -- Permission denied, but it exists
			return true
		end
	end

	return ok, err
end

local function generate_config_file()
	if IS_CONFIG_WRITABLE then
		local file = io.open(CONFIG_FILE, 'w')
		if file ~= nil then
			file:write(LIGHT_THEME, '\n')
			file:write(DARK_THEME, '\n')
			file:write(CURRENT_THEME, '\n')
			io.close(file)
		end
	end
end

function M.set_light_theme(theme_name)
	LIGHT_THEME = theme_name
	generate_config_file()
end

function M.set_dark_theme(theme_name)
	DARK_THEME = theme_name
	generate_config_file()
end

function M.toggle_theme()
	if ( DARK_THEME == "NULL" ) or ( LIGHT_THEME == "NULL" ) then
		vim.notify("Please set a light & dark theme!", "error", { title = "Toggle Theme" })
		return
	end

	if CURRENT_THEME == LIGHT_THEME then
		CURRENT_THEME = DARK_THEME
	else
		CURRENT_THEME = LIGHT_THEME
	end

	vim.cmd("colorscheme " .. CURRENT_THEME)
	generate_config_file()

	--refresh lualine
	if package.loaded["lualine"] then
		require("lualine").refresh()
	end
end

function M.setup()
	--check if exists
	if not exists(CONFIG_FILE) then
		local file = io.open(CONFIG_FILE, 'w+')
		if (file ~= nil) then
			file:write(LIGHT_THEME, '\n')
			file:write(DARK_THEME, '\n')
			file:write(CURRENT_THEME, '\n')
			io.close(file)
		else
			vim.notify("Cannot make " .. CONFIG_FILE .. '!', "error", { title = "Toggle Theme" })
			vim.notify("Please make it yourself & make sure it has r+w access!", "error", { title = "Toggle Theme" })
			return
		end
	else --read themes
		local file = io.open(CONFIG_FILE, 'r')
		if file ~= nil then
			LIGHT_THEME = file:read()		--read first line
			DARK_THEME = file:read()		--read second line
			CURRENT_THEME = file:read()		--read third line
			io.close(file)

			vim.cmd("colorscheme " .. CURRENT_THEME)	--set theme
		else
			vim.notify("Cannot open " .. CONFIG_FILE .. '!', "error", { title = "Toggle Theme" })
			vim.notify("Please make sure it has r+w access!", "error", { title = "Toggle Theme" })
			return
		end
	end

	IS_CONFIG_WRITABLE = true
end

function M.list_active_themes()
	vim.notify(
		"Dark Theme: " .. DARK_THEME ..
		"\nLight Theme: " .. LIGHT_THEME ..
		"\nCurrent Theme: " .. CURRENT_THEME,
		"info",
		{ title = "Toggle Theme"}
	)
end


-- Make user commands
vim.cmd('command! -nargs=0 ToggleTheme lua require("toggletheme").toggle_theme()')
vim.cmd('command! -nargs=0 ListActiveThemes lua require("toggletheme").list_active_themes()')
vim.cmd('command! -nargs=1 SetLightTheme lua require("toggletheme").set_light_theme("<args>")')
vim.cmd('command! -nargs=1 SetDarkTheme lua require("toggletheme").set_dark_theme("<args>")')

return M

