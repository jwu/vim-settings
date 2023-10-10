"/////////////////////////////////////////////////////////////////////////////
" basic
"/////////////////////////////////////////////////////////////////////////////

set nocompatible " be iMproved, required

if has('nvim')
  set termguicolors
endif

if exists("g:neovide")
  let g:neovide_scroll_animation_length = 0.3
  let g:neovide_hide_mouse_when_typing = v:true
  let g:neovide_refresh_rate = 60
  let g:neovide_refresh_rate_idle = 60
  let g:neovide_no_idle = v:true
  let g:neovide_cursor_animation_length = 0.0
endif

function! g:OSX()
  return has('macunix')
endfunction

function! g:LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction

function! g:WINDOWS()
  return (has('win16') || has('win32') || has('win64'))
endfunction

"/////////////////////////////////////////////////////////////////////////////
" language and encoding setup
"/////////////////////////////////////////////////////////////////////////////

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use English for anaything in vim-editor.
if WINDOWS()
  silent exec 'language english'
elseif OSX()
  silent exec 'language en_US'
else
  let s:uname = system("uname -s")
  if s:uname == "Darwin\n"
    " in mac-terminal
    silent exec 'language en_US'
  else
    " in linux-terminal
    silent exec 'language en_US.utf8'
  endif
endif

" try to set encoding to utf-8
if WINDOWS()
  " Be nice and check for multi_byte even if the config requires
  " multi_byte support most of the time
  if has('multi_byte')
    " Windows cmd.exe still uses cp850. If Windows ever moved to
    " Powershell as the primary terminal, this would be utf-8
    set termencoding=cp850
    " Let Vim use utf-8 internally, because many scripts require this
    set encoding=utf-8
    setglobal fileencoding=utf-8
    " Windows has traditionally used cp1252, so it's probably wise to
    " fallback into cp1252 instead of eg. iso-8859-15.
    " Newer Windows files might contain utf-8 or utf-16 LE so we might
    " want to try them first.
    set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
  endif

  if !has('nvim')
    " use directx rendering font in Windows for better text
    set renderoptions=type:directx
  endif
else
  " set default encoding to utf-8
  set encoding=utf-8
  set termencoding=utf-8
endif

scriptencoding utf-8

"/////////////////////////////////////////////////////////////////////////////
" General
"/////////////////////////////////////////////////////////////////////////////

"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search
set backup " make backup file and leave it around

" setup back and swap directory
let data_dir = $HOME.'/.data/'
let backup_dir = data_dir . 'backup'
let swap_dir = data_dir . 'swap'

if finddir(data_dir) == ''
  silent call mkdir(data_dir, 'p', 0700)
endif

if finddir(backup_dir) == ''
  silent call mkdir(backup_dir, 'p', 0700)
endif

if finddir(swap_dir) == ''
  silent call mkdir(swap_dir, 'p', 0700)
endif

unlet backup_dir
unlet swap_dir
unlet data_dir

set backupdir=$HOME/.data/backup " where to put backup file
set directory=$HOME/.data/swap " where to put swap file

" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change (better for vc/vim change)
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)

"/////////////////////////////////////////////////////////////////////////////
" xterm settings
"/////////////////////////////////////////////////////////////////////////////

behave xterm  " set mouse behavior as xterm
if &term =~ 'xterm'
  set mouse=a
endif

"/////////////////////////////////////////////////////////////////////////////
" Variable settings (set all)
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------
" Desc: Visual
" ------------------------------------------------------------------

set matchtime=0 " 0 second to show the matching paren (much faster)
set nu " show line number
set scrolloff=0 " minimal number of screen lines to keep above and below the cursor
set nowrap " do not wrap text

" only supoort in 7.3 or higher
if v:version >= 703
  set noacd " no autochchdir
endif

