---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  local build = function() vim.fn["mkdp#util#install"]() end

  -- Preview markdown files
  add({
    source = "iamcco/markdown-preview.nvim",
    hooks = {
      post_install = function() later(build) end,
      post_checkout = build,
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
      vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview" })
    end,
  })

  -- Don't close the preview tab when switching to other buffers
  vim.g.mkdp_auto_close = 0
end)

now(function()
  -- Dependencies
  add({ source = "nvim-treesitter/nvim-treesitter" })
  add({ source = "nvim-mini/mini.icons" })

  -- Render markdown (within file)
  add({
    source = "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
  })

  require("render-markdown").setup({
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    completions = { lsp = { enabled = true } },
    checkbox = { enabled = false },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function(args)
      -- Start treesitter on markdown files.
      vim.treesitter.start(args.buf, "markdown")
    end,
  })
end)
