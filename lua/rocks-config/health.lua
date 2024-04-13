local health = {}

local function check_for_duplicates()
    vim.health.start("Checking for duplicate configuration files")

    local dupes = require("rocks-config").duplicate_configs_found

    if #dupes == 0 then
        vim.health.ok("No duplicate configurations found.")
        return
    end

    for _, dupe in ipairs(dupes) do
        local plugin_name, config_basename = unpack(dupe)
        vim.health.warn(
            ("Duplicate configuration found for plugin '%s' named '%s.lua'. Skipping."):format(
                plugin_name,
                config_basename
            )
        )
    end
end

function health.check()
    check_for_duplicates()
end

return health
