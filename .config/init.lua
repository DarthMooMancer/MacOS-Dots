local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }) end
require('mini.deps').setup({ path = { package = vim.fn.stdpath('data') .. '/site/' } })
for _, mod in ipairs({ 'icons', 'pairs', 'statusline', 'pick' }) do require('mini.' .. mod).setup() end

MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', depends = { 'rebelot/kanagawa.nvim' }, hooks = { function() vim.cmd('TSUpdate') end } })
MiniDeps.add({ source = 'saghen/blink.cmp', depends = { 'rafamadriz/friendly-snippets' } })
MiniDeps.add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', 'DarthMooMancer/Polydev' } })

vim.g.mapleader = " "
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>ff", "gg=G")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader><leader>", ":Pick files<CR>")

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.mouse =  ""
vim.opt.wrap = false
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4

require('Polydev').setup()
require('blink.cmp').setup({ keymap = { preset = 'default', ['<C-y>'] = {}, ['<D-y>'] = { 'select_and_accept' } } })
require('nvim-treesitter.configs').setup({ auto_install = true, highlight = { enable = true }, indent = { enable = true } })
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls", "jdtls", "clangd" },
    handlers = { function(server_name) require('lspconfig')[server_name].setup { capabilities = require('blink.cmp').get_lsp_capabilities() } end,
	["lua_ls"] = function() require('lspconfig').lua_ls.setup { settings = { Lua = { diagnostics = { globals = { "vim", "MiniDeps", "MiniPick" } } } } } end,
    }
})
require('kanagawa').setup({ colors = { theme = { all = { ui = { bg_gutter = "none" } } } }, overrides = function(colors) return {
    Pmenu = { fg = colors.theme.ui.shade0, bg = colors.theme.ui.bg_p1 },
    PmenuSel = { fg = "NONE", bg = colors.theme.ui.bg_p2 },
    PmenuSbar = { bg = colors.theme.ui.bg_m1 },
    PmenuThumb = { bg = colors.theme.ui.bg_p2 }
} end })
vim.cmd.colorscheme('kanagawa-dragon')
