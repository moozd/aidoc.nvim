local M = {}
local api = require("aidoc.api")
local config = require("aidoc.config")

function M.setup(opt)
  opt = vim.tbl_extend("force", config.defaults, opt)
  --TODO: add keymap customization
  --
  --stylua: ignore
  vim.api.nvim_create_user_command("AIDocGenerate", function() api.generate(opt) end, {})
  --stylua: ignore
  vim.keymap.set({ "v"}, opt.keymap, function() api.generate(opt) end, {})
end

return M
