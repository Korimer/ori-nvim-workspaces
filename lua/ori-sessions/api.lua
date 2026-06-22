local M = {}

local config = require("ori-sessions.config").config
local consts = require("ori-sessions.consts")
local registry = require("ori-sessions._core.registry")

function M.guessSessionType()
  if vim.v.this_session ~= "" then
    return consts.sessionTypes.VIM
  else
    return consts.sessionTypes.BASIC
  end
end

function M.addWorkspace(name, directory, opts)
  local sessionopts
  if opts then
    sessionopts = vim.deepcopy(opts)
  else
    sessionopts = {}
  end

  local ws_loc = directory or vim.fs.joinpath(config.workspace_location, name)

  sessionopts = vim.tbl_deep_extend("force", sessionopts, config.default_session)

  sessionopts.name = name
  sessionopts.directory = ws_loc

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

  registry._registerWS(sessionopts)
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

  if workspace == nil then
    vim.notify("Workspace " .. name .. " does not exist!", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_set_current_dir(workspace.directory)

  local hook = workspace.hook
  if hook then
    vim.cmd(hook)
  end

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
