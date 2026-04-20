-- Disable conform formatters for shell scripts to preserve hand-crafted
-- style (backslash line-continuations, spacing around redirects, etc.).
-- Manual formatting is still available via <leader>cf or :lua require('conform').format().
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = {},
        bash = {},
        zsh = {},
      },
    },
  },
}
