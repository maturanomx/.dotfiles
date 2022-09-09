local M = {}

M.ui = {
  theme = "catppuccin",
  theme_toggle = { "catppuccin", "catppuccin_latte" },
  transparency = true,
}

M.plugins = {
  user = require "custom.plugins",
  override = {
    ["nvim-treesitter/nvim-treesitter"] = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "css",
        "dockerfile",
        "gitignore",
        "html",
        "http",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      }
    },
    ["williamboman/mason.nvim"] = {
      ensure_installed = {
        "bash-language-server",
        "clangd",
        "css-lsp",
        "diagnostic-languageserver",
        "dockerfile-language-server",
        "eslint-lsp",
        "fixjson",
        "gitlint",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "shellcheck",
        "stylua",
        "typescript-language-server",
        "yaml-language-server",
      }
    },
  }
}

return M
