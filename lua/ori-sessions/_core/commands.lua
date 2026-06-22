local api = require("ori-sessions.api")

local function addWS(opts)
  api.addWorkspace(opts.fargs[2],{
    force = opts.bang
  })
end

local function delWS(opts)
  api.delWorkspace(opts.fargs[2])
end

local function swapWS(opts)
  api.swapToWorkspace(opts.fargs[2])
end

local completions = {
  add = {
    op = addWS
    ;complete = {}
  }
  ;delete = {
    op = delWS
    ;complete = {}
  }
  ;swap = {
    op = swapWS
    ;complete = {}
  }
}

local function completion(ArgLead, CmdLine, CursorPos)
  return vim.tbl_keys(completions)
end

local function dispatch_cmd(opts)
  completions[opts.fargs[1]].op(opts)
end

local function setup()
  vim.api.nvim_create_user_command(
    "Workspace",
    dispatch_cmd,
    {
      complete = completion
      ;nargs = "+"
    }
  )

  --local group = vim.api.nvim_create_augroup("ori-sessions",{clear=false})
  --vim.api.nvim_create_autocmd("VimLeave",{
  --  pattern = "*",
  --  group = group,
  --  callback = function()
  --    require("ori-sessions._core.registry").writeRegistry()
  --  end
  --})
end

return {
  setup = setup
}