" set default guifont
if has('gui_running')
  augroup ex_gui_font
    " check and determine the gui font after GUIEnter.
    " NOTE: getfontname function only works after GUIEnter.
    au!

    if has('nvim')
      au UIEnter * call s:set_gui_font_nvim()
    else
      au GUIEnter * call s:set_gui_font()
    endif
  augroup END

  " set guifont
  function! s:set_gui_font_nvim()
    if WINDOWS()
      set guifont=FuraMono\ Nerd\ Font:h11
      set guifontwide=Microsoft\ YaHei\ Mono:h11
    elseif OSX()
      set guifont=FuraMono\ Nerd\ Font:h13
    else
      set guifont=FuraMono\ Nerd\ Font\ 12
    endif
  endfunction

  " set guifont
  function! s:set_gui_font()
    if has('gui_gtk2')
      if getfontname('FuraMono Nerd Font') != ''
        set guifont=FuraMono\ Nerd\ Font\ 12
      elseif getfontname('DejaVu Sans Mono for Powerline') != ''
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
      elseif getfontname('DejaVu Sans Mono') != ''
        set guifont=DejaVu\ Sans\ Mono\ 12
      else
        set guifont=Luxi\ Mono\ 12
      endif
    elseif has('x11')
      " Also for GTK 1
      set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
    elseif OSX()
      if getfontname('FuraMono Nerd Font') != ''
        set guifont=FuraMono\ Nerd\ Font:h13
      elseif getfontname('DejaVu Sans Mono for Powerline') != ''
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h13
      elseif getfontname('DejaVu Sans Mono') != ''
        set guifont=DejaVu\ Sans\ Mono:h13
      endif
    elseif WINDOWS()
      if getfontname('FuraMono Nerd Font') != ''
        set guifont=FuraMono\ Nerd\ Font:h11
        set guifontwide=Microsoft\ YaHei\ Mono:h11
      elseif getfontname('DejaVu Sans Mono for Powerline') != ''
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
  endfunction
endif

" ------------------------------------------------------------------
" Desc: Vim UI
" ------------------------------------------------------------------

