DFRL:NewDefaults("Mini", {
    enabled = {true},
    miniDarkMode = {0, "slider", {0, 1}, nil, "mini appearance", 1, "Adjust dark mode intensity", nil, nil},
    miniTextShow = {true, "checkbox", nil, nil, "mini text settings", 2, "Show pet/target of target/party health and mana text", nil, nil},
    noPetPercent = {true, "checkbox", nil, nil, "mini text settings", 3, "Hide pet health and mana percent text", nil, nil},
    miniPetTextMaxShow = {true, "checkbox", nil, nil, "mini text settings", 4, "Show pet max health and mana text", nil, nil},
    noTotPercent = {true, "checkbox", nil, nil, "mini text settings", 5, "Hide target of target health and mana percent text", nil, nil},
    miniTotTextMaxShow = {true, "checkbox", nil, nil, "mini text settings", 6, "Show target of target max health and mana text", nil, nil},
    noPartyPercent = {true, "checkbox", nil, nil, "mini text settings", 7, "Hide party health and mana percent text", nil, nil},
    miniPartyTextMaxShow = {true, "checkbox", nil, nil, "mini text settings", 8, "Show party max health and mana text", nil, nil},
    frameFont = {"BigNoodleTitling", "dropdown", {
        "FRIZQT__.TTF",
        "Expressway",
        "Homespun",
        "Hooge",
        "Myriad-Pro",
        "Prototype",
        "PT-Sans-Narrow-Bold",
        "PT-Sans-Narrow-Regular",
        "RobotoMono",
        "BigNoodleTitling",
        "Continuum",
        "DieDieDie"
    }, nil, "mini text settings", 9, "Change the font used for all smaller frames", nil, nil},
    colorReaction = {true, "checkbox", nil, nil, "mini bar color", 10, "Color health bar based on target reaction", nil, nil},
    colorClass = {false, "checkbox", nil, nil, "mini bar color", 11, "Color health bar based on target class", nil, nil},
    partyFrameScale = {1, "slider", {0.7, 1.3}, nil, "mini scaling", 12, "Adjust party frame size", nil, nil},
    petFrameScale = {1, "slider", {0.7, 1.3}, nil, "mini scaling", 13, "Adjust pet frame size", nil, nil},
    totFrameScale = {1, "slider", {0.7, 1.3}, nil, "mini scaling", 14, "Adjust target of target frame size", nil, nil},
})

