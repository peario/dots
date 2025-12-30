---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add({
    source = "mfussenegger/nvim-dap",
    depends = {
      "mason-org/mason.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
    },
  })

  add({
    source = "rcarriga/nvim-dap-ui",
    depends = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  })

  -- for keymaps
  local map = vim.keymap.set

  local dap = require("dap")
  local dapui = require("dapui")
  dapui.setup()

  -- stylua: ignore start
  map("n", "<leader>du", function() require("dapui").toggle({}) end, { desc = "Dap UI" })
  map({ "n", "v" }, "<leader>de", function() require("dapui").eval() end, { desc = "Eval" })
  -- stylua: ignore end

  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
  dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end

  -- for keymaps
  ---@param config {type?:string, args?:string[]|fun():string[]?}
  local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
    local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
      local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
      if config.type and config.type == "java" then
        ---@diagnostic disable-next-line: return-type-mismatch
        return new_args
      end
      return require("dap.utils").splitstr(new_args)
    end
    return config
  end

  -- stylua: ignore start
  map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Breakpoint Condition" })
  map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
  map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Run/Continue" })
  map("n", "<leader>da", function() require("dap").continue({ before = get_args }) end, { desc = "Run with Args" })
  map("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
  map("n", "<leader>dg", function() require("dap").goto_() end, { desc = "Go to Line (No Execute)" })
  map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
  map("n", "<leader>dj", function() require("dap").down() end, { desc = "Down" })
  map("n", "<leader>dk", function() require("dap").up() end, { desc = "Up" })
  map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run Last" })
  map("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
  map("n", "<leader>dO", function() require("dap").step_over() end, { desc = "Step Over" })
  map("n", "<leader>dP", function() require("dap").pause() end, { desc = "Pause" })
  map("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
  map("n", "<leader>ds", function() require("dap").session() end, { desc = "Session" })
  map("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })
  map("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "Widgets" })
  -- stylua: ignore end
end)
