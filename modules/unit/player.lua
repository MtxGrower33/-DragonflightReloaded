DFRL:NewDefaults("Player", {
    enabled = {true},
    playerDarkMode = {0, "slider", {0, 1}, nil, "appearance", 1, "Adjust dark mode intensity", nil, nil},
    eliteBorder = {"standard", "dropdown", {"standard", "rare", "elite", "rare-elite", "boss", "dfrl evolved", "dfrl nebula"}, nil, "appearance", 2, "Changes the texture of the playerframe", nil, nil},
    textShow = {true, "checkbox", nil, nil, "text settings", 3, "Show health and mana text", nil, nil},
    textMaxShow = {true, "checkbox", nil, nil, "text settings", 4, "Show max health and mana text", nil, nil},
    noPercent = {true, "checkbox", nil, nil, "text settings", 5, "Show only current values without percentages", nil, nil},
    textColoringHealth = {false, "checkbox", nil, nil, "text settings", 6, "Color text based on health percentage from white to red", nil, nil},
    textColoringResource = {false, "checkbox", nil, nil, "text settings", 7, "Color text based on resource (mana/rage/energy) percentage from white to red", nil, nil},
    healthSize = {15, "slider", {8, 20}, nil, "text settings", 8, "Health text font size", nil, nil},
    manaSize = {9, "slider", {8, 20}, nil, "text settings", 9, "Mana text font size", nil, nil},
    nameSize = {9, "slider", {6, 16}, nil, "text settings", 10, "Name text font size", nil, nil},
    levelSize = {9, "slider", {6, 16}, nil, "text settings", 11, "Level text font size", nil, nil},
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
    }, nil, "text settings", 12, "Change the font used for the playerframe", nil, nil},
    classColor = {false, "checkbox", nil, nil, "bar color", 13, "Color health bar based on class", nil, nil},
    classPortrait = {false, "checkbox", nil, nil, "tweaks", 14, "Activate 2D class portrait icons", nil, nil},
    frameHide = {false, "checkbox", nil, nil, "tweaks", 15, "Hide frame at full HP when not in combat", nil, nil},
    frameScale = {1, "slider", {0.7, 1.3}, nil, "tweaks", 16, "Adjust frame size", nil, nil},
    combatGlow = {true, "checkbox", nil, nil, "effects", 17, "Enable combat pulse animation", nil, nil},
    glowSpeed = {1, "slider", {0.4, 5}, nil, "effects", 18, "Adjust the speed of the combat pulsing", nil, nil},
    glowAlpha = {1, "slider", {0.1, 1}, nil, "effects", 19, "Adjust the maximum alpha of the combat pulsing", nil, nil},
    restingGlow = {true, "checkbox", nil, nil, "effects", 20, "Enable resting glow animation", nil, nil},
    restingSpeed = {1, "slider", {0.4, 5}, nil, "effects", 21, "Adjust the speed of the resting pulsing", nil, nil},
    restingAlpha = {1, "slider", {0.1, 1}, nil, "effects", 22, "Adjust the maximum alpha of the resting pulsing", nil, nil},
    restingColor = {{0, 1, 1}, "colour", nil, nil, "effects", 23, "Changes the colour of the resting glow animation", nil, nil},
})

