## Global Search

  - [rg](https://github.com/BurntSushi/ripgrep)
  - [ag](https://github.com/ggreer/the_silver_searcher)

## Fonts

  - [top-programming-fonts](https://github.com/hbin/top-programming-fonts)
  - [powerline-fonts](https://github.com/powerline/fonts)

## NeoVim
  - [vimr](https://github.com/qvacua/vimr)
    - `brew cask install vimr`
  - [nvim-qt](https://github.com/equalsraf/neovim-qt)
    - [See the windows installation guide of neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#windows)

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
