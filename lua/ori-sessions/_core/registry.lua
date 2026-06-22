local M = {}

local config = require("ori-sessions.config").config
local consts = require("ori-sessions.consts")
local registry = vim.fs.joinpath(config.storage_location, consts.registryName)


function M.generateRegistryIfNotExists()
  if vim.fn.filereadable(registry) == 1 then
    return
  end

  local registrydir = vim.fn.fnamemodify(registry,":h")
  if vim.fn.isdirectory(registrydir) == 0 then
    vim.fn.mkdir(registrydir, "p")
  end

  M._createRegistry()
end

function M._createRegistry()
  M._writeToRegistry(vim.json.encode({
    workspaces = {}
    ;version = consts.latestRegistryVersion
  }))
end

function M._writeToRegistry(JSON)
  local file = io.open(registry, "w")
  if file then
    file:write(JSON)
    file:close()
  else
    vim.notify("Could not write file " .. registry)
  end
end

function M._registerWS(ws_path, ws_name, ws_type)
  config.workspaces[ws_name] = {
    path = ws_path
    ;type = ws_type
  }
end

function M._packRegistry()
  return {
    workspaces = config.workspaces
    ;version = config.meta.version
    ;lastSession = config.meta.lastSession
  }
end

function M._unpackRegistry(reg_table)
  config.workspaces = reg_table.workspaces
  config.meta.version = reg_table.version
  config.meta.lastSession = reg_table.lastSession
end

function M.writeRegistry()
  local regfmt = M._packRegistry()
  local regJSON = vim.json.encode(regfmt)
  M._writeToRegistry(regJSON)
end

-- TODO: ReadFromRegistry (for cleanliness)
function M._readRegistry()
  local regfile = io.open(registry, "r")
  if regfile then
    local regcontents = regfile:read("*a")
    local regdata = vim.json.decode(regcontents)
    M._unpackRegistry(regdata)
  else
    vim.notify("Could not read file " .. registry, vim.log.levels.ERROR)
  end
end


function M.setup()
  M.generateRegistryIfNotExists()
  M._readRegistry()
end

return M
