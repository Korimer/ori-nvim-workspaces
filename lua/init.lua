local M = {}
local defaults = require('defaults')
local finalconfig = {}
function M.setup(opts)
  for k,v in pairs(defaults) do
    finalconfig[k] = opts[k] or v
  end
end

function M.newWorkspace(name)
  os.execute("mkdir " .. finalconfig.workspace_location .. " name")

end

return M
