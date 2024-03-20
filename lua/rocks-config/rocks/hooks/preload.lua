--[[
Example rocks.toml:
```toml
[plugins]
"neorg" = "6.0.0-1"

[config]
plugins_dir = "plugins/"
```
--]]

if vim.g.did_load_rocks_config_nvim then
    return
end

local api = require("rocks.api")

local user_configuration = api.get_rocks_toml()

require("rocks-config").setup(user_configuration)

vim.g.did_load_rocks_config_nvim = true
