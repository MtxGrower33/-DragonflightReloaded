function print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

setfenv(1, DFRL:GetEnvironment())
d:DebugPrint("BOOTING")

-- my api
function print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function KillFrame(frame)
    if not frame then return end

    if frame.UnregisterAllEvents then
        frame:UnregisterAllEvents()
    end

    if frame.Hide then
        frame:Hide()
    end

    if frame.GetScript and frame.SetScript then
        local scriptTypes = {
            "OnShow", "OnHide", "OnEnter", "OnLeave", "OnMouseDown", "OnMouseUp",
            "OnClick", "OnDoubleClick", "OnDragStart", "OnDragStop", "OnUpdate",
            "OnEvent", "OnLoad", "OnSizeChanged", "OnValueChanged"
        }

        for _, scriptType in ipairs(scriptTypes) do
            local success = pcall(function() return frame:GetScript(scriptType) end)
            if success and frame:GetScript(scriptType) then
            frame:SetScript(scriptType, nil)
            end
        end
    end

    if frame.SetParent then
        frame:SetParent(UIParent)
    end

    if frame.ClearAllPoints then
        frame:ClearAllPoints()
    end

    if frame.SetAlpha then
        frame:SetAlpha(0)
    end

    if frame.EnableMouse then
        frame:EnableMouse(false)
    end

    if frame.EnableKeyboard then
        frame:EnableKeyboard(false)
    end
end

function HideFrameTextures(frame)
    local regions = {frame:GetRegions()}
    for _, region in ipairs(regions) do
        if region:GetObjectType() == "Texture" then
            region:Hide()
        end
    end
end

function AbbreviateName(name)
    if name and string.len(name) > 5 then
        return string.sub(name, 1, 8) .. "..."
    elseif name then
        return name
    else
        return "No target"
    end
end

local lastMessageTime = 0
local canSendMessages = false
local throttleFrame = CreateFrame("Frame")
throttleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
throttleFrame:SetScript("OnEvent", function()
    throttleFrame.timeToEnable = GetTime() + 2
    throttleFrame:SetScript("OnUpdate", function()
        if GetTime() >= throttleFrame.timeToEnable then
            canSendMessages = true
            throttleFrame:SetScript("OnUpdate", nil)
            throttleFrame:UnregisterEvent("CVAR_UPDATE")
        end
    end)
end)

function ThrottledMessage(message)
    if not canSendMessages then return end

    local currentTime = GetTime()
    if currentTime - lastMessageTime >= 4 then
        print("|cffff0000[BUG]:|r " .. message)
        lastMessageTime = currentTime
    end
end

-- shagu api
function hooksecurefunc(name, func, append)
    if not _G[name] then return end

    DFRL.hooks[tostring(func)] = {}
    DFRL.hooks[tostring(func)]["old"] = _G[name]
    DFRL.hooks[tostring(func)]["new"] = func

    if append then
        DFRL.hooks[tostring(func)]["function"] = function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
            DFRL.hooks[tostring(func)]["old"](a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
            DFRL.hooks[tostring(func)]["new"](a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        end
    else
        DFRL.hooks[tostring(func)]["function"] = function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
            DFRL.hooks[tostring(func)]["new"](a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
            DFRL.hooks[tostring(func)]["old"](a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        end
    end

    _G[name] = DFRL.hooks[tostring(func)]["function"]
end

HookScript = function(f, script, func)
    local prev = f:GetScript(script)
    f:SetScript(script, function(a1,a2,a3,a4,a5,a6,a7,a8,a9)
    if prev then prev(a1,a2,a3,a4,a5,a6,a7,a8,a9) end
        func(a1,a2,a3,a4,a5,a6,a7,a8,a9)
    end)
end
