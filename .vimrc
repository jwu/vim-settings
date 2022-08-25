vim9script

# /////////////////////////////////////////////////////////////////////////////
#  basic
# /////////////////////////////////////////////////////////////////////////////

set nocompatible # be iMproved, required

if has('nvim')
  set termguicolors
endif

def OSX(): bool
  return has('macunix')
enddef

def LINUX(): bool
  var unix = has('unix')
  var macunix = has('macunix')
  var win32unix = has('win32unix')

  return unix && !macunix && !win32unix
enddef

def WINDOWS(): bool
  var win16 = has('win16')
  var win32 = has('win32')
  var win64 = has('win64')

  return win16 || win32 || win64
enddef

# /////////////////////////////////////////////////////////////////////////////
# language and encoding setup
# /////////////////////////////////////////////////////////////////////////////

# always use English menu
# NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

# use English for anaything in vim-editor.
if WINDOWS()
  silent exec 'language english'
elseif OSX()
  silent exec 'language en_US'
else
  var uname = system("uname -s")
  if uname == "Darwin\n"
    # in mac-terminal
    silent exec 'language en_US'
  else
    # in linux-terminal
    silent exec 'language en_US.utf8'
  endif
endif

# try to set encoding to utf-8
if WINDOWS()
  # Be nice and check for multi_byte even if the config requires
  # multi_byte support most of the time
  if has('multi_byte')
    # Windows cmd.exe still uses cp850. If Windows ever moved to
    # Powershell as the primary terminal, this would be utf-8
    set termencoding=cp850
    # Let Vim use utf-8 internally, because many scripts require this
    set encoding=utf-8
    setglobal fileencoding=utf-8
    # Windows has traditionally used cp1252, so it's probably wise to
    # fallback into cp1252 instead of eg. iso-8859-15.
    # Newer Windows files might contain utf-8 or utf-16 LE so we might
    # want to try them first.
    set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
  endif

else
  # set default encoding to utf-8
  set encoding=utf-8
  set termencoding=utf-8
endif

scriptencoding utf-8

# /////////////////////////////////////////////////////////////////////////////
# General
# /////////////////////////////////////////////////////////////////////////////

#set path=.,/usr/include/*,, " where gf, ^Wf, :find will search
set backup # make backup file and leave it around

# setup back and swap directory
var data_dir = $HOME .. '/.data/'
var backup_dir = data_dir .. 'backup'
var swap_dir = data_dir .. 'swap'

if finddir(data_dir) == ''
  silent call mkdir(data_dir, 'p', 0700)
endif

if finddir(backup_dir) == ''
  silent call mkdir(backup_dir, 'p', 0700)
endif

if finddir(swap_dir) == ''
  silent call mkdir(swap_dir, 'p', 0700)
endif

backup_dir = null_string
swap_dir = null_string
data_dir = null_string

set backupdir=$HOME/.data/backup # where to put backup file
set directory=$HOME/.data/swap # where to put swap file

# Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 # keep 50 lines of command line history
set updatetime=1000 # default = 4000
set autoread # auto read same-file change (better for vc/vim change)
set maxmempattern=1000 # enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)

# /////////////////////////////////////////////////////////////////////////////
# xterm settings
# /////////////////////////////////////////////////////////////////////////////

behave xterm  # set mouse behavior as xterm
if &term =~ 'xterm'
  set mouse=a
endif

# /////////////////////////////////////////////////////////////////////////////
# Variable settings (set all)
# /////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------
# Desc: Visual
# ------------------------------------------------------------------

set matchtime=0 # 0 second to show the matching paren (much faster)
set nu # show line number
set scrolloff=0 # minimal number of screen lines to keep above and below the cursor
set nowrap # do not wrap text

# only supoort in 7.3 or higher
if v:version >= 703
  set noacd # no autochchdir
endif

