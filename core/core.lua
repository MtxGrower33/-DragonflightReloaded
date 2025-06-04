---@diagnostic disable: redundant-parameter
--===============================================
-- DRAGONFLIGHT RELOADED WORKFLOW
--===============================================
-- >> Core Initialization:
-- Creates main frame (DFRL) and initializes
-- environment, modules, config, and callbacks tables.
-- >> Environment Setup:
-- Creates sandboxed environment via GetEnvironment(),
-- using metatables for global access.
-- >> Module System:
-- RegisterModule(): Registers modules with priority.
-- LoadModules(): Loads modules by priority.
-- >> Config System:
-- InitializeConfig(): Loads settings from DFRL_DB,
-- applies defaults.
-- SetDefaults(): Registers module default values/metadata.
-- GetConfig(): Retrieves config values.
-- SetConfig(): Updates config and triggers callbacks.
-- >> Callback System:
-- RegisterCallback(): Modules register for config change
-- notifications.
-- TriggerCallback(): Fires callbacks on config updates.
-- >> Event Handling:
-- PLAYER_ENTERING_WORLD: Init config and loads modules.
-- PLAYER_LOGOUT: Saves tempDB to DFRL_DB.
-- Debug: DebugPrint() saves logs to DFRL_LOGS.
--===============================================

-- debug compatibility
local d
if DBS_TOOLS then
    d = DBS_TOOLS
else
    d = {}
    function d:DebugPrint() end
end

if not ErrorHandler then
    ErrorHandler = function(err)
        DEFAULT_CHAT_FRAME:AddMessage("ERROR: " .. err, 1, 0, 0)
    end
    seterrorhandler(ErrorHandler)
end

-- mainframe
DFRL = CreateFrame("Frame", nil, UIParent)

d:DebugPrint("BOOTING")

-- tables
DFRL_DB = {}
DFRL_FRAMEPOS = {}

DFRL.env = {}
DFRL.gui = {}
DFRL.hooks = {}
DFRL.tempDB = {}
DFRL.modules = {}
DFRL.defaults = {}
DFRL.callbacks = {}
DFRL.performance = {}

-- setup environment
setmetatable(DFRL.env, {__index = getfenv(0)})

function DFRL:GetEnvironment()
    assert(self.env, "Environment table must exist")
    self.env._G = getfenv(0)

    -- add stub
    if DBS_TOOLS then
        self.env.d = DBS_TOOLS
    else
        local stub = {}
        function stub:DebugPrint() end
        self.env.d = stub
    end

    d:DebugPrint("Environment created")
    return self.env
end

-- modules system
function DFRL:RegisterModule(moduleName, priority, moduleFunc)
    assert(type(moduleName) == "string", "Module name must be a string")
    assert(priority == 1 or priority == 2, "Priority must be 1 (normal) or 2 (delayed)")
    assert(type(moduleFunc) == "function", "Module must be a function")

    self.modules[moduleName] = {
        func = moduleFunc,
        priority = priority
    }

    d:DebugPrint("Registered module: " .. moduleName .. " with priority " .. tostring(priority))
end

function DFRL:LoadModules()
    local env = self:GetEnvironment()
    assert(env, "Failed to get environment for modules")

    -- priority 1 (immediate)
    local normalCount = 0
    for moduleName, moduleData in pairs(self.modules) do
        if moduleData.priority == 1 then  -- Only load priority 1 modules here
            -- check enabled
            local isEnabled = true
            if self.tempDB[moduleName] and
               self.tempDB[moduleName]["enabled"] and
               self.tempDB[moduleName]["enabled"][1] == false then
                isEnabled = false
                d:DebugPrint("Skipping disabled module: " .. moduleName)
            end

            if isEnabled then
                collectgarbage()

                local startTime = GetTime()
                local startMem = gcinfo()

                -- execute module
                setfenv(moduleData.func, env)
                local success, errorMsg = pcall(moduleData.func)

                local endTime = GetTime()
                local endMem = gcinfo()

                if success then
                    -- store performance data
                    self.performance[moduleName] = {
                        loadTime = endTime - startTime,
                        memoryUsage = endMem - startMem
                    }

                    normalCount = normalCount + 1
                    d:DebugPrint(moduleName .. " loaded in " .. (endTime - startTime) .. "s using " .. (endMem - startMem) .. "KB")
                else
                    ErrorHandler("Failed to load module " .. moduleName .. ": " .. tostring(errorMsg))
                end
            end
        end
    end

    d:DebugPrint("TOTAL: " .. tostring(normalCount) .. " modules")
