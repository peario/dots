---@class util.data
local M = {}

--- Attempts to return the path to the users `~/.config` directory.
---@return string
function M.config_dir()
  ---@type string
  local from_xdg = vim.env.XDG_CONFIG_HOME

  ---@type string
  local from_env = vim.env.HOME .. "/.config"

  ---@type string
  local from_exp = vim.fn.expand("~/.config")

  return (from_xdg or from_env or from_exp)
end

--- Grabs the path to given data dir within `~/.config/nvim/`.
---@param data string Name of the data directory
---@return string
function M.set_data_dir(data)
  local path = M.config_dir() .. "/nvim/" .. data .. "/"

  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p", "0o700")
  end

  return path
end

return M