DFRL:NewMod("Player", 1, function()
    --=================
    -- SETUP
    --=================
    local Setup = {
        texpath = "Interface\\AddOns\\-DragonflightReloaded\\media\\tex\\unitframes\\",
        texpath2 = "Interface\\AddOns\\-DragonflightReloaded\\media\\tex\\ui\\",
        fontpath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\",

        hideFrame = nil,
        restingAnimation = nil,
        combatOverlay = nil,
        combatOverlayTex = nil,
        combatGlow = {
            fadeSpeed = 1.0,
            alphaMin = 0,
            alphaMax = 1.0,
        },

        restingOverlay = nil,
        restingOverlayTex = nil,
        restingGlow = {
            fadeSpeed = 1.0,
            alphaMin = 0,
            alphaMax = 1.0,
            color = {0, 1, 1},
        },

        texts = {
            healthPercent = nil,
            healthValue = nil,
            healthPercentShow = true,
            manaPercent = nil,
            manaValue = nil,
            manaPercentShow = true,
            config = {
                font = "Fonts\\FRIZQT__.TTF",
                healthFontSize = 12,
                manaFontSize = 9,
                nameFontSize = 9,
                levelFontSize = 9,
                outline = "NONE",
                nameColor = {1, .82, 0},
                levelColor = {1, .82, 0},
                healthColor = {1, 1, 1},
                manaColor = {1, 1, 1},
            }
        }
    }

    function Setup:HealthBar()
        PlayerFrameHealthBar:SetStatusBarTexture(self.texpath .. "healthDF2.tga")
        PlayerFrameHealthBar:SetWidth(130)
        PlayerFrameHealthBar:SetHeight(30)
        PlayerFrameHealthBar:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 100, -29)
    end

    function Setup:HealthBarText()
        PlayerFrameHealthBarText:ClearAllPoints()
        PlayerFrameHealthBarText:SetText("")
        local cfg = self.texts.config
        self.texts.healthTextFrame = CreateFrame("Frame", nil, PlayerFrame)
        self.texts.healthTextFrame:SetAllPoints(PlayerFrameHealthBar)
        self.texts.healthTextFrame:SetFrameStrata(PlayerFrame:GetFrameStrata())
        self.texts.healthTextFrame:SetFrameLevel(PlayerFrame:GetFrameLevel() + 2)
        self.texts.healthPercent = self.texts.healthTextFrame:CreateFontString(nil)
        self.texts.healthPercent:SetFont(cfg.font, cfg.healthFontSize, "OUTLINE")
        self.texts.healthPercent:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 5, 0)
        self.texts.healthValue = self.texts.healthTextFrame:CreateFontString(nil)
        self.texts.healthValue:SetFont(cfg.font, cfg.healthFontSize, "OUTLINE")
    end

    function Setup:ManaBar()
        PlayerFrameManaBar:SetStatusBarTexture(self.texpath .. "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Status.tga")
        PlayerFrameManaBar:SetWidth(130)
        PlayerFrameManaBar:SetHeight(12)
        PlayerFrameManaBar:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 100, -53)
    end

    function Setup:ManaBarText()
        PlayerFrameManaBarText:SetText("")
        PlayerFrameManaBarText:ClearAllPoints()
        local cfg = self.texts.config
        self.texts.manaTextFrame = CreateFrame("Frame", nil, PlayerFrame)
        self.texts.manaTextFrame:SetAllPoints(PlayerFrameManaBar)
        self.texts.manaTextFrame:SetFrameStrata(PlayerFrame:GetFrameStrata())
        self.texts.manaTextFrame:SetFrameLevel(PlayerFrame:GetFrameLevel() + 2)
        self.texts.manaPercent = self.texts.manaTextFrame:CreateFontString(nil)
        self.texts.manaPercent:SetFont(cfg.font, cfg.manaFontSize, cfg.outline)
        self.texts.manaPercent:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 5, 0)
        self.texts.manaValue = self.texts.manaTextFrame:CreateFontString(nil)
        self.texts.manaValue:SetFont(cfg.font, cfg.manaFontSize, cfg.outline)
    end

    function Setup:FrameTextures()
        PlayerFrameTexture:SetTexture(self.texpath .. "UI-TargetingFrameDF.blp")
        PlayerFrameTexture:SetWidth(256)
        PlayerFrameTexture:SetHeight(128)
        PlayerFrameTexture:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 0, 0)
        PlayerFrameTexture:SetDrawLayer("BACKGROUND")
        PlayerFrameBackground:SetTexture(self.texpath .. "UI-TargetingFrameDF-Background.blp")
        PlayerFrameBackground:SetWidth(256)
        PlayerFrameBackground:SetHeight(128)
        PlayerFrameBackground:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 0, 0)
        PlayerFrameBackground:SetDrawLayer("BACKGROUND")
        PlayerStatusTexture:SetTexture("")
    end

    function Setup:Portrait()
        PlayerFrame.portrait:SetHeight(62)
        PlayerFrame.portrait:SetWidth(62)
    end

    function Setup:NameText()
        local cfg = self.texts.config
        PlayerFrame.name:ClearAllPoints()
        PlayerFrame.name:SetPoint("LEFT", PlayerFrame, "LEFT", 80, 25)
        PlayerFrame.name:SetFont(cfg.font, cfg.nameFontSize, cfg.outline)
        PlayerFrame.name:SetTextColor(unpack(cfg.nameColor))
    end

    function Setup:LevelText()
        local cfg = self.texts.config
        PlayerLevelText:ClearAllPoints()
        PlayerLevelText:SetPoint("RIGHT", PlayerFrame, "RIGHT", -14, 25)
        PlayerLevelText:SetFont(cfg.font, cfg.levelFontSize, cfg.outline)
        PlayerLevelText:SetTextColor(unpack(cfg.levelColor))
    end

    function Setup:CombatGlow()
        function _G.PlayerFrame_UpdateStatus() end
        PlayerAttackGlow:SetTexture("")
        PlayerAttackIcon:SetTexture("")
        Setup.combatOverlay = CreateFrame("Frame", nil, PlayerFrame)
        Setup.combatOverlay:SetAllPoints(PlayerFrame)
        Setup.combatOverlay:SetFrameStrata("MEDIUM")
        Setup.combatOverlayTex = Setup.combatOverlay:CreateTexture(nil, "OVERLAY")
        Setup.combatOverlayTex:SetTexture(Setup.texpath.. "UI-Player-Status.blp")
        Setup.combatOverlayTex:SetPoint("CENTER", PlayerFrame, "CENTER", 45, -21)
        Setup.combatOverlayTex:SetVertexColor(1, 0, 0)
        Setup.combatOverlayTex:SetBlendMode("ADD")
        Setup.combatOverlayTex:SetAlpha(0)
    end

    function Setup:RestingGlow()
        PlayerRestIcon:SetTexture("")
        PlayerRestGlow:SetTexture("")
        Setup.restingOverlay = CreateFrame("Frame", nil, PlayerFrame)
        Setup.restingOverlay:SetAllPoints(PlayerFrame)
        Setup.restingOverlay:SetFrameStrata("MEDIUM")
        Setup.restingOverlayTex = Setup.restingOverlay:CreateTexture(nil, "OVERLAY")
        Setup.restingOverlayTex:SetTexture(Setup.texpath.. "UI-Player-Status.blp")
        Setup.restingOverlayTex:SetPoint("CENTER", PlayerFrame, "CENTER", 45, -21)
        Setup.restingOverlayTex:SetVertexColor(Setup.restingGlow.color[1], Setup.restingGlow.color[2], Setup.restingGlow.color[3])
        Setup.restingOverlayTex:SetBlendMode("ADD")
        Setup.restingOverlayTex:SetAlpha(0)
    end

    function Setup:RestingZZZ()
        restingAnimation = CreateFrame("Frame", "restingAnimation", UIParent)
        restingAnimation:SetPoint("CENTER", PlayerFrame, "CENTER", -20, 30)
        restingAnimation:SetWidth(24)
        restingAnimation:SetHeight(24)
        local texture = restingAnimation:CreateTexture(nil, "OVERLAY")
        texture:SetTexture(Setup.texpath.. "UIUnitFrameRestingFlipbook")
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
                DFRL.activeScripts["RestingAnimationScript"] = true
            else
                DFRL.activeScripts["RestingAnimationScript"] = false
            end
        end)

        local function UpdateRestingState()
            if IsResting() and PlayerFrame:IsShown() then
                restingAnimation:Show()
            else
                restingAnimation:Hide()
            end
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:RegisterEvent("PLAYER_UPDATE_RESTING")
        f:SetScript("OnEvent", function()
            UpdateRestingState()
        end)

        UpdateRestingState()
    end

    function Setup:Run()
        self:FrameTextures()
        self:HealthBar()
        self:HealthBarText()
        self:ManaBar()
        self:ManaBarText()
        self:Portrait()
        self:LevelText()
        self:NameText()
        self:CombatGlow()
        self:RestingGlow()
        self:RestingZZZ()
    end

    --=================
    -- CALLBACKS
    --=================
    local callbacks = {}

    callbacks.playerDarkMode = function(value)
        local intensity = value or 0
        local color = {1 - intensity, 1 - intensity, 1 - intensity}

        PlayerFrameTexture:SetVertexColor(color[1], color[2], color[3])
        PlayerFrameBackground:SetVertexColor(color[1], color[2], color[3])
    end

    callbacks.textMaxShow = function(value)
        Setup.texts.showMaxValues = value
        callbacks.textShow(DFRL:GetTempDB("Player", "textShow"))
    end

    callbacks.textShow = function(value)
        if value then
            local health = UnitHealth("player")
            local maxHealth = UnitHealthMax("player")
            local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0

            local mana = UnitMana("player")
            local maxMana = UnitManaMax("player")
            local manaPercent = maxMana > 0 and math.floor((mana / maxMana) * 100) or 0

            if Setup.texts.healthPercentShow then
                Setup.texts.healthPercent:SetText(healthPercent .. "%")
                Setup.texts.healthPercent:Show()
            else
                Setup.texts.healthPercent:SetText("")
                Setup.texts.healthPercent:Hide()
            end

            if Setup.texts.manaPercentShow then
                Setup.texts.manaPercent:SetText(manaPercent .. "%")
                Setup.texts.manaPercent:Show()
            else
                Setup.texts.manaPercent:SetText("")
                Setup.texts.manaPercent:Hide()
            end

            Setup.texts.healthValue:SetText(health .. (Setup.texts.showMaxValues and "/" .. maxHealth or ""))
            Setup.texts.manaValue:SetText(mana .. (Setup.texts.showMaxValues and "/" .. maxMana or ""))
            Setup.texts.healthValue:Show()
            Setup.texts.manaValue:Show()

            if not Setup.texts.healthPercentShow then
                Setup.texts.healthValue:ClearAllPoints()
                Setup.texts.healthValue:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", -3, 1)
            else
                Setup.texts.healthValue:ClearAllPoints()
                Setup.texts.healthValue:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -5, 1)
            end

            if not Setup.texts.manaPercentShow then
                Setup.texts.manaValue:ClearAllPoints()
                Setup.texts.manaValue:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", -3, 0)
            else
                Setup.texts.manaValue:ClearAllPoints()
                Setup.texts.manaValue:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -5, 0)
            end
        else
            Setup.texts.healthPercent:Hide()
            Setup.texts.healthValue:Hide()
            Setup.texts.manaPercent:Hide()
            Setup.texts.manaValue:Hide()
        end
    end

    callbacks.frameFont = function(value)
        local fontPath
        if value == "Expressway" then
            fontPath = Setup.fontpath .. "Expressway.ttf"
        elseif value == "Homespun" then
            fontPath = Setup.fontpath .. "Homespun.ttf"
        elseif value == "Hooge" then
            fontPath = Setup.fontpath .. "Hooge.ttf"
        elseif value == "Myriad-Pro" then
            fontPath = Setup.fontpath .. "Myriad-Pro.ttf"
        elseif value == "Prototype" then
            fontPath = Setup.fontpath .. "Prototype.ttf"
        elseif value == "PT-Sans-Narrow-Bold" then
            fontPath = Setup.fontpath .. "PT-Sans-Narrow-Bold.ttf"
        elseif value == "PT-Sans-Narrow-Regular" then
            fontPath = Setup.fontpath .. "PT-Sans-Narrow-Regular.ttf"
        elseif value == "RobotoMono" then
            fontPath = Setup.fontpath .. "RobotoMono.ttf"
        elseif value == "BigNoodleTitling" then
            fontPath = Setup.fontpath .. "BigNoodleTitling.ttf"
        elseif value == "Continuum" then
            fontPath = Setup.fontpath .. "Continuum.ttf"
        elseif value == "DieDieDie" then
            fontPath = Setup.fontpath .. "DieDieDie.ttf"
        else
            fontPath = "Fonts\\FRIZQT__.TTF"
        end

        Setup.texts.config.font = fontPath
        Setup.texts.healthPercent:SetFont(fontPath, Setup.texts.config.healthFontSize, "OUTLINE")
        Setup.texts.healthValue:SetFont(fontPath, Setup.texts.config.healthFontSize, "OUTLINE")
        Setup.texts.manaPercent:SetFont(fontPath, Setup.texts.config.manaFontSize, "OUTLINE")
        Setup.texts.manaValue:SetFont(fontPath, Setup.texts.config.manaFontSize, "OUTLINE")
        Setup:NameText()
        Setup:LevelText()
    end

    callbacks.noPercent = function(value)
        Setup.texts.healthPercentShow = not value
        Setup.texts.manaPercentShow = not value

        callbacks.textShow(DFRL:GetTempDB("Player", "textShow"))
    end

    callbacks.textColoringHealth  = function(value)
        local health = UnitHealth("player")
        local maxHealth = UnitHealthMax("player")
        local healthPercent = maxHealth > 0 and (health / maxHealth) or 1

        local function getColor(p)
            return 1, p, p
        end

        if value then
            local hr, hg, hb = getColor(healthPercent)
            Setup.texts.healthValue:SetTextColor(hr, hg, hb)
            Setup.texts.healthPercent:SetTextColor(hr, hg, hb)
        else
            local hc = Setup.texts.config.healthColor
            Setup.texts.healthValue:SetTextColor(hc[1], hc[2], hc[3])
            Setup.texts.healthPercent:SetTextColor(hc[1], hc[2], hc[3])
        end
    end

    callbacks.textColoringResource = function(value)
        local mana = UnitMana("player")
        local maxMana = UnitManaMax("player")
        local manaPercent = maxMana > 0 and (mana / maxMana) or 1

        local function getColor(p)
            return 1, p, p
        end

        if value then
            local mr, mg, mb = getColor(manaPercent)
            Setup.texts.manaValue:SetTextColor(mr, mg, mb)
            Setup.texts.manaPercent:SetTextColor(mr, mg, mb)
        else
            local mc = Setup.texts.config.manaColor
            Setup.texts.manaValue:SetTextColor(mc[1], mc[2], mc[3])
            Setup.texts.manaPercent:SetTextColor(mc[1], mc[2], mc[3])
        end
    end

    callbacks.healthSize = function(value)
        Setup.texts.config.healthFontSize = value
        Setup.texts.healthPercent:SetFont(Setup.texts.config.font, value, "OUTLINE")
        Setup.texts.healthValue:SetFont(Setup.texts.config.font, value, "OUTLINE")
    end

    callbacks.manaSize = function(value)
        Setup.texts.config.manaFontSize = value
        Setup.texts.manaPercent:SetFont(Setup.texts.config.font, value, "OUTLINE")
        Setup.texts.manaValue:SetFont(Setup.texts.config.font, value, "OUTLINE")
    end

    callbacks.nameSize = function(value)
        Setup.texts.config.nameFontSize = value
        PlayerFrame.name:SetFont(Setup.texts.config.font, value, Setup.texts.config.outline)
    end

    callbacks.levelSize = function(value)
        Setup.texts.config.levelFontSize = value
        PlayerLevelText:SetFont(Setup.texts.config.font, value, Setup.texts.config.outline)
    end

    callbacks.classColor = function(value)
        if value then
            local _, class = UnitClass("player")
            if class and RAID_CLASS_COLORS[class] then
                local color = RAID_CLASS_COLORS[class]
                PlayerFrameHealthBar:SetStatusBarColor(color.r, color.g, color.b)
            else
                PlayerFrameHealthBar:SetStatusBarColor(0, 1, 0)
            end
        else
            PlayerFrameHealthBar:SetStatusBarColor(0, 1, 0)
        end
    end

    callbacks.frameHide = function(value)
        if Setup.hideFrame then
            Setup.hideFrame:UnregisterAllEvents()
            Setup.hideFrame:SetScript("OnEvent", nil)
            Setup.hideFrame = nil
        end

        local function updatePlayerFrameAndResting()
            local health = UnitHealth("player")
            local maxHealth = UnitHealthMax("player")
            local inCombat = UnitAffectingCombat("player")

            if health == maxHealth and not inCombat then
                PlayerFrame:Hide()
                if restingAnimation then restingAnimation:Hide() end
            else
                PlayerFrame:Show()
                if restingAnimation and IsResting() then
                    restingAnimation:Show()
                elseif restingAnimation then
                    restingAnimation:Hide()
                end
            end
        end

        if value then
            Setup.hideFrame = CreateFrame("Frame")
            Setup.hideFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            Setup.hideFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
            Setup.hideFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
            Setup.hideFrame:RegisterEvent("UNIT_HEALTH")
            Setup.hideFrame:SetScript("OnEvent", function()
                updatePlayerFrameAndResting()
            end)

            updatePlayerFrameAndResting()
        else
            PlayerFrame:Show()
            if restingAnimation and IsResting() then
                restingAnimation:Show()
            elseif restingAnimation then
                restingAnimation:Hide()
            end
        end
    end

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
                    frame.portrait:SetTexture(Setup.texpath2 .."UI-Classes-Circles.tga")
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
                DFRL.activeScripts["PortraitUpdateScript"] = true
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
                DFRL.activeScripts["PortraitUpdateScript"] = false
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

    callbacks.frameScale = function(value)
        PlayerFrame:SetScale(value)
    end

    callbacks.combatGlow = function (value)
        if not Setup.combatOverlay or not Setup.combatOverlayTex then return end

        local pulseTime = 0
        local pulseDuration = 1 / Setup.combatGlow.fadeSpeed

        if value then
            Setup.combatOverlay:SetScript("OnUpdate", function()
                if (this.tick or 0) > GetTime() then
                    DFRL.activeScripts["CombatGlowScript"] = false
                    return
                end
                this.tick = GetTime() + 0.01

                local elapsed = arg1
                if not UnitAffectingCombat("player") then
                    local alpha = Setup.combatOverlayTex:GetAlpha()
                    alpha = alpha - (Setup.combatGlow.fadeSpeed * elapsed * 2)
                    if alpha < 0 then alpha = PlayerFrameHealthBar:GetAlpha() * 0 end
                    Setup.combatOverlayTex:SetAlpha(alpha)
                    DFRL.activeScripts["CombatGlowScript"] = true
                    return
                end

                pulseTime = pulseTime + elapsed
                if pulseTime > pulseDuration then
                    pulseTime = pulseTime - pulseDuration
                end
                local progress = pulseTime / pulseDuration
                local alpha = Setup.combatGlow.alphaMin + (Setup.combatGlow.alphaMax - Setup.combatGlow.alphaMin) * (0.5 + 0.5 * math.sin(progress * 2 * math.pi))
                Setup.combatOverlayTex:SetAlpha(alpha)
                DFRL.activeScripts["CombatGlowScript"] = true
            end)
        else
            Setup.combatOverlay:SetScript("OnUpdate", nil)
            Setup.combatOverlayTex:SetAlpha(0)
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_REGEN_DISABLED")
        f:RegisterEvent("PLAYER_REGEN_ENABLED")
        f:SetScript("OnEvent", function()
            if event == "PLAYER_REGEN_DISABLED" then
                currentAlpha = Setup.combatGlow.alphaMin
                fadeDirection = 1
            elseif event == "PLAYER_REGEN_ENABLED" then
                fadeDirection = -1
            end
        end)
    end

    callbacks.glowSpeed = function(value)
        Setup.combatGlow.fadeSpeed = value
        callbacks.combatGlow(DFRL:GetTempDB("Player", "combatGlow"))
    end

    callbacks.glowAlpha = function(value)
        Setup.combatGlow.alphaMax = value
        callbacks.combatGlow(DFRL:GetTempDB("Player", "combatGlow"))
    end

    callbacks.restingGlow = function(value)
        if not Setup.restingOverlay or not Setup.restingOverlayTex then return end

        local pulseTime = 0
        local pulseDuration = 1 / Setup.restingGlow.fadeSpeed

        if value then
            Setup.restingOverlay:SetScript("OnUpdate", function()
                if (this.tick or 0) > GetTime() then
                    DFRL.activeScripts["RestingGlowScript"] = false
                    return
                end
                this.tick = GetTime() + 0.01

                local elapsed = arg1
                if not IsResting() then
                    local alpha = Setup.restingOverlayTex:GetAlpha()
                    alpha = alpha - (Setup.restingGlow.fadeSpeed * elapsed * 2)
                    if alpha < 0 then alpha = PlayerFrameHealthBar:GetAlpha() * 0 end
                    Setup.restingOverlayTex:SetAlpha(alpha)
                    DFRL.activeScripts["RestingGlowScript"] = true
                    return
                end

                pulseTime = pulseTime + elapsed
                if pulseTime > pulseDuration then
                    pulseTime = pulseTime - pulseDuration
                end
                local progress = pulseTime / pulseDuration

                local alpha = Setup.restingGlow.alphaMin + (Setup.restingGlow.alphaMax - Setup.restingGlow.alphaMin) * (0.5 + 0.5 * math.sin(progress * 2 * math.pi))
                Setup.restingOverlayTex:SetAlpha(alpha)
                DFRL.activeScripts["RestingGlowScript"] = true
            end)
        else
            Setup.restingOverlay:SetScript("OnUpdate", nil)
            Setup.restingOverlayTex:SetAlpha(0)
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_UPDATE_RESTING")
        f:SetScript("OnEvent", function()
            currentAlpha = Setup.restingGlow.alphaMin
            fadeDirection = 1
        end)
    end

    callbacks.restingSpeed = function(value)
        Setup.restingGlow.fadeSpeed = value
        callbacks.restingGlow(DFRL:GetTempDB("Player", "restingGlow"))
    end

    callbacks.restingAlpha = function(value)
        Setup.restingGlow.alphaMax = value
        callbacks.restingGlow(DFRL:GetTempDB("Player", "restingGlow"))
    end

    callbacks.restingColor = function (value)
        Setup.restingGlow.color = value
        Setup.restingOverlayTex:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.eliteBorder = function(value)
        local tex
        if value == "rare" then
            tex = Setup.texpath .. "UI-TargetingFrame-Rare.blp"
        elseif value == "elite" then
            tex = Setup.texpath .. "UI-TargetingFrame-Elite.blp"
        elseif value == "rare-elite" then
            tex = Setup.texpath .. "UI-TargetingFrame-RareElite.blp"
        elseif value == "boss" then
            tex = Setup.texpath .. "UI-TargetingFrame-Boss.blp"
        elseif value == "dfrl nebula" then
            tex = Setup.texpath .. "guzruul_nebula_v1.tga"
        elseif value == "dfrl evolved" then
            tex = Setup.texpath .. "guzruul_evolved_v1.tga"
        else
            tex = Setup.texpath .. "UI-TargetingFrameDF.blp"
        end
        PlayerFrameTexture:SetTexture(tex)
    end

    -- event handler
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_MANA")
    f:RegisterEvent("UNIT_RAGE")
    f:RegisterEvent("UNIT_ENERGY")
    f:RegisterEvent("UNIT_FOCUS")
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then

            Setup:Run()
            DFRL:NewCallbacks("Player", callbacks)

            f:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end

        if event == "PLAYER_REGEN_ENABLED" or
        event == "PLAYER_REGEN_DISABLED" or
        arg1 == "player" then
            callbacks.textShow(DFRL:GetTempDB("Player", "textShow"))
            callbacks.textColoringHealth(DFRL:GetTempDB("Player", "textColoringHealth"))
            callbacks.textColoringResource(DFRL:GetTempDB("Player", "textColoringResource"))
            callbacks.classColor(DFRL:GetTempDB("Player", "classColor"))
        end
    end)
end)