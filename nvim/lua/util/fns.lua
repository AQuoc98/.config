local M = {}

function M.with_desc(options, desc)
  return vim.tbl_extend("force", options, { desc = desc })
end

return M
