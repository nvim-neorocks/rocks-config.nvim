--[[
Example rocks.toml:
```toml
[plugins]
"neorg" = "6.0.0-1"

[config]
plugins_dir = "plugins/"
```
--]]

local ok, api = pcall(require, "rocks.api")

if not ok then
    vim.notify("[rocks-config.nvim]: rocks.nvim not found, aborting!", vim.log.levels.ERROR, {})
    return
end

local user_configuration = api.get_rocks_toml()

require("rocks-config").setup(user_configuration)
