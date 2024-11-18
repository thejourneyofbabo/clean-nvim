vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

  --- for copy & paste / ssh
  --- ssh -R 2489:127.0.0.1:2489 -p <SSH_PORT> <USER>@<HOST>
vim.g.clipboard = {
  name = 'lemonade',
  copy = {
    ['+'] = 'lemonade copy',
    ['*'] = 'lemonade copy',
  },
  paste = {
    ['+'] = 'lemonade paste',
    ['*'] = 'lemonade paste',
  },
  cache_enabled = 1,
}

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
