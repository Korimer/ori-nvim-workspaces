local M = {}

local default_opts = require('ori-sessions._core.defaults')

M.options = {}

function M.setup(user_opts)
  M.options = vim.tbl_deep_extend("force", default_opts, user_opts or {})
end

return M
