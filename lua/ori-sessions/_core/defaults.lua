return {
  storage_location = vim.fs.joinpath(vim.fn.stdpath('data'),"ori-sessions"),
  require_full_name = false,
  workspace_location = vim.fs.joinpath(vim.fn.expand('~'), "/Documents", "vim_workspaces"),
  restore_prev_session = false,

  -- Options:
  -- - `none` = never save; requires you to manually call require("ori-sessions.api").save().
  -- - `modify` = save when using a provided (API/User Command) means of managing sessions.
  -- - `exit` = save when exiting nvim.
  -- - `all` = `modify` and `exit` combined.
  save_on = "all",

  default_session = {
    type = "directory",
    hook = nil,
    -- `name` and `directory` don't have sensible defaults, as they will always be overwritten
  },

  meta = {}
}
