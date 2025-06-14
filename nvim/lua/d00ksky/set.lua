-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation (4 spaces as you prefer)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Line wrapping
vim.opt.wrap = false

-- Backup and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Colors
vim.opt.termguicolors = true

-- Scrolling
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Update time
vim.opt.updatetime = 50

-- Column guide
vim.opt.colorcolumn = "88" -- Python PEP 8 line length

-- Cursor
vim.opt.guicursor = ""

-- Mouse support
vim.opt.mouse = "a"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Command line height
vim.opt.cmdheight = 1

-- Show mode
vim.opt.showmode = false

-- File encoding
vim.opt.fileencoding = "utf-8"

-- Popup menu height
vim.opt.pumheight = 10

-- Completion options
vim.opt.completeopt = { "menuone", "noselect" }

-- Case sensitivity
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Global status line
vim.opt.laststatus = 3