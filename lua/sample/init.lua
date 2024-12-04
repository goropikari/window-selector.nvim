local M = {}

local default_config = {
  greet = 'hello',
}
local global_config = {}

function M.hello()
  print(global_config.greet)
end

function M.setup(opts)
  global_config = vim.tbl_deep_extend('force', default_config, opts or {})
end

return M