# set default guifont
if has('gui_running')
  augroup ex_gui_font
    # check and determine the gui font after GUIEnter.
    # NOTE: getfontname function only works after GUIEnter.
    au!
    au GUIEnter * call S_set_gui_font()
  augroup END

  # set guifont
  def S_set_gui_font()
    if has('gui_gtk2')
      if getfontname('DejaVu Sans Mono for Powerline') != ''
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
      elseif getfontname('DejaVu Sans Mono') != ''
        set guifont=DejaVu\ Sans\ Mono\ 12
      else
        set guifont=Luxi\ Mono\ 12
      endif
    elseif has('x11')
      # Also for GTK 1
      set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
    elseif OSX()
      if getfontname('DejaVu Sans Mono for Powerline') != ''
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h13
      elseif getfontname('DejaVu Sans Mono') != ''
        set guifont=DejaVu\ Sans\ Mono:h13
      endif
    elseif WINDOWS()
      if getfontname('DejaVu Sans Mono for Powerline') != ''
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11
        set guifontwide=Microsoft\ YaHei\ Mono:h11
      elseif getfontname('DejaVu Sans Mono') != ''
        set guifont=DejaVu\ Sans\ Mono:h11
        set guifontwide=Microsoft\ YaHei\ Mono:h11
      elseif getfontname('Consolas') != ''
        set guifont=Consolas:h11
        set guifontwide=Microsoft\ YaHei\ Mono:h11
      else
        set guifont=Lucida_Console:h11
      endif
    endif
  enddef
endif

# ------------------------------------------------------------------
# Desc: Vim UI
# ------------------------------------------------------------------

set wildmenu # turn on wild menu, try typing :h and press <Tab>
set showcmd # display incomplete commands
set cmdheight=1 # 1 screen lines to use for the command-line
set ruler # show the cursor position all the time
set hidden # allow to change buffer without saving
set shortmess=aoOtTI # shortens messages to avoid 'press a key' prompt
set lazyredraw # do not redraw while executing macros (much faster)
set display+=lastline # for easy browse last line with wrap text
set laststatus=2 # always have status-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)

# set window size (if it's GUI)
if has('gui_running')
  # set window's width to 130 columns and height to 40 rows
  if exists('+lines')
    set lines=40
  endif

  if exists('+columns')
    set columns=130
  endif

  # DISABLE
  # if WINDOWS()
  #     au GUIEnter * simalt ~x # Maximize window when enter vim
  # else
  #     # TODO: no way right now
  # endif
endif

set showfulltag # show tag with function protype.

# disable menu & toolbar, add bottom scrollbar
set guioptions-=m # disable Menu
set guioptions-=T # disalbe Toolbar
set guioptions+=b # present the bottom scrollbar when the longest visible line exceed the window

# ------------------------------------------------------------------
# Desc: Text edit
# ------------------------------------------------------------------

set ai # autoindent
set si # smartindent
set backspace=indent,eol,start # allow backspacing over everything in insert mode
# indent options
# see help cinoptions-values for more details
# set cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,k0,m0,j0,J0,)20,*70,#0
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,L0:0,=s,l0,b0,g0,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(0,us,U0,w0,Ws,m1,M0,j1,J1,)20,*70,#0
# default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
# set cinkeys=0{,0},0),:,!^F,o,O,e

# official diff settings
set diffexpr=g:MyDiff()
def! g:MyDiff()
  var opt = '-a --binary -w '
  if &diffopt =~ 'icase' | opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | opt = opt . '-b ' | endif
  var arg1 = v:fname_in
  if arg1 =~ ' ' | arg1 = '"' . arg1 . '"' | endif
  var arg2 = v:fname_new
  if arg2 =~ ' ' | arg2 = '"' . arg2 . '"' | endif
  var arg3 = v:fname_out
  if arg3 =~ ' ' | arg3 = '"' . arg3 . '"' | endif
  silent execute '!' .  'diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
enddef

set cindent shiftwidth=2 # set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=2 # set tabstop to 4 characters
set expandtab # set expandtab on, the tab will be change to space automaticaly
set ve=block # in visual block mode, cursor can be positioned where there is no actual character

