local M = {}

function M.highlights(p, options)
  local bg = options.transparent and 'NONE' or p.surface.panel
  local active = options.transparent and 'NONE' or p.surface.bg
  local text = p.text
  return {
    fill = { bg = bg }, background = { fg = text.muted, bg = bg },
    buffer_visible = { fg = text.muted, bg = bg },
    buffer_selected = { fg = text.primary, bg = active, bold = true },
    duplicate = { fg = text.muted, bg = bg, italic = options.italics.bufferline },
    duplicate_visible = { fg = text.muted, bg = bg },
    duplicate_selected = { fg = text.primary, bg = active },
    tab = { fg = text.muted, bg = bg },
    tab_selected = { fg = text.primary, bg = active, bold = true },
    indicator_selected = { fg = p.ui.accent, bg = active },
    separator = { fg = p.surface.border, bg = bg },
    separator_visible = { fg = p.surface.border, bg = bg },
    separator_selected = { fg = p.surface.border, bg = active },
    close_button = { fg = text.muted, bg = bg },
    close_button_visible = { fg = text.muted, bg = bg },
    close_button_selected = { fg = p.diagnostic.error, bg = active },
    modified = { fg = p.ui.accent, bg = bg },
    modified_selected = { fg = p.ui.accent, bg = active },
    diagnostic = { fg = text.muted, bg = bg },
    diagnostic_selected = { fg = text.primary, bg = active },
    error = { fg = p.diagnostic.error, bg = bg },
    error_selected = { fg = p.diagnostic.error, bg = active },
    warning = { fg = p.diagnostic.warn, bg = bg },
    warning_selected = { fg = p.diagnostic.warn, bg = active },
    info = { fg = p.diagnostic.info, bg = bg },
    info_selected = { fg = p.diagnostic.info, bg = active },
    hint = { fg = p.diagnostic.hint, bg = bg },
    hint_selected = { fg = p.diagnostic.hint, bg = active },
  }
end

return M
