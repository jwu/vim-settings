# Install

## vim + gvim

1. install [gvim](https://www.vim.org/download.php)
1. copy `.vimrc` to `${YOUR_VIM_DIR}/.vimrc`
1. install [vim-plug](https://github.com/junegunn/vim-plug)
1. install [rg](https://github.com/BurntSushi/ripgrep)
1. install `fonts`
1. install [omnisharp-roslyn](https://github.com/OmniSharp/omnisharp-roslyn)
  - Windows install: extract package in `c:\bin\omnisharp.win-x64\`

## nvim + neovide (Windows)

1. install [nvim](https://neovim.io/)
1. install [neovide](https://neovide.dev/)
  1. run it first
1. copy `init.lua` to `c:\Users\${YOUR_NAME}\AppData\Local\nvim\init.lua`
1. copy `config.toml` to `c:\Users\${YOUR_NAME}\AppData\Roaming\neovide\config.toml`
1. install [lazy.nvim](https://github.com/folke/lazy.nvim)
1. install [rg](https://github.com/BurntSushi/ripgrep)
1. install `fonts`
1. compile `nvim-treesitter` parsers
  1. For Windows user, just read [MSVC](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#msvc) session
  1. Install [Visual Studio Build Tools](https://visualstudio.microsoft.com/zh-hans/downloads/?q=build+tools+for+visual+studio)
  1. Open `x64 Native Tools Command Prompt`
  1. Open `neovide`
  1. Wait until the compile finish

## nvim + neovide (Linux)

1. install [nvim](https://neovim.io/)
  1. `sudo cp -r nvim-linux64/bin/ /usr/`
  1. `sudo cp -r nvim-linux64/lib/ /usr/`
  1. `sudo cp -r nvim-linux64/share/ /usr/`
1. install [neovide](https://neovide.dev/)
  1. `sudo cp neovide-linux-x86_64/neovide /usr/bin/`
  1. update ubuntu desktop
    1. `sudo desktop-file-install neovide.desktop`
    1. `sudo update-desktop-database`
1. cp `init.lua` to `~/.config/nvim`
1. cp `config.toml` to `~/.config/neovide`
1. install [lazy.nvim](https://github.com/folke/lazy.nvim)
1. install [rg](https://github.com/BurntSushi/ripgrep)
1. install `fonts`
1. compile `nvim-treesitter` parsers

## refs

### rust-analyzer

- [rust-analyzer](https://github.com/rust-lang/rust-analyzer/releases)
  - Windows install: extract package in `c:\bin\`
  - add `c:\bin\` to Environment Path
  - Mac install: extract package in `/usr/local/bin/`
  - `chmod +x /usr/local/bin/rust-analyzer`

### Fonts

- [nerdfonts](https://www.nerdfonts.com/)
- [powerline-fonts](https://github.com/powerline/fonts)
- [top-programming-fonts](https://github.com/hbin/top-programming-fonts)
- [Microsoft-Yahei-Mono.ttf](https://github.com/whorusq/sublime-text-3/blob/master/fonts/Microsoft-Yahei-Mono.ttf)
