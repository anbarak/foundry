return {
  -- Gruvbox Material — matches Ghostty's "Gruvbox Material Dark" palette exactly
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Match Ghostty: medium contrast, material palette
      vim.g.gruvbox_material_background = "medium"        -- soft | medium | hard
      vim.g.gruvbox_material_foreground = "material"      -- material | mix | original
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_ui_contrast = "high"
    end,
  },
  -- Keep Catppuccin installed but not default, in case you want to A/B test
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },
  -- Tell LazyVim which colorscheme to apply by default
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox-material" },
  },
}
