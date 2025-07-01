local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    cpp = { "clang_format" }, -- C++ clang_format add
    c = { "clang_format" }, -- C as well
  },

  formatters = {
    clang_format = {
      args = { "--style=google" }, -- Set code format style
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
return options
