-- /////////////////////////////////////////////////////////////////////////////
-- basic
-- /////////////////////////////////////////////////////////////////////////////

vim.g.neovide_scroll_animation_length = 0.0
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_refresh_rate = 60
vim.g.neovide_refresh_rate_idle = 60
vim.g.neovide_no_idle = true
vim.g.neovide_cursor_animation_length = 0.0

function OSX()
  return vim.loop.os_uname().sysname == 'Darwin'
end

function LINUX()
  return vim.loop.os_uname().sysname == 'Linux'
end

function WINDOWS()
  return vim.loop.os_uname().sysname == 'Windows_NT'
end

-- TODO: delme
vim.cmd([[
  function! g:OSX()
    return has('macunix')
  endfunction

  function! g:LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
  endfunction

  function! g:WINDOWS()
    return (has('win16') || has('win32') || has('win64'))
  endfunction
]])

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
vim.opt.autochdir = false -- no autochchdir

if WINDOWS() then
  vim.opt.guifont = 'FuraMono Nerd Font:h11'
  vim.opt.guifontwide = 'Microsoft YaHei Mono:h11'
elseif OSX() then
  vim.opt.guifont = 'FuraMono Nerd Font:h13'
else
  vim.opt.guifont = 'FuraMono Nerd Font:h12'
end

--------------------------------------------------------------------
-- Desc: Vim UI
--------------------------------------------------------------------

vim.opt.wildmenu = true -- turn on wild menu, try typing :h and press <Tab>
vim.opt.showcmd = true -- display incomplete commands
vim.opt.cmdheight = 1 -- 1 screen lines to use for the command-line
vim.opt.ruler = true -- show the cursor position all the time
vim.opt.hidden = true -- allow to change buffer without saving
vim.opt.shortmess = 'aoOtTI' -- shortens messages to avoid 'press a key' prompt
vim.opt.lazyredraw = true -- do not redraw while executing macros (much faster)
vim.opt.display = 'lastline' -- for easy browse last line with wrap text
vim.opt.laststatus = 2 -- always have status-line
vim.opt.title = true
vim.opt.titlestring = '%t (%{expand("%:p:h")})'

-- set window size (if it's GUI)
-- set window's width to 130 columns and height to 40 rows
vim.opt.lines = 40
vim.opt.columns = 130
vim.opt.showfulltag = true -- show tag with function protype.

-- disable menu, toolbar and scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'm' -- disable Menu
-- vim.opt.guioptions = vim.opt.guioptions - 'T' -- disalbe Toolbar
-- vim.opt.guioptions = vim.opt.guioptions - 'b' -- disalbe the bottom scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'l' -- disalbe the left scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'L' -- disalbe the left scrollbar when the longest visible line exceed the window

--------------------------------------------------------------------
-- Desc: Text edit
--------------------------------------------------------------------

vim.opt.ai = true -- autoindent
vim.opt.si = true -- smartindent
vim.opt.backspace = 'indent,eol,start' -- allow backspacing over everything in insert mode
-- indent options
-- see help cinoptions-values for more details
-- set cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,k0,m0,j0,J0,)20,*70,#0
vim.opt.cinoptions = '>s,e0,n0,f0,{0,}0,^0,L0:0,=s,l0,b0,g0,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(0,us,U0,w0,Ws,m1,M0,j1,J1,)20,*70,#0'
-- default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
-- set cinkeys=0{,0},0),:,!^F,o,O,e

-- official diff settings
-- function MyDiff()
--   local opt = '-a --binary -w '
--   if vim.o.diffopt == 'icase' then opt = opt .. '-i ' end
--   if vim.o.diffopt == 'iwhite' then opt = opt .. '-b ' end

--   local arg1 = vim.v.fname_in
--   if arg1 == ' ' then arg1 = '"' .. arg1 .. '"' end

--   local arg2 = vim.v.fname_new
--   if arg2 == ' ' then arg2 = '"' .. arg2 .. '"' end

