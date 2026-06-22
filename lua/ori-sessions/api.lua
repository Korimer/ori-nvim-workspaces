local M = {}

local config = require("ori-sessions.config").config
local registry = require("ori-sessions._core.registry")

function M.addWorkspace(name, opts)
  opts = opts or {}
  local ws_loc = opts.directory or vim.fs.joinpath(config.workspace_location, name)

  if config.workspaces[name] ~= nil then
    vim.notify(
      "A session named " .. name .. " already exists!",
      vim.log.levels.ERROR
    )
  end

  if vim.fn.isdirectory(ws_loc) == 1 and not opts.force then
    vim.notify(
      "Folder " .. ws_loc .. " already exists!",
      vim.log.levels.WARN
    )
  else
    vim.fn.mkdir(ws_loc)
  end

  local ws_type = opts.type or config.default_session.type

  registry._registerWS(ws_loc, name, ws_type)
  M._conditionalSave()
end

function M.delWorkspace(name, del_folder)
  -- TODO
  vim.notify("TODO", vim.log.levels.ERROR)
  M._conditionalSave()
end

function M.swapToLastWorkspace()
  if config.meta.lastSession then
    M.swapToWorkspace(config.meta.lastSession)
  else
    vim.notify("ori-sessions: No previous session to swap to!", vim.log.levels.WARN)
  end
end

function M.swapToWorkspace(name)
  local workspace = config.workspaces[name]

  local hook = workspace.hook
  if hook then hook(name) end

  vim.api.nvim_set_current_dir(workspace.path)

  config.meta.lastSession = name
end

function M._conditionalSave()
  if config.save_on == "modify" or config.save_on == "all" then
    M.save()
  end
end

function M.save()
  registry.writeRegistry()
end

return M
