# Neovim

[Install with lazy.nvim](README.md#install), then choose `zirconium-dark`, `zirconium-light`, or `zirconium` (follows `vim.o.background`). Truecolor is recommended; core highlights also have 256-color fallback.

Call `setup()` **before** `:colorscheme`:

```lua
require('zirconium').setup({
  transparent = false,
  italics = { comments = true, keywords = false },
  overrides = { CursorLineNr = { fg = '#ff9b79', bold = true } },
})
vim.cmd.colorscheme('zirconium-dark')
```

`overrides` can also be a function receiving the active palette and returning highlight specs. Explicit `ctermfg`/`ctermbg` overrides are preserved; supply them for custom colors in non-truecolor terminals. Switching colorschemes recalculates the theme; plugins that cache colors may need refreshing.

Optional integrations:

```lua
require('lualine').setup({ options = { theme = 'zirconium' } })
require('bufferline').setup({
  highlights = require('zirconium').bufferline.highlights,
})
```

nvim-cmp highlight groups are included without requiring nvim-cmp. For an uninstalled checkout, add its absolute path with `vim.opt.rtp:append('/path/to/zirconium')` before `:colorscheme`.