--   local arg3 = vim.v.fname_out
--   if arg3 == ' ' then arg3 = '"' .. arg3 .. '"' end

--   vim.cmd('!diff ' .. opt .. arg1 .. ' ' .. arg2 .. ' > ' .. arg3)
-- end
-- vim.opt.diffexpr = MyDiff()

vim.opt.cindent = true -- set cindent on to autoinent when editing c/c++ file
vim.opt.shiftwidth = 2 -- 2 shift width
vim.opt.tabstop = 2 -- set tabstop to 4 characters
vim.opt.expandtab = true -- set expandtab on, the tab will be change to space automaticaly
vim.opt.ve = 'block' -- in visual block mode, cursor can be positioned where there is no actual character

-- set Number format to null(default is octal), when press CTRL-A on number
-- like 007, it would not become 010
vim.opt.nf = ''
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'

--------------------------------------------------------------------
-- Desc: Fold text
--------------------------------------------------------------------

vim.opt.foldmethod = 'marker'
vim.opt.foldmarker = '{,}'
vim.opt.foldlevel = 9999
vim.opt.diffopt = 'filler,context:9999'

--------------------------------------------------------------------
-- Desc: Search
--------------------------------------------------------------------

vim.opt.showmatch = true -- show matching paren
vim.opt.incsearch = true -- do incremental searching
vim.opt.hlsearch = true -- highlight search terms
vim.opt.ignorecase = true -- set search/replace pattern to ignore case
vim.opt.smartcase = true -- set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

-- TODO: use rg instead
-- set this to use id-utils for global search
-- vim.opt.grepprg = 'lid -Rgrep -s'
-- vim.opt.grepformat = '%f:%l:%m'

-- /////////////////////////////////////////////////////////////////////////////
--  Key Mappings
-- /////////////////////////////////////////////////////////////////////////////

-- NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

-- Don't use Ex mode, use Q for formatting
vim.keymap.set('', 'Q', 'gq')

-- define the copy/paste judged by clipboard
-- general copy/paste.
-- NOTE: y,p,P could be mapped by other key-mapping
vim.keymap.set('', '<leader>y', '"*y')
vim.keymap.set('', '<leader>p', '"*p')
vim.keymap.set('', '<leader>P', '"*P')

-- copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
vim.keymap.set('n', '<leader>y1', ':let @*=fnamemodify(bufname("%"),":p:h")<CR>', { noremap = true, silent = true })

-- copy file name to clipboard, foo/bar/foobar.c => foobar.c
vim.keymap.set('n', '<leader>y2', ':let @*=fnamemodify(bufname("%"),":p:t")<CR>', { noremap = true, silent = true })

-- copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
vim.keymap.set('n', '<leader>y3', ':let @*=fnamemodify(bufname("%"),":p")<CR>', { noremap = true, silent = true })

-- F8 or <leader>/:  Set Search pattern highlight on/off
vim.keymap.set('n', '<leader>\\', ':let @/=""<CR>', { noremap = true, silent = true })
-- DISABLE: though nohlsearch is standard way in Vim, but it will not erase the
--          search pattern, which is not so good when use it with exVim's <leader>r
--          filter method
-- nnoremap <leader>\ :nohlsearch<CR>

-- map Ctrl-Tab to switch window
vim.keymap.set('n', '<S-Up>', '<C-W><Up>', { noremap = true })
vim.keymap.set('n', '<S-Down>', '<C-W><Down>', { noremap = true })
vim.keymap.set('n', '<S-Left>', '<C-W><Left>', { noremap = true })
vim.keymap.set('n', '<S-Right>', '<C-W><Right>', { noremap = true })

-- map Ctrl-Space to Omni Complete
vim.keymap.set('i', '<C-Space>', '<C-X><C-O>', { noremap = true })

-- -- NOTE: if we already map to EXbn,EXbp. skip setting this
-- -- easy buffer navigation
-- if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
--   nnoremap <C-l> :bn<CR>
-- endif
-- if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
--   noremap <C-h> :bp<CR>
-- endif

