--=========================================================================
-- DRAGONFLIGHT: RELOADED DOCUMENTATION
--=========================================================================
----> Workflow:
-- 1. ADDON_LOADED: VersionCheckDB() checks/wipes DB versions → InitTempDB()
--    detects character → creates/gets profile mapping → loads profile data
--    into tempDB → applies missing defaults from NewDefaults() → RunMods()
-- 2. Runtime: RegisterCallback() sets up listeners, SetTempDB() triggers
--    TriggerCallback() for module reactions, modules execute in sandboxed
--    environment with shortcuts and track exec time, mem used, and scripts
-- 3. PLAYER_LOGOUT: SaveTempDB() writes tempDB back to character's profile,
--    preserving character-to-profile mapping
--=========================================================================

--=================
-- DFRL MAINFRAME
--=================
DFRL = CreateFrame("Frame", nil, UIParent)

--=================
-- TABLES
--=================
-- global
DFRL_PROFILES = {}
DFRL_DB_SETUP = {}

-- character
DFRL_CUR_PROFILE = {}
DFRL_FRAMEPOS = {}

-- internal
DFRL.env = {}
DFRL.tools = {}
DFRL.hooks = {}
DFRL.tempDB = {}
DFRL.modules = {}
DFRL.defaults = {}
DFRL.profiles = {}
DFRL.callbacks = {}
DFRL.performance = {}
DFRL.activeScripts = {}
DFRL.gui = {}

-- DB VERSION
DFRL.DBversion = "1.0"

--=================
-- LOCALS
--=================
local gcinfo = gcinfo
local GetTime = GetTime

-- boot flag
local boot = false

-- stub
local function debugprint() end
debugprint(">> BOOTING")

--=================
-- UTILITY
--=================
function DFRL:GetInfoOrCons(type)
    local name = "-DragonflightReloaded"
    if type == "name" then
        return name
    elseif type == "version" then
        return GetAddOnMetadata(name, "Version")
    elseif type == "author" then
        return GetAddOnMetadata(name, "Author")
    elseif type == "path" then
        return "Interface\\AddOns\\" .. name .. "\\"
    elseif type == "media" then
        return "Interface\\AddOns\\" .. name .. "\\media\\"
    elseif type == "tex" then
        return "Interface\\AddOns\\" .. name .. "\\media\\tex\\"
    elseif type == "font" then
        return "Interface\\AddOns\\" .. name .. "\\media\\fnt\\"
    end
end

function DFRL:CheckAddon(name)
    if name == "ShaguTweaks" then
        self.addon1 = true
        debugprint("CheckAddon - Detected: " .. name)
    elseif name == "ShaguTweaks-extras" then
        self.addon2 = true
        debugprint("CheckAddon - Detected: " .. name)
    elseif name == "Bagshui" then
        self.addon3 = true
        debugprint("CheckAddon - Detected: " .. name)
    end

    if IsAddOnLoaded("ShaguTweaks") then
        self.addon1 = true
        debugprint("CheckAddon - Already loaded: ShaguTweaks")
    elseif IsAddOnLoaded("ShaguTweaks-extras") then
        self.addon2 = true
        debugprint("CheckAddon - Already loaded: ShaguTweaks-extras")
    elseif IsAddOnLoaded("Bagshui") then
        self.addon3 = true
        debugprint("CheckAddon - Already loaded: Bagshui")
    end
end

function print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd100DFRL: |r".. tostring(msg))
end

--=================
-- ENVIRONMENT
--=================
function DFRL:GetEnv()
    debugprint("GetEnv - Env requested")
    self.env._G = getfenv(0)
    self.env.T = self.tools
    self.env.debugprint = debugprint
    return self.env
end

setmetatable(DFRL.env, {__index = getfenv(0)})

--=================
-- MODULES
--=================
function DFRL:NewDefaults(mod, defaults)

    if not self.defaults[mod] then
        self.defaults[mod] = {}
    end

    local count = 0
    for key, value in pairs(defaults) do
        self.defaults[mod][key] = value
        count = count + 1
    end

    debugprint("Set " .. count .. " defaults for module: " .. mod)
end

function DFRL:NewMod(name, prio, func)
    if self.modules[name] then
        debugprint("NewMod - Module already registered: " .. name)
        return
    end
    debugprint("NewMod - Registrating new mod " .. name .. " with priority " .. prio)
    self.modules[name] = {func = func, priority = prio}
end

