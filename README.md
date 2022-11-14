# Install

1. copy `.vimrc` to `YOUR_VIM_DIR/.vimrc`
1. install `vim-plug`
1. install `rg`
1. install `fonts`
1. install `omnisharp`

## vim-plug

- [vim-plug](https://github.com/junegunn/vim-plug)

## Global Search

- [rg](https://github.com/BurntSushi/ripgrep)
  - Windows install: `choco install ripgrep`
  - Mac install: `brew install ripgrep`

## OmniSharp

- [omnisharp-roslyn](https://github.com/OmniSharp/omnisharp-roslyn)
  - Windows install: extract package in `c:\bin\omnisharp.win-x64\`

## rust-analyzer

- [rust-analyzer](https://github.com/rust-lang/rust-analyzer/releases)
  - Windows install: extract package in `c:\bin\`
  - add `c:\bin\` to Environment Path
  - Mac install: extract package in `/usr/local/bin/`
  - `chmod +x /usr/local/bin/rust-analyzer`

## jq

- [jq](https://github.com/stedolan/jq)
  - windows install: `choco install jq`

## Fonts

- [nerdfonts](https://www.nerdfonts.com/)
- [powerline-fonts](https://github.com/powerline/fonts)
- [top-programming-fonts](https://github.com/hbin/top-programming-fonts)
- [Microsoft-Yahei-Mono.ttf](https://github.com/whorusq/sublime-text-3/blob/master/fonts/Microsoft-Yahei-Mono.ttf)

## NeoVim

- [nvim-qt](https://github.com/equalsraf/neovim-qt)
  - Windows install: `choco install neovim`
  - [See the windows installation guide of neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#windows)
- [vimr](https://github.com/qvacua/vimr)
  - Mac install `brew cask install vimr`

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
