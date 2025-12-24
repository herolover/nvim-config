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

vim.api.nvim_create_user_command('BazelCompileCommands', '!bazel run @hedron_compile_commands//:refresh_all', {})

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
  "Exafunction/windsurf.vim",
  event = "BufEnter"
},
{
  "FabijanZulj/blame.nvim",
  config = function()
    require("blame").setup()
  end
},
{
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }
},
{
  "nvim-java/nvim-java",
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "nvim-java/nvim-java-refactor",
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
}})

vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files<cr>', { silent = true })
vim.keymap.set('n', '<leader>l', '<cmd>Telescope live_grep<cr>', { silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>Telescope grep_string<cr>', { silent = true })
vim.keymap.set('n', '<leader>g', '<cmd>Telescope git_files<cr>', { silent = true })
vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<cr>', { silent = true })
vim.keymap.set('n', '<leader>d', '<cmd>Telescope diagnostics<cr>', { silent = true })
vim.keymap.set('n', '<leader>r', '<cmd>Telescope resume<cr>', { silent = true })
vim.keymap.set('n', '<leader>p', '<cmd>cp<cr>', { silent = true })
vim.keymap.set('n', '<leader>n', '<cmd>cn<cr>', { silent = true })
vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeFindFileToggle<cr>', { silent = true })

vim.keymap.set('i', 'jj', '<esc>')
vim.keymap.set('i', '<C-s>', '<cmd>update<cr><esc>', { silent = true })
vim.keymap.set('n', '<C-s>', '<cmd>update<cr>', { silent = true })
vim.keymap.set('n', '<leader>s', '<cmd>LspClangdSwitchSourceHeader<cr>', { silent = true })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { noremap = true, silent = true, buffer = args.buf }

        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
        vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
        vim.keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    end
})

vim.lsp.config.clangd = {
    cmd = {'/usr/bin/clangd', '--background-index'},
}
vim.lsp.enable("clangd")

vim.lsp.enable("pyright")

vim.lsp.config.jdtls = {
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
}
vim.lsp.enable("jdtls")

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

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    float = {
      enable = true,
      open_win_config = {
        width = 150,
        height = 40,
      }
    }
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

vim.filetype.add {
  extension = {
    jinja = 'jinja',
    jinja2 = 'jinja',
    j2 = 'jinja',
  },
}

EOF

colorscheme nordfox
