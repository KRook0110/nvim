return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup()

			-- Install desired parsers if they are not already installed
			local parsers = { "python", "cpp", "c", "lua", "vim", "vimdoc", "query" , "c_sharp" }
			local installed = ts.get_installed()
			local to_install = vim.tbl_filter(function(p)
				return not vim.list_contains(installed, p)
			end, parsers)

			if #to_install > 0 then
				ts.install(to_install)
			end

			-- Enable Treesitter highlighting and indentexpr for buffers with supported parsers
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					if pcall(vim.treesitter.start, args.buf) then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("treesitter-context").setup({
	-- 			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	-- 			multiwindow = false, -- Enable multiwindow support.
	-- 			max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
	-- 			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	-- 			line_numbers = true,
	-- 			multiline_threshold = 20, -- Maximum number of lines to show for a single context
	-- 			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	-- 			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- 			-- Separator between context and content. Should be a single character string, like '-'.
	-- 			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	-- 			separator =nil,
	-- 			zindex = 20, -- The Z-index of the context window
	-- 			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
	-- 		})
	--
	-- 		vim.keymap.set("n", "[c", function()
	-- 			require("treesitter-context").go_to_context(vim.v.count1)
	-- 		end, { silent = true, desc = "go to context" })
	-- 	end,
	-- },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						-- ['@class.outer'] = '<c-v>', -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,
				},
				move = {
					-- whether to set jumps in the jumplist
					set_jumps = true,
				},
			})

			vim.keymap.set({ "x", "o" }, "am", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "im", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "ia", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "aa", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
			end)
		end,
	},
}
