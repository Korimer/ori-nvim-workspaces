local config = require("ori-sessions")

local completions = {
  add = {
    op = {}
    ;complete = {}
  }
  ;delete = {
    op = {}
    ;complete = {}
  }
  ;enable = {
    op = {}
    ;complete = {}
  }
}

local function completion()

end

local function dispatch_cmd(operation, opts)
  completions[operation].op(opts)
end

vim.api.nvim_create_user_command("Workspace", dispatch_cmd, {complete = completion})

