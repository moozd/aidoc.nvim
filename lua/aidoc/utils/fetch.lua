local json = require("aidoc.utils.json")

---@param method 'POST'|'GET'
---@param url string
---@param data? table | nil
local function fetch(method, url, data)
  local args = {
    url,
    "-X " .. method,
    "-H 'Content-Type: application/json'",
  }

  local temp_file_path = vim.fn.tempname()

  if method == "POST" then
    local payload = json.stringify(data or {})
    vim.fn.writefile({ payload }, temp_file_path)
    table.insert(args, "-d " .. "@" .. temp_file_path .. "")
  end

  local command = "curl -s " .. table.concat(args, " ")

  local result = vim.fn.system(command)
  vim.fn.delete(temp_file_path)

  return json.parse(result)
end

return fetch