function DFRL:RunMods()
    local list = {}
    for name, data in pairs(self.modules) do
        tinsert(list, {name = name, func = data.func, priority = data.priority})
    end

    table.sort(list, function(a, b) return a.priority < b.priority end)

    debugprint("RunMods - Executing " .. table.getn(list) .. " modules...")

    for i = 1, table.getn(list) do
        local name = list[i].name
        local func = list[i].func
		local enabled = self.tempDB[name] and self.tempDB[name].enabled
		if enabled == true then
            collectgarbage()
			local start = GetTime()
			local mem = gcinfo()
			setfenv(func, self:GetEnv())
			local success, err = pcall(func)
			if success then
				self.performance[name] = {
					time = GetTime() - start,
					memory = gcinfo() - mem
				}
				debugprint("RunMods - " .. name .. " executed: " .. tostring(self.performance[name].time) .. "s, " .. tostring(self.performance[name].memory) .. "kb")
			else
				debugprint("RunMods - Error in module " .. name .. ": " .. tostring(err))
				geterrorhandler()(err)
			end
		else
			debugprint("RunMods - Skipping disabled module: " .. name)
		end
	end
end

--=================
-- DATABASE
--=================
function DFRL:InitTempDB()
    debugprint("InitTempDB - Config initializing...")
    self:VersionCheckDB()

    -- set default profile if none exists
    local char = UnitName("player")
    debugprint("Character detected: " .. char)

    if not DFRL_CUR_PROFILE[char] then
        DFRL_CUR_PROFILE[char] = "Default"
        debugprint("Created default profile for character: " .. char)
    end

    local cur = DFRL_CUR_PROFILE[char]
    debugprint("Using profile: " .. cur .. " for character: " .. char)

    -- ensure profile exists
    if not DFRL_PROFILES[cur] then
        DFRL_PROFILES[cur] = {}
        debugprint("Created new profile: " .. cur)
    end

    local settings = 0
    local defaults = 0

    -- copy existing module settings from current profile
    for mod, tbl in pairs(DFRL_PROFILES[cur]) do
        if type(tbl) == "table" then
            self.tempDB[mod] = self.tempDB[mod] or {}
            for key, value in pairs(tbl) do
                self.tempDB[mod][key] = value
                settings = settings + 1
            end
        end
    end

    -- add missing defaults
    for mod, def in pairs(self.defaults) do
        self.tempDB[mod] = self.tempDB[mod] or {}
        for key, val in pairs(def) do
            if self.tempDB[mod][key] == nil then
                self.tempDB[mod][key] = val[1]
                defaults = defaults + 1
            end
        end
    end

    debugprint("Config initialized: " .. tostring(settings) .. " settings loaded, " .. tostring(defaults) .. " defaults applied")
end

function DFRL:VersionCheckDB()
    if not DFRL_DB_SETUP.version or DFRL_DB_SETUP.version ~= self.DBversion then
        debugprint("Version mismatch - wiping all DB's")
        DFRL_PROFILES = {}
        DFRL_DB_SETUP = {}
        DFRL_CUR_PROFILE = {}
        DFRL_DB_SETUP.version = self.DBversion
        print("Version mismatch - wiping all DFRL DB's")
    end
    debugprint("DB version check complete: " .. DFRL_DB_SETUP.version)
end

function DFRL:SetTempDB(mod, key, value)
    local old = self.tempDB[mod][key]
    self.tempDB[mod][key] = value
    debugprint("Config changed for " .. mod .. "." .. key .. ": " .. tostring(old) .. " -> " .. tostring(value))
    local cb = mod .. "_" .. key .. "_changed"
    self:TriggerCallback(cb, value)
end

function DFRL:SetTempDBNoCallback(mod, key, value)
    if not self.tempDB[mod] then
        self.tempDB[mod] = {}
        debugprint("Module not found in config, creating: " .. mod)
    end
    self.tempDB[mod][key] = value
    debugprint("Config added for " .. mod .. "." .. key .. ": " .. tostring(value))
end

-- will be replaceed by new
-- gettempDB after test phase
function DFRL:GetTempValue(name, key)
    if not self.tempDB[name] then
        return nil
    end

    return self.tempDB[name][key]
end

function DFRL:GetTempDB(mod, key)
    --local caller = debugstack(2, 2, 0)
    --debugprint("Config requested for " .. mod .. "." .. key .. ": " .. tostring(self.tempDB[mod][key]) .. " by " .. caller)
    return self.tempDB[mod][key]
end

function DFRL:SaveTempDB()
    local count = 0
    for _, _ in pairs(self.tempDB) do
        count = count + 1
    end

    local char = UnitName("player")
    local cur = DFRL_CUR_PROFILE[char] or "Default"
    debugprint("Saving character: " .. char .. " to profile: " .. cur)

    DFRL_PROFILES[cur] = self.tempDB
    DFRL_DB_SETUP.version = self.DBversion
    debugprint("SaveDB - Saved " .. count .. " modules to profile: " .. cur)
end

