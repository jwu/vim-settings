# Install

1. copy `.vimrc` to `YOUR_VIM_DIR/.vimrc`
1. install `vim-plug`
1. install `rg`
1. install `fonts`

## vim-plug

- [vim-plug](https://github.com/junegunn/vim-plug)

## Global Search

- [rg](https://github.com/BurntSushi/ripgrep)
  - windows install: `choco install ripgrep`
  - mac install: `brew install ripgrep`

## Fonts

- [powerline-fonts](https://github.com/powerline/fonts)
- [top-programming-fonts](https://github.com/hbin/top-programming-fonts)
- [Microsoft-Yahei-Mono.ttf](https://github.com/whorusq/sublime-text-3/blob/master/fonts/Microsoft-Yahei-Mono.ttf)

## NeoVim

- [nvim-qt](https://github.com/equalsraf/neovim-qt)
  - windows install: `choco install neovim`
  - [See the windows installation guide of neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#windows)
- [vimr](https://github.com/qvacua/vimr)
  - mac install `brew cask install vimr`

### NeoVim additional setup

**init.vim**

```vim
set runtimepath^=~/vimfiles
let &packpath = &runtimepath
source your\vim\path\.vimrc
```

**ginit.vim**

```vim
silent exec 'GuiFont! DejaVu Sans Mono for Powerline:h12'
call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
```
