-- /////////////////////////////////////////////////////////////////////////////
-- basic
-- /////////////////////////////////////////////////////////////////////////////

vim.g.neovide_scale_factor = 1.0 -- NOTE: adjust by your system font scale factor
vim.g.neovide_scroll_animation_length = 0.0
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_refresh_rate = 60
vim.g.neovide_refresh_rate_idle = 60
vim.g.neovide_no_idle = true
vim.g.neovide_cursor_animation_length = 0.0

local function OSX()
  return vim.loop.os_uname().sysname == 'Darwin'
end

local function LINUX()
  return vim.loop.os_uname().sysname == 'Linux'
end

local function WINDOWS()
  return vim.loop.os_uname().sysname == 'Windows_NT'
end

_G.OSX = OSX
_G.LINUX = LINUX
_G.WINDOWS = WINDOWS

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
  vim.opt.fileencoding = 'utf-8'
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
  vim.fn.mkdir(data_dir, 'p', '0700')
end

if vim.fn.finddir(backup_dir) == '' then
  vim.fn.mkdir(backup_dir, 'p', '0700')
end

if vim.fn.finddir(swap_dir) == '' then
  vim.fn.mkdir(swap_dir, 'p', '0700')
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
  vim.opt.guifont = 'FiraMono Nerd Font:h12'
  vim.opt.guifontwide = 'Microsoft YaHei Mono:h12'
elseif OSX() then
  vim.opt.guifont = 'FiraMono Nerd Font:h13'
else
  vim.opt.guifont = 'FiraMono Nerd Font:h12'
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
-- vim.opt.lines = 40
-- vim.opt.columns = 130
vim.opt.showfulltag = true -- show tag with function protype.
vim.opt.signcolumn = 'auto'

vim.opt.mousemoveevent = true

-- disable menu, toolbar and scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'm' -- disable Menu
-- vim.opt.guioptions = vim.opt.guioptions - 'T' -- disalbe Toolbar
-- vim.opt.guioptions = vim.opt.guioptions - 'b' -- disalbe the bottom scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'l' -- disalbe the left scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'L' -- disalbe the left scrollbar when the longest visible line exceed the window

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, linehl = nil, numhl = nil })
end

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
local function MyDiff()
  local opt = '-a --binary -w '
  if vim.o.diffopt == 'icase' then opt = opt .. '-i ' end
  if vim.o.diffopt == 'iwhite' then opt = opt .. '-b ' end
  vim.cmd('silent !diff ' .. opt .. vim.v.fname_in .. ' ' .. vim.v.fname_new .. ' > ' .. vim.v.fname_out)
  vim.cmd('redraw!')
end

_G.MyDiff = MyDiff
vim.opt.diffexpr = 'luaeval("MyDiff()")'

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

-- DISABLE
-- map Ctrl-Space to Omni Complete
-- vim.keymap.set('i', '<C-Space>', '<C-X><C-O>', { noremap = true })

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

local ex_group = vim.api.nvim_create_augroup('ex', { clear = true })

