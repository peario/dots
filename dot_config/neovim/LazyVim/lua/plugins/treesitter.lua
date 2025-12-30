return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      endwise = { enable = true },
      matchup = { enable = true },
      autotag = { enable = true },
    },
    dependencies = {
      --- WARN: Use `brianhuster` (fork) until `RRethy` (original) is fixed
      "brianhuster/treesitter-endwise.nvim",
      -- "RRethy/nvim-treesitter-endwise",
      "andymass/vim-matchup",
    },
  },
}