# set Number format to null(default is octal) , when press CTRL-A on number
# like 007, it would not become 010
set nf=

# ------------------------------------------------------------------
# Desc: Fold text
# ------------------------------------------------------------------

set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

# ------------------------------------------------------------------
# Desc: Search
# ------------------------------------------------------------------

set showmatch # show matching paren
set incsearch # do incremental searching
set hlsearch # highlight search terms
set ignorecase # set search/replace pattern to ignore case
set smartcase # set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

# set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m

# /////////////////////////////////////////////////////////////////////////////
# Key Mappings
# /////////////////////////////////////////////////////////////////////////////

# NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

# Don't use Ex mode, use Q for formatting
map Q gq

# define the copy/paste judged by clipboard
if &clipboard ==# 'unnamed'
  # fix the visual paste bug in vim
  # vnoremap <silent>p :call g:()<CR>
else
  # general copy/paste.
  # NOTE: y,p,P could be mapped by other key-mapping
  map <leader>y "*y
  map <leader>p "*p
  map <leader>P "*P
endif

# copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
nnoremap <silent> <leader>y1 :@*=fnamemodify(bufname('%'),":p:h")<CR>

# copy file name to clipboard, foo/bar/foobar.c => foobar.c
nnoremap <silent> <leader>y2 :@*=fnamemodify(bufname('%'),":p:t")<CR>

# copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
nnoremap <silent> <leader>y3 :@*=fnamemodify(bufname('%'),":p")<CR>

# F8 or <leader>/:  Set Search pattern highlight on/off
nnoremap <F8> :@/=""<CR>
nnoremap <leader>/ :@/=""<CR>
# DISABLE: though nohlsearch is standard way in Vim, but it will not erase the
#          search pattern, which is not so good when use it with exVim's <leader>r
#          filter method
# nnoremap <F8> :nohlsearch<CR>
# nnoremap <leader>/ :nohlsearch<CR>

# map Ctrl-Tab to switch window
nnoremap <S-Up> <C-W><Up>
nnoremap <S-Down> <C-W><Down>
nnoremap <S-Left> <C-W><Left>
nnoremap <S-Right> <C-W><Right>

# map Ctrl-] to Omni Complete
inoremap <C-]> <C-X><C-O>

# # NOTE: if we already map to EXbn,EXbp. skip setting this
# # easy buffer navigation
# if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
#   nnoremap <C-l> :bn<CR>
# endif
# if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
#   noremap <C-h> :bp<CR>
# endif

# easy diff goto
noremap <C-k> [c
noremap <C-j> ]c

# enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

# map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj

# TODO: I should write a better one, make it as plugin exvim/swapword
# VimTip 329: A map for swapping words
# http://vim.sourceforge.net/tip_view.php?tip_id=
# Then when you put the cursor on or in a word, press "\sw", and
# the word will be swapped with the next word.  The words may
# even be separated by punctuation (such as "abc = def").
nnoremap <silent> <leader>sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o>

# /////////////////////////////////////////////////////////////////////////////
# vim-plug
# /////////////////////////////////////////////////////////////////////////////

plug#begin('~/.vim/plugged')

# exvim-lite
Plug 'jwu/exvim-lite'

# color theme
Plug 'rakr/vim-one'

# visual enhancement
Plug 'vim-airline/vim-airline'

# text highlight
Plug 'exvim/ex-easyhl'
Plug 'exvim/ex-showmarks'

# syntax highlight/check
Plug 'scrooloose/syntastic'
Plug 'tikhomirov/vim-glsl'
Plug 'drichardson/vex.vim'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

# complete
Plug 'exvim/ex-searchcompl'
Plug 'exvim/ex-autocomplpop'
Plug 'OmniSharp/omnisharp-vim'
# TODO: Plug 'neoclide/coc.nvim'

# file operation
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'

# text editing
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/VisIncr'
Plug 'godlygeek/tabular'
Plug 'ntpeters/vim-better-whitespace'

# git operation
Plug 'tpope/vim-fugitive'

plug#end()

