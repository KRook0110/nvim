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

		-- Keymaps
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "", linehl = "", numhl = "" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint,{ desc = "toggle breakpoint"})
		vim.keymap.set("n", "<leader>B", dap.clear_breakpoints, {desc = "clear breakpoints"})
		vim.keymap.set("n", "<space>?", function()
			dapui.eval(nil, { enter = true })
		end)
		vim.keymap.set("n", "gb", dap.run_to_cursor, {desc="Debug run to cursor"})
		vim.keymap.set("n", "<F1>", dap.continue)
		vim.keymap.set("n", "<F2>", dap.step_into)
		vim.keymap.set("n", "<F3>", dap.step_over)
		vim.keymap.set("n", "<F4>", dap.step_out)
		vim.keymap.set("n", "<F5>", dap.terminate)
		vim.keymap.set("n", "<F6>", dapui.toggle)

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
