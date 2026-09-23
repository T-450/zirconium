local config = require 'zirconium.config'
local get_palette = require 'zirconium.colorscheme'
local theme = {}

local function groups_for(p, options)
  local s, t, y, d, u = p.surface, p.text, p.syntax, p.diagnostic, p.ui
  local bg = options.transparent and 'NONE' or s.bg
  local panel = options.transparent and 'NONE' or s.panel
  local muted = options.transparent and 'NONE' or s.muted
  local elevated = options.transparent and 'NONE' or s.elevated
  local italics = options.italics
  local g = {
    Normal = { fg = t.primary, bg = bg }, NormalNC = { link = 'Normal' },
    NormalFloat = { fg = t.primary, bg = panel }, FloatBorder = { fg = s.border, bg = panel },
    FloatTitle = { fg = u.accent, bg = panel, bold = true },
    Cursor = { fg = t.inverse, bg = u.cursor }, lCursor = { link = 'Cursor' },
    CursorIM = { link = 'Cursor' }, TermCursor = { link = 'Cursor' },
    CursorLine = { bg = muted }, CursorColumn = { link = 'CursorLine' },
    CursorLineNr = { fg = u.accent, bold = true }, LineNr = { fg = t.subtle },
    SignColumn = { bg = bg }, FoldColumn = { fg = t.subtle, bg = bg },
    Folded = { fg = t.muted, bg = panel }, ColorColumn = { bg = muted },
    VertSplit = { fg = s.border }, WinSeparator = { fg = s.border },
    EndOfBuffer = { fg = t.subtle }, NonText = { fg = t.subtle },
    Whitespace = { fg = t.subtle }, SpecialKey = { fg = t.subtle },
    Visual = { fg = u.selectionFg, bg = s.selection }, VisualNOS = { link = 'Visual' },
    Search = { fg = u.selectionFg, bg = u.search },
    IncSearch = { fg = t.inverse, bg = u.cursor, bold = true },
    CurSearch = { link = 'IncSearch' }, Substitute = { link = 'IncSearch' },
    MatchParen = { fg = y['function'], bg = elevated, bold = true },
    Pmenu = { fg = t.primary, bg = panel },
    PmenuSel = { fg = u.selectionFg, bg = s.selection, bold = true },
    PmenuSbar = { bg = elevated }, PmenuThumb = { bg = s.border },
    PmenuMatch = { fg = y['function'], bold = true },
    PmenuMatchSel = { fg = y['function'], bg = s.selection, bold = true },
    StatusLine = { fg = t.primary, bg = panel },
    StatusLineNC = { fg = t.muted, bg = muted },
    TabLine = { fg = t.muted, bg = panel }, TabLineFill = { bg = panel },
    TabLineSel = { fg = t.primary, bg = bg, bold = true },
    Directory = { fg = y.type }, Title = { fg = u.accent, bold = true },
    MsgArea = { fg = t.primary }, ModeMsg = { fg = t.primary },
    MoreMsg = { fg = d.success }, Question = { fg = d.info },
    WarningMsg = { fg = d.warn }, ErrorMsg = { fg = d.error },
    WildMenu = { fg = t.primary, bg = s.selection },
    QuickFixLine = { bg = s.selection },
    DiffAdd = { fg = d.success, bg = muted },
    DiffChange = { fg = d.info, bg = muted },
    DiffDelete = { fg = d.error, bg = muted },
    DiffText = { fg = d.warn, bg = s.selection },
    Added = { fg = d.success }, Changed = { fg = d.info }, Removed = { fg = d.error },
    SpellBad = { undercurl = true, sp = d.error },
    SpellCap = { undercurl = true, sp = d.info },
    SpellLocal = { undercurl = true, sp = d.hint },
    SpellRare = { undercurl = true, sp = d.warn },
    Comment = { fg = y.comment, italic = italics.comments },
    Constant = { fg = y.literal }, String = { fg = y.string, italic = italics.strings },
    Character = { link = 'String' }, Number = { fg = y.number },
    Boolean = { fg = y.literal }, Float = { link = 'Number' },
    Identifier = { fg = y.variable, italic = italics.variables },
    Function = { fg = y['function'], bold = true, italic = italics.functions },
    Statement = { fg = y.keyword, bold = true, italic = italics.keywords },
    Conditional = { link = 'Statement' }, Repeat = { link = 'Statement' },
    Label = { fg = y.builtin }, Operator = { fg = y.operator },
    Keyword = { link = 'Statement' }, Exception = { link = 'Statement' },
    PreProc = { fg = y.builtin }, Include = { link = 'PreProc' },
    Define = { link = 'PreProc' }, Macro = { link = 'PreProc' },
    Type = { fg = y.type, bold = true }, StorageClass = { link = 'Type' },
    Structure = { link = 'Type' }, Typedef = { link = 'Type' },
    Special = { fg = y.builtin }, SpecialChar = { link = 'Special' },
    Tag = { fg = y.type }, Delimiter = { fg = y.operator },
    Debug = { fg = d.warn }, Underlined = { underline = true, fg = d.info },
    Ignore = { fg = t.subtle }, Error = { fg = d.error },
    Todo = { fg = t.inverse, bg = u.cursor, bold = true },
    DiagnosticError = { fg = d.error }, DiagnosticWarn = { fg = d.warn },
    DiagnosticInfo = { fg = d.info }, DiagnosticHint = { fg = d.hint },
    DiagnosticOk = { fg = d.success },
  }

  for _, kind in ipairs({ 'Error', 'Warn', 'Info', 'Hint', 'Ok' }) do
    for _, prefix in ipairs({ 'DiagnosticVirtualText', 'DiagnosticFloating', 'DiagnosticSign' }) do
      g[prefix .. kind] = { link = 'Diagnostic' .. kind }
    end
    local color = ({ Error = d.error, Warn = d.warn, Info = d.info, Hint = d.hint, Ok = d.success })[kind]
    g['DiagnosticUnderline' .. kind] = { undercurl = true, sp = color }
  end
  local captures = {
    ['@comment'] = 'Comment', ['@comment.documentation'] = 'Comment',
    ['@constant'] = 'Constant', ['@constant.builtin'] = 'Boolean',
    ['@string'] = 'String', ['@string.escape'] = 'SpecialChar',
    ['@string.special'] = 'SpecialChar', ['@character'] = 'Character',
    ['@number'] = 'Number', ['@number.float'] = 'Number', ['@boolean'] = 'Boolean',
    ['@function'] = 'Function', ['@function.call'] = 'Function',
    ['@function.method'] = 'Function', ['@function.method.call'] = 'Function',
    ['@function.builtin'] = 'Special', ['@function.macro'] = 'Macro',
    ['@variable'] = 'Identifier', ['@variable.builtin'] = 'Special',
    ['@variable.parameter'] = 'Identifier', ['@variable.member'] = 'Identifier',
    ['@property'] = 'Identifier', ['@type'] = 'Type', ['@type.builtin'] = 'Type',
    ['@type.definition'] = 'Type', ['@attribute'] = 'Special',
    ['@keyword'] = 'Keyword', ['@keyword.function'] = 'Keyword',
    ['@keyword.return'] = 'Keyword', ['@keyword.conditional'] = 'Keyword',
    ['@keyword.repeat'] = 'Keyword', ['@operator'] = 'Operator',
    ['@punctuation'] = 'Delimiter', ['@punctuation.bracket'] = 'Delimiter',
    ['@punctuation.delimiter'] = 'Delimiter', ['@punctuation.special'] = 'Special',
    ['@constructor'] = 'Type', ['@module'] = 'Type', ['@label'] = 'Label',
    ['@tag'] = 'Tag', ['@tag.attribute'] = 'Special',
    ['@markup.heading'] = 'Title', ['@markup.link'] = 'Underlined',
    ['@markup.raw'] = 'String', ['@markup.strong'] = 'Statement',
    ['@markup.italic'] = 'Comment', ['@diff.plus'] = 'Added',
    ['@diff.minus'] = 'Removed', ['@diff.delta'] = 'Changed',
    ['@lsp.type.namespace'] = 'Type', ['@lsp.type.type'] = 'Type',
    ['@lsp.type.class'] = 'Type', ['@lsp.type.enum'] = 'Type',
    ['@lsp.type.interface'] = 'Type', ['@lsp.type.struct'] = 'Type',
    ['@lsp.type.function'] = 'Function', ['@lsp.type.method'] = 'Function',
    ['@lsp.type.parameter'] = 'Identifier', ['@lsp.type.property'] = 'Identifier',
    ['@lsp.type.variable'] = 'Identifier', ['@lsp.type.macro'] = 'Macro',
  }
  for capture, target in pairs(captures) do g[capture] = { link = target } end
  -- Zig doc roles are deliberately explicit: @import is builtin, u8 is a type.
  g['@function.builtin.zig'] = { link = 'Special' }
  g['@type.builtin.zig'] = { link = 'Type' }
  g['@keyword.zig'] = { link = 'Keyword' }
  g['@string.zig'] = { link = 'String' }
  g['@comment.zig'] = { link = 'Comment' }

  for name, spec in pairs(require('zirconium.integrations.cmp').highlights(p)) do g[name] = spec end
  local overrides = type(options.overrides) == 'function' and options.overrides(p) or options.overrides
  for name, spec in pairs(overrides or {}) do g[name] = spec end
  return g
