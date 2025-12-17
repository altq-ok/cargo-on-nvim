local add_cmd = vim.api.nvim_create_user_command

local M = {}

local function cargo_cmd(sub)
    return function(opts)
        require("cargo-on-nvim-base").dispatch(
            vim.list_extend({ sub }, opts.fargs)
        )
    end
end

function M.setup()
    add_cmd("CargoRun", cargo_cmd("run"), { nargs = "*", complete = "shellcmd" })
    add_cmd("CargoTest", cargo_cmd("test"), { nargs = "*", complete = "shellcmd" })
    add_cmd("CargoCheck", cargo_cmd("check"), { nargs = "*", complete = "shellcmd" })
    add_cmd("CargoBuild", cargo_cmd("build"), { nargs = "*", complete = "shellcmd" })
    add_cmd("CargoClippy", cargo_cmd("clippy"), { nargs = "*", complete = "shellcmd" })
end

return M
