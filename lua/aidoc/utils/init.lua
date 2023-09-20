local M = {}

M.buffer = require("aidoc.utils.buffer")
M.fetch = require("aidoc.utils.fetch")

function M.sleep(milliseconds)
  --TODO: find a cross platform way of doing this
  os.execute(string.format("sleep %d", milliseconds / 1000))
end

function M.log(msg, level)
  vim.notify("aidoc: " .. msg, level)
end

function M.get_machine_id()
  
return vim.fn.system('printf %s "$(uuidgen)"')
end

return M
