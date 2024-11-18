vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

  --- for copy & paste / ssh
  --- ssh -R 2489:127.0.0.1:2489 -p <SSH_PORT> <USER>@<HOST>
if vim.env.SSH_CONNECTION then
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
else
  vim.g.clipboard = {
    name = 'system_clipboard',
    copy = {
      ['+'] = 'xclip -selection clipboard -in',
      ['*'] = 'xclip -selection primary -in',
    },
    paste = {
      ['+'] = 'xclip -selection clipboard -out',
      ['*'] = 'xclip -selection primary -out',
    },
    cache_enabled = 1,
  }
end


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
