DFRL:SetDefaults("smallframes", {
    enabled = {true},
    hidden = {false},

    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for the pet and target of target frame"},
    textShow = {false, 2, "checkbox", "text", "Show pet health and mana text"},
    noPercent = {false, 3, "checkbox", "text", "Hide pet health and mana percent text"},
    colorReaction = {true, 4, "checkbox", "bar color", "Color health bar based on target reaction"},

})

DFRL:RegisterModule("smallframes", 1, function()
    d:DebugPrint("BOOTING")

    -- petframe
    PetFrameHealthBar:SetScript("OnEnter", nil)
    PetFrameHealthBar:SetScript("OnLeave", nil)
    PetFrameManaBar:SetScript("OnEnter", nil)
    PetFrameManaBar:SetScript("OnLeave", nil)

    local healthPercentText = PetFrameHealthBar:CreateFontString(nil, "OVERLAY")
    healthPercentText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    healthPercentText:SetPoint("LEFT", 5, 0)
    healthPercentText:SetTextColor(1, 1, 1)

    local healthValueText = PetFrameHealthBar:CreateFontString(nil, "OVERLAY")
    healthValueText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    healthValueText:SetPoint("RIGHT", -5, 0)
    healthValueText:SetTextColor(1, 1, 1)

    local manaPercentText = PetFrameManaBar:CreateFontString(nil, "OVERLAY")
    manaPercentText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    manaPercentText:SetPoint("LEFT", 5, 0)
    manaPercentText:SetTextColor(1, 1, 1)

    local manaValueText = PetFrameManaBar:CreateFontString(nil, "OVERLAY")
    manaValueText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    manaValueText:SetPoint("RIGHT", -5, 0)
    manaValueText:SetTextColor(1, 1, 1)

    local function UpdatePetTexts()
        if not UnitExists("pet") then return end

        local health = UnitHealth("pet")
        local maxHealth = UnitHealthMax("pet")
        local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0

        healthPercentText:SetText(healthPercent .. "%")
        healthValueText:SetText(health)

        local mana = UnitMana("pet")
        local maxMana = UnitManaMax("pet")

        if maxMana > 0 then
            local manaPercent = math.floor((mana / maxMana) * 100)
            manaPercentText:SetText(manaPercent .. "%")
            manaValueText:SetText(mana)
        else
            manaPercentText:SetText("")
            manaValueText:SetText("")
        end
    end

    local new_PetFrame_Update = _G.PetFrame_Update
    _G.PetFrame_Update = function()
        new_PetFrame_Update()
        PetFrameTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\pet")
        PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health")

        PetFrameTexture:SetDrawLayer("BACKGROUND")
        PetFrame:ClearAllPoints()
        PetFrame:SetPoint("BOTTOM", PlayerFrame, -10, -30)

        PetFrameHealthBar:SetHeight(13)
        PetFrameHealthBar:ClearAllPoints()
        PetFrameHealthBar:SetPoint("CENTER", PetFrame, "CENTER", 15, 3)

        local class = UnitClass("player")
        if class == "Hunter" then
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus")
        else
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana")
        end

        PetFrameManaBar:ClearAllPoints()
        PetFrameManaBar:SetPoint("CENTER", PetFrame, "CENTER", 15, -7)

        PetName:ClearAllPoints()
        PetName:SetPoint("CENTER", PetFrame, "CENTER", 5, 16)

        UpdatePetTexts()
    end

    -- targetoftarget frame
    TargetofTargetTexture:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\pet")
    TargetofTargetHealthBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health.tga")

    hooksecurefunc("TargetofTarget_Update", function()
        local powerType = UnitPowerType("targettarget")
        local tex

        if powerType == 0 then
            tex = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana"
        elseif powerType == 1 then
            tex = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage"
        elseif powerType == 2 then
            tex = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus"
        end

        if tex then
            TargetofTargetManaBar:SetStatusBarTexture(tex)
        end

        if UnitExists("targettarget") then
            TargetofTargetFrame.name:SetText(AbbreviateName(UnitName("targettarget")))
        end
    end)

    TargetofTargetTexture:SetTexCoord(0, 1, 0, 1)
    TargetofTargetTexture:SetPoint("TOPLEFT", -0, 0)
    TargetofTargetTexture:SetPoint("BOTTOMRIGHT", 20, -15)

    TargetofTargetFrame:ClearAllPoints()
    TargetofTargetFrame:SetPoint("TOPLEFT", TargetFrame, "BOTTOM", 0, 20)

    TargetofTargetPortrait:SetHeight(32)
    TargetofTargetPortrait:SetWidth(32)

    TargetofTargetFrameDebuff1:ClearAllPoints()
    TargetofTargetFrameDebuff1:SetPoint("TOPLEFT", TargetofTargetFrame, "BOTTOMLEFT", 40, 5)

    TargetofTargetBackground:ClearAllPoints()
    TargetofTargetBackground:SetWidth(60)
    TargetofTargetBackground:SetPoint("LEFT", TargetofTargetFrame, "LEFT", 40, -2)

    TargetofTargetHealthBar:SetWidth(60)
    TargetofTargetHealthBar:SetHeight(11)
    TargetofTargetHealthBar:ClearAllPoints()
    TargetofTargetHealthBar:SetPoint("LEFT", TargetofTargetFrame, "LEFT", 40, 1)

    TargetofTargetManaBar:SetWidth(60)
    TargetofTargetManaBar:SetHeight(5)
    TargetofTargetManaBar:ClearAllPoints()
    TargetofTargetManaBar:SetPoint("TOPLEFT", TargetofTargetHealthBar, "BOTTOMLEFT", 0, 0)

    TargetofTargetFrame.name:SetPoint("TOPLEFT", TargetofTargetFrame, "TOPLEFT", 40, 25)

    -- party frames
    local partyHealthPercentTexts = {}
    local partyCustomBorders = {}

    PartyMemberFrame1:ClearAllPoints()
    PartyMemberFrame1:SetPoint("LEFT", UIParent, "LEFT", 10, 220)

    for i = 1, 4 do
        local frame = _G["PartyMemberFrame" .. i]
        local name = _G["PartyMemberFrame" .. i .. "Name"]
        local healthBar = _G["PartyMemberFrame" .. i .. "HealthBar"]
        local manaBar = _G["PartyMemberFrame" .. i .. "ManaBar"]

        local borderTexture = _G["PartyMemberFrame" .. i .. "Texture"]
        if borderTexture then
            borderTexture:SetAlpha(0)
        end

        local partyHealthText = healthBar:CreateFontString(nil, "OVERLAY")
        partyHealthText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        partyHealthText:SetPoint("CENTER", 0, 0)
        partyHealthText:SetTextColor(1, 1, 1)
        partyHealthPercentTexts[i] = partyHealthText

        local customBorder = frame:CreateTexture(nil, "OVERLAY")
        customBorder:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\pet")
        customBorder:SetDrawLayer("BORDER", 1)
        customBorder:SetPoint("CENTER", frame, 0, 0)
        customBorder:SetWidth(128)
        customBorder:SetHeight(64)
        partyCustomBorders[i] = customBorder

        local portrait = _G["PartyMemberFrame" .. i .. "Portrait"]
        if portrait then
            portrait:SetHeight(35)
            portrait:SetWidth(35)
            portrait:SetDrawLayer("BACKGROUND",1)
            portrait:ClearAllPoints()
            portrait:SetPoint("CENTER", frame, -40, 8.25)
        end

        if name and frame then
            name:ClearAllPoints()
            name:SetPoint("CENTER", frame, "CENTER", 6, 23)
            name:SetDrawLayer("BORDER", 2)
        end

        if healthBar and manaBar and frame then
            healthBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health")
            manaBar:SetStatusBarTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\unitframes\\UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health-Status.tga")

            healthBar:SetHeight(11)
            healthBar:ClearAllPoints()
            healthBar:SetPoint("CENTER", frame, "CENTER", 15, 10)

            manaBar:SetHeight(5)
            manaBar:ClearAllPoints()
            manaBar:SetPoint("CENTER", frame, "CENTER", 15, 0.5)
        end
    end

    local function UpdatePartyTexts()
        for i = 1, 4 do
            if UnitExists("party" .. i) then
                local health = UnitHealth("party" .. i)
                local maxHealth = UnitHealthMax("party" .. i)
                local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0

                partyHealthPercentTexts[i]:SetText(healthPercent .. "%")
            else
                partyHealthPercentTexts[i]:SetText("")
            end
        end
    end

    local function IsTargetOfTargetTaggedByOther()
        if not UnitExists("targettarget") or UnitIsPlayer("targettarget") then
            return false
        end
        return UnitIsTapped("targettarget") and not UnitIsTappedByPlayer("targettarget")
    end


    -- callbacks
    local callbacks = {}

    callbacks.textShow = function(value)
        if value then
            healthPercentText:Show()
            healthValueText:Show()
            manaPercentText:Show()
            manaValueText:Show()

            for i = 1, 4 do
                partyHealthPercentTexts[i]:Show()
            end
        else
            healthPercentText:Hide()
            healthValueText:Hide()
            manaPercentText:Hide()
            manaValueText:Hide()

            for i = 1, 4 do
                partyHealthPercentTexts[i]:Hide()
            end
        end
    end

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        PetFrameTexture:SetVertexColor(color[1], color[2], color[3])
        TargetofTargetTexture:SetVertexColor(color[1], color[2], color[3])

        for i = 1, 4 do
            partyCustomBorders[i]:SetVertexColor(color[1], color[2], color[3])
        end
    end

    callbacks.noPercent = function(value)
        local function UpdatePetTextsWithFormat()
            if not UnitExists("pet") then return end

            local health = UnitHealth("pet")
            local maxHealth = UnitHealthMax("pet")
            local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0

            local mana = UnitMana("pet")
            local maxMana = UnitManaMax("pet")
            local manaPercent = maxMana > 0 and math.floor((mana / maxMana) * 100) or 0

            if value then
                healthPercentText:SetText("")
                healthValueText:SetText(health)
                healthValueText:ClearAllPoints()
                healthValueText:SetPoint("CENTER", PetFrameHealthBar, "CENTER", 0, 0)

                manaPercentText:SetText("")
                manaValueText:SetText(mana)
                manaValueText:ClearAllPoints()
                manaValueText:SetPoint("CENTER", PetFrameManaBar, "CENTER", 0, 0)
            else
                healthPercentText:SetText(healthPercent .. "%")
                healthValueText:SetText(health)
                healthValueText:ClearAllPoints()
                healthValueText:SetPoint("RIGHT", PetFrameHealthBar, "RIGHT", -5, 0)

                manaPercentText:SetText(manaPercent .. "%")
                manaValueText:SetText(mana)
                manaValueText:ClearAllPoints()
                manaValueText:SetPoint("RIGHT", PetFrameManaBar, "RIGHT", -5, 0)
            end
        end

        UpdatePetTexts = UpdatePetTextsWithFormat

        -- updat
        UpdatePetTextsWithFormat()
    end

    callbacks.colorReaction = function(value)
        TargetofTargetHealthBar.colorReaction = value

        if UnitExists("targettarget") then
            if IsTargetOfTargetTaggedByOther() then
                TargetofTargetHealthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                return
            end

            local reaction = UnitReaction("player", "targettarget")

            if value and reaction then
                if reaction <= 2 then
                    -- hostile
                    TargetofTargetHealthBar:SetStatusBarColor(1, 0, 0)
                elseif reaction == 3 or reaction == 4 then
                    -- neutral
                    TargetofTargetHealthBar:SetStatusBarColor(1, 1, 0)
                else
                    -- friendly
                    TargetofTargetHealthBar:SetStatusBarColor(0, 1, 0)
                end
            else
                -- reset
                TargetofTargetHealthBar:SetStatusBarColor(0, 1, 0)
            end
        end
    end

    HookScript(_G["TargetofTargetHealthBar"], "OnValueChanged", function()
        if IsTargetOfTargetTaggedByOther() then
            _G["TargetofTargetHealthBar"]:SetStatusBarColor(0.5, 0.5, 0.5)
            return
        end

        if _G["TargetofTargetHealthBar"].colorReaction then
            local reaction = UnitReaction("player", "targettarget")
            if reaction then
                if reaction <= 2 then
                    _G["TargetofTargetHealthBar"]:SetStatusBarColor(1, 0, 0)
                elseif reaction <= 4 then
                    _G["TargetofTargetHealthBar"]:SetStatusBarColor(1, 1, 0)
                else
                    _G["TargetofTargetHealthBar"]:SetStatusBarColor(0, 1, 0)
                end
            end
        end
    end)

    --  event handler
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("UNIT_MANA")
    f:RegisterEvent("UNIT_ENERGY")
    f:RegisterEvent("UNIT_RAGE")
    f:RegisterEvent("UNIT_FOCUS")
    f:RegisterEvent("UNIT_PET")
    f:RegisterEvent("PARTY_MEMBERS_CHANGED")
    f:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" or
            (event == "UNIT_HEALTH" and arg1 == "pet") or
            (event == "UNIT_MANA" and arg1 == "pet") or
            (event == "UNIT_ENERGY" and arg1 == "pet") or
            (event == "UNIT_RAGE" and arg1 == "pet") or
            (event == "UNIT_FOCUS" and arg1 == "pet") then
            UpdatePetTexts()
        end

        if event == "PLAYER_ENTERING_WORLD" or event == "PARTY_MEMBERS_CHANGED" or
            (event == "UNIT_HEALTH" and string.find(arg1, "party")) then
            UpdatePartyTexts()
        end
    end)

    -- init
    UpdatePetTexts()
    UpdatePartyTexts()

    -- execute callbacks
    DFRL:RegisterCallback("smallframes", callbacks)
end)