set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set titlestring=%t\ (%{expand(\"%:p:h\")})

" set window size (if it's GUI)
if has('gui_running')
  " set window's width to 130 columns and height to 40 rows
  if exists('+lines')
    set lines=40
  endif

  if exists('+columns')
    set columns=130
  endif

  " DISABLE
  " if WINDOWS()
  "     au GUIEnter * simalt ~x " Maximize window when enter vim
  " else
  "     " TODO: no way right now
  " endif
endif

set showfulltag " show tag with function protype.

" disable menu, toolbar and scrollbar
" set guioptions= " remove all guioptions
set guioptions-=m " disable Menu
set guioptions-=T " disalbe Toolbar
set guioptions-=b " disalbe the bottom scrollbar
set guioptions-=l " disalbe the left scrollbar
set guioptions-=L " disalbe the left scrollbar when the longest visible line exceed the window

" ------------------------------------------------------------------
" Desc: Text edit
" ------------------------------------------------------------------

set ai " autoindent
set si " smartindent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" indent options
" see help cinoptions-values for more details
" set cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,k0,m0,j0,J0,)20,*70,#0
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,L0:0,=s,l0,b0,g0,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(0,us,U0,w0,Ws,m1,M0,j1,J1,)20,*70,#0
" default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e

" official diff settings
set diffexpr=g:MyDiff()
function! g:MyDiff()
  let opt = '-a --binary -w '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  silent execute '!' .  'diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
endfunction

set cindent shiftwidth=2 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=2 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
set nf=

" ------------------------------------------------------------------
" Desc: Fold text
" ------------------------------------------------------------------

set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

" ------------------------------------------------------------------
" Desc: Search
" ------------------------------------------------------------------

set showmatch " show matching paren
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m

"/////////////////////////////////////////////////////////////////////////////
" Key Mappings
"/////////////////////////////////////////////////////////////////////////////

" NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

" Don't use Ex mode, use Q for formatting
map Q gq

" define the copy/paste judged by clipboard
if &clipboard ==# 'unnamed'
  " fix the visual paste bug in vim
  " vnoremap <silent>p :call g:()<CR>
else
  " general copy/paste.
  " NOTE: y,p,P could be mapped by other key-mapping
  map <leader>y "*y
  map <leader>p "*p
  map <leader>P "*P
endif

" copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
nnoremap <silent> <leader>y1 :let @*=fnamemodify(bufname('%'),":p:h")<CR>

" copy file name to clipboard, foo/bar/foobar.c => foobar.c
nnoremap <silent> <leader>y2 :let @*=fnamemodify(bufname('%'),":p:t")<CR>

" copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
nnoremap <silent> <leader>y3 :let @*=fnamemodify(bufname('%'),":p")<CR>

" F8 or <leader>/:  Set Search pattern highlight on/off
nnoremap <leader>\ :let @/=""<CR>
" DISABLE: though nohlsearch is standard way in Vim, but it will not erase the
"          search pattern, which is not so good when use it with exVim's <leader>r
"          filter method
" nnoremap <leader>\ :nohlsearch<CR>

" map Ctrl-Tab to switch window
nnoremap <S-Up> <C-W><Up>
nnoremap <S-Down> <C-W><Down>
nnoremap <S-Left> <C-W><Left>
nnoremap <S-Right> <C-W><Right>

" map Ctrl-Space to Omni Complete
inoremap <C-Space> <C-X><C-O>

" " NOTE: if we already map to EXbn,EXbp. skip setting this
" " easy buffer navigation
" if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
"   nnoremap <C-l> :bn<CR>
" endif
" if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
"   noremap <C-h> :bp<CR>
" endif

" easy diff goto
noremap <C-k> [c
noremap <C-j> ]c

" enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj

" TODO: I should write a better one, make it as plugin exvim/swapword
" VimTip 329: A map for swapping words
" http://vim.sourceforge.net/tip_view.php?tip_id=
" Then when you put the cursor on or in a word, press "\sw", and
" the word will be swapped with the next word.  The words may
" even be separated by punctuation (such as "abc = def").
nnoremap <silent> <leader>sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o>

"/////////////////////////////////////////////////////////////////////////////
" vim-plug
"/////////////////////////////////////////////////////////////////////////////

call plug#begin('~/.vim/plugged')

" exvim-lite
Plug 'jwu/exvim-lite'

" color theme
Plug 'rakr/vim-one'

" visual enhancement
" Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'

" text highlight
Plug 'exvim/ex-easyhl'
Plug 'exvim/ex-showmarks'

" syntax highlight/check
Plug 'scrooloose/syntastic'
Plug 'tikhomirov/vim-glsl'
Plug 'drichardson/vex.vim'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

" complete
Plug 'exvim/ex-searchcompl'
Plug 'exvim/ex-autocomplpop'

" lsp
Plug 'dense-analysis/ale'
Plug 'jwu/omnisharp-vim'

" file operation
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'

" text editing
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/VisIncr'
Plug 'godlygeek/tabular'
Plug 'jwu/vim-better-whitespace'

" git operation
Plug 'tpope/vim-fugitive'

call plug#end()

" NOTE: au must after filetype plug, otherwise they won't work
"/////////////////////////////////////////////////////////////////////////////
" Auto Command
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------

if has('autocmd')
  augroup ex
    au!

    " ------------------------------------------------------------------
    " Desc: Buffer
    " ------------------------------------------------------------------

    " when editing a file, always jump to the last known cursor position.
    " don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    au BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal g`\"" |
          \ endif
    au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
    au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
    au BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.
    au BufNewFile,BufRead *.{vs,fs,hlsl,fx,fxh,cg,cginc,vsh,psh,shd,glsl,shader} set ft=glsl
    au BufNewFile,BufRead *.shader set ft=shader

    " ------------------------------------------------------------------
    " Desc: file types
    " ------------------------------------------------------------------

    au FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
    au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

    " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
    au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
    au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
    au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
    au FileType lua set comments=f:--

    " disable automaticaly insert current comment leader after hitting <Enter>, 'o' or 'O'
    au FileType c,cpp,cs,rust set formatoptions-=ro

    " if edit python scripts, check if have \t. (python said: the programme can only use \t or not, but can't use them together)
    au FileType python,coffee call s:check_if_expand_tab()
  augroup END

  function! s:check_if_expand_tab()
    let has_noexpandtab = search('^\t','wn')
    let has_expandtab = search('^    ','wn')

    if has_noexpandtab && has_expandtab
      let idx = inputlist (['ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
            \ '1. expand (tab=space, recommended)',
            \ '2. noexpand (tab=\t, currently have risk)',
            \ '3. do nothing (I will handle it by myself)'])
      let tab_space = printf('%*s',&tabstop,'')
      if idx == 1
        let has_noexpandtab = 0
        let has_expandtab = 1
        silent exec '%s/\t/' . tab_space . '/g'
      elseif idx == 2
        let has_noexpandtab = 1
        let has_expandtab = 0
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
      " it may be a new file
      " we use original vim setting
    endif
  endfunction
endif

"/////////////////////////////////////////////////////////////////////////////
" vim-plug setup
"/////////////////////////////////////////////////////////////////////////////

" exvim-lite
" ---------------------------------------------------

function s:find_file()
  if g:NERDTree.IsOpen()
    exec 'NERDTreeFind'
    return
  endif

  exec 'EXProjectFind'
endfunction

function s:fmt_file()
  exec 'StripWhitespace'
  " use this than exec 'ALEFix' to prevent 'no fixer found error'
  silent call ale#fix#Fix(bufnr(''), '!')
  echomsg 'file formatted!'
endfunction

" buffer operation
if has('nvim')
  unmap <C-l>
endif
nnoremap <unique> <silent> <Leader>bd :EXbd<CR>
nnoremap <unique> <silent> <C-l> :EXbn<CR>
nnoremap <unique> <silent> <C-h> :EXbp<CR>
nnoremap <unique> <silent> <C-Tab> :EXbalt<CR>

" plugin<->edit window switch
nnoremap <unique> <silent> <Leader><Tab> :EXsw<CR>
nmap <unique> <silent> <Leader><Esc> :EXgp<CR><ESC>

" search
nnoremap <unique> <leader>F :GS<space>
nnoremap <unique> <leader>gg :EXSearchCWord<CR>
nnoremap <unique> <leader>gs :call ex#search#toggle_window()<CR>

" project
nnoremap <unique> <leader>fc :call <SID>find_file()<CR>

" format
nnoremap <unique> <silent> <leader>w :call <SID>fmt_file()<CR>

" vim-one
" ---------------------------------------------------

colorscheme one
set background=dark

"DISABLE: use lightline instead
"" vim-airline
"" ---------------------------------------------------
"
"let g:airline_theme='one'
"if has('gui_running') || has('nvim')
"  let g:airline_powerline_fonts = 1
"else
"  let g:airline_powerline_fonts = 0
"endif
"
"" NOTE: When you open lots of buffers and typing text, it is so slow.
"" let g:airline_section_warning = ''
"let g:airline#extensions#tabline#enabled = 0
"let g:airline#extensions#tabline#show_buffers = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#fnamemod = ':t'
"
"" show ale errors or warnings in statusline
"let g:airline#extensions#ale#enabled = 1

" lightline
" ---------------------------------------------------

let g:lightline = {
      \   'colorscheme': 'one',
      \   'active': {
      \     'left': [
      \       ['mode', 'paste'],
      \       ['gitbranch'],
      \       ['fmod'],
      \     ],
      \     'right': [
      \       ['lineinfo'],
      \       ['fileinfo'],
      \       ['filetype'],
      \     ],
      \   },
      \   'inactive': {
      \     'left': [
      \       ['fmod'],
      \     ],
      \     'right': [
      \       ['lineinfo'],
      \       ['fileinfo'],
      \       ['filetype'],
      \     ],
      \   },
      \   'component': {
      \     'lineinfo': " %p%% %l/%v %{line('$')}",
      \     'fileinfo': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
      \   },
      \   'component_function': {
      \     'gitbranch': 'LightlineBranch',
      \     'fmod': 'LightlineFmod',
      \   },
      \}
let g:lightline.separator = {
      \   'left': '', 'right': ''
      \}
let g:lightline.subseparator = {
      \   'left': '', 'right': ''
      \}

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

" TODO:
" function! LightlineFileformat()
"   return winwidth(0) > 70 ? &fileformat : ''
" endfunction

" ex-easyhl
" ---------------------------------------------------

" hi clear EX_HL_cursorhl
" hi EX_HL_cursorhl gui=none guibg=white term=none cterm=none ctermbg=white

hi clear EX_HL_label1
hi EX_HL_label1 gui=none guibg=darkred term=none cterm=none ctermbg=darkred

hi clear EX_HL_label2
hi EX_HL_label2 gui=none guibg=darkmagenta term=none cterm=none ctermbg=darkmagenta

hi clear EX_HL_label3
hi EX_HL_label3 gui=none guibg=darkblue term=none cterm=none ctermbg=darkblue

hi clear EX_HL_label4
hi EX_HL_label4 gui=none guibg=darkgreen term=none cterm=none ctermbg=darkgreen

" ex-showmarks
" ---------------------------------------------------

let g:showmarks_enable = 1
let showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = 'hqm'

" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 0

" For marks a-z
hi clear ShowMarksHLl
hi ShowMarksHLl term=bold cterm=none ctermbg=lightblue gui=none guibg=SlateBlue

" For marks A-Z
hi clear ShowMarksHLu
hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred

" omnisharp-vim
" ---------------------------------------------------

let g:OmniSharp_server_stdio = 1
if WINDOWS()
  let g:OmniSharp_server_path = 'd:\utils\omnisharp.win-x64\OmniSharp.exe'
endif
let g:OmniSharp_highlight_groups = {
      \ 'ExcludedCode': 'Normal'
      \}

" ale
" ---------------------------------------------------

let g:ale_hover_cursor = 0 " disable hover cursor
let g:ale_hover_to_preview = 0 " disable hover preview window
let g:ale_set_balloons = 0 " disable hover mouse
let g:ale_floating_preview = 1 " NOTE: Vim 8+, long messages will be shown in a preview window, so we use this instead
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1 " Only run linters named in ale_linters settings.
let g:ale_linters = {
      \  'cs': ['OmniSharp'],
      \  'rust': ['analyzer']
      \}
let g:ale_fixers = {
      \  'rust': ['rustfmt']
      \}
let g:ale_rust_analyzer_config = {
      \   'diagnostics': {
      \     'disabled': ['inactive-code']
      \   }
      \}

set omnifunc=ale#completion#OmniFunc
if has('nvim')
  set completeopt=menu,menuone,noselect,noinsert
else
  set completeopt=menu,menuone,popup,noselect,noinsert
endif

nnoremap <leader>] :ALEGoToDefinition<CR>
nnoremap <leader>[ :ALEHover<CR>
" NOTE: we do this in s:fmt_file()
" nnoremap <unique> <leader>w :ALEFix<CR>

" rust.vim
" ---------------------------------------------------

" NOTE: we use ale & rust-analyzer instead
let g:rustfmt_autosave = 0
let g:rustfmt_autosave_if_config_present = 0
let g:syntastic_rust_checkers = []

" ctrlp
" ---------------------------------------------------

let g:ctrlp_working_path_mode = ''
" let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'
let g:ctrlp_follow_symlinks = 2
let g:ctrlp_max_files = 0 " Unset cap of 10,000 files so we find everything
nnoremap <unique> <leader>bs :CtrlPBuffer<CR>

" nerdtree
" ---------------------------------------------------

let g:NERDTreeWinSize = 30
let g:NERDTreeWinSizeMax = 60
let g:NERDTreeMouseMode = 1
let g:NERDTreeMapToggleZoom = '<Space>'

" vim-commentary
" ---------------------------------------------------

xmap <leader>/ <Plug>Commentary
nmap <leader>/ <Plug>CommentaryLine

autocmd FileType cs setlocal commentstring=\/\/\ %s

" vim-surround
" ---------------------------------------------------

xmap s <Plug>VSurround

" tabular
" ---------------------------------------------------

nnoremap <silent> <leader>= :call g:Tabular(1)<CR>
xnoremap <silent> <leader>= :call g:Tabular(0)<CR>
function! g:Tabular(ignore_range) range
  let c = getchar()
  let c = nr2char(c)
  if a:ignore_range == 0
    exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
  else
    exec printf('Tabularize /%s', c)
  endif
endfunction

" vim-better-whitespace
" ---------------------------------------------------

let g:better_whitespace_guicolor = 'darkred'
" NOTE: we do this in s:fmt_file()
" nnoremap <unique> <leader>w :StripWhitespace<CR>

" vim:ts=2:sw=2:sts=2 et fdm=marker:
