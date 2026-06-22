return {
  storage_location = vim.fs.joinpath(vim.fn.stdpath('data'),"ori-sessions"),
  require_full_name = false,
  workspace_location = vim.fs.joinpath(vim.fn.expand('~'), "/Documents", "vim_workspaces"),
  restore_prev_session = false,

  default_session = {
    type = require("ori-sessions.consts").sessionTypes.DIRECTORY,
    hook = nil,
    -- `name` and `directory` don't have sensible defaults, as they will always be overwritten
  }
}
