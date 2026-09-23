# Zirconium

Dark and light palettes for Neovim, Alacritty, foot and kitty. [View the colors](https://t-450.github.io/zirconium/).

## Install

**Neovim 0.8+** — add to your lazy.nvim plugin list:

```lua
{
  'T-450/zirconium', lazy = false, priority = 1000,
  config = function()
    vim.o.termguicolors = true
    vim.cmd.colorscheme('zirconium-dark') -- or zirconium-light
  end,
}
```

`:colorscheme zirconium` follows `vim.o.background`. [Options and integrations](THEME_README.md).

**Terminals** — clone once, then [import a dark or light file](terminal/README.md):

```sh
git clone https://github.com/T-450/zirconium.git ~/.local/share/zirconium
```

## Check

```sh
node scripts/generate.mjs --check
node scripts/check-palette.mjs
npm ci --prefix site
npm run build --prefix site
npm run test:prefix --prefix site
nvim --headless -u NONE --cmd 'set rtp+=.' -l tests/nvim-smoke.lua
```

Edit [palette/zirconium.json](palette/zirconium.json), then run `node scripts/generate.mjs` to update the committed theme exports. The smoke script needs Neovim 0.9+ and uses `-u NONE`; the theme supports 0.8+. The demo `init.lua` may install plugins. [Palette provenance](palette/README.md) · [MIT license](LICENSE).
