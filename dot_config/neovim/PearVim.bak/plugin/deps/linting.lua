---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add({
    source = "mfussenegger/nvim-lint",
    depends = { "mason-org/mason.nvim" },
  })

  require("lint").linters_by_ft = {
    go = { "revive" },
    lua = { "selene" },
    markdown = { "markdownlint-cli2" },
    yaml = { "actionlint" },
  }
end)
