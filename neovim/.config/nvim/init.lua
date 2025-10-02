-- Plugins using packer.nvim
-- Make sure packer is installed before running this
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  -- Your plugins
  use 'tpope/vim-sensible'
  use { 'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
   config = function()
      require("nvim-tree").setup()
    end
  }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
-- nvim-ufo and its dependency
  use {
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async'
  }
  use "luukvbaal/statuscol.nvim"

  use {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('ibl').setup() -- Call setup in your config function
  end
  }

  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'vim-ruby/vim-ruby'
  use 'tpope/vim-rails'
  use 'Shougo/neocomplete.vim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  use 'hrsh7th/vim-vsnip'

  use 'junegunn/fzf.vim'

  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'  -- duplicate in original, kept here once

  use { "catppuccin/nvim", as = "catppuccin" }

  use 'folke/tokyonight.nvim'

  -- Themes
  -- use 'mhartington/oceanic-next' -- commented out in original


  use 'dense-analysis/ale'

  use 'jiangmiao/auto-pairs'

  use {'fatih/vim-go', run = ':GoUpdateBinaries'}
end)

-- Settings

-- termguicolors
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Enable syntax highlighting
vim.cmd('syntax enable')
vim.opt.termguicolors = true

-- Colorscheme
--require("tokyonight").setup({
--  -- use the night style
--  style = "night",
-- })
--vim.cmd[[colorscheme tokyonight]]
vim.cmd.colorscheme "catppuccin-mocha"

-- vim.cmd('colorscheme catppuccin_macchiato') -- commented out in original

-- Basic options
vim.opt.mouse = 'a'
vim.opt.modifiable = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.background = 'dark'

vim.opt.showmatch = true
vim.opt.matchtime = 3

-- Remove trailing whitespace on save (commented in original)
-- vim.cmd([[
-- autocmd BufWritePre * %s/\s\+$//e
-- ]])

-- Clear terminal on VimLeave
vim.cmd([[autocmd VimLeave * :!clear]])

-- Key mappings
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'w', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', 'q', ':q<CR>', opts)
vim.api.nvim_set_keymap('n', 'q!', ':q!<CR>', opts)
vim.api.nvim_set_keymap('n', 'wq', ':wq<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', opts)

vim.api.nvim_set_keymap('x', 'p', 'pgvy', opts)

-- Filetype plugins
vim.cmd('filetype plugin indent on')

-- Autocommands for ruby/eruby indentation and tabs
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})
-------------------- NVIM TREE ---------------------
-- Load nvim-tree plugin safely
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap=true, silent=true, nowait=true }
  end

  -- Default mappings (you can override or add more)
  api.config.mappings.default_on_attach(bufnr)

  -- Add custom mappings:
  vim.keymap.set('n', 'v', api.node.open.vertical, {
        desc = 'NvimTree: Open in vertical split',
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      })
  vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
end

-- Configure nvim-tree
nvim_tree.setup({
  -- disables netrw (builtin file explorer) and sets up nvim-tree as default
  disable_netrw = true,
  hijack_netrw = true,
  open_on_tab = false,
  update_cwd = true,
  on_attach = on_attach,
  view = {
    width = 30,
    side = "left",
    -- other options: hide_root_folder, mappings, etc.
  },
  -- add more options here if you want
})

local opts = { noremap = true, silent = true }

-- Toggle file explorer
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', opts)
-- Find current file in tree
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFindFile<CR>', opts)




vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
      return
    end

    -- change to the directory
    vim.cmd.cd(data.file)

    -- open the tree
    require("nvim-tree.api").tree.open()
  end
})

------------------------------------

------------------- NVIM TREESITTER-------------

require('nvim-treesitter.configs').setup {
  -- Enable syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false, -- Optional: Set to true if you need additional regex highlighting
  },
  -- Enable indentation
  indent = {
    enable = true,
  },
  -- Ensure the JavaScript parser is installed
  ensure_installed = { "javascript", "typescript" },
  -- auto_install = true, -- Optional: Automatically install parsers for detected filetypes
  -- Other configurations like textobjects, incremental_selection, etc. can be added here
}
------- FOLDING BEHAVIOR -----

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldcolumn = 'auto:9'

vim.opt.foldenable = true -- Enable folding

local ufo = require('ufo')
ufo.setup({
    -- Use treesitter as the preferred provider
    -- This ensures it uses the syntax tree for accurate folding (like JS functions)
    provider_selector = function(bufnr, filetype, buftype)
        -- Prioritize treesitter, fall back to indent if no treesitter parser is found
        return { 'treesitter', 'indent' }
    end,
    })

-- In your statuscol.nvim config (e.g., in the 'config' function or a separate file)
require('statuscol').setup({
    -- setopt = true is often required to ensure it overrides Neovim's default column behavior
    setopt = true,
    segments = {
        -- 1. Fold Column: Uses 'foldfunc' which is designed to hide the numbers
        { text = { require('statuscol.builtin').foldfunc }, click = "v:lua.ScFa" },
        -- 2. Sign Column (for diagnostics/git signs)
        { text = { '%s' } },
        -- 3. Line Number (or Relativenumber)
        { text = { require('statuscol.builtin').lnumfunc, " " }, click = "v:lua.ScLa" }
    }
})

--------------------INDENT LINES----




-- Lua configuration (e.g., in init.lua or a plugin config file)
require('ibl').setup {
  -- Configure the 'indent' table
  indent = {
    -- Change the character used for the indent lines
    char = '│', -- A vertical line is a common choice
    -- You can also use a different character for tabs
    tab_char = '│',
  },

  -- Other options you might want:
  -- show_current_context = true, -- Highlights the current scope
  -- show_current_context_start = true, -- Shows the start of the current scope
}








------------------------------------------------
-----------------------------------------------------
--------- lualine -------


require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'horizon',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


-----------------------------


-- split window navigations
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader><Left>',  '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<leader><Down>',  '<C-w>j', opts)
vim.api.nvim_set_keymap('n', '<leader><Up>',    '<C-w>k', opts)
vim.api.nvim_set_keymap('n', '<leader><Right>', '<C-w>l', opts)


-- FZF config
vim.api.nvim_set_keymap('n', '<C-f>', ':Files<CR>', { noremap = true, silent = true })
vim.opt.rtp:append('/usr/local/opt/fzf')

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)

-- ALE config
vim.g.ale_linters = {
  javascript = {'eslint'},
  ruby = {'rubocop'},
}

vim.g.ale_sign_error = '•'
vim.g.ale_sign_warning = '•'
vim.g.ale_sign_column_always = 1

