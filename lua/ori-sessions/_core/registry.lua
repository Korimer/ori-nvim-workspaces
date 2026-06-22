local M = {}

local config = require("ori-sessions").config
local consts = require("ori-sessions._core.consts")
local registry = vim.fs.joinpath(config.storage_location, consts.registryName)


function M.generateRegistryIfNotExists()
  if vim.fn.filereadable(registry) then
    return
  end

  local registrydir = vim.fn.fnamemodify(registry,":h")
  if vim.fn.isdirectory(registrydir) == 0 then
    vim.fn.mkdir(registrydir, "p")
  end

  M._createRegistry()
end

function M._createRegistry()
  M._writeToRegistry("")
end


function M._writeToRegistry(JSON)
  local file = io.open(registry, "w")
  if file then
    file:write(JSON)
    file:close()
  else
    vim.notify("Error: Could not write file " .. registry)
  end
end

function M._registerWS(ws_path, ws_name, ws_type)
  config.workspaces[ws_name] = {
    path = ws_path
    ;type = ws_type
  }
  M.writeRegistry()
end

function M.writeRegistry()
  local regfmt = {
    workspaces = config.workspaces
    ;version = config.version
  }
  local regJSON = vim.json.encode(regfmt)
  M._writeToRegistry(regJSON)
end

function M._loadRegistry()
  local regdata = vim.json.decode(registry)
  config.workspaces = regdata.workspaces
  config.version = consts.latestVersion
end

function M.setup()
  M.generateRegistryIfNotExists()
  M._loadRegistry()
end

return M