end


function DFRL:SetDefaults(moduleName, defaultsTable)
    assert(type(moduleName) == "string", "Module name must be a string")
    assert(type(defaultsTable) == "table", "Defaults must be a table")

    if not self.defaults[moduleName] then
        self.defaults[moduleName] = {}
    end

    local count = 0
    for key, value in pairs(defaultsTable) do
        self.defaults[moduleName][key] = value
        count = count + 1
    end

    d:DebugPrint("Set " .. tostring(count) .. " defaults for module: " .. moduleName)
end

-- callback system
function DFRL:RegisterCallback(moduleName, callbacksTable)
    assert(type(moduleName) == "string", "Module name must be a string")
    assert(type(callbacksTable) == "table", "Callbacks must be a table")

    local count = 0
    for key, func in pairs(callbacksTable) do
        local callbackName = moduleName .. "_" .. key .. "_changed"

        if not self.callbacks[callbackName] then
            self.callbacks[callbackName] = {}
        end

        tinsert(self.callbacks[callbackName], func)

        -- check if key exists in tempdb, some dont
        if self.tempDB[moduleName] and self.tempDB[moduleName][key] then
            local value = self.tempDB[moduleName][key][1]
            self:TriggerCallback(callbackName, value)
        end

        count = count + 1
    end

    d:DebugPrint("Registered and triggered " .. tostring(count) .. " callbacks for module: " .. moduleName)
end

function DFRL:TriggerCallback(callbackName, value)
    assert(callbackName, "Callback name cannot be nil")
    assert(type(callbackName) == "string", "Callback name must be a string")

    if not self.callbacks[callbackName] then
        d:DebugPrint("No callbacks registered for: " .. callbackName)
        return
    end

    assert(type(self.callbacks[callbackName]) == "table", "Callbacks container must be a table")

    for i, callbackFunc in ipairs(self.callbacks[callbackName]) do
        assert(type(callbackFunc) == "function", "Callback #" .. i .. " for " .. callbackName .. " must be a function")
        callbackFunc(value)
    end

    d:DebugPrint("Triggered callback for: " .. callbackName)
end

-- config system
function DFRL:GetConfig(moduleName, key)
    assert(self.tempDB[moduleName], "Module not found in config: " .. tostring(moduleName))
    assert(self.tempDB[moduleName][key], "Key not found in config: " .. tostring(key))
    d:DebugPrint("Config requested for " .. moduleName .. "." .. key .. ": " .. tostring(self.tempDB[moduleName][key][1]))
    return self.tempDB[moduleName][key][1]
end

function DFRL:SetConfig(moduleName, key, value)
    assert(self.tempDB[moduleName], "Module not found in config: " .. tostring(moduleName))
    assert(self.tempDB[moduleName][key] ~= nil, "Key not found in config: " .. tostring(key))

    local oldValue = self.tempDB[moduleName][key][1]
    self.tempDB[moduleName][key][1] = value

    d:DebugPrint("Config changed for " .. moduleName .. "." .. key .. ": " .. tostring(oldValue) .. " -> " .. tostring(value))

    -- trigger callback for this config change
    local callbackName = moduleName .. "_" .. key .. "_changed"
    self:TriggerCallback(callbackName, value)
end

