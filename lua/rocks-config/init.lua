---@mod rocks-config rocks-config.nvim Lua API

local rocks_config = {}

---Load a plugin's configuration
---@param plugin string The name of the plugin to configure
function rocks_config.configure(plugin)
    require("rocks-config.internal").configure(plugin)
end

return rocks_config
