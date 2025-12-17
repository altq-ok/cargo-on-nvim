local M = {}

local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")

-- Switch to release from debug when ready
local runner = plugin_root .. "/target/release/cargo-on-nvim"

local function handle_result(res)
    -- cargo usually returns output to both stderr and stdout
    local output = res.stderr
    if output ~= "" then
        output = output .. "\n" .. res.stdout
    else
        output = res.stdout
    end

    if res.code ~= 0 then
        vim.notify(output, vim.log.levels.ERROR)
    else
        vim.notify(output, vim.log.levels.INFO)
    end
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
