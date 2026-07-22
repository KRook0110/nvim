return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- VimTeX configuration goes here, e.g.
		vim.g.vimtex_view_method = "skim"
		-- Enable continuous compilation (compile on save/change)
		vim.g.vimtex_compiler_method = "latexmk"

		-- Configure VimTeX to automatically open the PDF viewer on compilation start
		vim.g.vimtex_view_skim_activate = 1
		vim.g.vimtex_view_skim_reading_bar = 0
	end,
}
