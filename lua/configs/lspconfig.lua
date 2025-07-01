-- lspconfig.lua

-- load defaults i.e lua_ls-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
local servers = { "html", "cssls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Configure Python server
lspconfig.pyright.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = { "python" },
}

-- Enhanced Clangd configuration
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    -- Disable signature help provider
    client.server_capabilities.signatureHelpProvider = false

    -- Apply nvlsp on_attach
    nvlsp.on_attach(client, bufnr)

    -- Additional keymaps for C/C++ (using different key than 'K')
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>h", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
    vim.keymap.set("n", "<leader>st", "<cmd>ClangdAST<cr>", opts)
    -- Use Alt+k for C++ hover instead of K
    vim.keymap.set("n", "<A-k>", vim.lsp.buf.hover, opts)
    -- Or use leader key
    vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
  end,
  capabilities = nvlsp.capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=microsoft",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
