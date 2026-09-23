local theme = require 'zirconium'
local palette = require 'zirconium.palette'
local function color(group, key)
  return vim.api.nvim_get_hl(0, { name = group, link = false })[key]
end
local function rgb(hex) return tonumber(hex:sub(2), 16) end
for _, variant in ipairs({ 'dark', 'light' }) do
  local p = palette[variant]
  vim.cmd.colorscheme('zirconium-' .. variant)
  assert(vim.g.colors_name == 'zirconium-' .. variant)
  assert(vim.o.background == variant)
  assert(color('Normal', 'bg') == rgb(p.surface.bg))
  assert(color('Normal', 'fg') == rgb(p.text.primary))
  assert(color('String', 'fg') == rgb(p.syntax.string))
  assert(color('Function', 'fg') == rgb(p.syntax['function']))
  assert(color('Type', 'fg') == rgb(p.syntax.type))
  assert(color('@function.builtin.zig', 'fg') == rgb(p.syntax.builtin))
  assert(color('DiagnosticError', 'fg') == rgb(p.diagnostic.error))
  assert(color('Search', 'bg') == rgb(p.ui.search))
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
  assert(normal.ctermfg == palette.cterm[p.text.primary])
  assert(normal.ctermbg == palette.cterm[p.surface.bg])
  for i = 0, 15 do
    local expected = i < 8 and p.ansi.normal[i + 1] or p.ansi.bright[i - 7]
    assert(vim.g['terminal_color_' .. i] == expected, variant .. ' terminal_color_' .. i)
  end
  assert(theme.bufferline.highlights.buffer_selected.fg == p.text.primary)
  local lualine = dofile('lua/lualine/themes/zirconium.lua')
  assert(lualine.normal.a.bg == p.ui.accent)
end
theme.setup({ overrides = {
  Normal = { fg = palette.dark.text.primary, bg = palette.dark.surface.bg, ctermfg = 196, ctermbg = 0 },
  Search = { fg = '#123456', bg = '#654321', ctermfg = 16, ctermbg = 21 },
} })
vim.cmd.colorscheme 'zirconium-dark'
local overridden_normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
local overridden_search = vim.api.nvim_get_hl(0, { name = 'Search' })
assert(overridden_normal.ctermfg == 196 and overridden_normal.ctermbg == 0)
assert(overridden_search.ctermfg == 16 and overridden_search.ctermbg == 21)
theme.setup({})
vim.o.background = 'light'
vim.cmd.colorscheme 'zirconium'
assert(color('String', 'fg') == rgb(palette.light.syntax.string))
vim.o.background = 'dark'
vim.cmd.colorscheme 'zirconium'
assert(color('String', 'fg') == rgb(palette.dark.syntax.string))
theme.setup({ transparent = true, italics = { comments = false }, overrides = function(p)
  return { CursorLineNr = { fg = p.syntax.string, bold = true } }
end })
vim.cmd.colorscheme 'zirconium-dark'
assert(color('Normal', 'bg') == nil)
assert(color('NormalFloat', 'bg') == nil)
assert(color('CursorLineNr', 'fg') == rgb(palette.dark.syntax.string))
assert(vim.api.nvim_get_hl(0, { name = 'Comment' }).italic == nil)
assert(vim.g.terminal_color_background == palette.dark.surface.bg)
vim.o.termguicolors = false
vim.cmd.colorscheme 'zirconium-light'
assert(vim.api.nvim_get_hl(0, { name = 'Normal' }).ctermfg == palette.cterm[palette.light.text.primary])
print('Zirconium Neovim smoke: dark/light/auto/ANSI/Zig/LSP/cterm/transparent/overrides OK')
