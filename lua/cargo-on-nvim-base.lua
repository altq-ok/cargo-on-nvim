local M = {}

local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local runner = plugin_root .. "/target/release/cargo-on-nvim"
local output_module = require("output-window")

local function handle_result(res)
    -- cargo uses stderr for log and stdout for output
    local output = table.concat({
        res.stderr or "",
        res.stdout or "",
    }, "\n")

    local buf, win = output_module.open_float_window()
    vim.bo[buf].filetype = "cargo-output" -- apply highlights etc.
    output_module.write_output(buf, output)
end

function M.dispatch(args)
    local cmd = vim.list_extend({ runner }, args)
    local cwd = vim.fn.expand("%:p:h")

    vim.system(cmd, { text = true, cwd = cwd }, function(res)
        vim.schedule(function()
            handle_result(res)
        end)
    end)
end

return M
