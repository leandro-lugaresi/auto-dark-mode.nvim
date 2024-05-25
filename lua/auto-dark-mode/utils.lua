local M = {}

---@param cmd string
---@param opts {input?: string, oa_stdout?: function, on_exit?: function}
---@return number | 'the job id'
function M.start_job(cmd, opts)
  opts = opts or {}
  local id = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      if type(data) == "table" then
        data = table.concat(data, "\n")
      end
      if data and opts.on_stdout then
        opts.on_stdout(data)
      end
    end,
    on_exit = function(_, data, _)
      if opts.on_exit then
        opts.on_exit(data)
      end
    end,
  })

  if opts.input then
    vim.fn.chansend(id, opts.input)
    vim.fn.chanclose(id, "stdin")
  end

  return id
end

return M
