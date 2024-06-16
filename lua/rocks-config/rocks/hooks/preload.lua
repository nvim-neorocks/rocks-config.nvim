--[[
Example rocks.toml:
```toml
[plugins]
"neorg" = "6.0.0-1"

[config]
plugins_dir = "plugins/"
```
--]]

if vim.g.rocks_config_nvim_loaded then
    return
end
vim.g.rocks_config_nvim_loaded = true

require("rocks-config.internal").setup()
