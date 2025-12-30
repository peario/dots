# :pear: PearVim

This is my latest attempt at creating an optimized but feature-rich neovim config.

> [!NOTE] Why the name PearVim?
> PearVim is just a play on my username and LazyVim.
> LazyVim has a global helper table of functions and I'm aiming for something similar.

> [!WARNING] WIP
> Before using this config, I'd like to warn you that this is a work-in-progress
> config. I've yet to reach the point where I feel satisfied with PearVim and I
> can guarantee that breaking changes won't be common. I've also yet to reach the
> point where I feel that the config is stable enough to be used as a daily driver.

## :framed_picture: Images

_The font used in these images is "Maple Mono NF"._

TODO: Add images

_There's more images within [docs/assets](./docs/assets)._

## :sparkles: Features

- Utilises Neovim's built-in runtime paths (`after`, `plugin`, `lsp`, etc.)
- Lazy-loading and package management via lazy.nvim
- Most plugins are setup as modules, can be enabled/disabled as you wish.

## :jigsaw: Requirements

- Neovim >= 0.11.0 (preferably nightly, built with LuaJIT)
- Git >= 2.19.0 (for partial clones support)
- a [Nerd Font](https://www.nerdfonts.com/) (optional)
- [luarocks](https://luarocks.org/) (optional, enabled by default)

## :evergreen_tree: Config Structure

```bash
nvim/
├── after/
│   └── plugin/
├── lazy/
├── lsp/
├── plugin/
├── queries/
├── spell/
├── init.lua
├── neovim.yml
├── README.md
├── selene.toml
└── stylua.toml
```

### :file_folder: Folders and files

#### after/plugin/

> [!NOTE]
> These plugin configurations are loaded after those plugins via lazy.nvim

Here goes configurations such as:

- Cross-plugin integration which requires multiple plugins to be loaded.
- Complex configurations which cannot properly be expressed via `opts = {}`
  from lazy.nvim.
- Custom functions that may be used between multiple plugins.
- Overrides of configs that can only be done once all plugins have been loaded.

#### lazy/

Here goes the "classic" plugins to be installed and configured via lazy.nvim.

## :package: Installation

### Try it out

If you just want to try out my config, PearVim, then you can do the following:

<details>
<summary>Linux / MacOS</summary>

If you wish this to be like a fresh install, it's optional, but I recommend doing:

```bash
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Regardless if you go for a fresh-install-experience, or not, clone and run the
config with:

```bash
git clone https://github.com/peario/pearvim ~/.config/pearvim
NVIM_APPNAME=pearvim nvim
```

</details>

<details>
<summary>Windows</summary>

If you wish this to be like a fresh install, it's optional, but I recommend doing:

```pwsh
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

Regardless if you go for a fresh-install-experience, or not, clone and run the
config with:

```pwsh
git clone https://github.com/peario/pearvim $env:LOCALAPPDATA/pearvim
$env:NVIM_APPNAME=pearvim; nvim
```

</details>

<details>
<summary>Docker</summary>

```bash
docker run -w /root -it --rm alpine:edge sh -uelic '
    apk add git fzf curl neovim ripgrep fd alpine-sdk --update
    git clone https://github.com/peario/pearvim ~/.config/nvim
    cd ~/.config/nvim
    nvim
'
```

</details>

### Normal installation

Otherwise, for a normal installation:

<details>
<summary>Linux / MacOS</summary>

First, backup your current config (if you already have one):

```bash
# Required
mv ~/.config/nvim{,.bak}

# Optional, but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Then install PearVim with:

```bash
git clone https://github.com/peario/pearvim ~/.config/pearvim
NVIM_APPNAME=pearvim nvim
```

</details>

<details>
<summary>Windows</summary>

First, backup your current config (if you already have one):

```pwsh
# Required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# Optional, but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

Then install PearVim with:

```pwsh
git clone https://github.com/peario/pearvim $env:LOCALAPPDATA/nvim
nvim
```

</details>

<details>
<summary>Docker</summary>

```bash
docker run -w /root -it --rm alpine:edge sh -uelic '
    apk add git fzf curl neovim ripgrep fd alpine-sdk --update
    git clone https://github.com/peario/pearvim ~/.config/nvim
    cd ~/.config/nvim
    nvim
'
```

</details>

## :dizzy: Extras

If you have any ideas, questions or issues with the config, please open an issue
and I'll try my best at providing my thoughts, answers and attempts at resolving
your issue (or issues :eyes:).

Additionally, while this neovim config is public and free for anyone to use. It
is also intended to be my daily driver. However, if this config somehow gets
"complex" enough or if there's enough requests about turning it into a distro
with a starter, after some discussion I'll see what I can do.

### :man_technologist: Inspiration

These are some of my sources of inspiration, both in areas of visuals,
user experience and internal implementation:

- [LazyVim](https://github.com/LazyVim/LazyVim)
- [NvChad](https://github.com/NvChad/NvChad)
- [vieitesss/nvim](https://github.com/vieitesss/nvim)