end

local function apply_highlight(name, spec, cterm)
  local result = vim.deepcopy(spec)
  if result.link then
    -- Neovim ignores other fields alongside link; allow overrides to replace links.
    vim.api.nvim_set_hl(0, name, result)
    return
  end
  for _, key in ipairs({ 'fg', 'bg' }) do
    local color = result[key]
    if result['cterm' .. key] == nil
      and type(color) == 'string'
      and color:sub(1, 1) == '#'
    then
      result['cterm' .. key] = cterm[color:lower()]
    end
  end
  vim.api.nvim_set_hl(0, name, result)
end

function theme.setup(options)
  config.setup(options)
end

function theme.colorscheme(variant)
  if variant and variant ~= 'dark' and variant ~= 'light' then error('Zirconium: unknown variant ' .. tostring(variant)) end
  if variant then vim.o.background = variant end
  local p = get_palette(variant)
  local name = variant and 'zirconium-' .. variant or 'zirconium'
  vim.cmd 'highlight clear'
  if vim.fn.exists('syntax_on') == 1 then vim.cmd 'syntax reset' end
  vim.g.colors_name = name
  local options = config.options
  local groups = groups_for(p, options)
  local cterm = require('zirconium.palette').cterm
  for group, spec in pairs(groups) do apply_highlight(group, spec, cterm) end
  for i, color in ipairs(p.ansi.normal) do vim.g['terminal_color_' .. (i - 1)] = color end
  for i, color in ipairs(p.ansi.bright) do vim.g['terminal_color_' .. (i + 7)] = color end
  vim.g.terminal_color_background = p.surface.bg
  vim.g.terminal_color_foreground = p.text.primary
  theme.bufferline = { highlights = require('zirconium.integrations.bufferline').highlights(p, options) }
end

return theme
