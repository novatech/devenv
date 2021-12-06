-- PlugInterface is base on https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom
-- TODO: move this to packer.nvim instead
local PlugInterface = {
   begin = vim.fn["plug#begin"],
   ends = function()
      vim.fn["plug#end"]()
   end,
}

local meta = {
   __call = function(self, repo, opts)
      opts = opts or vim.empty_dict()

      opts["do"] = opts.run
      opts.run = nil

      opts["for"] = opts.ft
      opts.ft = nil

      vim.call("plug#", repo, opts)
   end,
}

-- Meta-tables are awesome
Plug = setmetatable(PlugInterface, meta)

Plug.begin "~/.config/nvim/plugged"

-- themes
Plug("dracula/vim", { as = "dracula" })
Plug "tomasr/molokai"
Plug "ayu-theme/ayu-vim"
Plug "rakr/vim-one"

-- misc
Plug "tpope/vim-sensible"
Plug "tpope/vim-unimpaired"
Plug "tpope/vim-repeat"
Plug "tpope/vim-surround"
Plug "tpope/vim-vinegar"
Plug "tpope/vim-eunuch"
Plug "folke/which-key.nvim"

-- draw ascii
Plug("vim-scripts/DrawIt", { on = "DrawIt" })

-- filetypes
Plug "nathom/filetype.nvim"

-- devicons
Plug "kyazdani42/nvim-web-devicons"

-- file browser
Plug "kyazdani42/nvim-tree.lua"

-- airline
Plug "vim-airline/vim-airline-themes"
Plug "vim-airline/vim-airline"

-- fzf
Plug("junegunn/fzf", { dir = "~/.fzf", run = "./install --all" })
Plug "junegunn/fzf.vim"

-- LSP stuffs
Plug "neovim/nvim-lspconfig"
Plug "williamboman/nvim-lsp-installer"
Plug "ray-x/lsp_signature.nvim"
Plug "onsails/lspkind-nvim"
Plug "hrsh7th/nvim-cmp"
Plug "hrsh7th/cmp-nvim-lsp"
Plug "hrsh7th/cmp-nvim-lua"
Plug "hrsh7th/cmp-path"
Plug "hrsh7th/cmp-buffer"
Plug "hrsh7th/cmp-cmdline"
Plug "hrsh7th/cmp-emoji"
Plug "windwp/nvim-autopairs"
Plug "simrat39/symbols-outline.nvim"
Plug "folke/trouble.nvim"
Plug "folke/lsp-colors.nvim"
Plug "terrortylor/nvim-comment"

-- debugger
Plug "mfussenegger/nvim-dap"
Plug "mfussenegger/nvim-dap-python"
Plug "rcarriga/nvim-dap-ui"

-- tree-sitter
Plug "nvim-treesitter/nvim-treesitter"
Plug "windwp/nvim-ts-autotag"
Plug "p00f/nvim-ts-rainbow"
Plug "nvim-treesitter/playground"

-- using ultrasnips
Plug "SirVer/ultisnips"
Plug "quangnguyen30192/cmp-nvim-ultisnips"
Plug "honza/vim-snippets"

-- bufferline/tabs
Plug "kyazdani42/nvim-web-devicons"
Plug "akinsho/bufferline.nvim"

-- indentation setting for all projects
Plug "editorconfig/editorconfig-vim"

-- git stuff
Plug "tpope/vim-fugitive"
Plug "junegunn/gv.vim"
Plug "nvim-lua/plenary.nvim"
Plug "lewis6991/gitsigns.nvim"

-- automatically clear search highlight
Plug "junegunn/vim-slash"

-- indent guide
Plug "lukas-reineke/indent-blankline.nvim"

-- auto formatter
Plug "sbdchd/neoformat"

-- markdown stuffs
Plug("godlygeek/tabular", { ft = "markdown" })
Plug("plasticboy/vim-markdown", { ft = "markdown" })
Plug("vimwiki/vimwiki", { ft = "markdown" })

-- zen mode
Plug "junegunn/goyo.vim"
Plug "folke/twilight.nvim"

-- smooth scrolling
Plug "karb94/neoscroll.nvim"

Plug.ends()
