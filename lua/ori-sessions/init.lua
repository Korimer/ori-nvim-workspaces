local M = {}

function M.setup(opts)
  local config = require("ori-sessions.config")
  config.setup(opts)
  M.config = config.options
end

return M