-- easy diff goto
vim.keymap.set('', '<C-k>', '[c', { noremap = true })
vim.keymap.set('', '<C-j>', ']c', { noremap = true })

-- enhance '<' '>' , do not need to reselect the block after shift it.
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- map Up & Down to gj & gk, helpful for wrap text edit
vim.keymap.set('', '<Up>', 'gk', { noremap = true })
vim.keymap.set('', '<Down>', 'gj', { noremap = true })

-- TODO: I should write a better one, make it as plugin exvim/swapword
-- VimTip 329: A map for swapping words
-- http://vim.sourceforge.net/tip_view.php?tip_id=
-- Then when you put the cursor on or in a word, press "\sw", and
-- the word will be swapped with the next word.  The words may
-- even be separated by punctuation (such as "abc = def").
vim.keymap.set('n', '<leader>sw', '"_yiw:s/(%#w+)(W+)(w+)/321/<cr><c-o>', { noremap = true, silent = true })

-- NOTE: au must after filetype plug, otherwise they won't work
-- /////////////////////////////////////////////////////////////////////////////
-- Auto Command
-- /////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------
-- Desc: Only do this part when compiled with support for autocommands.
--------------------------------------------------------------------

local ex_group = vim.api.nvim_create_augroup("ex", { clear = true })

