local M = {}

function M.open_float_window()
    -- create buffer (not showin in :ls, scratch buffer independent of file)
    local buf = vim.api.nvim_create_buf(false, true)

    -- define window size and options
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.6)
    local win_opts = {
        -- show at the centre relative to the editor
        relative = "editor",
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
    }
    -- open and put focus on the window
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Initialise buffer as terminal channel
    local chan = vim.api.nvim_open_term(buf, {})

    -- Allow closing the float window with q or Enter
    local function close_window()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    vim.keymap.set('n', '<CR>', close_window, { buffer = buf, silent = true })
    vim.keymap.set('n', 'q', close_window, { buffer = buf, silent = true })

    return buf, win, chan
end

return M
