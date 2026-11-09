return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	config = function()
		require("ibl").setup({
			enabled = true,
            indent= {
                char = "│",
            },
			scope = {
				enabled = false,
				show_start = false,
                show_end = false,
				show_exact_scope = false,
			},
		})
	end,
}
