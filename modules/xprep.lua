DFRL:SetDefaults("xprep", {
    enabled = {true},
    hidden = {false},

    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for bar borders"},

    showRepText = {false, 2, "checkbox", "rEP Bar", "Show or hide reputation text on the reputation bar"},
    autoTrack = {true, 3, "checkbox", "rEP Bar", "Automatically track reputation for factions you gain reputation with"},
    repBarHeight = {10, 4, "slider", {5, 20}, "rEP Bar", "Adjusts the height of the reputation bar"},
    repBarWidth = {300, 5, "slider", {200, 700}, "rEP Bar", "Adjusts the width of the reputation bar"},

    showXpText = {true, 6, "checkbox", "xP Bar", "Show or hide XP text on the XP bar"},
    xpBarHeight = {12, 7, "slider", {5, 20}, "xP Bar", "Adjusts the height of the XP bar"},
    xpBarWidth = {400, 8, "slider", {200, 700}, "xP Bar", "Adjusts the width of the XP bar"},

})

DFRL:RegisterModule("xprep", 1, function()
    d:DebugPrint("BOOTING")

    -- hide blizzard bars
    do
        KillFrame(MainMenuBarPerformanceBarFrame)
        KillFrame(MainMenuExpBar)
        KillFrame(ReputationWatchBar)
    end

    -- XP bar
    local xpBar
    do
        xpBar = CreateFrame("StatusBar", "DFRL_XPBar", UIParent)
        xpBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 25)
        xpBar:SetWidth(512)
        xpBar:SetHeight(10)
        xpBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\xprep\\main.tga")
        xpBar:SetStatusBarColor(0.58, 0, 0.55)

        local xpBg = xpBar:CreateTexture(nil, "BACKGROUND")
        xpBg:SetAllPoints(xpBar)
        xpBg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
        xpBg:SetVertexColor(0.1, 0.1, 0.1, 0.8)

        local leftBorder = xpBar:CreateTexture(nil, "OVERLAY", nil, 1)
        leftBorder:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\xprep\\border_half.tga")
        leftBorder:SetPoint("RIGHT", xpBar, "CENTER", 1, 0)
        leftBorder:SetWidth(203)
        leftBorder:SetHeight(18)
        xpBar.leftBorder = leftBorder

        local rightBorder = xpBar:CreateTexture(nil, "OVERLAY", nil, 1)
        rightBorder:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\xprep\\border_half.tga")
        rightBorder:SetPoint("LEFT", xpBar, "CENTER", -1, 0)
        rightBorder:SetWidth(203)
        rightBorder:SetHeight(18)
        rightBorder:SetTexCoord(1, 0, 0, 1)
        xpBar.rightBorder = rightBorder
    end

    -- reputation bar
    local repBar
    do
        repBar = CreateFrame("StatusBar", "DFRL_RepBar", UIParent)
        repBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 5)
        repBar:SetWidth(512)
        repBar:SetHeight(8)
        repBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\xprep\\main.tga")
        repBar:SetStatusBarColor(0, 0.6, 0.1)

        local repBg = repBar:CreateTexture(nil, "BACKGROUND")
        repBg:SetAllPoints(repBar)
        repBg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
        repBg:SetVertexColor(0.1, 0.1, 0.1, 0.8)

        local leftBorder = repBar:CreateTexture(nil, "OVERLAY", nil, 1)
        leftBorder:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\xprep\\border_half.tga")
        leftBorder:SetPoint("LEFT", repBar, "LEFT", -2, 0)
        leftBorder:SetWidth(203)
        leftBorder:SetHeight(18)
        repBar.leftBorder = leftBorder

        local rightBorder = repBar:CreateTexture(nil, "OVERLAY", nil, 1)
        rightBorder:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\xprep\\border_half.tga")
        rightBorder:SetPoint("RIGHT", repBar, "RIGHT", 2, 0)
        rightBorder:SetWidth(203)
        rightBorder:SetHeight(18)
        rightBorder:SetTexCoord(1, 0, 0, 1)
        repBar.rightBorder = rightBorder
    end

    -- store text display settings
    repBar.showText = true

    -- update bars
    do
        local function UpdateXPBar()
            local currXP = UnitXP("player")
            local maxXP = UnitXPMax("player")
            local playerLevel = UnitLevel("player")
            local restXP = GetXPExhaustion()

            -- hide XP at max lvl
            if playerLevel == 60 then
                xpBar:Hide()
            else
                xpBar:Show()
            end

            if maxXP == 0 then maxXP = 1 end
            xpBar:SetMinMaxValues(0, maxXP)
            xpBar:SetValue(currXP)

            d:DebugPrint("Rested XP: " .. tostring(restXP))

            -- color
            if restXP and restXP > 0 then
                -- blue
                xpBar:SetStatusBarColor(0, 0.4, 0.8)
                d:DebugPrint("Setting XP bar to blue (rested)")
            else
                -- purple
                xpBar:SetStatusBarColor(0.58, 0, 0.55)
                d:DebugPrint("Setting XP bar to purple (normal)")
            end

            -- update the text when XP changes
            if xpBar.text then
                local restPercent = 0
                if restXP and maxXP > 0 then
                    restPercent = math.floor((restXP / maxXP) * 100)
                end
                xpBar.text:SetText(currXP .. " / " .. maxXP .. " (" .. restPercent .. "% rested)")
            end
        end

        local function UpdateRepBar()
            local name, standing, min, max, value = GetWatchedFactionInfo()

            if name then
                repBar:Show()
                if max == min then max = min + 1 end
                repBar:SetMinMaxValues(min, max)
                repBar:SetValue(value)

                -- color based on standing
                if standing == 1 then
                    -- hated - red
                    repBar:SetStatusBarColor(0.8, 0, 0)
                elseif standing == 2 then
                    -- hostile - red
                    repBar:SetStatusBarColor(0.8, 0, 0)
                elseif standing == 3 then
                    -- unfriendly - orange
                    repBar:SetStatusBarColor(0.8, 0.3, 0)
                elseif standing == 4 then
                    -- neutral - yellow
                    repBar:SetStatusBarColor(1, 0.82, 0)
                elseif standing == 5 then
                    -- friendly - light green
                    repBar:SetStatusBarColor(0.0, 0.6, 0.1)
                elseif standing == 6 then
                    -- honored - green
                    repBar:SetStatusBarColor(0, 0.7, 0.1)
                elseif standing == 7 then
                    -- revered - dark green
                    repBar:SetStatusBarColor(0, 0.8, 0.1)
                elseif standing == 8 then
                    -- exalted - teal
                    repBar:SetStatusBarColor(0, 0.8, 0.5)
                end

                -- update the text if it exists and should be shown
                if repBar.text and repBar.showText then
                    local standingText = getglobal("FACTION_STANDING_LABEL"..standing)
                    repBar.text:SetText(name .. " - " .. standingText .. " - " .. (value-min) .. "/" .. (max-min))
                    repBar.text:Show()
                end
            else
                repBar:Hide()
                if repBar.text then
                    repBar.text:Hide()
                end
            end
        end

        xpBar:RegisterEvent("PLAYER_XP_UPDATE")
        xpBar:RegisterEvent("PLAYER_LEVEL_UP")
        xpBar:RegisterEvent("UPDATE_FACTION")
        xpBar:RegisterEvent("PLAYER_ENTERING_WORLD")
        xpBar:RegisterEvent("UPDATE_EXHAUSTION")

        xpBar:SetScript("OnEvent", function()
            if event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_ENTERING_WORLD" or event == "UPDATE_EXHAUSTION" then
                UpdateXPBar()
            end

            if event == "UPDATE_FACTION" or event == "PLAYER_ENTERING_WORLD" then
                UpdateRepBar()
            end
        end)

        UpdateXPBar()
        UpdateRepBar()
    end

    -- expose
    DFRL.xpBar = xpBar
    DFRL.repBar = repBar

    -- callbacks
    local callbacks = {}

    callbacks.xpBarWidth = function(value)
        xpBar:SetWidth(value)
        xpBar.leftBorder:SetWidth(value / 2 + 3)
        xpBar.rightBorder:SetWidth(value / 2 + 3)
    end

    callbacks.xpBarHeight = function(value)
        xpBar:SetHeight(value)
        xpBar.leftBorder:SetHeight(value + 9)
        xpBar.rightBorder:SetHeight(value + 9)
    end

    callbacks.repBarWidth = function(value)
        repBar:SetWidth(value)
        repBar.leftBorder:SetWidth(value / 2 + 3)
        repBar.rightBorder:SetWidth(value / 2 + 3)
    end

    callbacks.repBarHeight = function(value)
        repBar:SetHeight(value)
        repBar.leftBorder:SetHeight(value + 9)
        repBar.rightBorder:SetHeight(value + 9)
    end

    callbacks.showXpText = function(value)
        if not xpBar.text and value then
            xpBar.text = xpBar:CreateFontString(nil, "OVERLAY")
            xpBar.text:SetPoint("CENTER", xpBar, "CENTER", 0, 1)
            xpBar.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        end

        if xpBar.text then
            if value then
                local currXP = UnitXP("player")
                local maxXP = UnitXPMax("player")
                local restXP = GetXPExhaustion() or 0
                local restPercent = 0
                if maxXP > 0 then
                    restPercent = math.floor((restXP / maxXP) * 100)
                end
                xpBar.text:SetText(currXP .. " / " .. maxXP .. " (" .. restPercent .. "% rested)")
                xpBar.text:Show()
            else
                xpBar.text:Hide()
            end
        end
    end

    callbacks.showRepText = function(value)
        if not repBar.text and value then
            repBar.text = repBar:CreateFontString(nil, "OVERLAY")
            repBar.text:SetPoint("CENTER", repBar, "CENTER", 0, 1)
            repBar.text:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        end

        -- Store the setting for use in UpdateRepBar
        repBar.showText = value

        if repBar.text then
            if value then
                local name, standing, min, max, value = GetWatchedFactionInfo()
                if name then
                    local standingText = getglobal("FACTION_STANDING_LABEL"..standing)
                    repBar.text:SetText(name .. " - " .. standingText .. " - " .. (value-min) .. "/" .. (max-min))
                    repBar.text:Show()
                else
                    repBar.text:Hide()
                end
            else
                repBar.text:Hide()
            end
        end
    end

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        if xpBar.leftBorder then
            xpBar.leftBorder:SetVertexColor(color[1], color[2], color[3])
        end
        if xpBar.rightBorder then
            xpBar.rightBorder:SetVertexColor(color[1], color[2], color[3])
        end

        if repBar.leftBorder then
            repBar.leftBorder:SetVertexColor(color[1], color[2], color[3])
        end
        if repBar.rightBorder then
            repBar.rightBorder:SetVertexColor(color[1], color[2], color[3])
        end
    end

    callbacks.autoTrack = function(value)
        if not repBar.trackingFrame then
            repBar.trackingFrame = CreateFrame("Frame")
            repBar.trackingFrame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
            repBar.trackingFrame:SetScript("OnEvent", function()
                if not repBar.autoTrack then return end

                d:DebugPrint("Faction message: " .. tostring(arg1))

                -- extract faction name
                local startPos, endPos = string.find(arg1, "Your ", 1, true)
                if startPos then
                    local restStart = string.find(arg1, " reputation has increased", endPos + 1, true)
                    if restStart then
                        local factionName = string.sub(arg1, endPos + 1, restStart - 1)
                        d:DebugPrint("Found faction: " .. factionName)

                        -- find the faction
                        for i=1, GetNumFactions() do
                            local name = GetFactionInfo(i)
                            if name == factionName then
                                d:DebugPrint("Setting watched faction to: " .. name)
                                SetWatchedFactionIndex(i)
                                -- update
                                xpBar:GetScript("OnEvent")("UPDATE_FACTION")
                                break
                            end
                        end
                    end
                end
            end)
        end

        -- store
        repBar.autoTrack = value
    end

    -- execute module callbacks
    DFRL:RegisterCallback("xprep", callbacks)
end)
