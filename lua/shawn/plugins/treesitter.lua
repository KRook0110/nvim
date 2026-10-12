return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup()

			-- Install desired parsers if they are not already installed
			local parsers = { "python", "cpp", "c", "lua", "vim", "vimdoc", "query" }
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
}
