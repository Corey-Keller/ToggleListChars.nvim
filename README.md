# ToggleListChars.nvim

A lightweight, modern Neovim plugin written in Lua to painlessly configure and toggle individual `listchars`. 

Instead of messing with long, hard-to-read `set listchars=...` strings, this plugin lets you define your preferred symbols and active states using clean Lua tables, and provides a simple command to toggle them on the fly.

## Features
* **Granular Control:** Toggle specific characters (like `space`, `tab`, or `trail`) on and off individually without affecting the rest of your listchars.
* **Smart Insert Mode:** Automatically hides trailing spaces when you enter Insert mode so your screen isn't cluttered while actively typing, then restores them when you leave.
* **Native Lua Tables:** No string parsing. Configure everything using standard Neovim Lua tables.
* **Autocomplete Commands:** Includes `:ToggleListChar` with built-in argument completion.

## Installation

Here is how to install and configure the plugin using [lazy.nvim](https://github.com/folke/lazy.nvim). 

If you keep your plugins in separate files (e.g., inside a `lua/plugins/` directory), return this table. If you keep all plugins in one list, simply add this table to it:

```lua
{
    "Corey-Keller/ToggleListChars.nvim",
    -- Load immediately when Neovim UI enters to avoid empty listchars on a blank start buffer
    event = "UIEnter",
    -- The `opts` table is automatically passed into your `require("togglelistchars").setup(opts)`
    opts = {
        -- You can override the defaults here!
        active = {
            space = false, -- Just an example of overriding
        },
        symbols = {
            trail = "▫", -- Example of swapping a default symbol from your config
        },
        hide_trailing_in_insert = false, -- Set to false to disable this feature
    },
}
```
