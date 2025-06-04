DFRL:SetDefaults("targetframe", {
    enabled = {true},
    hidden = {false},

    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for the target frame"},
    textShow = {true, 2, "checkbox", "text", "Show health and mana text"},
    noPercent = {true, 3, "checkbox", "text", "Show only current values without percentages"},
    textColoring = {false, 4, "checkbox", "text", "Color text based on health/mana percentage"},
    colorReaction = {true, 5, "checkbox", "bar color", "Color health bar based on target reaction"},

})

DFRL:RegisterModule("targetframe", 1, function()
    d:DebugPrint("BOOTING")

    -- blizz
    do
        TargetFrameHealthBar:SetScript("OnEnter", nil)
        TargetFrameHealthBar:SetScript("OnLeave", nil)
    end

    TargetFrameHealthBar:SetPoint("TOPRIGHT", -100, -29)
    TargetFrameHealthBar:SetWidth(130)
    TargetFrameHealthBar:SetHeight(31)

    TargetFrameManaBar:SetPoint("TOPRIGHT", -95, -53)
    TargetFrameManaBar:SetWidth(132)

    TargetFrameBackground:SetWidth(256)
    TargetFrameBackground:SetHeight(128)
    TargetFrameBackground:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", 0, 0)

    TargetLevelText:ClearAllPoints()
    TargetLevelText:SetPoint("CENTER", TargetFrame, "CENTER", -102, 25)

    TargetFrame.name:ClearAllPoints()
    TargetFrame.name:SetPoint("CENTER", TargetFrame, "CENTER", -40, 25)
    TargetFrame.name:SetJustifyH("RIGHT")

    TargetFrame.portrait:SetHeight(61)
    TargetFrame.portrait:SetWidth(61)

    -- text elements
    local healthPercentText = TargetFrameHealthBar:CreateFontString(nil, "OVERLAY")
    healthPercentText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    healthPercentText:SetPoint("LEFT", 5, 0)
    healthPercentText:SetTextColor(1, 1, 1)

    local healthValueText = TargetFrameHealthBar:CreateFontString(nil, "OVERLAY")
    healthValueText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    healthValueText:SetPoint("RIGHT", -5, 0)
    healthValueText:SetTextColor(1, 1, 1)

    local manaPercentText = TargetFrameManaBar:CreateFontString(nil, "OVERLAY")
    manaPercentText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    manaPercentText:SetPoint("LEFT", 5, 0)
    manaPercentText:SetTextColor(1, 1, 1)

    local manaValueText = TargetFrameManaBar:CreateFontString(nil, "OVERLAY")
    manaValueText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    manaValueText:SetPoint("RIGHT", -12, 0)
    manaValueText:SetTextColor(1, 1, 1)

    -- elite
    function _G.TargetFrame_CheckClassification()
        local classification = UnitClassification("target")
        if ( classification == "worldboss" ) then
            TargetFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrame-Boss.blp")
        elseif ( classification == "rareelite"  ) then
            TargetFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrame-RareElite.blp")
        elseif ( classification == "elite"  ) then
            TargetFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrame-Elite.blp")
        elseif ( classification == "rare"  ) then
            TargetFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrame-Rare.blp")
        else
            TargetFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrameDF1.blp")
        end
    end

    local function UpdateTexts()
        if not UnitExists("target") then return end

        local health = UnitHealth("target")
        local maxHealth = UnitHealthMax("target")
        local healthPercent = maxHealth > 0 and health / maxHealth or 0
        local healthPercentInt = math.floor(healthPercent * 100)

        local mana = UnitMana("target")
        local maxMana = UnitManaMax("target")
        local manaPercent = maxMana > 0 and mana / maxMana or 0
        local manaPercentInt = math.floor(manaPercent * 100)

        local noPercentEnabled = DFRL:GetConfig("targetframe", "noPercent")
        local coloringEnabled = DFRL:GetConfig("targetframe", "textColoring")

        local isDead = UnitIsDead("target")

        if noPercentEnabled then
            healthPercentText:SetText("")
            if isDead then
                healthValueText:SetText("")
            else
                healthValueText:SetText(health)
            end
            healthValueText:ClearAllPoints()
            healthValueText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 3, 0)

            manaPercentText:SetText("")
            if maxMana > 0 then
                manaValueText:SetText(mana)
                manaValueText:ClearAllPoints()
                manaValueText:SetPoint("CENTER", TargetFrameManaBar, "CENTER", -3, 0)
            else
                manaValueText:SetText("")
            end
        else
            if isDead then
                healthPercentText:SetText("")
                healthValueText:SetText("")
            else
                healthPercentText:SetText(healthPercentInt .. "%")
                healthValueText:SetText(health)
            end
            healthValueText:ClearAllPoints()
            healthValueText:SetPoint("RIGHT", TargetFrameHealthBar, "RIGHT", -5, 0)

            if maxMana > 0 then
                manaPercentText:SetText(manaPercentInt .. "%")
                manaValueText:SetText(mana)
                manaValueText:ClearAllPoints()
                manaValueText:SetPoint("RIGHT", TargetFrameManaBar, "RIGHT", -12, 0)
            else
                manaPercentText:SetText("")
                manaValueText:SetText("")
            end
        end

        if coloringEnabled then
            local r = 1
            local g = healthPercent
            local b = healthPercent
            healthPercentText:SetTextColor(r, g, b)
            healthValueText:SetTextColor(r, g, b)

            if maxMana > 0 then
                r = 1
                g = manaPercent
                b = manaPercent
                manaPercentText:SetTextColor(r, g, b)
                manaValueText:SetTextColor(r, g, b)
            end
        else
            healthPercentText:SetTextColor(1, 1, 1)
            healthValueText:SetTextColor(1, 1, 1)
            manaPercentText:SetTextColor(1, 1, 1)
            manaValueText:SetTextColor(1, 1, 1)
        end
    end

    local function IsTargetTaggedByOther()
        if not UnitExists("target") or UnitIsPlayer("target") then
            return false
        end

        return UnitIsTapped("target") and not UnitIsTappedByPlayer("target")
    end

    -- callbacks
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

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        TargetFrameTexture:SetVertexColor(color[1], color[2], color[3])
        TargetFrameBackground:SetVertexColor(color[1], color[2], color[3])
    end

    callbacks.noPercent = function()
        UpdateTexts()
    end

    callbacks.textColoring = function()
        UpdateTexts()
    end

    callbacks.colorReaction = function(value)
        TargetFrameHealthBar.colorReaction = value

        if UnitExists("target") then
            -- Check for tagged mobs first
            if IsTargetTaggedByOther() then
                TargetFrameHealthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                return
            end

            local reaction = UnitReaction("player", "target")
            if value and reaction then
                if reaction <= 2 then
                    -- hostile
                    TargetFrameHealthBar:SetStatusBarColor(1, 0, 0)
                elseif reaction == 3 or reaction == 4 then
                    -- neutral
                    TargetFrameHealthBar:SetStatusBarColor(1, 1, 0)
                else
                    -- friendly
                    TargetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                end
            else
                -- reset
                TargetFrameHealthBar:SetStatusBarColor(0, 1, 0)
            end
        end
    end

    HookScript(_G["TargetFrameHealthBar"], "OnValueChanged", function()
        if IsTargetTaggedByOther() then
            _G["TargetFrameHealthBar"]:SetStatusBarColor(0.5, 0.5, 0.5)
            return
        end

        if _G["TargetFrameHealthBar"].colorReaction then
            local reaction = UnitReaction("player", "target")
            if reaction then
                if reaction <= 2 then
                    _G["TargetFrameHealthBar"]:SetStatusBarColor(1, 0, 0)
                elseif reaction <= 4 then
                    _G["TargetFrameHealthBar"]:SetStatusBarColor(1, 1, 0)
                else
                    _G["TargetFrameHealthBar"]:SetStatusBarColor(0, 1, 0)
                end
            end
        end
    end)

    -- event handler
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("UNIT_MANA")
    f:RegisterEvent("UNIT_ENERGY")
    f:RegisterEvent("UNIT_RAGE")
    f:RegisterEvent("UNIT_FOCUS")
    f:SetScript("OnEvent", function()
        if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
            TargetFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrameDF1.blp")
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\healthDF2.tga")
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status.blp")
            TargetFrameBackground:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-TargetingFrameDF1-Background.blp")
            TargetFrameNameBackground:SetTexture(nil)

            _G.TargetFrame_CheckClassification()
            UpdateTexts()

            if IsTargetTaggedByOther() then
                TargetFrameHealthBar:SetStatusBarColor(0.5, 0.5, 0.5)
            elseif TargetFrameHealthBar.colorReaction then
                local reaction = UnitReaction("player", "target")
                if reaction then
                    if reaction <= 2 then
                        -- hostile - red
                        TargetFrameHealthBar:SetStatusBarColor(1, 0, 0)
                    elseif reaction == 3 or reaction == 4 then
                        -- neutral - yellow
                        TargetFrameHealthBar:SetStatusBarColor(1, 1, 0)
                    else
                        -- friendly - green
                        TargetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                    end
                else
                    -- reset to default color
                    TargetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                end
            end
        elseif (event == "UNIT_HEALTH" and arg1 == "target") or
            (event == "UNIT_MANA" and arg1 == "target") or
            (event == "UNIT_ENERGY" and arg1 == "target") or
            (event == "UNIT_RAGE" and arg1 == "target") or
            (event == "UNIT_FOCUS" and arg1 == "target") then
            UpdateTexts()
        end
    end)

    -- execute callbacks
    DFRL:RegisterCallback("targetframe", callbacks)
end)
