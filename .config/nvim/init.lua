local keymap = vim.keymap.set
local add = MiniDeps.add
local opt = vim.opt

if not vim.loop.fs_stat(vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim') then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim' })
  vim.cmd('packadd mini.nvim | helptags ALL') end
require('mini.deps').setup({ path = { package = vim.fn.stdpath('data') .. '/site/' } })

for _, mod in ipairs({ 'icons', 'pairs', 'statusline', 'extra', 'pick', 'bracketed' }) do
  require('mini.' .. mod).setup() end

opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.mouse = ""
opt.wrap = false
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
vim.g.mapleader = " "

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("n", "<leader>ff", "gg=G")
keymap("n", "<leader>h", function() MiniPick.builtin.help() end)
keymap("n", "<leader>p", function() MiniPick.builtin.files() end)
keymap("n", "<leader>g", function() MiniPick.builtin.grep() end)
keymap("n", "<leader>d", ":Pick diagnostic<CR>", { silent = true })

add({ source = 'saghen/blink.cmp', depends = { 'rafamadriz/friendly-snippets' } })
add({ source = 'rebelot/kanagawa.nvim' })
add({ source = 'nvim-treesitter/nvim-treesitter', hooks = {function() vim.cmd('TSUpdate') end} })
add({ source = 'DarthMooMancer/Polydev' })
add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' } })

require('Polydev').java.setup()
require('Polydev').c.setup()
require('blink.cmp').setup({
  keymap = { preset = 'default', ['<C-y>'] = {}, ['<D-y>'] = { 'select_and_accept' } },
})

require('nvim-treesitter.configs').setup({
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "jdtls" },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup { capabilities = require('blink.cmp').get_lsp_capabilities() }
    end
  }
})

require('lspconfig').lua_ls.setup { settings = { Lua = { diagnostics = { globals = { "vim", "MiniDeps", "MiniPick" } } } } }
require('mini.hipatterns').setup({ highlighters = { hex_color = require('mini.hipatterns').gen_highlighter.hex_color({ priority = 100 }) } })
require('kanagawa').setup({
  colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
  overrides = function(colors)
    return {
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },
      NormalDark = { fg = colors.theme.ui.fg_dim, bg = colors.theme.ui.bg_m3 },
      MasonNormal = { bg = "none", fg = colors.theme.ui.fg_dim },
      Pmenu = { fg = colors.theme.ui.shade0, bg = colors.theme.ui.bg_p1 },
      PmenuSel = { fg = "NONE", bg = colors.theme.ui.bg_p2 },
      PmenuSbar = { bg = colors.theme.ui.bg_m1 },
      PmenuThumb = { bg = colors.theme.ui.bg_p2 }
    }
  end
})

vim.cmd.colorscheme('kanagawa-dragon')
