---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  -- Add neotest
  add({
    source = "nvim-neotest/neotest",
    monitor = "master",
    checkout = "master",
    depends = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "folke/trouble.nvim",
      "fredrikaverpil/neotest-golang",
    },
  })

  local neotest_opts = {
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = {
      open = function()
        if vim.fn.exists(":Trouble") then
          require("trouble").open({ mode = "quickfix", focus = false })
        else
          vim.cmd("copen")
        end
      end,
    },
    adapters = {
      ["rustaceanvim.neotest"] = {},
      ["neotest-golang"] = {
        -- Here we can set options for neotest-golang, e.g.
        -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
        dap_go_enabled = true, -- requires leoluz/nvim-dap-go
      },
    },
  }

  local neotest_ns = vim.api.nvim_create_namespace("neotest")
  vim.diagnostic.config({
    virtual_text = {
      format = function(diagnostic)
        -- Replace newline and tab characters with space for more compact diagnostics
        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
        return message
      end,
    },
  }, neotest_ns)

  neotest_opts.consumers = neotest_opts.consumers or {}
  -- Refresh and auto close trouble after running tests
  ---@type neotest.Consumer
  neotest_opts.consumers.trouble = function(client)
    client.listeners.results = function(adapter_id, results, partial)
      if partial then return end
      local tree = assert(client:get_position(nil, { adapter = adapter_id }))

      local failed = 0
      for pos_id, result in pairs(results) do
        if result.status == "failed" and tree:get_key(pos_id) then failed = failed + 1 end
      end
      vim.schedule(function()
        local trouble = require("trouble")
        if trouble.is_open() then
          trouble.refresh()
          if failed == 0 then trouble.close() end
        end
      end)
      return {}
    end
  end

  if neotest_opts.adapters then
    local adapters = {}
    for name, config in pairs(neotest_opts.adapters or {}) do
      if type(name) == "number" then
        if type(config) == "string" then config = require(config) end
        adapters[#adapters + 1] = config
      elseif config ~= false then
        local adapter = require(name)
        if type(config) == "table" and not vim.tbl_isempty(config) then
          local meta = getmetatable(adapter)
          if adapter.setup then
            adapter.setup(config)
          elseif adapter.adapter then
            adapter.adapter(config)
            adapter = adapter.adapter
          elseif meta and meta.__call then
            adapter = adapter(config)
          else
            error("Adapter " .. name .. " does not support setup")
          end
        end
        adapters[#adapters + 1] = adapter
      end
    end
    neotest_opts.adapters = adapters
  end

  require("neotest").setup(neotest_opts)
end)
