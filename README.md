# cargo-on-nvim

Run cargo commands in Neovim.

**Please note that this repository is originally intended for my personal use.**

#### Lazy.nvim
```lua
return {
    "altq-ok/cargo-on-nvim",
    build = "cargo build --release",
    config = function()
        require("cargo-on-nvim").setup()
    end,
}
```
