return {
	"folke/which-key.nvim",
	event = "VeryLazy",

	config = function()
		require("which-key").setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
            delay = 500,
		})


		local wk = require("which-key")
		      wk.add(
		{
			-- { "<leader>M", group = "Modes" },
			-- { "<leader>d", group = "Debug" },
			{ "<leader>f", group = "Find" },
			{ "<leader>h", group = "Hunk" },
			-- { "<leader>h", group = "Harpoon" },
			{ "<leader>n", group = "No Highlight" },
			{ "<leader>p", group = "Project" },
			{ "<leader>t", group = "Toggle" },
		})
	end,
}
