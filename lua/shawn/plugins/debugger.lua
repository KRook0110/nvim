return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dapvt = require("nvim-dap-virtual-text")

		dapui.setup()
		dapvt.setup()

		-- dap.adapters.lldb = {
		-- 	type = "executable",
		-- 	command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
		-- 	name = "lldb",
		-- }
		-- ----------------------------------------------------------------------
		-- Adapter 1: Native GDB (requires GDB >= 14.1)
		----------------------------------------------------------------------
		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "--quiet", "-i", "dap" },
		}

		----------------------------------------------------------------------
		-- Adapter 2: CodeLLDB (installable via Mason or system package)
		----------------------------------------------------------------------
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				-- If installed via Mason:
				-- command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}

		----------------------------------------------------------------------
		-- Common C / C++ Debug Configurations
		----------------------------------------------------------------------
		local c_cpp_configurations = {
			{
				name = "Launch executable (GDB)",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
			{
				name = "Launch with arguments (GDB)",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				args = function()
					local args_str = vim.fn.input("Arguments: ")
					return vim.split(args_str, "%s+", { trimempty = true })
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
			{
				name = "Attach to process (GDB)",
				type = "gdb",
				request = "attach",
				pid = function()
					return tonumber(vim.fn.input("Process ID: "))
				end,
				cwd = "${workspaceFolder}",
			},
			{
				name = "Launch executable (CodeLLDB)",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		-- Assign to both C and C++ filetypes
		dap.configurations.c = c_cpp_configurations
		dap.configurations.cpp = c_cpp_configurations

		-- Keymaps
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "", linehl = "", numhl = "" })
		vim.keymap.set("n", "gb", dap.run_to_cursor, { desc = "Debug run to cursor" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
		vim.keymap.set("n", "<leader>B", dap.clear_breakpoints, { desc = "clear breakpoints" })
		vim.keymap.set("n", "<space>?", function()
			dapui.eval(nil, { enter = true })
		end)
		vim.keymap.set("n", "<leader>Dt", dapui.toggle, { desc = "Debug: Toggle UI" })
		vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Debug: Stop" })
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
		-- vim.keymap.set("n", "<C-F11>", dap.step_back, { desc = "Debug: Step Back" })
		-- vim.keymap.set("n", "<C-S-F5>", dap.restart, { desc = "Debug: Restart" })

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
