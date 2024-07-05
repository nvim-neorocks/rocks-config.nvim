local constants = require("rocks-config.constants")
local api = require("rocks.api")

local rocks_config = {
    duplicate_configs_found = {},
    failed_to_load = {},
}

---@type table<rock_name, boolean>
local _configured_rocks = {}

---@class RocksConfigToml: RocksConfigConfig
---@field rocks? table<string, RockSpec[]>
---@field plugins? table<string, RockSpec[]>

---Deduplicates a table that is being used as an array of strings
---@param arr string[]
---@return string[]
local function dedup(arr)
    local res = {}
    local hash = {}

    for _, v in ipairs(arr) do
        if not hash[v] then
            table.insert(res, v)
            hash[v] = true
        end
    end

    return res
end

---Creates plugin heuristics for a given plugin
---@param name string
---@return string[]
local function create_plugin_heuristics(name)
    name = name:gsub("%.", "-")

    return dedup({
        name,
        name:gsub("[%.%-]n?vim$", ""):gsub("n?vim%-", ""),
        name:gsub("%.", "-"),
        name .. "-nvim",
    })
end

---Tries to get a loader function for a given module.
---Returns nil if the module is not found.
---@param mod_name string The module name to search for
---@return function | nil
local function try_get_loader_for_module(mod_name)
    for _, searcher in ipairs(package.loaders) do
        local loader = searcher(mod_name)

        if type(loader) == "function" then
            return loader
        end
    end

    return nil
end

---Emulates Lua's require mechanism behaviour. Lua's `require` function
---returns `true` if the module returns nothing (`nil`), so we do the same.
---@param loader function The loader function
---@return unknown loaded
local function load_like_require(loader)
    local module = loader()

    if module == nil then
        return true
    end

    return module
end

---Tries to load a module, without panicking if it is not found.
---Will panic if the module is found and loading it panics.
---@param mod_name string The module name
---@return boolean loaded
local function try_load_config(mod_name)
    -- Modules can indeed return `false` so we must check specifically
    -- for `nil`.
    if package.loaded[mod_name] ~= nil then
        return true
    end

    local loader = try_get_loader_for_module(mod_name)

    if loader == nil then
        return false
    end

    package.loaded[mod_name] = load_like_require(loader)

    return true
end

---Checks if a plugin that already had a configuration loaded has
---a given duplicate candidate configuration, and registers the duplicate
---for being checked later.
---@param plugin_name string The plugin that is being configured
---@param config_basename string The basename of the configuration module.
---@param mod_name string The configuration module name to check for
local function check_for_duplicate(plugin_name, config_basename, mod_name)
    local duplicate = try_get_loader_for_module(mod_name)

    if duplicate ~= nil then
        table.insert(rocks_config.duplicate_configs_found, { plugin_name, config_basename })
    end
end

---Load a config and register any errors that happened while trying to load it.
---Returns false if the module was not found and true if it was, even if errors happened.
---@param plugin_name string The plugin that is being configured
---@param config_basename string The basename of the configuration module.
---@param mod_name string The configuration module to load.
---@return boolean
local function load_config(plugin_name, config_basename, mod_name)
    local ok, result = pcall(function()
        return try_load_config(mod_name)
    end)

    if not ok then
        -- Module was found but failed to load.
        table.insert(rocks_config.failed_to_load, { plugin_name, config_basename, result })
        return true
    end

    if type(result) ~= "boolean" then
        error(
            "rocks-config.nvim: The impossible happened! Please report this bug: try_load_config did not return boolean as expected."
        )
    end

    return result
end

---Check if any errors were registered during setup.
---@return boolean
local function errors_found()
    return #rocks_config.duplicate_configs_found > 0 or #rocks_config.failed_to_load > 0
end

---@return RocksConfigToml
local function get_config()
    local rocks_toml = api.get_rocks_toml()
    return vim.tbl_deep_extend("force", {}, constants.DEFAULT_CONFIG, rocks_toml or {})
end

