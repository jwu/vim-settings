## vim-plug

  - [vim-plug](https://github.com/junegunn/vim-plug)

## Global Search

  - [rg](https://github.com/BurntSushi/ripgrep)
    - windows install: `choco install ripgrep`
    - mac install: `brew install ripgrep`

## Fonts

  - [powerline-fonts](https://github.com/powerline/fonts)
  - [top-programming-fonts](https://github.com/hbin/top-programming-fonts)

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
