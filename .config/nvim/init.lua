local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
  vim.cmd('packadd mini.nvim | helptags ALL')
end

require('mini.deps').setup({ path = { package = vim.fn.stdpath('data') .. '/site/' } })

local mini_modules = { 'icons', 'pairs', 'surround', 'statusline', 'extra', 'pick' }
for _, mod in ipairs(mini_modules) do
  require('mini.' .. mod).setup()
end

require('mini.hipatterns').setup({
  highlighters = { hex_color = require('mini.hipatterns').gen_highlighter.hex_color({ priority = 100 }) }
})

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.mouse = ""
vim.opt.wrap = false
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.hlsearch = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>h", function() MiniPick.builtin.help() end)
vim.keymap.set("n", "<leader>p", function() MiniPick.builtin.files() end)
vim.keymap.set("n", "<leader>b", function() MiniPick.builtin.buffers() end)
vim.keymap.set("n", "<leader>g", function() MiniPick.builtin.grep() end)
vim.keymap.set("n", "<leader>d", ":Pick diagnostic<CR>", { silent = true })
vim.keymap.set("n", "<leader>fo", ":lua MiniFiles.open()<CR>")
vim.keymap.set("n", "<leader>jb", ":JavaBuild<CR>", { silent = true })
vim.keymap.set("n", "<leader>jr", ":JavaRun<CR>", { silent = true })
vim.keymap.set("n", "<leader>nf", ":NewJavaFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>np", ":NewJavaProject<CR>", { silent = true })
vim.keymap.set("n", "<leader>ff", "gg=G")

MiniDeps.add({ source = 'saghen/blink.cmp', depends = { 'rafamadriz/friendly-snippets' } })
MiniDeps.add({ source = 'mbbill/undotree' })
MiniDeps.add({ source = 'rebelot/kanagawa.nvim' })
MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', hooks = {function() vim.cmd('TSUpdate') end} })
MiniDeps.add({ source = 'neovim/nvim-lspconfig',
  depends = {
    'saghen/blink.cmp',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim'
  },
})

require("nvim-java")
require('nvim-treesitter.configs').setup({
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

require('blink.cmp').setup({
  keymap = { preset = 'default', ['<C-y>'] = {}, ['<D-y>'] = { 'select_and_accept' } },
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "jdtls" },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup { capabilities = require('blink.cmp').get_lsp_capabilities() }
    end,
    ["lua_ls"] = function()
      require('lspconfig').lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "MiniDeps", "MiniPick" }
            }
          }
        }
      }
    end,
  },
})

require('kanagawa').setup({
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },
      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
      MasonNormal = { bg = "none", fg = theme.ui.fg_dim },
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 }
    }
  end
})
vim.cmd.colorscheme('kanagawa-dragon')
