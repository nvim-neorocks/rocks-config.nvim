local constants = require("rocks-config.constants")

local rocks_config = {}

--- Creates plugin heuristics for a given plugin
---@param name string
local function create_plugin_heuristics(name)
    name = name:gsub("%.", "-")

    return {
        name,
        name:gsub("[%.%-]n?vim$", ""):gsub("n?vim%-", ""),
        name:gsub("%.", "-"),
        name .. "-nvim",
    }
end

---Tries to load a module, without panicking if it is not found.
---Will panic if the module is found and loading it panics.
---@param mod_name string The module name
---@return boolean loaded
local function try_load_config(mod_name)
    if package.loaded[mod_name] then
        return true
    end
    -- Loaders that search `package.preload` and `package.path`.
    -- We don't need to search the cpath or neovim's runtimepath,
    -- as the nvim `lua` directory is added to the `package.path`.
    for _, searcher in ipairs(package.loaders) do
        local loader = searcher(mod_name)
        if type(loader) == "function" then
            package.preload[mod_name] = loader
            package.loaded[mod_name] = loader()
            return true
        end
    end
    return false
end

function rocks_config.setup(user_configuration)
    if not user_configuration or type(user_configuration) ~= "table" then
        return
    end

    local config = vim.tbl_deep_extend("force", constants.DEFAULT_CONFIG, user_configuration or {})

    config.config.plugins_dir = config.config.plugins_dir:gsub("[%.%/%\\]+$", "")

    for name, data in pairs(user_configuration.plugins or {}) do
        local plugin_heuristics = create_plugin_heuristics(name)

        local found_custom_configuration = false

        for _, possible_match in ipairs(plugin_heuristics) do
            local mod_name = table.concat({ config.config.plugins_dir, possible_match }, ".")
            local ok = try_load_config(mod_name)
            found_custom_configuration = found_custom_configuration or ok
        end

        -- If there is no custom configuration defined by the user then attempt to autoinvoke the setup() function.
        if not found_custom_configuration and (config.config.auto_setup or data.config) then
            for _, possible_match in ipairs(plugin_heuristics) do
                local ok, maybe_module = pcall(require, possible_match)

                if ok and type(maybe_module) == "table" and type(maybe_module.setup) == "function" then
                    if type(data.config) == "table" then
                        maybe_module.setup(data.config)
                    elseif config.config.auto_setup or data.config == true then
                        maybe_module.setup()
                    end
                end
            end
        end
    end

    if type(config.config.colorscheme or config.config.colourscheme) == "string" then
        pcall(vim.cmd.colorscheme, config.config.colorscheme or config.config.colourscheme)
    end

    if type(config.config.options) == "table" then
        for key, value in pairs(config.config.options) do
            vim.opt[key] = value
        end
    end
end

return rocks_config
