return {
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = "italic",
      },
    },
    config = function(_, opts)
      require("onenord").setup(opts)
    end
  },
}
