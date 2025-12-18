local M = {}

local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local runner = plugin_root .. "/target/release/cargo-on-nvim"
local output_module = require("output-window")


function M.dispatch(args)
    local buf, win, chan = output_module.open_float_window()

    local cmd = vim.list_extend({ runner }, args)
    local cwd = vim.fn.expand("%:p:h")

    -- use jobstart to enable pty to properly handle ANSI
    vim.fn.jobstart(cmd, {
        cwd = cwd,
        pty = true,
        on_stderr = function(_, data)
            if data then
                local lines = table.concat(data, "\r\n")
                vim.api.nvim_chan_send(chan, lines)
            end
        end,
        on_stdout = function(_, data)
            if data then
                local lines = table.concat(data, "\r\n")
                vim.api.nvim_chan_send(chan, lines)
            end
        end,
        on_exit = function(_, exit_code)
            local msg = string.format("\n[Process exited with code %d]", exit_code)
            vim.api.nvim_chan_send(chan, msg)
        end,
    })
end

return M
