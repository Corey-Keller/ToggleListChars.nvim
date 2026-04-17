# ToggleListChars.nvim

![Neovim](https://img.shields.io/badge/Neovim-0.7+-blue.svg)
![License](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)

A lightweight, modern Neovim plugin written in Lua to painlessly configure and toggle individual `listchars`. 

Instead of messing with long, hard-to-read `set listchars=...` strings, this plugin lets you define your preferred symbols and active states using clean Lua tables. It provides a simple, autocomplete-friendly command to toggle specific invisible characters on the fly.

## Features
* **Granular Control:** Toggle specific characters (like `space`, `tab`, or `trail`) on and off individually without overwriting or breaking the rest of your `listchars`.
* **Smart Insert Mode:** Automatically hides trailing spaces when you enter Insert mode so your screen isn't cluttered while actively typing, then instantly restores them when you leave Insert mode.
* **Native Lua Tables:** No string parsing. Configure everything using standard Neovim Lua tables.
* **Zero Boilerplate:** Automatically manages the global vim.opt.list state for you. No extra configuration required to make the characters visible.
* **Autocomplete Command:** Includes `:ToggleListChars` with built-in argument completion for your configured characters.

## Requirements
  * Neovim >= 0.7.0 (Relies on modern `vim.api.nvim_create_autocmd` API)
  * A [Nerd Font](https://www.nerdfonts.com/) or a font with good Unicode support (required for the default symbols to render correctly).
    
## Installation

Here is how to install and configure the plugin using [lazy.nvim](https://github.com/folke/lazy.nvim). 

If you keep your plugins in separate files (e.g., inside a `lua/plugins/` directory), return this table. If you keep all plugins in one list, simply add this table to it:

```lua
{
    "Corey-Keller/ToggleListChars.nvim",
    -- Load immediately when Neovim UI enters to avoid empty listchars on a blank start buffer
    -- Explicitly tell lazy where to find the setup function
    main = "togglelistchars",
    event = "UIEnter",
    -- The `opts` table is automatically passed into your `require("togglelistchars").setup(opts)`
    opts = {
        -- Override default active states
        active = {
            space = false, -- Just an example of overriding
        },
        symbols = {
            trail = "▫", -- Example of swapping a default symbol from your config
        },
        -- Disable the auto-hide feature in Insert mode
        hide_trailing_in_insert = false,
    },
    -- Optional: Define your keymaps here for lazy-loading
    keys = {
        { "<leader>tt", function() require("togglelistchars").toggle("trail") end, desc = "Toggle trailing spaces" },
        { "<leader>ts", function() require("togglelistchars").toggle("space") end, desc = "Toggle visible spaces" },
    },
}
```
## Usage
The plugin exposes a user command to toggle characters during your session. You can type this directly in the command line (it supports `<Tab>` auto-completion for valid characters!):
```vim
:ToggleListChars <character>
```
Example: `:ToggleListChars space` or `:ToggleListChars trail`

### Keymaps
You can easily map the toggle function to your preferred keybindings using Neovim's standard Lua API:

```lua
-- Example: Toggle trailing spaces with <leader>tt
vim.keymap.set('n', '<leader>tt', function()
    require("togglelistchars").toggle("trail")
end, { desc = "Toggle trailing spaces" })

-- Example: Toggle visible spaces with <leader>ts
vim.keymap.set('n', '<leader>ts', function()
    require("togglelistchars").toggle("space")
end, { desc = "Toggle visible spaces" })
```

## Default Configuration
ToggleListChars.nvim works out-of-the-box. If you don't pass an `opts` table, it defaults to the following configuration:
> **Note:** For a full explanation of what each of these keys does, run `:help listchars` inside Neovim.
```lua
{
    symbols = {
        tab = "«-»",
        space = "·",
        nbsp = "␣",
        extends = "❯",
        precedes = "❮",
        trail = "●",
        eol = "↲",
        conceal = "┊",
        lead = "∘",
        multispace = "∘╌╌╌",
    },
    active = {
        tab = true,
        trail = true,
        extends = true,
        precedes = true,
        conceal = true,
        -- space, nbsp, eol, lead, and multispace are available but disabled by default
        -- Any character omitted from this table defaults to false.
        space = false,
        nbsp = false,
        eol = false,
        lead = false,
        multispace = false,
    },
    hide_trailing_in_insert = true, 
}
```
## Lua API
If you are writing your own scripts or integrating with other plugins, you can call the core functions directly:

```lua
local tlc = require("togglelistchars")

-- Toggle a specific character's state
tlc.toggle("space")

-- Force re-apply the current configuration to Neovim's global listchars
tlc.apply()
```
## License

This project is licensed under the Mozilla Public License 2.0. See the [LICENSE](LICENSE) file for details.
