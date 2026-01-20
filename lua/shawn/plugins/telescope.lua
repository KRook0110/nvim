return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		-- or                              , branch = '0.1.x',
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
						n = {
							["l"] = actions.cycle_history_next,
							["h"] = actions.cycle_history_prev,
							["q"] = actions.close,
							["<esc>"] = actions.close,
						},
					},
					wrap_results = true,
					file_ignore_patterns = {
						"node_modules",
						"node_modules/",
						".git/",
					},
				},
				pickers = {
					find_files = {
						disable_devicons = true,
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fa", builtin.current_buffer_fuzzy_find, { desc = "current buffer" })
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({ previewer = false })
			end, { desc = "files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fd", ":Telescope fd find_command=fd,-t=d disable_devicons=true previewer=false<CR> ", { desc = "Directories" })
			vim.keymap.set("n", "<leader>fw",builtin.lsp_workspace_symbols, { desc = "Telescope Workspace Symbols" })
			vim.keymap.set("n", "<leader>ft",builtin.treesitter, { desc = "Telescope Treesitter" })
			-- LSP
			vim.keymap.set("n", "grr", builtin.lsp_references, { desc = "Telescope Lsp references" })
			vim.keymap.set("n", "gri", builtin.lsp_implementations, { desc = "Telescope Lsp references" })

		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
}
