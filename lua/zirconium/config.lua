local M = {}

M.defaults = {
  transparent = false,
  italics = {
    comments = true,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
    bufferline = false,
  },
  overrides = {},
}

M.options = vim.deepcopy(M.defaults)

function M.setup(options)
  M.options = vim.tbl_deep_extend('force', vim.deepcopy(M.defaults), options or {})
end

return M
