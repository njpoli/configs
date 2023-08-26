-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.wo.relativenumber = true

-------------------------------------------------------------------------------
-- Keymap
-------------------------------------------------------------------------------
-- Tab/Shift+tab to indent/dedent
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("n", "<Tab>", "v><C-\\><C-N>")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "<S-Tab>", "v<<C-\\><C-N>")
vim.keymap.set("i", "<S-Tab>", "<C-\\><C-N>v<<C-\\><C-N>^i")
vim.g.mapleader = " "

-------------------------------------------------------------------------------
-- Bootstrap Package Manager
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
    print('Installing lazy.nvim....')
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
    print('Done.')
end

vim.opt.rtp:prepend(lazypath)


-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require('lazy').setup({
    {'folke/tokyonight.nvim'},
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    },
    { "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = "nvim-lua/plenary.nvim",
        keys = {
            { "<leader>ft", "<CMD>Telescope<CR>", mode = { "n", "i", "v" } },
            { "<leader>ff", "<CMD>Telescope find_files<CR>", mode = { "n", "i", "v" } },
            { "<leader>fg", "<CMD>Telescope live_grep<CR>", mode = { "n", "i", "v" } },
            { "<leader>fc", "<CMD>Telescope commands<CR>", mode = { "n", "i", "v" } },
            { "<leader>fk", "<CMD>Telescope keymaps<CR>", mode = { "n", "i", "v" } },
            { "<leader>fd", "<CMD>Telescope grep_string<CR>", mode = { "n", "i", "v" } },
        },
        config = true
    },
})

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

-------------------------------------------------------------------------------
-- Autocompletion
-------------------------------------------------------------------------------
-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = {
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({select = false}),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    }
})
--
-------------------------------------------------------------------------------
-- Color Scheme
-------------------------------------------------------------------------------
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