function DFRL:InitializeConfig()
    local settingsLoaded = 0
    local defaultsApplied = 0

    assert(DFRL_DB, "DFRL_DB is not initialized")
    assert(type(DFRL_DB) == "table", "DFRL_DB must be a table")

    -- copy existing module settings from DFRL_DB
    for moduleName, moduleTable in pairs(DFRL_DB) do
        if type(moduleTable) == "table" then
            self.tempDB[moduleName] = self.tempDB[moduleName] or {}
            for key, value in pairs(moduleTable) do
                self.tempDB[moduleName][key] = value
                settingsLoaded = settingsLoaded + 1
            end
        end
    end

    -- add missing defaults - only copy first value as value table
    for moduleName, defaultsTable in pairs(self.defaults) do
        assert(type(defaultsTable) == "table", "Defaults for " .. moduleName .. " must be a table")
        self.tempDB[moduleName] = self.tempDB[moduleName] or {}
        for key, defaultValue in pairs(defaultsTable) do
            if self.tempDB[moduleName][key] == nil then
                -- only extract the first value and wrap it in a table
                if type(defaultValue) == "table" and defaultValue[1] ~= nil then
                    self.tempDB[moduleName][key] = {defaultValue[1]}
                else
                    -- fallback for non-table defaults or empty tables
                    self.tempDB[moduleName][key] = {defaultValue}
                end
                defaultsApplied = defaultsApplied + 1
            end
        end
    end

    d:DebugPrint("Config initialized: " .. tostring(settingsLoaded) .. " settings loaded, " .. tostring(defaultsApplied) .. " defaults applied")
end

function DFRL:SaveDB()
    assert(self.tempDB, "tempDB must exist before saving")
    assert(type(self.tempDB) == "table", "tempDB must be a table") -- im insecure sry lol

    local count = 0
    for moduleName, moduleData in pairs(self.tempDB) do
        assert(type(moduleData) == "table", "Module data for " .. moduleName .. " must be a table")
        count = count + 1
    end

    assert(count > 0, "No modules found in tempDB to save")

    DFRL_DB = self.tempDB
    d:DebugPrint("DFRL:SaveDB() saved " .. count .. " modules to database")
end

function DFRL:LoadDelayedModules()
    local env = self:GetEnvironment()
    assert(env, "Failed to get environment for modules")

    -- priority 2 (delayed)
    local delayedCount = 0
    for moduleName, moduleData in pairs(self.modules) do
        if moduleData.priority == 2 then
            -- check enabled
            local isEnabled = true
            if self.tempDB[moduleName] and
               self.tempDB[moduleName]["enabled"] and
               self.tempDB[moduleName]["enabled"][1] == false then
                isEnabled = false
                d:DebugPrint("Skipping disabled module: " .. moduleName)
            end

            if isEnabled then
                collectgarbage()

                local startTime = GetTime()
                local startMem = gcinfo()

                -- execute module
                setfenv(moduleData.func, env)
                local success, errorMsg = pcall(moduleData.func)

                local endTime = GetTime()
                local endMem = gcinfo()

                if success then
                    -- store performance data
                    self.performance[moduleName] = {
                        loadTime = endTime - startTime,
                        memoryUsage = endMem - startMem
                    }

                    delayedCount = delayedCount + 1
                    d:DebugPrint(moduleName .. " loaded in " .. (endTime - startTime) .. "s using " .. (endMem - startMem) .. "KB")
                else
                    ErrorHandler("Failed to load module " .. moduleName .. ": " .. tostring(errorMsg))
                end
            end
        end
    end
    d:DebugPrint("Loaded " .. tostring(delayedCount) .. " delayed priority modules")
end

-- event handler
DFRL:RegisterEvent("ADDON_LOADED")
DFRL:RegisterEvent("PLAYER_ENTERING_WORLD")
DFRL:RegisterEvent("PLAYER_LOGOUT")
DFRL:SetScript("OnEvent", function()

	-- init
    if event == "ADDON_LOADED" and arg1 == "DragonflightReloaded" then
        d:DebugPrint("EVENT: ADDON_LOADED")

        -- print belongs to me
        function print(msg)
            DEFAULT_CHAT_FRAME:AddMessage("|cffffd100DFRL: |r".. tostring(msg))
        end

        -- exec the addon
        DFRL:InitializeConfig()
        DFRL:LoadModules()

        print("Welcome to |cffffd200Dragonflight:|r Reloaded.")
        print("Open menu via |cffddddddESC|r or |cffddddddSLASH DFRL|r.")
    end

    -- In your event handler
    if event == "PLAYER_ENTERING_WORLD" then
        DFRL:LoadDelayedModules()
        d:DebugPrint("EVENT: PLAYER_ENTERING_WORLD")

        DFRL:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end

	-- save DB
    if event == "PLAYER_LOGOUT" then
        local count = 0
        for _ in pairs(DFRL.tempDB) do
            count = count + 1
        end

        d:DebugPrint("EVENT: PLAYER_LOGOUT")
        DFRL:SaveDB()
    end
end)