function DFRL:ResetDB()
    self.tempDB = {}
    DFRL_PROFILES = {}
    DFRL_DB_SETUP = {}
    DFRL_CUR_PROFILE = {}
    DFRL_DB_SETUP.version = self.DBversion
    debugprint("DFRL:ResetDB() - Database reset")
    ReloadUI()
end

--=================
-- PROFILES
--=================
function DFRL:CreateProfile(name)
    debugprint("CreateProfile - Creating profile: " .. name)
    DFRL_PROFILES[name] = {}
    for mod, def in pairs(self.defaults) do
        DFRL_PROFILES[name][mod] = {}
        for key, value in pairs(def) do
            DFRL_PROFILES[name][mod][key] = value[1]
        end
    end
    debugprint("CreateProfile - Profile created: " .. name)
end

function DFRL:SwitchProfile(name)
    local char = UnitName("player")
    local old = DFRL_CUR_PROFILE[char]
    debugprint("SwitchProfile - Switching from " .. old .. " to " .. name)
    DFRL_PROFILES[old] = self.tempDB
    DFRL_CUR_PROFILE[char] = name
    self:LoadProfile(name)
    debugprint("SwitchProfile - Profile switched to: " .. name)
end

function DFRL:CopyProfile(from, tbl)
    local src
    local name
    if tbl then
        debugprint("CopyProfile - Using provided table")
        src = tbl
        name = "static table"
    else
        debugprint("CopyProfile - Using profile: " .. from)
        src = DFRL_PROFILES[from]
        name = from
    end
    debugprint("CopyProfile - Loading " .. name .. " into tempDB")
    self.tempDB = {}
    for mod, data in pairs(src) do
        self.tempDB[mod] = {}
        for key, value in pairs(data) do
            self.tempDB[mod][key] = value
        end
    end
    debugprint("CopyProfile - Profile loaded into tempDB: " .. name)
end

function DFRL:LoadProfile(name)
    debugprint("LoadProfile - Loading profile: " .. name)
    self.tempDB = {}
    for mod, data in pairs(DFRL_PROFILES[name]) do
        self.tempDB[mod] = {}
        for key, value in pairs(data) do
            self.tempDB[mod][key] = value
        end
    end
    debugprint("LoadProfile - Profile loaded into tempDB: " .. name)
end

function DFRL:DeleteProfile(name)
    debugprint("DeleteProfile - Deleting profile: " .. name)
    DFRL_PROFILES[name] = nil
    debugprint("DeleteProfile - Profile deleted: " .. name)
end

--=================
-- CALLBACKS
--=================
function DFRL:NewCallbacks(mod, callbacks)
    debugprint("NewCallbacks - Registering new callbacks for module: " .. mod)

    local count = 0
    for key, func in pairs(callbacks) do
        local cb = mod .. "_" .. key .. "_changed"

        self.callbacks[cb] = {}
        tinsert(self.callbacks[cb], func)

        self:TriggerCallback(cb, self.tempDB[mod][key])

        count = count + 1
    end

    debugprint("Registered and triggered " .. count .. " callbacks for module: " .. mod)
end

function DFRL:TriggerCallback(cb, value)

    for _, func in ipairs(self.callbacks[cb]) do
        func(value)
    end

    debugprint("Triggered callback for: " .. cb)
end

function DFRL:TriggerAllCallbacks()
    for cb, callbacks in pairs(self.callbacks) do
        local name = string.gsub(cb, "_changed$", "")
        local pos = string.find(name, "_[^_]*$")
        local mod = string.sub(name, 1, pos - 1)
        local key = string.sub(name, pos + 1)
        local value = self.tempDB[mod] and self.tempDB[mod][key]

        for _, func in ipairs(callbacks) do
            func(value)
        end
    end
    debugprint("Triggered all callbacks")
end

--=================
-- EVENT HANDLER
--=================
DFRL:RegisterEvent("ADDON_LOADED")
DFRL:RegisterEvent("PLAYER_LOGOUT")
DFRL:SetScript("OnEvent", function()

    -- check on every addon load
    if event == "ADDON_LOADED" then
        DFRL:CheckAddon(arg1)
    end

    -- init DRAGONFLIGHT:RELOADED
    if event == "ADDON_LOADED" and arg1 == "-DragonflightReloaded" then
        debugprint("EVENT: ADDON_LOADED")

        if boot then
            debugprint("EVENT: Already booted, skipping")
            return
        end

        DFRL:InitTempDB()
        DFRL:RunMods()

        print("Welcome to |cffffd200Dragonflight:|r Reloaded.")
        print("Open menu via |cffddddddESC|r or |cffddddddSLASH DFRL|r.")
    end

    -- save tempDB to globalDB on logout
    if event == "PLAYER_LOGOUT" then
        debugprint("EVENT: PLAYER_LOGOUT")
        DFRL:SaveTempDB()
    end
end)
