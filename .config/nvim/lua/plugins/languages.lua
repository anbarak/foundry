return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "lua-language-server",
        "bash-language-server",
        "pyright",
        "ruff",
        "terraform-ls",
        "tflint",
        "yaml-language-server",
        "json-lsp",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "marksman",
        "gopls",
        "helm-ls",
        "stylua",
        "shfmt",
        "prettier",
        "black",
        "isort",
        "gofumpt",
        "shellcheck",
        "hadolint",
        "yamllint",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
              schemas = {
                kubernetes = { "*.yaml", "*.yml" },
                ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
                ["https://json.schemastore.org/github-action.json"] = ".github/actions/*/action.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-cd/master/assets/schemas/application-v1.json"] = "*argocd*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
              },
            },
          },
        },
        terraformls = {
          filetypes = { "terraform", "terraform-vars", "tf", "hcl" },
        },
      },
    },
  },

  {
    "hashivim/vim-terraform",
    ft = { "terraform", "hcl", "tf" },
    init = function()
      vim.g.terraform_fmt_on_save = 1
      vim.g.terraform_align = 1
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash", "dockerfile", "go", "gomod", "gosum",
        "hcl", "terraform",
        "json", "json5", "jsonnet",
        "lua", "luadoc",
        "markdown", "markdown_inline",
        "python",
        "regex",
        "toml",
        "yaml",
        "sql",
      })
    end,
  },
}