DFRL:NewMod("Mini", 1, function()
    local configCache = {
        noPetPercent = nil,
        miniPetTextMaxShow = nil,
        noTotPercent = nil,
        miniTotTextMaxShow = nil,
        noPartyPercent = nil,
        miniPartyTextMaxShow = nil,
        lastUpdate = 0
    }

    -- setup
    local Setup = {
        path = "Interface\\AddOns\\-DragonflightReloaded\\media\\tex\\unitframes\\",
        healthPercentText = nil,
        healthValueText = nil,
        manaPercentText = nil,
        manaValueText = nil,
        partyHealthPercentTexts = {},
        partyCustomBorders = {},
        totHealthPercentText = nil,
        totHealthValueText = nil,
        totManaPercentText = nil,
        totManaValueText = nil,
        framesState = {
            colorReaction = false,
            colorClass = false,
        },
        UpdatePetTexts = nil,
    }

    function Setup:KillBlizz()
        PetFrameHealthBar:SetScript("OnEnter", nil)
        PetFrameHealthBar:SetScript("OnLeave", nil)
        PetFrameManaBar:SetScript("OnEnter", nil)
        PetFrameManaBar:SetScript("OnLeave", nil)
        for i = 1, 4 do
            local borderTexture = _G["PartyMemberFrame" .. i .. "Texture"]
            if borderTexture then
                borderTexture:SetAlpha(0)
            end
        end
    end

    function Setup:PetFrameTexts()
        self.healthPercentText = PetFrameHealthBar:CreateFontString(nil, "OVERLAY")
        self.healthPercentText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        self.healthPercentText:SetPoint("LEFT", 5, 0)
        self.healthPercentText:SetTextColor(1, 1, 1)
        self.healthValueText = PetFrameHealthBar:CreateFontString(nil, "OVERLAY")
        self.healthValueText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        self.healthValueText:SetPoint("RIGHT", -5, 0)
        self.healthValueText:SetTextColor(1, 1, 1)
        self.manaPercentText = PetFrameManaBar:CreateFontString(nil, "OVERLAY")
        self.manaPercentText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        self.manaPercentText:SetPoint("LEFT", 5, 0)
        self.manaPercentText:SetTextColor(1, 1, 1)
        self.manaValueText = PetFrameManaBar:CreateFontString(nil, "OVERLAY")
        self.manaValueText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        self.manaValueText:SetPoint("RIGHT", -5, 0)
        self.manaValueText:SetTextColor(1, 1, 1)
    end

    function Setup:PetFrameSetup()
        local new_PetFrame_Update = _G.PetFrame_Update
        _G.PetFrame_Update = function()
            new_PetFrame_Update()
            PetFrameTexture:SetTexture(Setup.path .. "pet")
            PetFrameHealthBar:SetStatusBarTexture(Setup.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health")
            PetFrameTexture:SetDrawLayer("BACKGROUND")
            PetFrame:ClearAllPoints()
            PetFrame:SetPoint("BOTTOM", PlayerFrame, -10, -30)
            PetFrameHealthBar:SetHeight(13)
            PetFrameHealthBar:ClearAllPoints()
            PetFrameHealthBar:SetPoint("CENTER", PetFrame, "CENTER", 15, 3)
            local class = UnitClass("player")
            if class == "Hunter" then
                PetFrameManaBar:SetStatusBarTexture(Setup.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus")
            else
                PetFrameManaBar:SetStatusBarTexture(Setup.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana")
            end
            PetFrameManaBar:ClearAllPoints()
            PetFrameManaBar:SetPoint("CENTER", PetFrame, "CENTER", 15, -7)
            PetName:ClearAllPoints()
            PetName:SetPoint("CENTER", PetFrame, "CENTER", 5, 16)
            Setup.UpdatePetTexts()
        end
    end

    function Setup:TargetOfTargetSetup()
        TargetofTargetTexture:SetTexture(self.path .. "pet")
        TargetofTargetHealthBar:SetStatusBarTexture(self.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health.tga")

        -- mana/rage hook
        hooksecurefunc("TargetofTarget_Update", function()
            local powerType = UnitPowerType("targettarget")
            local tex

            if powerType == 0 then
                tex = Setup.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana"
            elseif powerType == 1 then
                tex = Setup.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage"
            elseif powerType == 2 then
                tex = Setup.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus"
            end

            if tex then
                TargetofTargetManaBar:SetStatusBarTexture(tex)
            end

            if UnitExists("targettarget") then
                TargetofTargetFrame.name:SetText(AbbreviateName(UnitName("targettarget")))
            end
            Setup:UpdateTargetOfTargetTexts()
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
    end

    function Setup:TargetOfTargetTexts()
        self.totHealthPercentText = TargetofTargetHealthBar:CreateFontString(nil, "OVERLAY")
        self.totHealthPercentText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        self.totHealthPercentText:SetPoint("LEFT", 5, 0)
        self.totHealthPercentText:SetTextColor(1, 1, 1)
        self.totHealthValueText = TargetofTargetHealthBar:CreateFontString(nil, "OVERLAY")
        self.totHealthValueText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        self.totHealthValueText:SetPoint("RIGHT", -5, 0)
        self.totHealthValueText:SetTextColor(1, 1, 1)
        self.totManaPercentText = TargetofTargetManaBar:CreateFontString(nil, "OVERLAY")
        self.totManaPercentText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        self.totManaPercentText:SetPoint("LEFT", 5, 0)
        self.totManaPercentText:SetTextColor(1, 1, 1)
        self.totManaValueText = TargetofTargetManaBar:CreateFontString(nil, "OVERLAY")
        self.totManaValueText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        self.totManaValueText:SetPoint("RIGHT", -5, 0)
        self.totManaValueText:SetTextColor(1, 1, 1)
    end

    function Setup:PartyFramesSetup()
        PartyMemberFrame1:ClearAllPoints()
        PartyMemberFrame1:SetPoint("LEFT", UIParent, "LEFT", 10, 220)
        for i = 1, 4 do
            local frame = _G["PartyMemberFrame" .. i]
            local name = _G["PartyMemberFrame" .. i .. "Name"]
            local healthBar = _G["PartyMemberFrame" .. i .. "HealthBar"]
            local manaBar = _G["PartyMemberFrame" .. i .. "ManaBar"]
            local partyHealthText = healthBar:CreateFontString(nil, "OVERLAY")
            partyHealthText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            partyHealthText:SetPoint("CENTER", 0, 0)
            partyHealthText:SetTextColor(1, 1, 1)
            self.partyHealthPercentTexts[i] = partyHealthText

            local customBorder = frame:CreateTexture(nil, "OVERLAY")
            customBorder:SetTexture(self.path .. "pet")
            customBorder:SetDrawLayer("BORDER", 1)
            customBorder:SetPoint("CENTER", frame, 0, 0)
            customBorder:SetWidth(128)
            customBorder:SetHeight(64)
            self.partyCustomBorders[i] = customBorder

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
                healthBar:SetStatusBarTexture(self.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health")
                manaBar:SetStatusBarTexture(self.path .. "UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health-Status.tga")

                local healthBarBG = _G["PartyMemberFrame" .. i .. "HealthBarBG"]
                if not healthBarBG then
                    healthBarBG = healthBar:CreateTexture(nil, "BACKGROUND")
                    healthBarBG:SetTexture(self.path .. "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health")
                    healthBarBG:SetVertexColor(0.3, 0.3, 0.3, .5)
                    healthBarBG:SetAllPoints(healthBar)
                end

                local manaBarBG = _G["PartyMemberFrame" .. i .. "ManaBarBG"]
                if not manaBarBG then
                    manaBarBG = manaBar:CreateTexture(nil, "BACKGROUND")
                    manaBarBG:SetTexture(self.path .. "UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health-Status.tga")
                    manaBarBG:SetVertexColor(0.3, 0.3, 0.3, .5)
                    manaBarBG:SetAllPoints(manaBar)
                end

                healthBar:SetHeight(11)
                healthBar:ClearAllPoints()
                healthBar:SetPoint("CENTER", frame, "CENTER", 15, 10)
                manaBar:SetHeight(5)
                manaBar:ClearAllPoints()
                manaBar:SetPoint("CENTER", frame, "CENTER", 15, 0.5)
            end
        end
    end

    function Setup:UpdateTexts()
        self.UpdatePetTexts = function()
            if not UnitExists("pet") then return end

            local health = UnitHealth("pet")
            local maxHealth = UnitHealthMax("pet")
            local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0

            local mana = UnitMana("pet")
            local maxMana = UnitManaMax("pet")
            local manaPercent = maxMana > 0 and math.floor((mana / maxMana) * 100) or 0

            local now = GetTime()
            if not configCache.noPetPercent or (now - configCache.lastUpdate > 1) then
                configCache.noPetPercent = DFRL:GetTempDB("Mini", "noPetPercent")
                configCache.lastUpdate = now
            end

            local noPetPercentEnabled = configCache.noPetPercent
            local isMaxHealthManaEnabled = configCache.miniPetTextMaxShow

            if noPetPercentEnabled then
                Setup.healthPercentText:SetText("")
                Setup.healthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
                Setup.healthValueText:ClearAllPoints()
                Setup.healthValueText:SetPoint("CENTER", PetFrameHealthBar, "CENTER", 0, 0)

                Setup.manaPercentText:SetText("")
                if maxMana > 0 then
                    Setup.manaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                    Setup.manaValueText:ClearAllPoints()
                    Setup.manaValueText:SetPoint("CENTER", PetFrameManaBar, "CENTER", 0, 0)
                else
                    Setup.manaValueText:SetText("")
                end
            else
                Setup.healthPercentText:SetText(healthPercent .. "%")
                Setup.healthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
                Setup.healthValueText:ClearAllPoints()
                Setup.healthValueText:SetPoint("RIGHT", PetFrameHealthBar, "RIGHT", -5, 0)

                if maxMana > 0 then
                    Setup.manaPercentText:SetText(manaPercent .. "%")
                    Setup.manaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                    Setup.manaValueText:ClearAllPoints()
                    Setup.manaValueText:SetPoint("RIGHT", PetFrameManaBar, "RIGHT", -5, 0)
                else
                    Setup.manaPercentText:SetText("")
                    Setup.manaValueText:SetText("")
                end
            end
        end
    end

    function Setup:UpdateTargetOfTargetTexts()
        if not UnitExists("targettarget") then
            self.totHealthPercentText:SetText("")
            self.totHealthValueText:SetText("")
            self.totManaPercentText:SetText("")
            self.totManaValueText:SetText("")
            return
        end
        local health = UnitHealth("targettarget")
        local maxHealth = UnitHealthMax("targettarget")
        local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
        local mana = UnitMana("targettarget")
        local maxMana = UnitManaMax("targettarget")
        local manaPercent = maxMana > 0 and math.floor((mana / maxMana) * 100) or 0
        local now = GetTime()
        local isMaxHealthManaEnabled = configCache.miniTotTextMaxShow
        if not configCache.noTotPercent or (now - configCache.lastUpdate > 0.5) then
            configCache.noTotPercent = DFRL:GetTempDB("Mini", "noTotPercent")
            configCache.lastUpdate = now
        end
        local noTotPercentEnabled = configCache.noTotPercent
        local isDead = UnitIsDead("targettarget") or UnitIsGhost("targettarget")
        if isDead then
            self.totHealthPercentText:SetText("")
            self.totHealthValueText:SetText("")
            self.totManaPercentText:SetText("")
            self.totManaValueText:SetText("")
            return
        end
        if noTotPercentEnabled then
            self.totHealthPercentText:SetText("")
            self.totHealthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
            self.totHealthValueText:ClearAllPoints()
            self.totHealthValueText:SetPoint("CENTER", TargetofTargetHealthBar, "CENTER", 0, 0)

            self.totManaPercentText:SetText("")
            if maxMana > 0 then
                self.totManaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                self.totManaValueText:ClearAllPoints()
                self.totManaValueText:SetPoint("CENTER", TargetofTargetManaBar, "CENTER", 0, 0)
            else
                self.totManaValueText:SetText("")
            end
        else
            self.totHealthPercentText:SetText(healthPercent .. "%")
            self.totHealthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
            self.totHealthValueText:ClearAllPoints()
            self.totHealthValueText:SetPoint("RIGHT", TargetofTargetHealthBar, "RIGHT", -5, 0)

            if maxMana > 0 then
                self.totManaPercentText:SetText(manaPercent .. "%")
                self.totManaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                self.totManaValueText:ClearAllPoints()
                self.totManaValueText:SetPoint("RIGHT", TargetofTargetManaBar, "RIGHT", -5, 0)
            else
                self.totManaPercentText:SetText("")
                self.totManaValueText:SetText("")
            end
        end
    end

    function Setup:StateManagement()
        local function IsTargetOfTargetTaggedByOther()
            if not UnitExists("targettarget") or UnitIsPlayer("targettarget") then
                return false
            end
            return UnitIsTapped("targettarget") and not UnitIsTappedByPlayer("targettarget")
        end
        self.framesState.updateToTColor = function(self)
            if not UnitExists("targettarget") then
                TargetofTargetHealthBar:SetStatusBarColor(0, 1, 0)
                return
            end
            if IsTargetOfTargetTaggedByOther() then
                TargetofTargetHealthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                return
            end
            if self.colorClass and UnitIsPlayer("targettarget") then
                local _, class = UnitClass("targettarget")
                if class and RAID_CLASS_COLORS[class] then
                    local color = RAID_CLASS_COLORS[class]
                    TargetofTargetHealthBar:SetStatusBarColor(color.r, color.g, color.b)
                    return
                end
            end

            if self.colorReaction then
                local reaction = UnitReaction("player", "targettarget")
                if reaction then
                    if reaction >= 5 then
                        -- friendly (5+) - green
                        TargetofTargetHealthBar:SetStatusBarColor(0, 1, 0)
                    elseif reaction == 4 then
                        -- neutral (4) - yellow
                        TargetofTargetHealthBar:SetStatusBarColor(1, 1, 0)
                    elseif reaction <= 3 then
                        -- hostile (1-3) - red
                        TargetofTargetHealthBar:SetStatusBarColor(1, 0, 0)
                    end
                    return
                end
            end
            TargetofTargetHealthBar:SetStatusBarColor(0, 1, 0)
        end

        self.framesState.updatePartyColors = function(self)
            for i = 1, 4 do
                if UnitExists("party" .. i) then
                    local healthBar = _G["PartyMemberFrame" .. i .. "HealthBar"]

                    if self.colorClass then
                        local _, class = UnitClass("party" .. i)
                        if class and RAID_CLASS_COLORS[class] then
                            local color = RAID_CLASS_COLORS[class]
                            healthBar:SetStatusBarColor(color.r, color.g, color.b)
                        else
                            healthBar:SetStatusBarColor(0, 1, 0)
                        end
                    else
                        healthBar:SetStatusBarColor(0, 1, 0)
                    end
                end
            end
        end
        self.framesState.updateAllColors = function(self)
            self:updateToTColor()
            self:updatePartyColors()
        end
    end

    function Setup:HookEvents()
        HookScript(TargetofTargetHealthBar, "OnValueChanged", function()
            Setup.framesState:updateToTColor()
        end)
        hooksecurefunc("TargetofTarget_Update", function()
            Setup.framesState:updateToTColor()
        end)
    end

    function Setup:Run()
        self:KillBlizz()
        self:PetFrameTexts()
        self:PetFrameSetup()
        self:TargetOfTargetTexts()
        self:TargetOfTargetSetup()
        self:PartyFramesSetup()
        self:UpdateTexts()
        self:StateManagement()
        self:HookEvents()
        self.UpdatePetTexts()
        self:UpdateTargetOfTargetTexts()
    end

    Setup:Run()

    -- callbacks
    local callbacks = {}

    callbacks.miniTextShow = function(value)
        if value then
            Setup.healthPercentText:Show()
            Setup.healthValueText:Show()
            Setup.manaPercentText:Show()
            Setup.manaValueText:Show()

            Setup.totHealthPercentText:Show()
            Setup.totHealthValueText:Show()
            Setup.totManaPercentText:Show()
            Setup.totManaValueText:Show()

            for i = 1, 4 do
                Setup.partyHealthPercentTexts[i]:Show()
            end
        else
            Setup.healthPercentText:Hide()
            Setup.healthValueText:Hide()
            Setup.manaPercentText:Hide()
            Setup.manaValueText:Hide()

            Setup.totHealthPercentText:Hide()
            Setup.totHealthValueText:Hide()
            Setup.totManaPercentText:Hide()
            Setup.totManaValueText:Hide()

            for i = 1, 4 do
                Setup.partyHealthPercentTexts[i]:Hide()
            end
        end
    end

    callbacks.miniDarkMode = function(value)
        local intensity = value or 0
        local color = {1 - intensity, 1 - intensity, 1 - intensity}

        PetFrameTexture:SetVertexColor(color[1], color[2], color[3])
        TargetofTargetTexture:SetVertexColor(color[1], color[2], color[3])

        for i = 1, 4 do
            Setup.partyCustomBorders[i]:SetVertexColor(color[1], color[2], color[3])
        end
    end

    callbacks.miniPetTextMaxShow = function(value)
        configCache.miniPetTextMaxShow = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end

    callbacks.miniTotTextMaxShow = function(value)
        configCache.miniTotTextMaxShow = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end

    callbacks.miniPartyTextMaxShow = function(value)
        configCache.miniPartyTextMaxShow = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end
    
    callbacks.noPetPercent = function(value)
        configCache.noPetPercent = value
        configCache.lastUpdate = GetTime()
        Setup.UpdatePetTexts()
    end

    callbacks.noTotPercent = function(value)
        configCache.noTotPercent = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTargetOfTargetTexts()
    end

    callbacks.noPartyPercent = function(value)
        for i = 1, 4 do
            if UnitExists("party" .. i) then
                local health = UnitHealth("party" .. i)
                local maxHealth = UnitHealthMax("party" .. i)

                if value then
                    Setup.partyHealthPercentTexts[i]:SetText(health .. (configCache.miniPartyTextMaxShow and "/" .. maxHealth or ""))
                else
                    local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
                    Setup.partyHealthPercentTexts[i]:SetText(healthPercent .. "%")
                end
            end
        end
    end

    callbacks.colorReaction = function(value)
        Setup.framesState.colorReaction = value
        Setup.framesState:updateAllColors()
    end

    callbacks.colorClass = function(value)
        Setup.framesState.colorClass = value
        Setup.framesState:updateAllColors()
    end

    callbacks.frameFont = function(value)
        local fontPath
        if value == "Expressway" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Expressway.ttf"
        elseif value == "Homespun" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Homespun.ttf"
        elseif value == "Hooge" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Hooge.ttf"
        elseif value == "Myriad-Pro" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Myriad-Pro.ttf"
        elseif value == "Prototype" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Prototype.ttf"
        elseif value == "PT-Sans-Narrow-Bold" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Bold.ttf"
        elseif value == "PT-Sans-Narrow-Regular" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Regular.ttf"
        elseif value == "RobotoMono" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\RobotoMono.ttf"
        elseif value == "BigNoodleTitling" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\BigNoodleTitling.ttf"
        elseif value == "Continuum" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Continuum.ttf"
        elseif value == "DieDieDie" then
            fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\DieDieDie.ttf"
        else
            fontPath = "Fonts\\FRIZQT__.TTF"
        end
        Setup.healthPercentText:SetFont(fontPath, 9, "OUTLINE")
        Setup.healthValueText:SetFont(fontPath, 9, "OUTLINE")
        Setup.manaPercentText:SetFont(fontPath, 8, "OUTLINE")
        Setup.manaValueText:SetFont(fontPath, 8, "OUTLINE")
        Setup.totHealthPercentText:SetFont(fontPath, 9, "OUTLINE")
        Setup.totHealthValueText:SetFont(fontPath, 9, "OUTLINE")
        Setup.totManaPercentText:SetFont(fontPath, 8, "OUTLINE")
        Setup.totManaValueText:SetFont(fontPath, 8, "OUTLINE")
        for i = 1, 4 do
            Setup.partyHealthPercentTexts[i]:SetFont(fontPath, 9, "OUTLINE")
        end
        PetName:SetFont(fontPath, 10, "")
        TargetofTargetName:SetFont(fontPath, 9, "")
        for i = 1, 4 do
            local partyName = getglobal("PartyMemberFrame" .. i .. "Name")
            if partyName then
                partyName:SetFont(fontPath, 10, "")
            end
        end
    end

    callbacks.petFrameScale = function(value)
        PetFrame:SetScale(value)
    end

    callbacks.partyFrameScale = function(value)
        for i = 1, 4 do
            _G['PartyMemberFrame' .. i]:SetScale(value)
        end
    end

    callbacks.totFrameScale = function(value)
        TargetofTargetFrame:SetScale(value)
    end

    -- event handler
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("UNIT_MANA")
    f:RegisterEvent("UNIT_ENERGY")
    f:RegisterEvent("UNIT_RAGE")
    f:RegisterEvent("UNIT_FOCUS")
    f:RegisterEvent("UNIT_PET")
    f:RegisterEvent("PARTY_MEMBERS_CHANGED")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("UNIT_TARGET")
    f:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" or
            (event == "UNIT_HEALTH" and arg1 == "pet") or
            (event == "UNIT_MANA" and arg1 == "pet") or
            (event == "UNIT_ENERGY" and arg1 == "pet") or
            (event == "UNIT_RAGE" and arg1 == "pet") or
            (event == "UNIT_FOCUS" and arg1 == "pet") then
            Setup.UpdatePetTexts()
        end
        local partyUpdateTimer = nil
        if event == "PLAYER_ENTERING_WORLD" or event == "PARTY_MEMBERS_CHANGED" or
            (event == "UNIT_HEALTH" and string.find(arg1, "party")) then
            local now = GetTime()
            if not configCache.noPartyPercent or (now - configCache.lastUpdate > 1) then
                configCache.noPartyPercent = DFRL:GetTempDB("Mini", "noPartyPercent")
                configCache.lastUpdate = now
            end
            local value = configCache.noPartyPercent
            for i = 1, 4 do
                if UnitExists("party" .. i) then
                    local health = UnitHealth("party" .. i)
                    local maxHealth = UnitHealthMax("party" .. i)

                    if value then
                        Setup.partyHealthPercentTexts[i]:SetText(health .. (configCache.miniPartyTextMaxShow and "/" .. maxHealth or ""))
                    else
                        local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
                        Setup.partyHealthPercentTexts[i]:SetText(healthPercent .. "%")
                    end
                else
                    Setup.partyHealthPercentTexts[i]:SetText("")
                end
            end
            if event == "PARTY_MEMBERS_CHANGED" then
                if partyUpdateTimer then
                    partyUpdateTimer:SetScript("OnUpdate", nil)
                else
                    partyUpdateTimer = CreateFrame("Frame")
                end

                partyUpdateTimer:SetScript("OnUpdate", function()
                    Setup.framesState:updatePartyColors()
                    partyUpdateTimer:SetScript("OnUpdate", nil)
                end)
            else
                Setup.framesState:updatePartyColors()
            end
        end
        if event == "PLAYER_ENTERING_WORLD" or
        event == "PLAYER_TARGET_CHANGED" or
        (event == "UNIT_TARGET" and arg1 == "target") or
        (event == "UNIT_HEALTH" and arg1 == "targettarget") then
            Setup.framesState:updateToTColor()
        end
        if event == "PLAYER_ENTERING_WORLD" then
            f:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end)

    -- execute callbacks
    DFRL:NewCallbacks("Mini", callbacks)
end)