# NOTE: au must after filetype plug, otherwise they won't work
# /////////////////////////////////////////////////////////////////////////////
# Auto Command
# /////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------
# Desc: Only do this part when compiled with support for autocommands.
# ------------------------------------------------------------------

if has('autocmd')
  augroup ex
    au!

    # ------------------------------------------------------------------
    # Desc: Buffer
    # ------------------------------------------------------------------

    # when editing a file, always jump to the last known cursor position.
    # don't do it when the position is invalid or when inside an event handler
    # (happens when dropping a file on gvim).
    au BufReadPost * \
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \ exe "normal g`\"" |
          \ endif
    au BufNewFile,BufEnter * set cpoptions+=d # NOTE: ctags find the tags file from the current path instead of the path of currect file
    au BufEnter * :syntax sync fromstart # ensure every file does syntax highlighting (full)
    au BufNewFile,BufRead *.avs set syntax=avs # for avs syntax file.
    au BufNewFile,BufRead *.{vs,fs,hlsl,fx,fxh,cg,cginc,vsh,psh,shd,glsl,shader} set ft=glsl
    au BufNewFile,BufRead *.shader set ft=shader

    # ------------------------------------------------------------------
    # Desc: file types
    # ------------------------------------------------------------------

    au FileType text setlocal textwidth=78 # for all text files set 'textwidth' to 78 characters.
    au FileType c,cpp,cs,swig set nomodeline # this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

    # disable auto-comment for c/cpp, lua, javascript, c# and vim-script
    au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
    au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
    au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
    au FileType lua set comments=f:--

    # disable automaticaly insert current comment leader after hitting <Enter>, 'o' or 'O'
    au FileType c,cpp,cs set formatoptions-=ro

    # if edit python scripts, check if have \t. (python said: the programme can only use \t or not, but can't use them together)
    au FileType python,coffee call S_check_if_expand_tab()
  augroup END

  def S_check_if_expand_tab()
    var has_noexpandtab = search('^\t','wn')
    var has_expandtab = search('^    ','wn')

    if has_noexpandtab && has_expandtab
      var idx = inputlist([
        'ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
        '1. expand (tab=space, recommended)',
        '2. noexpand (tab=\t, currently have risk)',
        '3. do nothing (I will handle it by myself)'
      ])
      var tab_space = printf('%*s',&tabstop,'')
      if idx == 1
        has_noexpandtab = 0
        has_expandtab = 1
        silent exec '%s/\t/' . tab_space . '/g'
      elseif idx == 2
        has_noexpandtab = 1
        has_expandtab = 0
        silent exec '%s/' . tab_space . '/\t/g'
      else
        return
      endif
    endif

    if has_noexpandtab == 1 && has_expandtab == 0
      echomsg 'substitute space to TAB...'
      set noexpandtab
      echomsg 'done!'
    elseif has_noexpandtab == 0 && has_expandtab == 1
      echomsg 'substitute TAB to space...'
      set expandtab
      echomsg 'done!'
    else
      # it may be a new file
      # we use original vim setting
    endif
  enddef
endif

# /////////////////////////////////////////////////////////////////////////////
# vim-plug setup
# /////////////////////////////////////////////////////////////////////////////

# exvim-lite
# ---------------------------------------------------

def S_find_file()
  if g:NERDTree.IsOpen()
    exec 'NERDTreeFind'
    return
  endif

  exec 'EXProjectFind'
enddef

# buffer operation
nnoremap <unique> <silent> <Leader>bd :EXbd<CR>
nnoremap <unique> <silent> <C-l> :EXbn<CR>
nnoremap <unique> <silent> <C-h> :EXbp<CR>
nnoremap <unique> <silent> <C-Tab> :EXbalt<CR>

# plugin<->edit window switch
nnoremap <unique> <silent> <Leader><Tab> :EXsw<CR>
nmap <unique> <silent> <Leader><Esc> :EXgp<CR><ESC>

