local constants = {}

---@class rocks-config.Config
constants.DEFAULT_CONFIG = {
    ---@class rocks-config.Settings
    config = {
        ---@type boolean
        auto_setup = false,
        ---@type string
        plugins_dir = "plugins/",
        ---@type boolean
        load_opt_plugins = false,
        ---@type table?
        options = nil,
        ---@type string?
        colorscheme = nil,
        ---@type string?
        colourscheme = nil,
    },
    ---@type table?
    bundles = nil,
}

return constants
