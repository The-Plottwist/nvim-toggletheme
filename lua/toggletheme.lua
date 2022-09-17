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
		vim.notify("Theme-config: Please set a light & dark theme!", "error")
		return
	end

	if CURRENT_THEME == LIGHT_THEME then
		CURRENT_THEME = DARK_THEME
	else
		CURRENT_THEME = LIGHT_THEME
	end

	vim.cmd("colorscheme " .. CURRENT_THEME)
	require("lualine").refresh()
	generate_config_file()
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
			vim.notify("Theme-config: Cannot make " .. CONFIG_FILE .. '!', "error")
			vim.notify("Theme-config: Please make it yourself & make sure it has r+w access!", "error")
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
			vim.notify("Theme-config: Cannot open " .. CONFIG_FILE .. '!', "error")
			vim.notify("Theme-config: Please make sure it has r+w access!", "error")
			return
		end
	end

	IS_CONFIG_WRITABLE = true
end

-- Make user commands
vim.api.nvim_create_user_command("ToggleTheme", M.toggle_theme, {})
vim.api.nvim_create_user_command("SetDarkTheme", M.set_dark_theme, {})
vim.api.nvim_create_user_command("SetLightTheme", M.set_light_theme, {})

return M