-- when editing a file, always jump to the last known cursor position.
-- don't do it when the position is invalid or when inside an event handler
-- (happens when dropping a file on gvim).
vim.api.nvim_create_autocmd({'BufReadPost'}, {
  group = ex_group,
  pattern = {'*'},
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal g`"')
    end
  end,
})

-- NOTE: ctags find the tags file from the current path instead of the path of currect file
vim.api.nvim_create_autocmd({'BufNewFile', 'BufEnter'}, {
  group = ex_group,
  pattern = {'*'},
  command = 'set cpoptions+=d',
})

-- ensure every file does syntax highlighting (full)
vim.api.nvim_create_autocmd({'BufEnter'}, {
  group = ex_group,
  pattern = {'*'},
  command = 'syntax sync fromstart',
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = ex_group,
  pattern = {'*.hlsl', '*.shader', '*.cg', '*.cginc', '*.vs', '*.fs', '*.fx', '*.fxh', '*.vsh', '*.psh', '*.shd'},
  command = 'set ft=hlsl',
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = ex_group,
  pattern = {'*.glsl'},
  command = 'set ft=glsl',
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = ex_group,
  pattern = {'*.avs'},
  command = 'set syntax=avs',
})

--------------------------------------------------------------------
-- Desc: file types
--------------------------------------------------------------------

-- for all text files set 'textwidth' to 78 characters.
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'text'},
  command = 'setlocal textwidth=78',
})

-- this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.
-- au FileType c,cpp,cs,swig set nomodeline
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'c', 'cpp', 'cs', 'swig'},
  command = 'set nomodeline',
})

-- disable auto-comment for c/cpp, lua, javascript, c# and vim-script
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'c', 'cpp', 'java', 'javascript'},
  command = [[set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://]],
})
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'cs'},
  command = [[set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://]],
})
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'vim'},
  command = [[set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"]],
})
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'lua'},
  command = [[set comments=f:--]],
})

-- disable automaticaly insert current comment leader after hitting <Enter>, 'o' or 'O'
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'c', 'cpp', 'cs', 'rust'},
  command = 'set formatoptions-=ro',
})

-- if edit python scripts, check if have \t. (python said: the programme can only use \t or not, but can't use them together)
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
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
})

-- /////////////////////////////////////////////////////////////////////////////
-- Plugs
-- /////////////////////////////////////////////////////////////////////////////

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  ------------------------------
  -- color theme
  ------------------------------

  {
    'navarasu/onedark.nvim',
    priority = 100,
    config = function()
      require('onedark').setup {
        style = 'dark',
        transparent = false,
        term_colors = true,
        ending_tildes = false,
        cmp_itemkind_reverse = false,

        -- Options are italic, bold, underline, none
        code_style = {
          comments = 'none',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none'
        },

        lualine = {
          transparent = false,
        },

        -- Custom Highlights --
        colors = {},
        highlights = {
          -- exvim/ex-easyhl
          ['EX_HL_label1'] = { bg = 'darkred'},
          ['EX_HL_label2'] = { bg = 'darkmagenta'},
          ['EX_HL_label3'] = { bg = 'darkblue'},
          ['EX_HL_label4'] = { bg = 'darkgreen'},

          -- 'exvim/ex-showmarks'
          ['ShowMarksHLl'] = { bg = 'slateblue', fmt = 'none' },
          ['ShowMarksHLu'] = { fg = 'darkred', bg = 'lightred', fmt = 'bold' },
        },

        -- Plugins Config --
        diagnostics = {
          darker = true,
          undercurl = true,
          background = true,
        },
      }
      require('onedark').load()
    end
  },

  ------------------------------
  -- exvim-lite
  ------------------------------

  {
    'jwu/exvim-lite',
    config = function()
      local function is_nvim_tree_open()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local bufnr = vim.api.nvim_win_get_buf(win)
          local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
          if filetype == 'NvimTree' then
            return true
          end
        end
        return false
      end

      local function find_file()
        if is_nvim_tree_open() then
          vim.cmd('NvimTreeFindFile')
          return
        end

        vim.cmd('EXProjectFind')
      end

      local function strip_ws()
        vim.cmd('StripWhitespace')
        print('whitespace striped!')
      end

      vim.api.nvim_create_autocmd({'FileType'}, {
        group = ex_group,
        pattern = {'exproject', 'exsearch'},
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      -- buffer operation
      vim.keymap.set('n', '<leader>bd', ':EXbd<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.del('n', '<C-l>')
      vim.keymap.set('n', '<C-l>', ':EXbn<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<C-h>', ':EXbp<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<C-Tab>', ':EXbalt<CR>', { noremap = true, silent = true, unique = true })

      -- plugin<->edit window switch
      vim.keymap.set('n', '<leader><Tab>', ':EXsw<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<leader><Esc>', ':EXgc<CR>', { noremap = true, silent = true, unique = true })

      -- search
      vim.keymap.set('n', '<leader>F', ':GS<space>', { noremap = true, unique = true })
      vim.keymap.set('n', '<leader>gg', ':EXSearchCWord<CR>', { noremap = true, unique = true })
      vim.keymap.set('n', '<leader>gs', ':call ex#search#toggle_window()<CR>', { noremap = true, unique = true })

      -- plugin hotkey
      vim.keymap.set('n', '<leader>fc', find_file, { noremap = true, unique = true })
      vim.keymap.set('n', '<leader>w', strip_ws, { noremap = true, unique = true })
    end,
  },

  ------------------------------
  -- visual enhancement
  ------------------------------

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local bufferline = require('bufferline')

      _G.show_bufferline = function()
        local config = require('bufferline.config')
        config.options.always_show_bufferline = true
      end

      bufferline.setup {
        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
          },
        },
        options = {
          mode = 'buffers',
          style_preset = bufferline.style_preset.default,
          themable = true,
          separator_style = 'thick',
          always_show_bufferline = false,
          hover = {
            enabled = true,
            delay = 100,
            reveal = {'close'}
          },
          offsets = {
            {
              filetype = 'NvimTree',
              text = function()
                return vim.fn.getcwd()
              end,
              highlight = 'Directory',
              separator = true,
              text_align = 'left',
            },
            {
              filetype = 'exproject',
              text = function()
                return vim.fn.getcwd()
              end,
              highlight = 'Directory',
              separator = true,
              text_align = 'left',
            }
          }
        },
      }
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- local function lineinfo()
      --   return "%p%% %l:%v %{line('$')}"
      -- end
      local function projectinfo()
        return 'Project'
      end
      local function searchinfo()
        return 'Search Results'
      end

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onedark',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {'filename'},
          lualine_x = {'filetype'},
          lualine_y = {'encoding', 'fileformat'},
          lualine_z = {'progress', 'location'}
          -- lualine_z = {lineinfo}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'filetype'},
          lualine_y = {'encoding', 'fileformat'},
          lualine_z = {'progress', 'location'}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          {
            filetypes = {'exproject', 'NvimTree'},
            sections = {
              lualine_a = {projectinfo},
              lualine_b = {'progress'},
              lualine_c = {'location'},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {}
            }
          },
          {
            filetypes = {'exsearch'},
            sections = {
              lualine_a = {searchinfo},
              lualine_b = {'progress'},
              lualine_c = {'location'},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {}
            }
          },
        }
      }
    end,
  },

  {
    'petertriho/nvim-scrollbar',
    dependencies = {
      'kevinhwang91/nvim-hlslens',
      'lewis6991/gitsigns.nvim',
    },
    config = function()
      require('gitsigns').setup {
        update_debounce = 100,
      }
      require('scrollbar.handlers.gitsigns').setup()

      require('scrollbar.handlers.search').setup {
        override_lens = function() end, -- leave only search marks and disable virtual text
      }

      require('scrollbar').setup {
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
        max_lines = false, -- disables if no. of lines in buffer exceeds this
        hide_if_all_visible = false, -- Hides everything if all lines are visible
        throttle_ms = 100,
        handle = {
          text = ' ',
          blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
          color = nil,
          color_nr = nil, -- cterm
          highlight = 'Tabline',
          hide_if_all_visible = true, -- Hides handle if all lines are visible
        },
        marks = {
          Cursor = {
            text = '•',
            priority = 0,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'Normal',
          },
          Search = {
            text = { '-', '=' },
            priority = 1,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'Type',
          },
          GitAdd = {
            text = '┆',
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'GitSignsAdd',
          },
          GitChange = {
            text = '┆',
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'GitSignsChange',
          },
          GitDelete = {
            text = '▁',
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'GitSignsDelete',
          },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true, -- Requires gitsigns
          handle = true,
          search = true, -- Requires hlslens
          ale = false, -- Requires ALE
        },
      }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('ibl').setup {
        indent = {
          char = '▏',
          tab_char = '▏',
        },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            'help',
            'alpha',
            'dashboard',
            'neo-tree',
            'Trouble',
            'trouble',
            'lazy',
            'mason',
            'notify',
            'toggleterm',
            'lazyterm',
            'exproject',
          },
        },
      }
    end,
  },

  {
    'echasnovski/mini.indentscope',
    config = function()
      local mini_is = require('mini.indentscope')
      mini_is.setup {
        symbol = '▏',
        draw = {
          delay = 100,
          animation = mini_is.gen_animation.none(),
          priority = 2,
        },
        options = { try_as_border = true },
      }
    end,
  },

  ------------------------------
  -- text highlight
  ------------------------------

  'exvim/ex-easyhl',

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
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      sign_priority = 8,
      keywords = {
        FIX  = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, },
        DEL  = { icon = ' ', color = 'error', alt = { 'DELME' }, },
        TODO = { icon = ' ', color = 'info' },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTME', 'TESTING', 'PASSED', 'FAILED' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      },
      gui_style = {
        fg = 'NONE',
        bg = 'BOLD',
      },
      merge_keywords = true,
      highlight = {
        multiline = false,
        multiline_pattern = '^.',
        multiline_context = 10,
        before = '',
        keyword = 'bg',
        after = '',
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
    }
  },

  -- TODO: config it
  -- {
  --   'RRethy/vim-illuminate',
  --   config = function()
  --     require('illuminate').configure{
  --       delay = 100,
  --     }
  --   end,
  -- },

  ------------------------------
  -- syntax highlight/check
  ------------------------------

  {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c', 'cpp', 'c_sharp', 'rust', 'go',
          'python', 'lua', 'javascript', 'typescript', 'vim',
          'css', 'hlsl', 'glsl', 'wgsl',
          'json', 'toml', 'yaml', 'xml', 'html',
          'vimdoc', 'markdown', 'markdown_inline',
          'diff', 'query',
        },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },

  'tikhomirov/vim-glsl',
  'drichardson/vex.vim',
  'cespare/vim-toml',

  ------------------------------
  -- complete
  ------------------------------

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup {
        completion = {
          completeopt = 'menu,menuone,noselect,noinsert',
        },

        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- next
          ['<C-j>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end
          end, { 'i', 's', 'c' }),

          -- prev
          ['<C-k>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            end
          end, { 'i', 's', 'c' }),

          -- Tab
          ['<Tab>'] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
              local entry = cmp.get_selected_entry()
              if not entry then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              end
              cmp.confirm()
            else
              fallback()
            end
          end, { 'i', 's', 'c' }),
        }),

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      }

      -- DELME: disable cause it will make cursor jump amongs multiple windows
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline({ '/', '?' }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   view = {
      --     entries = { name = 'wildmenu', separator = ' | ' }
      --   },
      --   sources = {
      --     { name = 'buffer' }
      --   }
      -- })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        view = {
          entries = { name = 'wildmenu', separator = ' | ' }
        },
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end,
  },

  -- NOTE: Use this instead of  nvim-cmp cmdline({ '/', '?' }, ...)
  -- NOTE: nvim-cmp will random jump cursor when working with ex-gsearch window
  'exvim/ex-searchcompl',

  ------------------------------
  -- lsp
  ------------------------------

  {
    'github/copilot.vim',
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'clangd', 'omnisharp', 'rust_analyzer',
          'pyright', 'lua_ls',
        },
        automatic_installation = false,
      }

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      lspconfig.clangd.setup {
        capabilities = capabilities,
      }
      lspconfig.omnisharp.setup {
        capabilities = capabilities,
      }
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
      }
      lspconfig.pyright.setup {
        capabilities = capabilities,
      }
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim'},
            },
          },
        },
      }

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          local opts = { noremap = true, silent = true, buffer = ev.buf }
          vim.keymap.set('n', '<leader>]', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<leader>[', vim.lsp.buf.hover, opts)
          -- TODO: vim.lsp.buf.references(nil, {on_list = on_list})
          vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>gD', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.signature_help, opts)

          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          -- NOTE: format file will strip whitespace first.
          -- this is because some fmt don't handle whitespace trim well.
          vim.keymap.set('n', '<leader>ff', function()
            vim.cmd('StripWhitespace')
            vim.lsp.buf.format { async = true }
            print('file formatted!')
          end, opts)
        end,
      })
    end,
  },

  -- TODO: https://github.com/mfussenegger/nvim-lint
  -- TODO: https://github.com/neomake/neomake

  ------------------------------
  -- file operation
  ------------------------------

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local themes = require('telescope.themes')

      -- TODO: support other platform
      telescope.setup {
        defaults = {
          file_ignore_patterns = {
            '**/*.meta',
            '^[Bb]uild\\',
            '^[Ll]ibrary\\',
            '^[Ll]ogs\\',
            '^[Oo]bj\\',
            '^[Tt]emp\\',
          }
        }
      }

      local function find_files()
        builtin.find_files(themes.get_dropdown({
          hidden = false,
          no_ignore = true,
          no_ignore_parent = false,
        }))
      end

      vim.keymap.set('n', '<C-p>', find_files, {})
      -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end
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

      local view = require('nvim-tree.view')
      local win_size = 30
      local win_size_zoom = 60

      local function toggle_zoom()
        local winnr = view.get_winnr()
        local cur_size = vim.api.nvim_win_get_width(winnr)

        if cur_size == win_size then
          view.resize(win_size_zoom)
        elseif cur_size == win_size_zoom then
          view.resize(win_size)
        elseif cur_size > win_size_zoom then
          view.resize(win_size_zoom)
        else
          view.resize(win_size)
        end
      end

      require('nvim-tree').setup {
        sort_by = 'case_sensitive',
        view = {
          width = win_size,
        },
        renderer = {
          group_empty = true,
        },
        git = {
          show_on_dirs = true,
        },
        filters = {
          git_ignored = false,
          dotfiles = true,
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          vim.keymap.set('n', '<F1>',    api.tree.toggle_help, opts('Help'))
          vim.keymap.set('n', '<Space>', toggle_zoom, opts('Resize window'))
        end,
      }
    end
  },

  ------------------------------
  -- text editing
  ------------------------------

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
    end,
  },

  ------------------------------
  -- git operation
  ------------------------------

  'sindrets/diffview.nvim',
  'tpope/vim-fugitive',

  ------------------------------
  -- language tools
  ------------------------------

  -- rust
  -- TODO:
  -- {
  --   'mrcjkb/rustaceanvim',
  --   version = '^4', -- Recommended
  --   ft = { 'rust' },
  -- }

})
