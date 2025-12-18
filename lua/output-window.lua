local M = {}

function M.open_float_window()
    -- create buffer (not showin in :ls, scratch buffer independent of file)
    local buf = vim.api.nvim_create_buf(false, true)

    -- define window size
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.6)

    -- open and put focus on the window
    local win = vim.api.nvim_open_win(buf, true, {
        -- show at the centre relative to the editor
        relative = "editor",
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
    })

    return buf, win
end

function M.write_output(buf, text)
    local lines = vim.split(text, "\n")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

return M
