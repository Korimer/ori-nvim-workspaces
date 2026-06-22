local M = {}

local config = require("ori-sessions.config")
local registry = require("ori-sessions._core.registry")
M.config = config.options

function M.setup(opts)
  config.setup(opts)
  registry.setup()
end

return M
