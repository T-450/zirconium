# Zirconium for Neovim

Requires Neovim 0.8 or newer. The theme has no runtime plugin dependency. Recommended: a terminal with truecolor support and `vim.o.termguicolors = true`. With `termguicolors = false`, core highlights include xterm-256 `ctermfg`/`ctermbg` values, approximated from the adapted palette.

## Install and select

For lazy.nvim, add the GitHub plugin spec to your plugin list:

```lua
{
  'T-450/zirconium',
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.termguicolors = true
    require('zirconium').setup({ transparent = false })
    vim.cmd.colorscheme('zirconium-dark') -- or zirconium-light
  end,
}
```

For a local checkout instead, append its absolute path to Neovim's runtime path before selecting a variant:

```lua
vim.opt.rtp:append('/absolute/path/to/zirconium')
vim.o.termguicolors = true
vim.cmd.colorscheme('zirconium-dark')
```

No plugin manager or other plugin is required if you use the local runtimepath option.

`:colorscheme zirconium` uses the current `vim.o.background` (`dark` or `light`). The explicit names set `vim.o.background` accordingly. Switch at any time with `:colorscheme zirconium-light` or `:colorscheme zirconium-dark`; the palette, ANSI slots and integrations are recomputed when applied. After changing `vim.o.background` manually, reapply `:colorscheme zirconium`.

## Configuration

Call `setup()` **before** applying the colorscheme. All settings are optional:

```lua
require('zirconium').setup({
  transparent = false,
  italics = {
    comments = true,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
    bufferline = false,
  },
  -- A table of nvim_set_hl specs, or function(palette) returning that table.
  overrides = {},
})
vim.cmd.colorscheme('zirconium')
```

Transparent mode clears main, float, sign, gutter, status and bufferline backgrounds, but keeps a real background in palette computations and terminal ANSI. `overrides` are applied last; examples:

```lua
require('zirconium').setup({
  overrides = function(p)
    return {
      CursorLineNr = { fg = p.ui.accent, bold = true },
      ['@string'] = { fg = p.syntax.string, italic = false },
    }
  end,
})
vim.cmd.colorscheme('zirconium-dark')
```

For non-theme colors in custom overrides, set `ctermfg`/`ctermbg` yourself if you need 256-color fallback; explicit cterm values are preserved even when the same override supplies GUI hex colors. `vim.api.nvim_set_hl` does not combine `link` with other style attributes; use a complete foreground/background spec when changing a linked group.

## Integrations

```lua
-- Bufferline, after applying the theme:
require('bufferline').setup({
  highlights = require('zirconium').bufferline.highlights,
})

-- lualine: supplied at lua/lualine/themes/zirconium.lua
require('lualine').setup({ options = { theme = 'zirconium' } })
```

The theme also defines `CmpItem*` groups for nvim-cmp and general core/Tree-sitter/LSP highlights. Integrations are optional; they are not loaded as plugin dependencies. After a variant change, plugins that cache a palette during `setup()` (notably lualine/bufferline) may need their own setup/theme refresh; Zirconium recomputes its exported bufferline highlights each time.

## Development

The repository's `init.lua` is a separate, plugin-heavy demo that may attempt a lazy.nvim clone. Do **not** use it for isolated smoke checks; follow [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) instead. Palette provenance and accessibility notes are in [palette/README.md](palette/README.md).
