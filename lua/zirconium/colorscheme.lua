local palette = require 'zirconium.palette'

return function(variant)
  local name = variant or (vim.o.background == 'light' and 'light' or 'dark')
  return palette[name]
end
