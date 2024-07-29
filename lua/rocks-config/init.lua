---@mod rocks-config rocks-config.nvim Lua API

local rocks_config = {}

---@class rocks-config.RockSpec: RockSpec
---@field config? string | boolean

---@class rocks-config.configure.Opts
---
---Callback that is invoked before loading a plugin bundle.
---Takes the bundle items as an argument.
---@field load_bundle_pre? fun(bundle_items:string[])

---Load a plugin's configuration
---@param plugin string | rocks-config.RockSpec The name of the plugin to configure
---@param opts? rocks-config.configure.Opts
function rocks_config.configure(plugin, opts)
    opts = opts or {}
    local rc = require("rocks-config.internal")
    local bundle, bundle_items = rc.get_bundle(plugin)
    if bundle and bundle_items then
        if type(opts.load_bundle_pre) == "function" then
            opts.load_bundle_pre(bundle_items)
        end
        rc.load_bundle(bundle)
    else
        rc.configure(plugin)
    end
end

return rocks_config
