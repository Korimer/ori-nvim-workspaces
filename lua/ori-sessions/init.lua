local M = {}

local config = require("ori-sessions.config")
M.config = config.options

function M.setup(opts)
  config.setup(opts)
  M.config = config.config

  vim.fn.mkdir(M.config.workspace_location,"p")

  local registry = require("ori-sessions._core.registry")
  registry.setup()

  local commands = require("ori-sessions._core.commands")
  commands.setup()

  if M.config.restore_prev_session then
    require("ori-sessions.api").swapToLastWorkspace()
  else
    M.config.meta.lastSession = nil
  end
end

return M
