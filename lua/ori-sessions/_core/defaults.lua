local consts = require("ori-sessions.consts")
return {
  storage_location = vim.fs.joinpath(vim.fn.stdpath('data'),"ori-sessions"),
  require_full_name = false,
  workspace_location = vim.fs.joinpath(vim.fn.expand('~'), "/Documents", "ori-sessions"),
  restore_prev_session = false,

  -- Options:
  -- - `none` = never save; requires you to manually call require("ori-sessions.api").save().
  -- - `modify` = save when using a provided (API/User Command) means of managing sessions.
  -- - `exit` = save when exiting nvim.
  -- - `all` = `modify` and `exit` combined.
  save_on = "all",

  default_session = {
    -- Called via vim.cmd() whenever you swap to or otherwise enter said session. Can also be nil.
    hook = 'echo "Entered " . getcwd() .',
    -- If not nil; ori-sessions will attempt to clone this repository if it doesn't already exist in the current workspace's root.
    git_repo = nil,
    -- Can be of `BASIC`, `GIT`, `VIM`, and `AUTO`
    type = "AUTO",
    -- Can be modified freely, and will persist when nvim is closed. ori-sessions does not interface with this value.
    meta = {},

    -- `name` and `directory` don't have sensible defaults, as they will always be overwritten.
    directory = nil,
    name = nil,
  },

  meta = {}
}