---@param rock rock_name | RockSpec The rock to configure
---@param config? RocksConfigConfig
function rocks_config.configure(rock, config)
    config = config or get_config()
    if type(rock) == "string" then
        local all_plugins = api.get_user_rocks()
        if not all_plugins[rock] then
            vim.notify(("[rocks-config.nvim]: Plugin %s not found in rocks.toml"):format(rock), vim.log.levels.ERROR)
            return
        end
        rock = all_plugins[rock]
    end
    ---@cast rock RockSpec
    local name = rock.name
    if _configured_rocks[name] then
        return
    end
    _configured_rocks[rock.name] = true

    local plugin_heuristics = create_plugin_heuristics(name)

    local found_custom_configuration = false

    for _, possible_match in ipairs(plugin_heuristics) do
        local mod_name = table.concat({ config.config.plugins_dir, possible_match }, ".")

        if found_custom_configuration then
            check_for_duplicate(name, possible_match, mod_name)
        else
            local ok = load_config(name, possible_match, mod_name)
            found_custom_configuration = found_custom_configuration or ok
        end
    end

    -- If there is no custom configuration defined by the user then attempt to autoinvoke the setup() function.
    if not found_custom_configuration and (config.config.auto_setup or rock.config) then
        if type(rock.config) == "string" then
            require(rock.config)
        else
            for _, possible_match in ipairs(plugin_heuristics) do
                local ok, maybe_module = pcall(require, possible_match)

                if ok and type(maybe_module) == "table" and type(maybe_module.setup) == "function" then
                    if type(rock.config) == "table" then
                        maybe_module.setup(rock.config)
                    elseif (config.config.auto_setup or rock.config == true) and rock.config ~= false then
                        maybe_module.setup()
                    end
                end
            end
        end
    end
end

---@param all_plugins? table<rock_name, RockSpec>
function rocks_config.setup(all_plugins)
    local config = get_config()

    ---@diagnostic disable-next-line: inject-field
    config.config.plugins_dir = config.config.plugins_dir:gsub("[%.%/%\\]+$", "")
    if type(config.config.options) == "table" then
        for key, value in pairs(config.config.options) do
            vim.opt[key] = value
        end
    end

    if type(config.bundles) == "table" then
        for bundle_name, bundle in pairs(config.bundles) do
            if type(bundle) == "table" and type(bundle.items) == "table" then
                local nonexistent_bundle_item = vim.iter(bundle.items):find(function(item)
                    return (config.plugins or {})[item] == nil and (config.rocks or {})[item] == nil
                end)

                if nonexistent_bundle_item then
                    vim.notify(
                        string.format(
                            "[rocks-config.nvim]: Bundle '%s' has invalid plugin '%s'. Did you make a typo, or is the plugin not installed?",
                            bundle_name,
                            nonexistent_bundle_item
                        ),
                        vim.log.levels.ERROR
                    )
                    goto continue
                end

                if type(bundle.config) ~= "nil" and type(bundle.config) ~= "string" then
                    vim.notify(
                        string.format(
                            "[rocks-config.nvim]: Bundle '%s' has invalid `config` variable. Expected string pointing to a valid path, got %s instead...",
                            bundle_name,
                            type(bundle.config)
                        ),
                        vim.log.levels.ERROR
                    )
                    bundle.config = nil
                end

                local mod_name = bundle.config ~= nil and bundle.config
                    or table.concat({ config.config.plugins_dir, bundle_name }, ".")

                if try_load_config(mod_name) then
                    for _, plugin in ipairs(bundle.items) do
                        _configured_rocks[plugin] = true
                    end
                else
                    vim.notify(
                        string.format(
                            "[rocks-config.nvim]: Bundle '%s' has no specified configuration file, falling back to loading plugins from the bundle individually...",
                            bundle_name
                        ),
                        vim.log.levels.WARN
                    )
                end
            end

            ::continue::
        end
    end

    all_plugins = all_plugins or api.get_user_rocks()
    for _, rock_spec in pairs(all_plugins) do
        if not rock_spec.opt or config.config.load_opt_plugins then
            rocks_config.configure(rock_spec, config)
        end
    end

    if type(config.config.colorscheme or config.config.colourscheme) == "string" then
        pcall(vim.cmd.colorscheme, config.config.colorscheme or config.config.colourscheme)
    end

    if errors_found() then
        vim.notify(
            "Issues found while loading plugin configs. Run :checkhealth rocks-config for more info.",
            vim.log.levels.WARN
        )
    end
end

return rocks_config
