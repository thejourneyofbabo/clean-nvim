-- lspconfig.lua
-- load defaults i.e lua_ls
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

-- Enhanced Clangd configuration with more robust signature help disabling
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    -- More comprehensive signature help disabling
    if client.server_capabilities then
      client.server_capabilities.signatureHelpProvider = nil
    end
    if client.resolved_capabilities then
      client.resolved_capabilities.signature_help = false
    end

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
  capabilities = (function()
    local caps = nvlsp.capabilities
    -- Disable signature help capability
    if caps.textDocument then
      caps.textDocument.signatureHelp = nil
    end
    return caps
  end)(),
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
