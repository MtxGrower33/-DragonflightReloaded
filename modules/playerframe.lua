---@diagnostic disable: deprecated
DFRL:SetDefaults("playerframe", {
    enabled = {true},
    hidden = {false},

    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for the player frame"},
    textShow = {true, 2, "checkbox", "text", "Show health and mana text"},
    noPercent = {true, 3, "checkbox", "text", "Show only current values without percentages"},
    textColoring = {false, 4, "checkbox", "text", "Color text based on health/mana percentage from white to red"},
    classPortrait = {false, 5, "checkbox", "tweaks", "Activate 2D class portrait icons"},
    frameHide = {false, 6, "checkbox", "tweaks", "Hide frame at full HP when not in combat"},
})

DFRL:RegisterModule("playerframe", 2, function()
    d:DebugPrint("BOOTING")

    PlayerFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrameDF.blp")
    PlayerStatusTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-Player-Status.blp")
    PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\healthDF2.tga")
    PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Status.tga")
    PlayerFrameBackground:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrameDF-Background.blp")

    PlayerFrameHealthBar:SetWidth(130)
    PlayerFrameHealthBar:SetHeight(30)
    PlayerFrameHealthBar:SetPoint("TOPLEFT", 100, -29)
    PlayerFrameManaBar:SetWidth(125)
    PlayerFrameManaBar:SetPoint("TOPLEFT", 103, -53)
    PlayerFrameBackground:SetWidth(256)
    PlayerFrameBackground:SetHeight(128)
    PlayerFrameBackground:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 0, 0)

    PlayerFrame.name:ClearAllPoints()
    PlayerFrame.name:SetPoint("CENTER", PlayerFrame, "CENTER", 22, 25)

    PlayerFrame.portrait:SetHeight(62)
    PlayerFrame.portrait:SetWidth(62)

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint("CENTER", PlayerFrame, "CENTER", 102, 25)

    PlayerFrameHealthBarText:SetText("")
    PlayerFrameHealthBarText:ClearAllPoints()

    PlayerFrameManaBarText:SetText("")
    PlayerFrameManaBarText:ClearAllPoints()

    -- text elements
    local healthPercentText = PlayerFrameHealthBar:CreateFontString(nil, "OVERLAY")
    healthPercentText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    healthPercentText:SetPoint("LEFT", 5, 0)
    healthPercentText:SetTextColor(1, 1, 1)

    local healthValueText = PlayerFrameHealthBar:CreateFontString(nil, "OVERLAY")
    healthValueText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    healthValueText:SetPoint("RIGHT", -5, 0)
    healthValueText:SetTextColor(1, 1, 1)

    local manaPercentText = PlayerFrameManaBar:CreateFontString(nil, "OVERLAY")
    manaPercentText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    manaPercentText:SetPoint("LEFT", 5, 0)
    manaPercentText:SetTextColor(1, 1, 1)

    local manaValueText = PlayerFrameManaBar:CreateFontString(nil, "OVERLAY")
    manaValueText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    manaValueText:SetPoint("RIGHT", -5, 0)
    manaValueText:SetTextColor(1, 1, 1)


    -- combat indicator
    do
        local combatOverlay = CreateFrame("Frame", nil, PlayerFrame)
        combatOverlay:SetAllPoints(PlayerFrame)
        combatOverlay:SetFrameStrata("HIGH")

        local texture = combatOverlay:CreateTexture(nil, "OVERLAY")
        texture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-Player-Status.blp")
        texture:SetPoint("CENTER", PlayerFrame, "CENTER", 45, -21)
        texture:SetVertexColor(1, 0, 0)
        texture:SetBlendMode("ADD")
        texture:SetAlpha(0)

        local timeSinceLastUpdate = 0
        local updateInterval = 1.0
        local fadeDirection = 1
        local currentAlpha = 0
        local fadeSpeed = 2.0

        combatOverlay:SetScript("OnUpdate", function()
            timeSinceLastUpdate = timeSinceLastUpdate + arg1

            if UnitAffectingCombat("player") then
                if timeSinceLastUpdate >= updateInterval then
                    fadeDirection = -fadeDirection
                    timeSinceLastUpdate = 0
                end

                local deltaAlpha = fadeSpeed * arg1 * fadeDirection
                currentAlpha = currentAlpha + deltaAlpha

                if currentAlpha >= 1.0 then
                    currentAlpha = 1.0
                    fadeDirection = -1
                elseif currentAlpha <= 0.2 then
                    currentAlpha = 0.2
                    fadeDirection = 1
                end

                texture:SetAlpha(currentAlpha)
            else
                if currentAlpha > 0 then
                    currentAlpha = currentAlpha - (fadeSpeed * arg1 * 2)
                    if currentAlpha < 0 then
                        currentAlpha = 0
                    end
                    texture:SetAlpha(currentAlpha)
                end
            end
        end)

        local eventFrame = CreateFrame("Frame")
        eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        eventFrame:SetScript("OnEvent", function()
            if event == "PLAYER_REGEN_DISABLED" then
                currentAlpha = 0.2
                fadeDirection = 1
                timeSinceLastUpdate = 0
            elseif event == "PLAYER_REGEN_ENABLED" then
                fadeDirection = -1
            end
        end)
    end

    -- resting animation
    do
        PlayerRestIcon:SetTexture("")
        PlayerRestIcon:ClearAllPoints()
        PlayerRestIcon:SetPoint("TOPLEFT", PlayerFrame, -3000, 0)

        local restingAnimation = CreateFrame("Frame", "restingAnimation", UIParent)
        restingAnimation:SetPoint("CENTER", PlayerFrame, "CENTER", -20, 30)
        restingAnimation:SetWidth(24)
        restingAnimation:SetHeight(24)

        local texture = restingAnimation:CreateTexture(nil, "OVERLAY")
        texture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UIUnitFrameRestingFlipbook")
        texture:SetAllPoints(restingAnimation)

        local texCoords = {
            {0/512, 60/512, 0/512, 60/512}, {60/512, 120/512, 0/512, 60/512}, {120/512, 180/512, 0/512, 60/512}, {180/512, 240/512, 0/512, 60/512}, {240/512, 300/512, 0/512, 60/512}, {300/512, 360/512, 0/512, 60/512},
            {0/512, 60/512, 60/512,120/512}, {60/512, 120/512, 60/512, 120/512}, {120/512, 180/512, 60/512, 120/512}, {180/512, 240/512, 60/512, 120/512}, {240/512, 300/512, 60/512, 120/512}, {300/512, 360/512, 60/512, 120/512},
            {0/512, 60/512, 120/512, 180/512}, {60/512, 120/512, 120/512, 180/512}, {120/512, 180/512, 120/512, 180/512}, {180/512, 240/512, 120/512, 180/512}, {240/512, 300/512, 120/512, 180/512}, {300/512, 360/512, 120/512, 180/512},
            {0/512, 60/512, 180/512, 240/512}, {60/512, 120/512, 180/512, 240/512}, {120/512, 180/512, 180/512, 240/512}, {180/512, 240/512, 180/512, 240/512}, {240/512, 300/512, 180/512, 240/512}, {300/512, 360/512, 180/512, 240/512},
            {0/512, 60/512, 240/512, 300/512}, {60/512, 120/512, 240/512, 300/512}, {120/512, 180/512, 240/512, 300/512}, {180/512, 240/512, 240/512, 300/512}, {240/512, 300/512, 240/512, 300/512}, {300/512, 360/512, 240/512, 300/512},
            {0/512, 60/512, 300/512, 360/512}, {60/512, 120/512, 300/512, 360/512}, {120/512, 180/512, 300/512, 360/512}, {180/512, 240/512, 300/512, 360/512}, {240/512, 300/512, 300/512, 360/512}, {300/512, 360/512, 300/512, 360/512},
        }

        local currentFrame = 1
        local totalFrames = table.getn(texCoords)
        local timeSinceLastUpdate = 0
        local updateInterval = 0.05

        restingAnimation:Hide()

        restingAnimation:SetScript("OnUpdate", function()
            timeSinceLastUpdate = timeSinceLastUpdate + arg1

            if timeSinceLastUpdate >= updateInterval then
                currentFrame = currentFrame + 1
                if currentFrame > totalFrames then
                    currentFrame = 1
                end

                local coords = texCoords[currentFrame]
                texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])

                timeSinceLastUpdate = 0
            end
        end)

        local function UpdateRestingState()
            if IsResting() then
                restingAnimation:Show()
            else
                restingAnimation:Hide()
            end
        end

        local eventFrame = CreateFrame("Frame")
        eventFrame:RegisterEvent("PLAYER_UPDATE_RESTING")
        eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        eventFrame:SetScript("OnEvent", function()
            UpdateRestingState()
        end)

        -- init
        UpdateRestingState()
    end

    -- cut out effect
    do
        local animationFrames = {}

        local function CreateCutoutEffect(statusBar, barType, unit)
            -- d:DebugPrint("Creating cutout effect - BarType: " .. barType .. ", Unit: " .. (unit or "unknown"))

            local cutoutFrame = CreateFrame("Frame", nil, statusBar)
            cutoutFrame:SetFrameLevel(statusBar:GetFrameLevel() + 1)
            cutoutFrame:SetAllPoints(statusBar)

            local cutoutTexture = cutoutFrame:CreateTexture(nil, "OVERLAY")
            if barType == "health" then
                cutoutTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\healthDF2.tga")
            else
                cutoutTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Status.tga")
            end
            cutoutTexture:SetVertexColor(1, 1, 1, 0.7)
            cutoutTexture:SetAllPoints(cutoutFrame)
            cutoutTexture:Hide()

            cutoutFrame.texture = cutoutTexture
            cutoutFrame.barType = barType
            cutoutFrame.unit = unit
            cutoutFrame.lastValue = nil
            cutoutFrame.lastUnitID = nil
            cutoutFrame.initialized = false

            table.insert(animationFrames, cutoutFrame)
            -- d:DebugPrint("Cutout frame created and added to animationFrames")
            return cutoutFrame
        end

        local function UpdateCutoutEffect(frame, unit)
            local currentValue, maxValue

            if frame.barType == "health" then
                currentValue = UnitHealth(unit)
                maxValue = UnitHealthMax(unit)
            else
                currentValue = UnitMana(unit)
                maxValue = UnitManaMax(unit)
            end

            local unitName = UnitName(unit)
            local unitLevel = UnitLevel(unit)
            local unitID = (unitName or "unknown") .. "_" .. (unitLevel or "0")

            -- d:DebugPrint("UpdateCutoutEffect called - Unit: " .. unit .. ", ID: " .. unitID .. ", BarType: " .. frame.barType .. ", Current: " .. currentValue .. ", Max: " .. maxValue)

            if UnitIsDead(unit) or UnitIsGhost(unit) then
                -- d:DebugPrint("Unit is dead or ghost - setting lastValue and returning")
                frame.lastValue = currentValue
                frame.lastUnitID = unitID
                return
            end

            if frame.lastUnitID ~= unitID then
                -- d:DebugPrint("ACTUAL UNIT CHANGED - Old ID: " .. (frame.lastUnitID or "nil") .. ", New ID: " .. unitID .. ", Setting lastValue to: " .. currentValue)
                frame.lastUnitID = unitID
                frame.lastValue = currentValue
                frame.initialized = true
                return
            end

            if not frame.initialized then
                -- d:DebugPrint("Frame not initialized - setting lastValue to: " .. currentValue)
                frame.lastValue = currentValue
                frame.lastUnitID = unitID
                frame.initialized = true
                return
            end

            -- d:DebugPrint("Comparing values - LastValue: " .. (frame.lastValue or "nil") .. ", CurrentValue: " .. currentValue)

            if frame.lastValue and currentValue < frame.lastValue and maxValue > 0 then
                local statusBar = frame:GetParent()
                local width = statusBar:GetWidth()
                local lostPercent = (frame.lastValue - currentValue) / maxValue
                local cutoutWidth = width * lostPercent

                local remainingPercent = currentValue / maxValue
                local xOffset = width * remainingPercent

                -- d:DebugPrint("TRIGGERING CUTOUT EFFECT - Lost: " .. (frame.lastValue - currentValue) .. ", LostPercent: " .. lostPercent .. ", CutoutWidth: " .. cutoutWidth)

                frame.texture:ClearAllPoints()
                frame.texture:SetPoint("TOPLEFT", statusBar, "TOPLEFT", xOffset, 0)
                frame.texture:SetPoint("BOTTOMLEFT", statusBar, "BOTTOMLEFT", xOffset, 0)
                frame.texture:SetWidth(cutoutWidth)
                frame.texture:Show()

                frame.fadeStart = GetTime()
                frame.fading = true
            end

            frame.lastValue = currentValue
            -- d:DebugPrint("Updated lastValue to: " .. currentValue)
        end

        local function OnUpdate()
            local currentTime = GetTime()

            for i = 1, table.getn(animationFrames) do
                local frame = animationFrames[i]
                if frame.fading and frame.fadeStart then
                    local elapsed = currentTime - frame.fadeStart
                    local duration = 0.5

                    if elapsed >= duration then
                        frame.texture:Hide()
                        frame.fading = false
                    else
                        local alpha = 0.7 * (1 - (elapsed / duration))
                        frame.texture:SetAlpha(alpha)
                    end
                end
            end
        end

        local updateFrame = CreateFrame("Frame")
        updateFrame:SetScript("OnUpdate", function()
            OnUpdate()
        end)

        local function HookUnitFrames()
            local playerHealth = PlayerFrameHealthBar
            if playerHealth then
                local playerHealthCutout = CreateCutoutEffect(playerHealth, "health")
                playerHealth:SetScript("OnValueChanged", function()
                    UpdateCutoutEffect(playerHealthCutout, "player")
                end)
            end

            local playerMana = PlayerFrameManaBar
            if playerMana then
                local playerManaCutout = CreateCutoutEffect(playerMana, "mana")
                playerMana:SetScript("OnValueChanged", function()
                    UpdateCutoutEffect(playerManaCutout, "player")
                end)
            end

            local targetHealth = TargetFrameHealthBar
            if targetHealth then
                local targetHealthCutout = CreateCutoutEffect(targetHealth, "health", "target")
                targetHealth:SetScript("OnValueChanged", function()
                    d:DebugPrint("TARGET HEALTH OnValueChanged triggered")
                    UpdateCutoutEffect(targetHealthCutout, "target")
                end)
            end

            local targetMana = TargetFrameManaBar
            if targetMana then
                local targetManaCutout = CreateCutoutEffect(targetMana, "mana", "target")
                targetMana:SetScript("OnValueChanged", function()
                    d:DebugPrint("TARGET MANA OnValueChanged triggered")
                    UpdateCutoutEffect(targetManaCutout, "target")
                end)
            end

            local totHealth = TargetofTargetHealthBar
            if totHealth then
                local totHealthCutout = CreateCutoutEffect(totHealth, "health", "targettarget")
                totHealth:SetScript("OnValueChanged", function()
                    UpdateCutoutEffect(totHealthCutout, "targettarget")
                end)
            end

            local totMana = TargetofTargetManaBar
            if totMana then
                local totManaCutout = CreateCutoutEffect(totMana, "mana", "targettarget")
                totMana:SetScript("OnValueChanged", function()
                    UpdateCutoutEffect(totManaCutout, "targettarget")
                end)
            end

            -- for i = 1, 4 do
            --     local partyHealthBar = getglobal("PartyMemberFrame"..i.."HealthBar")
            --     if partyHealthBar then
            --         local partyHealthCutout = CreateCutoutEffect(partyHealthBar, "health")
            --         partyHealthBar:SetScript("OnValueChanged", function()
            --             UpdateCutoutEffect(partyHealthCutout, "party"..i)
            --         end)
            --     end

            --     local partyManaBar = getglobal("PartyMemberFrame"..i.."ManaBar")
            --     if partyManaBar then
            --         local partyManaCutout = CreateCutoutEffect(partyManaBar, "mana")
            --         partyManaBar:SetScript("OnValueChanged", function()
            --             UpdateCutoutEffect(partyManaCutout, "party"..i)
            --         end)
            --     end
            -- end
        end

        HookUnitFrames()
    end

    local function UpdateTexts()
        local health = UnitHealth("player")
        local maxHealth = UnitHealthMax("player")
        local healthPercent = math.floor((health / maxHealth) * 100)

        healthPercentText:SetText(healthPercent .. "%")
        healthValueText:SetText(health)

        local mana = UnitMana("player")
        local maxMana = UnitManaMax("player")
        local manaPercent = math.floor((mana / maxMana) * 100)

        manaPercentText:SetText(manaPercent .. "%")
        manaValueText:SetText(mana)
    end

    local callbacks = {}

    callbacks.textShow = function(value)
        if value then
            healthPercentText:Show()
            healthValueText:Show()
            manaPercentText:Show()
            manaValueText:Show()
        else
            healthPercentText:Hide()
            healthValueText:Hide()
            manaPercentText:Hide()
            manaValueText:Hide()
        end
    end

    callbacks.frameHide = function(value)
        if not value then return end

        local hideFrame = CreateFrame("Frame")
        hideFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        hideFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        hideFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        hideFrame:RegisterEvent("UNIT_HEALTH")
        hideFrame:SetScript("OnEvent", function()
            local health = UnitHealth("player")
            local maxHealth = UnitHealthMax("player")
            local inCombat = UnitAffectingCombat("player")

            if health == maxHealth and not inCombat then
                PlayerFrame:Hide()
            else
                PlayerFrame:Show()
            end
        end)
    end

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        PlayerFrameTexture:SetVertexColor(color[1], color[2], color[3])

        PlayerFrameBackground:SetVertexColor(color[1], color[2], color[3])
    end

    callbacks.noPercent = function(value)
        local function UpdateTextsWithFormat()
            local health = UnitHealth("player")
            local maxHealth = UnitHealthMax("player")
            local healthPercent = math.floor((health / maxHealth) * 100)

            local mana = UnitMana("player")
            local maxMana = UnitManaMax("player")
            local manaPercent = math.floor((mana / maxMana) * 100)

            if value then
                healthPercentText:SetText("")
                healthValueText:SetText(health)
                healthValueText:ClearAllPoints()
                healthValueText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)

                manaPercentText:SetText("")
                manaValueText:SetText(mana)
                manaValueText:ClearAllPoints()
                manaValueText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
            else
                healthPercentText:SetText(healthPercent .. "%")
                healthValueText:SetText(health)
                healthValueText:ClearAllPoints()
                healthValueText:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -5, 0)

                manaPercentText:SetText(manaPercent .. "%")
                manaValueText:SetText(mana)
                manaValueText:ClearAllPoints()
                manaValueText:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -5, 0)
            end
        end

        UpdateTexts = UpdateTextsWithFormat

        -- update
        UpdateTextsWithFormat()
    end

    callbacks.textColoring = function(value)
        local function UpdateTextsWithColoring()
            local health = UnitHealth("player")
            local maxHealth = UnitHealthMax("player")
            local healthPercent = health / maxHealth
            local healthPercentInt = math.floor(healthPercent * 100)

            local mana = UnitMana("player")
            local maxMana = UnitManaMax("player")
            local manaPercent = mana / maxMana
            local manaPercentInt = math.floor(manaPercent * 100)

            if DFRL:GetConfig("playerframe", "noPercent") then
                healthPercentText:SetText("")
                healthValueText:SetText(health)
                manaPercentText:SetText("")
                manaValueText:SetText(mana)
            else
                healthPercentText:SetText(healthPercentInt .. "%")
                healthValueText:SetText(health)
                manaPercentText:SetText(manaPercentInt .. "%")
                manaValueText:SetText(mana)
            end

            if value then
                local r = 1
                local g = healthPercent
                local b = healthPercent
                healthPercentText:SetTextColor(r, g, b)
                healthValueText:SetTextColor(r, g, b)

                r = 1
                g = manaPercent
                b = manaPercent
                manaPercentText:SetTextColor(r, g, b)
                manaValueText:SetTextColor(r, g, b)
            else
                healthPercentText:SetTextColor(1, 1, 1)
                healthValueText:SetTextColor(1, 1, 1)
                manaPercentText:SetTextColor(1, 1, 1)
                manaValueText:SetTextColor(1, 1, 1)
            end
        end

        UpdateTexts = UpdateTextsWithColoring

        -- update
        UpdateTextsWithColoring()
    end

    -- shagu code
    callbacks.classPortrait = function(value)
        if value then
            local CLASS_ICON_TCOORDS = {
                ["WARRIOR"] = { 0, 0.25, 0, 0.25 },
                ["MAGE"] = { 0.25, 0.49609375, 0, 0.25 },
                ["ROGUE"] = { 0.49609375, 0.7421875, 0, 0.25 },
                ["DRUID"] = { 0.7421875, 0.98828125, 0, 0.25 },
                ["HUNTER"] = { 0, 0.25, 0.25, 0.5 },
                ["SHAMAN"] = { 0.25, 0.49609375, 0.25, 0.5 },
                ["PRIEST"] = { 0.49609375, 0.7421875, 0.25, 0.5 },
                ["WARLOCK"] = { 0.7421875, 0.98828125, 0.25, 0.5 },
                ["PALADIN"] = { 0, 0.25, 0.5, 0.75 },
                ["DEATHKNIGHT"] = { 0.25, .5, 0.5, .75 },
            }

            DFRL.UpdatePortraits = function(frame)
                if not frame or not frame.unit then return end

                local _, class = UnitClass(frame.unit)
                class = UnitIsPlayer(frame.unit) and class or nil

                if class and frame.portrait then
                    local iconCoords = CLASS_ICON_TCOORDS[class]
                    frame.portrait:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\UI-Classes-Circles.tga")
                    frame.portrait:SetTexCoord(unpack(iconCoords))
                elseif not class and frame.portrait then
                    frame.portrait:SetTexCoord(0, 1, 0, 1)
                end
            end

            -- hook UnitFrame_Update
            hooksecurefunc("UnitFrame_Update", function()
                DFRL.UpdatePortraits(this)
            end, true)

            -- event handler
            DFRL.portraitEvents = CreateFrame("Frame")
            DFRL.portraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
            DFRL.portraitEvents:RegisterEvent("UNIT_PORTRAIT_UPDATE")
            DFRL.portraitEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
            DFRL.portraitEvents:SetScript("OnEvent", function()
                DFRL.UpdatePortraits(PlayerFrame)
                DFRL.UpdatePortraits(TargetFrame)
                DFRL.UpdatePortraits(PartyMemberFrame1)
                DFRL.UpdatePortraits(PartyMemberFrame2)
                DFRL.UpdatePortraits(PartyMemberFrame3)
                DFRL.UpdatePortraits(PartyMemberFrame4)
            end)

            -- init
            DFRL.UpdatePortraits(PlayerFrame)
            DFRL.UpdatePortraits(TargetFrame)
            DFRL.UpdatePortraits(PartyMemberFrame1)
            DFRL.UpdatePortraits(PartyMemberFrame2)
            DFRL.UpdatePortraits(PartyMemberFrame3)
            DFRL.UpdatePortraits(PartyMemberFrame4)

            -- tot update
            DFRL.totPortraitFrame = CreateFrame("Frame", nil, TargetFrame)
            DFRL.totPortraitFrame:SetScript("OnUpdate", function()
                DFRL.UpdatePortraits(TargetofTargetFrame)
            end)
        else
            -- disable class portraits
            -- restore original function by setting hook function to nothing
            DFRL.UpdatePortraits = function() end

            -- unregister events
            if DFRL.portraitEvents then
                DFRL.portraitEvents:UnregisterAllEvents()
                DFRL.portraitEvents:SetScript("OnEvent", nil)
            end

            -- remove target of target updates
            if DFRL.totPortraitFrame then
                DFRL.totPortraitFrame:SetScript("OnUpdate", nil)
            end

            -- reset portraits to default
            local function ResetPortrait(frame)
                if frame and frame.portrait then
                    frame.portrait:SetTexCoord(0, 1, 0, 1)
                    SetPortraitTexture(frame.portrait, frame.unit)
                end
            end

            ResetPortrait(PlayerFrame)
            ResetPortrait(TargetFrame)
            ResetPortrait(PartyMemberFrame1)
            ResetPortrait(PartyMemberFrame2)
            ResetPortrait(PartyMemberFrame3)
            ResetPortrait(PartyMemberFrame4)
            ResetPortrait(TargetofTargetFrame)
        end
    end

    local powerUpdateFrame = CreateFrame("Frame")
    powerUpdateFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    powerUpdateFrame:RegisterEvent("UNIT_MANA")
    powerUpdateFrame:RegisterEvent("UNIT_RAGE")
    powerUpdateFrame:RegisterEvent("UNIT_ENERGY")
    powerUpdateFrame:RegisterEvent("UNIT_FOCUS")
    powerUpdateFrame:RegisterEvent("UNIT_HEALTH")
    powerUpdateFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    powerUpdateFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    powerUpdateFrame:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" or
        event == "PLAYER_REGEN_ENABLED" or
        event == "PLAYER_REGEN_DISABLED" or
        arg1 == "player" then
            UpdateTexts()
        end
    end)

    UpdateTexts()

    -- execute callbacks
    DFRL:RegisterCallback("playerframe", callbacks)
end)
