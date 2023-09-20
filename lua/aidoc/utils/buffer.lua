local M = {}

function M.text()
  local bufnr = vim.api.nvim_win_get_buf(0)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), true)
  local text = ""
  for i, line in ipairs(lines) do
    text = text .. line .. "\n"
  end
  return text
end

function M.visual_text()
  local a_orig = vim.fn.getreg("a")
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    vim.cmd([[normal! gv]])
  end
  vim.cmd([[silent! normal! "aygv]])
  local text = vim.fn.getreg("a")
  vim.fn.setreg("a", a_orig)
  return text
end

function M.text_or_visual_text()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" then
    return M.visual_text()
  end
  return M.text()
end

function M.type()
  local ft = vim.o.filetype
  return ft
end

function M.filename()
  return vim.fn.expand("%:t")
end

---@param lines string[] new lines
---@param row number
---@param insert_before boolean | nil
function M.insert_lines(lines, row, insert_before)
  local offset = 1

  if insert_before then
    offset = 2
  end

  for i, line in ipairs(lines) do
    local lnr = row + i - offset
    vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), lnr, lnr, false, { line })
  end
end

function M.get_selection_start()
  local _, row = unpack(vim.fn.getpos("'<"))
  return row
end

function M.switch_to_normal_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
end

function M.format()
  vim.lsp.buf.format()
end

return M
