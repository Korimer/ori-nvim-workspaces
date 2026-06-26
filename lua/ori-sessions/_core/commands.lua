local api = require("ori-sessions.api")
local config = require("ori-sessions.config").config

local function addWS(opts)
  api.addWorkspace(opts.fargs[2], nil, {
    force = opts.bang
  })
end

local function delWS(opts)
  api.delWorkspace(opts.fargs[2])
end

local function swapWS(opts)
  api.swapToWorkspace(opts.fargs[2])
end

local function saveWS(opts)
  vim.notify("TODO: saveWS", vim.log.levels.ERROR)
end

local function createWS(opts)
  local cwd = vim.fn.getcwd()
  local folder = opts.fargs[2] or vim.fn.fnamemodify(cwd,":t")
  api.addWorkspace(folder, cwd, {
    force = opts.bang
    ;warn_existing = false
  })
end

local function _listWS()
  return vim.tbl_keys(config.workspaces)
end

local completions = {
  add = {
    op = addWS
    ;complete = function() return {} end
  }
  ;delete = {
    op = delWS
    ;complete = _listWS
  }
  ;restore = {
    op = swapWS
    ;complete = _listWS
  }
  ;save = {
    op = saveWS
    ;complete = _listWS
  }
  ;register = {
    op = createWS
    ; complete = function()
      return { vim.fn.fnamemodify(vim.fn.getcwd(),":t") }
    end
  }
}

local function completion(ArgLead, CmdLine, CursorPos)
  local parsed = vim.api.nvim_parse_cmd(CmdLine, {})

  if #parsed.args < 1 then
    return vim.tbl_keys(completions)
  end

  local completion_option = completions[parsed.args[1]]
  if completion_option then
    return completion_option.complete()
  end

  return {}
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

  local group = vim.api.nvim_create_augroup("ori-sessions",{clear=false})

  if config.save_on == "exit" or config.save_on == "all" then
    vim.api.nvim_create_autocmd("VimLeave",{
      pattern = "*",
      group = group,
      callback = function()
        require("ori-sessions.api").save()
      end
    })
  end
end

return {
  setup = setup
}
