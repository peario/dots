---@class Plugins
local M = {}

---@type string[]
M.files = {}

---@param path? string
function M.dirwalk(path)
  path = vim.fs.normalize(path or vim.fn.stdpath("config") .. "/plugin/deps")

  if vim.fn.isdirectory(path) == 1 then
    local fs = vim.uv.fs_scandir(path)
    if fs == nil then return end

    ---@type string|nil
    local name, type = "", ""

    while name do
      name, type = vim.uv.fs_scandir_next(fs)
      if name == nil or type == nil then break end

      local norm_path = vim.fs.normalize(path .. "/" .. name)
      if type == "file" and name:match("%.lua$") then table.insert(M.files, norm_path) end

      if type == "directory" then
        local isdir = vim.fn.isdirectory(norm_path) == 1
        local isempty = M.is_empty_dir(norm_path)

        if isdir and not isempty then M.dirwalk(norm_path) end
      end
    end
  end
end

---If the value returned is true, then either the direcotry does not exist or it's empty
---@return boolean
function M.is_empty_dir(path)
  if path == "" or path == nil then return true end

  local fs = vim.uv.fs_scandir(path)
  if fs == nil then return true end
  local name, type = vim.uv.fs_scandir_next(fs)
  return name == nil or type == nil
end

MiniDeps.now(function()
  -- Populate M.files
  M.dirwalk()
  -- Once done populating M.files, sort it and remove duplicates
  -- For safe measures as M.direwalk() does recursive searching
  table.sort(M.files)
  vim.list.unique(M.files)

  for _, file in ipairs(M.files or {}) do
    if vim.fn.filereadable(file) == 1 then dofile(file) end
  end
end)
