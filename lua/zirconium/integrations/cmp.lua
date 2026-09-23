local M = {}

function M.highlights(p)
  return {
    CmpItemAbbr = { fg = p.text.primary },
    CmpItemAbbrDeprecated = { fg = p.text.muted, strikethrough = true },
    CmpItemAbbrMatch = { fg = p.syntax['function'], bold = true },
    CmpItemAbbrMatchFuzzy = { fg = p.syntax['function'], bold = true },
    CmpItemMenu = { fg = p.text.muted },
    CmpItemKind = { fg = p.syntax.type },
    CmpItemKindFunction = { fg = p.syntax['function'] },
    CmpItemKindMethod = { fg = p.syntax['function'] },
    CmpItemKindKeyword = { fg = p.syntax.keyword },
    CmpItemKindVariable = { fg = p.syntax.variable },
    CmpItemKindProperty = { fg = p.syntax.builtin },
    CmpItemKindSnippet = { fg = p.syntax.string },
    CmpItemKindClass = { fg = p.syntax.type },
  }
end

return M
