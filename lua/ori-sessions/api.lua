local M = {}
local config = require("ori-sessions.config")

function M.newWorkspace(name, force)
  local ws_loc = vim.fs.joinpath(M.config.workspace_location, name)

  if vim.fn.isdirectory(ws_loc) == 1 and not force then
    vim.notify(
      "Folder " .. name .. " already exists!",
      vim.log.levels.WARN
    )
    return
  end
  vim.fn.mkdir(ws_loc)
end

return M
