local p = require('zirconium.colorscheme')()
local options = require('zirconium.config').options
local bg = options.transparent and 'NONE' or p.surface.bg
local panel = options.transparent and 'NONE' or p.surface.panel
local text = p.text.primary
local function section(accent)
  return { a = { fg = p.text.inverse, bg = accent, gui = 'bold' },
    b = { fg = text, bg = panel }, c = { fg = p.text.muted, bg = bg } }
end
local theme = {
  normal = section(p.ui.accent),
  insert = section(p.diagnostic.success),
  visual = section(p.syntax.type),
  replace = section(p.diagnostic.error),
  command = section(p.syntax['function']),
  terminal = section(p.diagnostic.hint),
  inactive = {
    a = { fg = p.text.muted, bg = panel },
    b = { fg = p.text.muted, bg = panel },
    c = { fg = p.text.muted, bg = bg },
  },
}
return theme
