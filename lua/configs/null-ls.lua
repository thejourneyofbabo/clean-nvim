-- null-ls.lua
--

local null_ls = require "null-ls"
local opts = {
  sources = {
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.black,
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = vim.api.nvim_create_augroup("LspFormatting", {}),
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatting", {}),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
return opts
