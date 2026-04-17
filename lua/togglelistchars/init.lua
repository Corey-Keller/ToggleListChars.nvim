-- =============================================================================
-- File: lua/togglelistchars/init.lua
-- Author: Corey Keller
-- Description: Set up custom `listchars` and allow easy toggling
-- Repository: https://github.com/Corey-Keller/ToggleListChars.nvim
-- Last Modified: 2026-04-17
-- License: Mozilla Public License 2.0
-- This Source Code Form is subject to the terms of the Mozilla Public License,
-- v. 2.0. If a copy of the MPL was not distributed with this file, You can
-- obtain one at http://mozilla.org/MPL/2.0/.
-- =============================================================================

local M = {}
-- =========================================================
-- Define your default configuration
-- =========================================================
M.config = {
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
  -- ------------------------------------------
  -- Active State: Set the ones you want turned on by default to 'true'
  -- ------------------------------------------
	active = {
		tab = true,
		trail = true,
		extends = true,
		precedes = true,
		conceal = true,
	},
    -- Make hiding trailing spaces optional
    hide_trailing_in_insert = true, 
}

-- =========================================================
-- Core Function: Apply active symbols to Neovim
-- =========================================================
function M.apply()
	local current_listchars = {}
	for char, is_active in pairs(M.config.active) do
		if is_active and M.config.symbols[char] then
			current_listchars[char] = M.config.symbols[char]
		end
	end

  	-- Neovim happily accepts a table here, no string parsing required!
	vim.opt.listchars = current_listchars
	vim.opt.list = true -- Ensure the global 'list' option is actually on
end

-- =========================================================
-- The Toggle Function
-- =========================================================
function M.toggle(char)
	if M.config.symbols[char] then
		M.config.active[char] = not M.config.active[char]
		M.apply()
		vim.notify(
			"Listchar '" .. char .. "' is now " .. (M.config.active[char] and "ON" or "OFF")
		)
	else
		vim.notify("Unknown listchar: " .. char, vim.log.levels.WARN)
	end
end

-- =========================================================
-- The Setup Function (Required for lazy.nvim compatibility)
-- =========================================================
function M.setup(opts)
  -- ------------------------------------------
	-- Merge the user's opts with your default M.config
  -- ------------------------------------------
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- ------------------------------------------
	-- Initialize on startup
  -- ------------------------------------------
	M.apply()

  -- ------------------------------------------
	-- Create User Command (with autocomplete!)
  -- ------------------------------------------
	vim.api.nvim_create_user_command("ToggleListChars", function(args)
		M.toggle(args.args)
	end, {
		nargs = 1,
		complete = function()
			return vim.tbl_keys(M.config.symbols)
		end,
		desc = "Toggle specific listchars on and off",
	})
  
  -- ------------------------------------------
	-- Hide trailing spaces in Insert mode
  -- ------------------------------------------
    if M.config.hide_trailing_in_insert then
        local group = vim.api.nvim_create_augroup("HideTrailingInsert", { clear = true })

        vim.api.nvim_create_autocmd("InsertEnter", {
            group = group,
            callback = function()
                local current = vim.opt.listchars:get()
                current.trail = nil -- Temporarily remove the trail character
                vim.opt.listchars = current
            end,
        })

        vim.api.nvim_create_autocmd("InsertLeave", {
            group = group,
            callback = function()
                M.apply() -- Restore back to your configured state
            end,
        })
    end
end

return M
