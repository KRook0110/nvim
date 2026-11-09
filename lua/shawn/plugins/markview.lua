-- For `plugins/markview.lua` users.
return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	config = function()
		require("markview").setup({
			initial_state = false, -- Keeps markview inactive when opening markdown files
		})
		vim.keymap.set("n", "<leader>mm", "<CMD>Markview Toggle<CR>")
		vim.keymap.set("n", "<leader>ms", "<CMD>Markview splitToggle<CR>")
	end,

	-- Completion for `blink.cmp`
	-- dependencies = { "saghen/blink.cmp" },
}
