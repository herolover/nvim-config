let mapleader=","

set nocompatible
set ignorecase
set smartcase
set hlsearch
set incsearch
set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set number
syntax on
filetype plugin indent on
filetype plugin on
set clipboard=unnamedplus
set cursorline
set splitbelow
set splitright
setlocal spell spelllang=en_us

lua<<EOF

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
{
  "nvim-java/nvim-java",
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    {
      "williamboman/mason.nvim",
      opts = {
        registries = {
          "github:nvim-java/mason-registry",
          "github:mason-org/mason-registry",
        },
      },
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        handlers = {
          ["jdtls"] = function()
            require("java").setup()
          end,
        },
      },
    },
  }
},
{
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }
},
{ "EdenEast/nightfox.nvim" },
{ "simeji/winresizer" },
{
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { "nvim-lua/plenary.nvim" }
},
{
  "nvim-telescope/telescope-fzf-native.nvim",
  build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
},
{
  "FabijanZulj/blame.nvim",
  config = function()
    require("blame").setup()
  end
}})

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap = true, silent = true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
end

require('java').setup()

require'lspconfig'.clangd.setup{
    on_attach = on_attach,
    cmd = {'/usr/bin/clangd-16', '--background-index', '--compile-commands-dir=cmake-build'},
}

require'lspconfig'.pylsp.setup{
    on_attach = on_attach,
}

require('lspconfig').jdtls.setup({
    on_attach = on_attach,
    settings = {
        java = {
            format = {
                settings = {
                    profile = "Flow-new-1.1",
                    url = "/home/azhvakin/Downloads/Eclipse_Flow_new_1_1.xml",
                }
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk-amd64",
                        default = true,
                    }
                }
            }
        }
    }
})

require('telescope').setup({
    defaults = {
        path_display = {"truncate"}
    }
})
require('telescope').load_extension('fzf')
require('lualine').setup{
    sections = {
        lualine_b = {'diff', 'diagnostics'},
        lualine_x = {},
        lualine_y = {'location', 'progress'},
        lualine_z = {
            {'datetime', style = '%a, %d %b %H:%M'}
        }
    }
}
require('nvim-web-devicons').setup()

EOF

colorscheme nordfox

nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>l <cmd>Telescope live_grep<cr>
nnoremap <leader>w <cmd>Telescope grep_string<cr>
nnoremap <leader>g <cmd>Telescope git_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>d <cmd>Telescope diagnostics<cr>
nnoremap <leader>r <cmd>Telescope resume<cr>
nnoremap <leader>p <cmd>:cp<cr>
nnoremap <leader>n <cmd>:cn<cr>

inoremap jj <esc>
inoremap <C-s> <cmd>update<cr><esc>
noremap <C-s> <cmd>update<cr>
nnoremap <leader>s <cmd>ClangdSwitchSourceHeader<cr>