-- when editing a file, always jump to the last known cursor position.
-- don't do it when the position is invalid or when inside an event handler
-- (happens when dropping a file on gvim).
vim.api.nvim_create_autocmd({'BufReadPost'}, {
  pattern = {'*'},
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal g`"')
    end
  end,
  group = ex_group,
})

-- NOTE: ctags find the tags file from the current path instead of the path of currect file
vim.api.nvim_create_autocmd({'BufNewFile', 'BufEnter'}, {
  pattern = {'*'},
  command = 'set cpoptions+=d',
  group = ex_group,
})

-- ensure every file does syntax highlighting (full)
vim.api.nvim_create_autocmd({'BufEnter'}, {
  pattern = {'*'},
  command = 'syntax sync fromstart',
  group = ex_group,
})

-- for avs syntax file.
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.avs'},
  command = 'set syntax=avs',
  group = ex_group,
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.vs', '*.fs', '*.hlsl', '*.fx', '*.fxh', '*.cg', '*.cginc', '*.vsh', '*.psh', '*.shd', '*.glsl'},
  command = 'set ft=glsl',
  group = ex_group,
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.shader'},
  command = 'set ft=shader',
  group = ex_group,
})

--------------------------------------------------------------------
-- Desc: file types
--------------------------------------------------------------------

-- for all text files set 'textwidth' to 78 characters.
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'text'},
  command = 'setlocal textwidth=78',
  group = ex_group,
})

-- this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.
-- au FileType c,cpp,cs,swig set nomodeline
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'c', 'cpp', 'cs', 'swig'},
  command = 'set nomodeline',
  group = ex_group,
})

-- disable auto-comment for c/cpp, lua, javascript, c# and vim-script
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'c', 'cpp', 'java', 'javascript'},
  command = [[set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://]],
  group = ex_group,
})
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'cs'},
  command = [[set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://]],
  group = ex_group,
})
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'vim'},
  command = [[set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"]],
  group = ex_group,
})
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'lua'},
  command = [[set comments=f:--]],
  group = ex_group,
})

-- disable automaticaly insert current comment leader after hitting <Enter>, 'o' or 'O'
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'c', 'cpp', 'cs', 'rust'},
  command = 'set formatoptions-=ro',
  group = ex_group,
})

-- if edit python scripts, check if have \t. (python said: the programme can only use \t or not, but can't use them together)
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'python', 'coffee'},
  callback = function()
    local has_noexpandtab = vim.fn.search('^\t','wn')
    local has_expandtab = vim.fn.search('^    ','wn')

    if has_noexpandtab and has_expandtab then
      local idx = vim.fn.inputlist({
        'ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
        '1. expand (tab=space, recommended)',
        '2. noexpand (tab=\t, currently have risk)',
        '3. do nothing (I will handle it by myself)'
      })
      local tab_space = vim.fn.printf('%*s',vim.o.tabstop,'')
      if idx == 1 then
        has_noexpandtab = 0
        has_expandtab = 1
        vim.cmd('%s/\t/' .. tab_space .. '/g')
      elseif idx == 2 then
        has_noexpandtab = 1
        has_expandtab = 0
        vim.cmd('%s/' .. tab_space .. '/\t/g')
      else
        return
      end
    end

    if has_noexpandtab == 1 and has_expandtab == 0 then
      print('substitute space to TAB...')
      vim.opt.expandtab = false
      print('done!')
    elseif has_noexpandtab == 0 and has_expandtab == 1 then
      print('substitute space to space...')
      vim.opt.expandtab = true
      print('done!')
    else
      -- it may be a new file
      -- we use original vim setting
    end
  end,
  group = ex_group,
})

-- /////////////////////////////////////////////////////////////////////////////
-- Plugs
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
  -- color theme
  {
    'rakr/vim-one',
    init = function()
      vim.cmd('colorscheme one')
      vim.opt.background = 'dark'
    end,
  },

  -- exvim-lite
  {
    'jwu/exvim-lite',
    config = function()
      local function find_file()
        vim.cmd('EXProjectFind')
      end

      local function fmt_file()
        vim.cmd('StripWhitespace')
        -- TODO: change to lspconfig
        -- use this than exec 'ALEFix' to prevent 'no fixer found error'
        -- vim.cmd('silent call ale#fix#Fix(bufnr(\'\'), \'!\')')
        print('file formatted!')
      end

      -- buffer operation
      vim.keymap.set('n', '<leader>bd', ':EXbd<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.del('n', '<C-l>')
      vim.keymap.set('n', '<C-l>', ':EXbn<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<C-h>', ':EXbp<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<C-Tab>', ':EXbalt<CR>', { noremap = true, silent = true, unique = true })

      -- plugin<->edit window switch
      vim.keymap.set('n', '<leader><Tab>', ':EXsw<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<leader><Esc>', ':EXgp<CR><ESC>', { silent = true, unique = true })

      -- search
      vim.keymap.set('n', '<leader>F', ':GS<space>', { noremap = true, unique = true })
      vim.keymap.set('n', '<leader>gg', ':EXSearchCWord<CR>', { noremap = true, unique = true })
      vim.keymap.set('n', '<leader>gs', ':call ex#search#toggle_window()<CR>', { noremap = true, unique = true })

      -- project
      vim.keymap.set('n', '<leader>fc', find_file, { noremap = true, unique = true })

      -- format
      vim.keymap.set('n', '<leader>w', fmt_file, { noremap = true, unique = true })
    end,
  },

  -- visual enhancement
  {
    'itchyny/lightline.vim',
    config = function()
      vim.api.nvim_exec([[
        function! LightlineBranch()
          if &buftype == 'nofile'
            return ''
          endif

          return ' ' .. FugitiveHead()
        endfunction

        function! LightlineFmod()
          " if &modified
          "   exe printf('hi link ModifiedColor Statement')
          " else
          "   exe printf('hi link ModifiedColor NonText')
          " endif
          let fname = fnamemodify(expand('%'), ':p:.:gs?\\?/?')
          let mod = &modified ? ' [+]' : ''
          let ro = &readonly ? ' [RO]' : ''

          return fname .. mod .. ro
        endfunction
      ]], true)

      vim.g.lightline = {
        colorscheme = 'one',
        active = {
          left = {
            {'mode', 'paste'},
            {'gitbranch'},
            {'fmod'},
          },
          right = {
            {'lineinfo'},
            {'fileinfo'},
            {'filetype'},
          },
        },
        inactive = {
          left = {
            {'fmod'},
          },
          right = {
            {'lineinfo'},
            {'fileinfo'},
            {'filetype'},
          },
        },
        component = {
          lineinfo = " %p%% %l/%v %{line('$')}",
          fileinfo = '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
        },
        component_function = {
          gitbranch = 'LightlineBranch',
          fmod = 'LightlineFmod',
        },
        separator = {
          left = '', right = ''
        },
        subseparator = {
          left = '', right = ''
        },
      }
    end,
  },
  -- TODO: 'nvim-lualine/lualine.nvim',
  -- local function LightlineBranch()
  --   if vim.o.buftype == 'nofile' then
  --     return ''
  --   end

  --   return ' ' .. vim.fn.FugitiveHead()
  -- end

  -- local function LightlineFmod()
  --   -- if &modified
  --   --   exe printf('hi link ModifiedColor Statement')
  --   -- else
  --   --   exe printf('hi link ModifiedColor NonText')
  --   -- endif
  --   local fname = vim.fn.fnamemodify(expand('%'), ':p:.:gs?\\?/?')
  --   local mod = vim.o.modified and ' [+]' or ''
  --   local ro = vim.o.readonly and ' [RO]' or ''

  --   return fname .. mod .. ro
  -- end

  {
    'petertriho/nvim-scrollbar',
    config = function()
      require("scrollbar").setup({
        handle = {
          text = " ",
          blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
          color = nil,
          color_nr = nil, -- cterm
          highlight = "Tabline",
          hide_if_all_visible = true, -- Hides handle if all lines are visible
        },
      })
    end,
  },

  -- text highlight
  {
    'exvim/ex-easyhl',
    config = function()
      vim.cmd([[
        hi clear EX_HL_label1
        hi EX_HL_label1 gui=none guibg=darkred term=none cterm=none ctermbg=darkred

        hi clear EX_HL_label2
        hi EX_HL_label2 gui=none guibg=darkmagenta term=none cterm=none ctermbg=darkmagenta

        hi clear EX_HL_label3
        hi EX_HL_label3 gui=none guibg=darkblue term=none cterm=none ctermbg=darkblue

        hi clear EX_HL_label4
        hi EX_HL_label4 gui=none guibg=darkgreen term=none cterm=none ctermbg=darkgreen
      ]])
    end,
  },

  {
    'exvim/ex-showmarks',
    init = function()
      vim.g.showmarks_enable = 1
      vim.g.showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

      -- Ignore help, quickfix, non-modifiable buffers
      vim.g.showmarks_ignore_type = 'hqm'

      -- Hilight lower & upper marks
      vim.g.showmarks_hlline_lower = 1
      vim.g.showmarks_hlline_upper = 0
    end,
    config = function()
      -- For marks a-z
      vim.cmd([[
        hi clear ShowMarksHLl
        hi ShowMarksHLl term=bold cterm=none ctermbg=lightblue gui=none guibg=SlateBlue
      ]])

      -- For marks A-Z
      vim.cmd([[
        hi clear ShowMarksHLu
        hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred
      ]])
    end,
  },

  -- syntax highlight/check
  'scrooloose/syntastic',
  'tikhomirov/vim-glsl',
  'drichardson/vex.vim',
  {
    'rust-lang/rust.vim',
    init = function()
      -- NOTE: we use ale & rust-analyzer instead
      vim.g.rustfmt_autosave = 0
      vim.g.rustfmt_autosave_if_config_present = 0
      vim.g.syntastic_rust_checkers = {}
    end
  },

  'cespare/vim-toml',

  -- complete
  'exvim/ex-searchcompl',
  'exvim/ex-autocomplpop',

  -- lsp
  -- {
  --   'dense-analysis/ale',
  --   init = function()
  --     vim.g.ale_hover_cursor = 0 -- disable hover cursor
  --     vim.g.ale_hover_to_preview = 0 -- disable hover preview window
  --     vim.g.ale_set_balloons = 0 -- disable hover mouse
  --     vim.g.ale_floating_preview = 1 -- NOTE: Vim 8+, long messages will be shown in a preview window, so we use this instead
  --     vim.g.ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

  --     vim.g.ale_completion_enabled = 0
  --     vim.g.ale_linters_explicit = 1 -- Only run linters named in ale_linters settings.
  --     vim.g.ale_linters = {
  --       cs = {'OmniSharp'},
  --       rust = {'analyzer'}
  --     }
  --     vim.g.ale_fixers = {
  --       rust = {'rustfmt'}
  --     }
  --     vim.g.ale_rust_analyzer_config = {
  --       diagnostics = {
  --         disabled = {'inactive-code'}
  --       }
  --     }
  --   end,
  --   config = function()
  --     vim.opt.omnifunc = 'ale#completion#OmniFunc'
  --     vim.opt.completeopt = 'menu,menuone,popup,noselect,noinsert'

  --     vim.keymap.set('n', '<leader>]', ':ALEGoToDefinition<CR>', { noremap = true })
  --     vim.keymap.set('n', '<leader>[', ':ALEHover<CR>', { noremap = true })
  --     -- NOTE: we do this in s:fmt_file()
  --     -- nnoremap <unique> <leader>w :ALEFix<CR>
  --   end,
  -- },
  -- {
  --   'jwu/omnisharp-vim',
  --   init = function()
  --     vim.g.OmniSharp_server_stdio = 1
  --     if WINDOWS() then
  --       vim.g.OmniSharp_server_path = 'd:\\utils\\omnisharp.win-x64\\OmniSharp.exe'
  --     end
  --     vim.g.OmniSharp_highlight_groups = {
  --       'ExcludedCode': 'Normal'
  --     }
  --   end,
  -- },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')

      -- rust
      lspconfig.rust_analyzer.setup {
        settings = {
          ['rust-analyzer'] = {},
        },
      }

      -- csharp
      local pid = vim.fn.getpid()
      local omnisharp_bin = 'd:\\utils\\omnisharp.win-x64\\OmniSharp.exe'
      lspconfig.omnisharp.setup {
        cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
      }

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { noremap = true, silent = true, buffer = ev.buf }
          vim.keymap.set('n', '<leader>[', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', '<leader>]', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

          -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wl', function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end, opts)
          -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          -- vim.keymap.set('n', '<space>f', function()
          --   vim.lsp.buf.format { async = true }
          -- end, opts)
        end,
      })
    end,
  },

  -- file operation
  {
    'kien/ctrlp.vim',
    init = function()
      vim.g.ctrlp_working_path_mode = ''
      -- let vim.g.ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'
      vim.g.ctrlp_follow_symlinks = 2
      vim.g.ctrlp_max_files = 0 -- Unset cap of 10,000 files so we find everything
    end,
    config = function()
      vim.keymap.set('n', '<leader>bs', ':CtrlPBuffer<CR>', { noremap = true, unique = true })
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end
  },

  -- text editing
  {
    'tpope/vim-commentary',
    config = function()
      vim.keymap.set('x', '<leader>/', '<Plug>Commentary')
      vim.keymap.set('n', '<leader>/', '<Plug>CommentaryLine')

      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = {'cs'},
        command = [[setlocal commentstring=\/\/\ %s]],
      })
    end,
  },
  {
    'tpope/vim-surround',
    config = function()
      vim.keymap.set('x', 's', '<Plug>VSurround')
    end,
  },
  'vim-scripts/VisIncr',
  {
    'godlygeek/tabular',
    config = function()
      vim.cmd([[
        function! g:Tabular(ignore_range) range
          let c = getchar()
          let c = nr2char(c)
          if a:ignore_range == 0
            exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
          else
            exec printf('Tabularize /%s', c)
          endif
        endfunction
      ]])

      vim.keymap.set('n', '<leader>=', ':call g:Tabular(1)<CR>', { noremap = true, silent = true })
      vim.keymap.set('x', '<leader>=', ':call g:Tabular(0)<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'jwu/vim-better-whitespace',
    init = function()
      vim.g.better_whitespace_guicolor = 'darkred'
      -- NOTE: we do this in s:fmt_file()
      -- nnoremap <unique> <leader>w :StripWhitespace<CR>
    end,
  },

  -- git operation
  'tpope/vim-fugitive',
})
