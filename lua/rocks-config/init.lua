local constants = require("rocks-config.constants")

local rocks_config = {}

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

---Emulates Lua's require mechanism behaviour. Lua's `require` function
---returns `true` if the module returns nothing (`nil`), so we do the same.
---@param searcher function The module name
---@param mod_name string The module name
---@return any loaded
local function try_load_like_require(searcher, mod_name)
    local loader = searcher(mod_name)

    if type(loader) ~= "function" then
        return nil
    end

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

    -- Loaders that search `package.preload` and `package.path`.
    -- We don't need to search the cpath or neovim's runtimepath,
    -- as the nvim `lua` directory is added to the `package.path`.
    for _, searcher in ipairs(package.loaders) do
        local loaded = try_load_like_require(searcher, mod_name)

        if loaded ~= nil then
            package.loaded[mod_name] = loaded
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

    if type(config.config.options) == "table" then
        for key, value in pairs(config.config.options) do
            vim.opt[key] = value
        end
    end

    local exclude = {}

    if type(config.bundles) == "table" then
        for bundle_name, bundle in pairs(config.bundles) do
            if type(bundle) == "table" and type(bundle.items) == "table" then
                if type(bundle.config) ~= "nil" and type(bundle.config) ~= "string" then
                    vim.notify(string.format("[rocks-config.nvim]: Bundle '%s' has invalid `config` variable. Expected string pointing to a valid path, got %s instead...", bundle_name, type(bundle.config)), vim.log.levels.ERROR)
                    bundle.config = nil
                end

                local mod_name = bundle.config ~= nil and bundle.config or table.concat({ config.config.plugins_dir, bundle_name }, ".")

                if try_load_config(mod_name) then
                    for _, plugin in ipairs(bundle.items) do
                        exclude[plugin] = true
                    end
                else
                    vim.notify(string.format("[rocks-config.nvim]: Bundle '%s' has no specified configuration file, falling back to loading plugins from the bundle individually...", bundle_name), vim.log.levels.WARN)
                end
            end
        end
    end

    for name, data in pairs(user_configuration.plugins or {}) do
        if exclude[name] then
            goto continue
        end

        local plugin_heuristics = create_plugin_heuristics(name)

        local found_custom_configuration = false

        for _, possible_match in ipairs(plugin_heuristics) do
            local mod_name = table.concat({ config.config.plugins_dir, possible_match }, ".")
            local ok = try_load_config(mod_name)
            found_custom_configuration = found_custom_configuration or ok

            if found_custom_configuration then
                break
            end
        end

        -- If there is no custom configuration defined by the user then attempt to autoinvoke the setup() function.
        if not found_custom_configuration and (config.config.auto_setup or data.config) then
            if type(data.config) == "string" then
                require(data.config)
            else
                for _, possible_match in ipairs(plugin_heuristics) do
                    local ok, maybe_module = pcall(require, possible_match)

                    if ok and type(maybe_module) == "table" and type(maybe_module.setup) == "function" then
                        if type(data.config) == "table" then
                            maybe_module.setup(data.config)
                        elseif (config.config.auto_setup or data.config == true) and data.config ~= false then
                            maybe_module.setup()
                        end
                    end
                end
            end
        end

        ::continue::
    end

    if type(config.config.colorscheme or config.config.colourscheme) == "string" then
        pcall(vim.cmd.colorscheme, config.config.colorscheme or config.config.colourscheme)
    end
end

return rocks_config
