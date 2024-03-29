# Toggle Theme
Toggle between Light and Dark themes/schemes with minimal code.


## Description
The goal of this project is to be as minimal as possible.

Even though it is possible to implement a profile based solution (e.g. user may define a summer or winter profile), on the current circumstances this is not implemented. Instead, only one dark theme and light theme can be chosen.

## Screenshot
![showcase](showcase.gif)

## Requirements
Neovim

## Dependencies
None

## Installation
Lazy:
```lua
"The-Plottwist/nvim-toggletheme"
```

## Usage
Please add the below line to your init.lua after your theme setups (if you have any):

```lua
require("toggletheme").setup()
```

Then set your themes (only needed once):

```lua
:SetDarkTheme YOUR_THEME_HERE
:SetLightTheme YOUR_THEME_HERE
```

If your currently active theme is different from the chosen ones, you also need to run:
```lua
:ToggleTheme
```

You can view your themes with:
```lua
:ListActiveThemes
```

## Notes
* You may need to close and re-enter Neovim after toggling (some plugins needs refreshment)
* You can find the config file with:
	```lua
	:lua print(vim.fn.stdpath("config") .. "/default_themes.txt")
	```

* This plugin supports [lualine](https://github.com/nvim-lualine/lualine.nvim) refresh.

## Contributing
I'm open to pull requests.
