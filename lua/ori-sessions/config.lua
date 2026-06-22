local M = {}

local default_opts = require('ori-sessions._core.defaults')

M.config = vim.deepcopy(default_opts)

function M.setup(user_opts)
  M.config = vim.tbl_deep_extend("force", M.config, user_opts or {})
end

return M