# search
nnoremap <unique> <leader>F :GS<space>
nnoremap <unique> <leader>gg :EXSearchCWord<CR>
nnoremap <unique> <leader>gs :ex#search#toggle_window()<CR>

# project
nnoremap <unique> <leader>fc :<SID>S_find_file()<CR>

# vim-one
# ---------------------------------------------------

colorscheme one
set background=dark

# vim-airline
# ---------------------------------------------------

g:airline_theme = 'one'
if has('gui_running') || has('nvim')
  g:airline_powerline_fonts = 1
else
  g:airline_powerline_fonts = 0
endif

# NOTE: When you open lots of buffers and typing text, it is so slow.
# g:airline_section_warning = ''
g:airline#extensions#tabline#enabled = 0
g:airline#extensions#tabline#show_buffers = 1
g:airline#extensions#tabline#buffer_nr_show = 1
g:airline#extensions#tabline#fnamemod = ':t'

# ex-easyhl
# ---------------------------------------------------

# hi clear EX_HL_cursorhl
# hi EX_HL_cursorhl gui=none guibg=white term=none cterm=none ctermbg=white

hi clear EX_HL_label1
hi EX_HL_label1 gui=none guibg=darkred term=none cterm=none ctermbg=darkred

hi clear EX_HL_label2
hi EX_HL_label2 gui=none guibg=darkmagenta term=none cterm=none ctermbg=darkmagenta

hi clear EX_HL_label3
hi EX_HL_label3 gui=none guibg=darkblue term=none cterm=none ctermbg=darkblue

hi clear EX_HL_label4
hi EX_HL_label4 gui=none guibg=darkgreen term=none cterm=none ctermbg=darkgreen

# ex-showmarks
# ---------------------------------------------------

g:showmarks_enable = 1
g:showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

# Ignore help, quickfix, non-modifiable buffers
g:showmarks_ignore_type = 'hqm'

# Hilight lower & upper marks
g:showmarks_hlline_lower = 1
g:showmarks_hlline_upper = 0

# For marks a-z
hi clear ShowMarksHLl
hi ShowMarksHLl term=bold cterm=none ctermbg=lightblue gui=none guibg=SlateBlue

# For marks A-Z
hi clear ShowMarksHLu
hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred

# omnisharp-vim
# ---------------------------------------------------

g:OmniSharp_server_stdio = 1
if WINDOWS()
  g:OmniSharp_server_path = 'C:\OmniSharp\omnisharp.win-x64\OmniSharp.exe'
endif
g:OmniSharp_highlight_groups = {
  'ExcludedCode': 'Normal'
}

# ctrlp
# ---------------------------------------------------

g:ctrlp_working_path_mode = ''
# g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'
g:ctrlp_follow_symlinks = 2
g:ctrlp_max_files = 0 # Unset cap of 10,000 files so we find everything
nnoremap <unique> <leader>bs :CtrlPBuffer<CR>

# nerdtree
# ---------------------------------------------------

g:NERDTreeWinSize = 30
g:NERDTreeWinSizeMax = 60
g:NERDTreeMouseMode = 1
g:NERDTreeMapToggleZoom = '<Space>'

# vim-commentary
# ---------------------------------------------------

xmap <leader>/ <Plug>Commentary
nmap <leader>/ <Plug>CommentaryLine

autocmd FileType cs setlocal commentstring=\/\/\ %s

# vim-surround
# ---------------------------------------------------

xmap s <Plug>VSurround

# tabular
# ---------------------------------------------------

nnoremap <silent> <leader>= :g:Tabular(1)<CR>
xnoremap <silent> <leader>= :g:Tabular(0)<CR>
def! g:Tabular(ignore_range: number)
  var c = getchar()
  c = nr2char(c)
  if ignore_range == 0
    exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
  else
    exec printf('Tabularize /%s', c)
  endif
enddef

# vim-better-whitespace
# ---------------------------------------------------

g:better_whitespace_guicolor = 'darkred'
nnoremap <unique> <leader>w :StripWhitespace<CR>

# vim:ts=2:sw=2:sts=2 et fdm=marker:
