-- /////////////////////////////////////////////////////////////////////////////
-- basic
-- /////////////////////////////////////////////////////////////////////////////

function OSX()
  return vim.loop.os_uname().sysname == 'Darwin'
end

function LINUX()
  return vim.loop.os_uname().sysname == 'Linux'
end

function WINDOWS()
  return vim.loop.os_uname().sysname == 'Windows'
end

-- /////////////////////////////////////////////////////////////////////////////
-- language and encoding setup
-- /////////////////////////////////////////////////////////////////////////////

-- always use English menu
-- NOTE: this must before filetype off, otherwise it won't work
vim.opt.langmenu = 'none'

-- use English for anaything in vim-editor.
if WINDOWS() then
  vim.cmd('language english')
elseif OSX() then
  vim.cmd('language en_US')
else
  vim.cmd('language en_US.utf8')
end

-- try to set encoding to utf-8
if WINDOWS() then
  -- Windows cmd.exe still uses cp850. If Windows ever moved to
  -- Powershell as the primary terminal, this would be utf-8
  vim.opt.termencoding = 'cp850'

  -- Let Vim use utf-8 internally, because many scripts require this
  vim.opt.encoding = 'utf-8'
  vim.g.fileencoding = 'utf-8'

  -- Windows has traditionally used cp1252, so it's probably wise to
  -- fallback into cp1252 instead of eg. iso-8859-15.
  -- Newer Windows files might contain utf-8 or utf-16 LE so we might
  -- want to try them first.
  vim.opt.fileencodings = 'ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15'
else
  -- set default encoding to utf-8
  vim.opt.encoding = 'utf-8'
  vim.opt.termencoding = 'utf-8'
end

vim.scriptencoding = 'utf-8'

-- /////////////////////////////////////////////////////////////////////////////
-- General
-- /////////////////////////////////////////////////////////////////////////////

vim.opt.backup = true -- make backup file and leave it around

-- setup back and swap directory
local data_dir = vim.env.HOME .. '/.data/'
local backup_dir = data_dir .. 'backup'
local swap_dir = data_dir .. 'swap'

if vim.fn.finddir(data_dir) == '' then
  vim.fn.mkdir(data_dir, 'p', 0700)
end

if vim.fn.finddir(backup_dir) == '' then
  vim.fn.mkdir(backup_dir, 'p', 0700)
end

if vim.fn.finddir(swap_dir) == '' then
  vim.fn.mkdir(swap_dir, 'p', 0700)
end

vim.opt.backupdir = vim.env.HOME .. '/.data/backup' -- where to put backup file
vim.opt.directory = vim.env.HOME .. '/.data/swap' -- where to put swap file

-- Redefine the shell redirection operator to receive both the stderr messages and stdout messages
vim.opt.shellredir = '>%s 2>&1'
vim.opt.history = 50 -- keep 50 lines of command line history
vim.opt.updatetime = 1000 -- default = 4000
vim.opt.autoread = true -- auto read same-file change (better for vc/vim change)
vim.opt.maxmempattern = 1000 -- enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)


-- /////////////////////////////////////////////////////////////////////////////
-- Variable settings (set all)
-- /////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------
-- Desc: Visual
--------------------------------------------------------------------

vim.opt.matchtime = 0 -- 0 second to show the matching paren (much faster)
vim.opt.number = true -- show line number
vim.opt.scrolloff = 0 -- minimal number of screen lines to keep above and below the cursor
vim.opt.wrap = false -- do not wrap text

-- /////////////////////////////////////////////////////////////////////////////
-- plugins
-- /////////////////////////////////////////////////////////////////////////////

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  'nvim-tree/nvim-tree.lua',
  'itchyny/lightline.vim'
})
