return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		-- "SmiteshP/nvim-navic",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
        "jay-babu/mason-nvim-dap.nvim"
	},
	lazy = false,
	-- event = "VeryLazy",

	config = function()
		local mason = require("mason")
        local masondap = require("mason-nvim-dap")
		local mason_lspconfig = require("mason-lspconfig")
		local lsp_config = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		mason.setup({})
        masondap.setup({
            handlers = {}
        })
		mason_lspconfig.setup({
			ensure_installed = { "lua_ls" },
			automatic_installation = true,
			automatic_enable = true,
		})


		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local dbname = os.getenv("POSTGRES_DB") or "default_db"
		local user = os.getenv("POSTGRES_USER") or "default_user"
		local password = os.getenv("POSTGRES_PASSWORD") or "default_password"

		vim.lsp.config("sqls", {
			cmd = { "sqls" }, -- or the full path to your sqls binary
			filetypes = { "sql" },
			root_dir = lsp_config.util.root_pattern(".git", "."),
			settings = {
				sqls = {
					connections = {
						{
							driver = "postgresql", -- change this if you use mysql or mssql
							dataSourceName = string.format(
								"host=localhost port=5432 user=%s password=%s dbname=%s sslmode=disable",
								user,
								password,
								dbname
							),
						},
						-- Add more connections if needed
					},
				},
			},
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		vim.lsp.config("sourcekit", {
			filetypes = { "swift" }, -- remove c, cpp
			-- root_dir = lsp_config.util.root_pattern(".git", "Package.swift", "compile_commands.json"),
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			}),
		})

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			-- capabilities = vim.tbl_deep_extend("force", capabilities, {
			-- 	textDocument = { offsetEncoding = { "utf-8" } },
			-- }),
			cmd = {
				"clangd",
				"--query-driver=/opt/homebrew/bin/gcc-15,/opt/homebrew/bin/g++-15",
			},
		})
		vim.lsp.enable("clangd")

		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					imports = {
						granularity = {
							group = "module",
						},
						prefix = "self",
					},
					cargo = {
						buildScripts = {
							enable = true,
						},
					},
					procMacro = {
						enable = true,
					},
				},
			},
		})

		vim.lsp.config("cssls", {
			cmd = { "vscode-css-language-server", "--stdio" },
			filetypes = { "css", "scss", "less" },
			capabilities = capabilities,
			init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
			root_dir = require("lspconfig.util").root_pattern("package.json", ".git"),
			single_file_support = true,
		})
		vim.lsp.config("jsonls", {
			filetypes = { "json", "jsonc" },
			settings = {
				json = {
					-- Schemas https://www.schemastore.org
					schemas = {
						{
							fileMatch = { "package.json" },
							url = "https://json.schemastore.org/package.json",
						},
						{
							fileMatch = { "tsconfig*.json" },
							url = "https://json.schemastore.org/tsconfig.json",
						},
						{
							fileMatch = {
								".prettierrc",
								".prettierrc.json",
								"prettier.config.json",
							},
							url = "https://json.schemastore.org/prettierrc.json",
						},
						{
							fileMatch = { ".eslintrc", ".eslintrc.json" },
							url = "https://json.schemastore.org/eslintrc.json",
						},
						{
							fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
							url = "https://json.schemastore.org/babelrc.json",
						},
						{
							fileMatch = { "lerna.json" },
							url = "https://json.schemastore.org/lerna.json",
						},
						{
							fileMatch = { "now.json", "vercel.json" },
							url = "https://json.schemastore.org/now.json",
						},
						{
							fileMatch = {
								".stylelintrc",
								".stylelintrc.json",
								"stylelint.config.json",
							},
							url = "http://json.schemastore.org/stylelintrc.json",
						},
					},
				},
			},
		})

		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					-- Schemas https://www.schemastore.org
					schemas = {
						["http://json.schemastore.org/gitlab-ci.json"] = { ".gitlab-ci.yml" },
						["https://json.schemastore.org/bamboo-spec.json"] = {
							"bamboo-specs/*.{yml,yaml}",
						},
						["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
							"docker-compose*.{yml,yaml}",
						},
						["http://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
						["http://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
						["http://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
						["http://json.schemastore.org/stylelintrc.json"] = ".stylelintrc.{yml,yaml}",
						["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
					},
				},
			},
		})
	end,
}
