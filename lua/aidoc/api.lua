local Util = require("aidoc.utils")

local mintlify_api_base = "https://api.mintlify.com"
local apis = {
  docs_writer = mintlify_api_base .. "/docs/write/v3",
  -- stylua: ignore
  docs_worker = function(id) return mintlify_api_base .. "/docs/worker/" .. id end,
}

local M = {}

local machine_id = Util.get_machine_id()

function M.generate(opts)
  local params = {
    userId = machine_id,

    code = Util.buffer.visual_text(),
    context = Util.buffer.text(),
    filename = Util.buffer.filename(),
    languageId = Util.buffer.type(),

    width = opts.width,
    email = opts.email,
    source = "vscode",
    docStyle = opts.docStyle or "Auto-detect",
    commented = true,
  }

  local worker_ok, worker = pcall(Util.fetch, "POST", apis.docs_writer, params)

  if worker_ok and worker then
    local worker_status = nil
    local worker_max_retry_counts = 250

    while worker_status == nil and worker_max_retry_counts > 0 do
      worker_max_retry_counts = worker_max_retry_counts - 1

      Util.sleep(100)

      local status_ok, status = pcall(Util.fetch, "GET", apis.docs_worker(worker.id))

      if status_ok and status and status.state == "completed" and status.data then
        worker_status = status
      elseif status_ok and status and status.state == "failed" then
        Util.log("Failed to retrieve the docs. 󰚑", vim.log.levels.ERROR)
        break
      end
    end

    if worker_status ~= nil then
      local lines = vim.fn.split(worker_status.data.docstring, "\n")

      local row = Util.buffer.get_selection_start()
      Util.buffer.insert_lines(lines, row, worker_status.data.position == "above")
      Util.buffer.switch_to_normal_mode()
      Util.buffer.format()
    else
      Util.log("Worker failed to respond. 󰚑", vim.log.levels.ERROR)
    end
  end
end

return M
