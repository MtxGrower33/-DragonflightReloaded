DFRL:NewDefaults("Micro", {
    enabled = {true},
    microDarkMode = {0, "slider", {0, 1}, nil, "appearance", 1, "Adjust dark mode intensity", nil, nil},
    switchColor = {true, "checkbox", nil, nil, "micro basic", 2, "Switch between gray and colorfull micro menu", nil, nil},
    microScale = {0.85, "slider", {0.5, 1.5}, nil, "micro basic", 3, "Adjusts the scale of the micro menu", nil, nil},
    microAlpha = {1, "slider", {0.1, 1}, nil, "micro basic", 4, "Adjusts the transparency of the micro menu", nil, nil},
    microSpacing = {3, "slider", {0.5, 15}, nil, "micro basic", 5, "Adjusts spacing between micro menu buttons", nil, nil},
    smallFPS = {false, "checkbox", nil, nil, "tweaks", 6, "Show smaller FPS/MS watcher (CTRL+R)", nil, nil},
})

DFRL:NewMod("Micro", 1, function()
    -- setup
    local Setup = {
        texpath = "Interface\\AddOns\\-DragonflightReloaded\\media\\tex\\micromenu\\",
        fontpath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\",

        buttons = {},
        microMenuContainer = nil,
        pvpButton = nil,
        lftButton = nil,
        ebcButton = nil,

        msText = nil,
        bwText = nil,
        fpsText = nil,
        netStatsFrame = nil,
        netStatsFrameBG = nil,
        latencyIndicator = nil,
        latencyTexture = nil,

        appearance = {
            scale = 0.85,
            alpha = 1.0,
            microDarkMode = false,
        },

        buttonWidth = 20,
        buttonHeight = 30,
        buttonSpacing = 2,
    }

    function Setup:CreateContainer()
        self.microMenuContainer = CreateFrame("Frame", "DFRLMicroMenuContainer", UIParent)
        self.microMenuContainer:SetWidth((self.buttonWidth + 2) * 10)
        self.microMenuContainer:SetHeight(self.buttonHeight)
        self.microMenuContainer:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 15)
        self.microMenuContainer:SetClampedToScreen(true)
    end

    function Setup:BlizzardButtons()
        self.buttons = {
            CharacterMicroButton,
            SpellbookMicroButton,
            TalentMicroButton,
            QuestLogMicroButton,
            SocialsMicroButton,
            WorldMapMicroButton,
            MainMenuMicroButton,
            HelpMicroButton,
        }
        for _, button in ipairs(self.buttons) do
            if button then
                button:Show()
                button:Enable()
                button:SetAlpha(1)
            end
        end
    end

    function Setup:PvPButton()
        self.pvpButton = CreateFrame("Button", "DFRLPvPMicroButton", self.microMenuContainer)
        self.pvpButton:SetWidth(self.buttonWidth)
        self.pvpButton:SetHeight(self.buttonHeight)
        self.pvpButton:SetHitRectInsets(0, 0, 0, 0)
        self.pvpButton:Show()
        self.pvpButton:Enable()
        self.pvpButton:SetScript("OnClick", function()
            if BattlefieldFrame:IsVisible() then
                ToggleGameMenu()
            else
                ShowTWBGQueueMenu()
            end
        end)
        self.pvpButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self.pvpButton, "ANCHOR_RIGHT")
            GameTooltip:SetText("Player vs Player", 1, 1, 1)
            GameTooltip:AddLine("Queue for battlegrounds and view PvP statistics.")
            GameTooltip:AddLine("Right-click to toggle honor system.")
            GameTooltip:Show()
        end)
        self.pvpButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    function Setup:LFTButton()
        self.lftButton = CreateFrame("Button", "DFRLLFTMicroButton", self.microMenuContainer)
        self.lftButton:SetWidth(self.buttonWidth)
        self.lftButton:SetHeight(self.buttonHeight)
        self.lftButton:SetHitRectInsets(0, 0, 0, 0)
        self.lftButton:Show()
        self.lftButton:Enable()
        self.lftButton:SetScript("OnClick", LFT_Toggle)
        self.lftButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self.lftButton, "ANCHOR_RIGHT")
            GameTooltip:SetText("Looking For Team", 1, 1, 1)
            GameTooltip:AddLine("Open the Group Finder interface to find a team,")
            GameTooltip:AddLine("be aware that you must travel to the dungeon manually.")
            GameTooltip:Show()
        end)
        self.lftButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    function Setup:EBCButton()
        self.ebcButton = CreateFrame("Button", "DFRLEBCMicroButton", self.microMenuContainer)
        self.ebcButton:SetWidth(self.buttonWidth)
        self.ebcButton:SetHeight(self.buttonHeight)
        self.ebcButton:SetHitRectInsets(0, 0, 0, 0)
        self.ebcButton:Show()
        self.ebcButton:Enable()
        self.ebcButton:SetScript("OnClick", function()
            EBCMinimapDropdown:ClearAllPoints()
            EBCMinimapDropdown:SetPoint("CENTER", self.ebcButton, 0, 65)
            ShowEBCMinimapDropdown()
        end)
        self.ebcButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self.ebcButton, "ANCHOR_RIGHT")
            GameTooltip:SetText("Everlook Broadcasting Co.", 1, 1, 1, 1, true)
            GameTooltip:AddLine("Listen to some awesome tunes while you play Turtle WoW.", nil, nil, nil, true)
            GameTooltip:Show()
        end)
        self.ebcButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    function Setup:LowLevelTalentButton()
        if not DFRL.lowLevelTalentsButton then
            local lowLevelTalentsButton = CreateFrame("Button", "DFRLLowLevelTalentsButton", Setup.microMenuContainer)
            lowLevelTalentsButton:SetWidth(Setup.buttonWidth)
            lowLevelTalentsButton:SetHeight(Setup.buttonHeight)
            lowLevelTalentsButton:SetPoint("TOPLEFT", Setup.buttons[2], "TOPLEFT", Setup.buttonWidth + Setup.buttonSpacing, 0)
            lowLevelTalentsButton:SetNormalTexture(Setup.texpath.. "color_micro\\talents-disabled.tga")
            lowLevelTalentsButton:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)

            lowLevelTalentsButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(lowLevelTalentsButton, "ANCHOR_RIGHT")
                GameTooltip:SetText("Talents", 1, 1, 1)
                GameTooltip:AddLine("You must reach level 10 to use talents.")
                GameTooltip:Show()
            end)

            lowLevelTalentsButton:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            DFRL.lowLevelTalentsButton = lowLevelTalentsButton

            local function UpdateTalentButtonVisibility()
                local playerLevel = UnitLevel("player")
                if playerLevel < 10 then
                    lowLevelTalentsButton:Show()
                    Setup.buttons[3]:Hide()
                else
                    lowLevelTalentsButton:Hide()
                    Setup.buttons[3]:Show()
                end
            end

            local talentVisibilityFrame = CreateFrame("Frame")
            talentVisibilityFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            talentVisibilityFrame:RegisterEvent("PLAYER_LEVEL_UP")
            talentVisibilityFrame:SetScript("OnEvent", function()
                UpdateTalentButtonVisibility()
                talentVisibilityFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
            end)

            UpdateTalentButtonVisibility()
        end
    end

    function Setup:ArrangeButtons()
        -- insert custom buttons after SocialsMicroButton (index 5)
        local newButtons = {}
        for i, button in ipairs(self.buttons) do
            table.insert(newButtons, button)
            if i == 5 then
                table.insert(newButtons, self.pvpButton)
                table.insert(newButtons, self.lftButton)
                table.insert(newButtons, self.ebcButton)
            end
        end
        self.buttons = newButtons

        for i, button in ipairs(self.buttons) do
            button:Show()
            button:Enable()
            button:SetParent(self.microMenuContainer)
            button:ClearAllPoints()
            local xOffset = (i-1) * (self.buttonWidth + self.buttonSpacing)
            button:SetPoint("TOPLEFT", self.microMenuContainer, "TOPLEFT", xOffset, 0)
            button:SetWidth(self.buttonWidth)
            button:SetHeight(self.buttonHeight)
            button:SetHitRectInsets(0, 0, 0, 0)
            if button == self.pvpButton or button == self.lftButton then
                local regions = {button:GetRegions()}
                for _, region in ipairs(regions) do
                    if region:GetObjectType() == "Texture" then
                        region:Hide()
                    end
                end
            end
        end

        local charBtn = self.buttons[1]
        if charBtn then
            local path = self.texpath .. "uimicromenu2x.tga"
            charBtn:SetNormalTexture(path)
            if charBtn:GetNormalTexture() then
                charBtn:GetNormalTexture():SetTexCoord(2/256, 37/256, 324/512, 372/512)
                charBtn:GetNormalTexture():Show()
            end
            charBtn:SetPushedTexture(path)
            if charBtn:GetPushedTexture() then
                charBtn:GetPushedTexture():SetTexCoord(82/256, 116/256, 216/512, 264/512)
            end
            charBtn:SetHighlightTexture(path)
            if charBtn:GetHighlightTexture() then
                charBtn:GetHighlightTexture():SetTexCoord(82/256, 116/256, 216/512, 264/512)
            end
        end
    end

    function Setup:HideOtherUI()
        if MicroButtonPortrait then MicroButtonPortrait:Hide() end
        if ShopMicroButton then ShopMicroButton:Hide() end
        if PVPMicroButton then PVPMicroButton:Hide() end

        if LFT then LFT:Hide() end
        if MinimapShopFrame then MinimapShopFrame:Hide() end
        if TWMiniMapBattlefieldFrame then TWMiniMapBattlefieldFrame:Hide() end
    end

    function Setup:DisableBlizzardFPS()
        UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = nil
        if FramerateLabel then
            FramerateLabel:ClearAllPoints()
            FramerateLabel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            FramerateLabel:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
            FramerateLabel:SetTextColor(1, 1, 1, 0)
        end
        if FramerateText then
            FramerateText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
            FramerateText:SetTextColor(1, 1, 1, 0)
        end
    end

    function Setup:NetStats()
        self.netStatsFrame = CreateFrame("Frame", "DFRL_NetStatsFrame", UIParent)
        self.netStatsFrame:SetPoint("BOTTOMRIGHT", CharacterMicroButton, "BOTTOMLEFT", -10, -1)
        self.netStatsFrame:SetWidth(98)
        self.netStatsFrame:SetHeight(26)
        self.netStatsFrame:SetClampedToScreen(true)

        self.netStatsFrameBG = self.netStatsFrame:CreateTexture(nil, "BACKGROUND")
        self.netStatsFrameBG:SetAllPoints(self.netStatsFrame)
        self.netStatsFrameBG:SetTexture(0, 0, 0, 0.3)

        local size = 9

        self.msText = self.netStatsFrame:CreateFontString(nil, "OVERLAY")
        self.msText:SetPoint("TOPRIGHT", self.netStatsFrame, "TOPRIGHT", -8, -2)
        self.msText:SetFont("Fonts\\FRIZQT__.TTF", size, "")
        self.msText:SetTextColor(1, 1, 1, 1)

        self.bwText = self.netStatsFrame:CreateFontString(nil, "OVERLAY")
        self.bwText:SetPoint("TOPRIGHT", self.msText, "BOTTOMRIGHT", 0, -3)
        self.bwText:SetFont("Fonts\\FRIZQT__.TTF", size, "")
        self.bwText:SetTextColor(1, 1, 1, 1)

        self.fpsText = self.netStatsFrame:CreateFontString(nil, "OVERLAY")
        self.fpsText:SetPoint("RIGHT", self.msText, "LEFT", -10, 0)
        self.fpsText:SetFont("Fonts\\FRIZQT__.TTF", size, "")
        self.fpsText:SetTextColor(1, 1, 1, 1)

        self.latencyIndicator = CreateFrame("Frame", "DFRL_LatencyIndicator", UIParent)
        self.latencyIndicator:SetPoint("TOP", HelpMicroButton, "BOTTOM", 0, 7)
        self.latencyIndicator:SetWidth(20)
        self.latencyIndicator:SetHeight(15)

        self.latencyTexture = self.latencyIndicator:CreateTexture(nil, "ARTWORK")
        self.latencyTexture:SetAllPoints(self.latencyIndicator)

        self.netStatsFrame:SetScript("OnUpdate", function()
            if (this.tick or 0) > GetTime() then return end
            this.tick = GetTime() + 0.5

            local bandwidthIn, bandwidthOut, latencyHome = GetNetStats()
            self.msText:SetText(string.format("MS: %d", latencyHome))
            self.bwText:SetText(string.format("UL/DL: %.1f / %.1f", bandwidthIn, bandwidthOut))
            self.fpsText:SetText(string.format("FPS: %d", GetFramerate()))
        end)

        self.latencyIndicator:SetScript("OnUpdate", function()
            if (this.tick or 0) > GetTime() then return end
            this.tick = GetTime() + 2

            local _, _, latencyHome = GetNetStats()
            if latencyHome < 100 then
                self.latencyTexture:SetTexture(self.texpath.. "LatencyGreen.tga")
            elseif latencyHome < 200 then
                self.latencyTexture:SetTexture(self.texpath.. "LatencyYellow.tga")
            else
                self.latencyTexture:SetTexture(self.texpath.. "LatencyRed.tga")
            end
        end)

        self.netStatsFrame:Hide()

        hooksecurefunc("ToggleFramerate", function()
            local checkTimer = CreateFrame("Frame")
            checkTimer:SetScript("OnUpdate", function()
                if (this.tick or 0) > GetTime() then return end
                this.tick = GetTime() + 0.1

                if FramerateLabel and FramerateLabel:IsVisible() then
                    self.netStatsFrame:Show()
                    DFRL.activeScripts["NetStatsFrameScript"] = true
                else
                    self.netStatsFrame:Hide()
                    DFRL.activeScripts["NetStatsFrameScript"] = false
                end
                checkTimer:SetScript("OnUpdate", nil)
            end)
        end)
    end

    function Setup:Run()
        self:CreateContainer()
        self:BlizzardButtons()
        self:PvPButton()
        self:LFTButton()
        self:EBCButton()
        self:ArrangeButtons()
        self:HideOtherUI()

        self:DisableBlizzardFPS()
        self:NetStats()
    end

    -- init setup
    Setup:Run()

    -- expose
    DFRL.microMenuContainer = Setup.microMenuContainer
    DFRL.netStatsFrame = Setup.netStatsFrame
    DFRL.gameMenuButton = MainMenuMicroButton

    -- callbacks
    local callbacks = {}

    callbacks.microDarkMode = function(value)
        local intensity = DFRL:GetTempDB("Micro", "microDarkMode")
        local darkColor = {1 - intensity, 1 - intensity, 1 - intensity}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        for _, button in ipairs(Setup.buttons) do
            local normalTexture = button:GetNormalTexture()
            if normalTexture then
                normalTexture:SetVertexColor(color[1], color[2], color[3])
            end
        end

        if DFRL.lowLevelTalentsButton then
            local normalTexture = DFRL.lowLevelTalentsButton:GetNormalTexture()
            if normalTexture then
                normalTexture:SetVertexColor(color[1], color[2], color[3])
            end
        end
    end

    callbacks.microScale = function(value)
        if DFRL.microMenuContainer then
            DFRL.microMenuContainer:SetScale(value)
        end
    end

    callbacks.microAlpha = function(value)
        if DFRL.microMenuContainer then
            DFRL.microMenuContainer:SetAlpha(value)
        end
    end

    callbacks.microSpacing = function(value)
        if DFRL.microMenuContainer and Setup.buttons then
            for i, button in ipairs(Setup.buttons) do
                button:ClearAllPoints()
                local xOffset = (i-1) * (Setup.buttonWidth + value)
                button:SetPoint("TOPLEFT", DFRL.microMenuContainer, "TOPLEFT", xOffset, 0)
            end

            DFRL.microMenuContainer:SetWidth((Setup.buttonWidth + value) * table.getn(Setup.buttons))
        end
    end

    callbacks.switchColor = function(value)
        if value then
            local colorpath = Setup.texpath.. "color_micro\\"

            if Setup.buttons[2] then
                Setup.buttons[2]:SetNormalTexture(colorpath .. "spellbook-regular.tga")
                Setup.buttons[2]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[2]:SetPushedTexture(colorpath .. "spellbook-faded.tga")
                Setup.buttons[2]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[2]:SetHighlightTexture(colorpath .. "spellbook-highlight.tga")
                Setup.buttons[2]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[3] then
                Setup.buttons[3]:SetNormalTexture(colorpath .. "talents-regular.tga")
                Setup.buttons[3]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[3]:SetPushedTexture(colorpath .. "talents-faded.tga")
                Setup.buttons[3]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[3]:SetHighlightTexture(colorpath .. "talents-highlight.tga")
                Setup.buttons[3]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            Setup:LowLevelTalentButton()

            if Setup.buttons[4] then
                Setup.buttons[4]:SetNormalTexture(colorpath .. "quest-regular.tga")
                Setup.buttons[4]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[4]:SetPushedTexture(colorpath .. "quest-faded.tga")
                Setup.buttons[4]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[4]:SetHighlightTexture(colorpath .. "quest-highlight.tga")
                Setup.buttons[4]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[5] then
                Setup.buttons[5]:SetNormalTexture(colorpath .. "tabard-regular.tga")
                Setup.buttons[5]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[5]:SetPushedTexture(colorpath .. "tabard-faded.tga")
                Setup.buttons[5]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[5]:SetHighlightTexture(colorpath .. "tabard-highlight.tga")
                Setup.buttons[5]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[6] then
                Setup.buttons[6]:SetNormalTexture(colorpath .. "book-regular.tga")
                Setup.buttons[6]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[6]:SetPushedTexture(colorpath .. "book-faded.tga")
                Setup.buttons[6]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[6]:SetHighlightTexture(colorpath .. "book-highlight.tga")
                Setup.buttons[6]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[7] then
                Setup.buttons[7]:SetNormalTexture(colorpath .. "eye-regular.tga")
                Setup.buttons[7]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[7]:SetPushedTexture(colorpath .. "eye-faded.tga")
                Setup.buttons[7]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[7]:SetHighlightTexture(colorpath .. "eye-highlight.tga")
                Setup.buttons[7]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[8] then
                Setup.buttons[8]:SetNormalTexture(colorpath .. "horseshoe-regular.tga")
                Setup.buttons[8]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[8]:SetPushedTexture(colorpath .. "horseshoe-faded.tga")
                Setup.buttons[8]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[8]:SetHighlightTexture(colorpath .. "horseshoe-highlight.tga")
                Setup.buttons[8]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[9] then
                Setup.buttons[9]:SetNormalTexture(colorpath .. "shield-regular.tga")
                Setup.buttons[9]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[9]:SetPushedTexture(colorpath .. "shield-faded.tga")
                Setup.buttons[9]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[9]:SetHighlightTexture(colorpath .. "shield-highlight.tga")
                Setup.buttons[9]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[10] then
                Setup.buttons[10]:SetNormalTexture(colorpath .. "wow-regular.tga")
                Setup.buttons[10]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[10]:SetPushedTexture(colorpath .. "wow-faded.tga")
                Setup.buttons[10]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[10]:SetHighlightTexture(colorpath .. "wow-highlight.tga")
                Setup.buttons[10]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[11] then
                Setup.buttons[11]:SetNormalTexture(colorpath .. "question-regular.tga")
                Setup.buttons[11]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[11]:SetPushedTexture(colorpath .. "question-faded.tga")
                Setup.buttons[11]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[11]:SetHighlightTexture(colorpath .. "question-highlight.tga")
                Setup.buttons[11]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end
        else
            if Setup.buttons[2] then
                Setup.buttons[2]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[2]:GetNormalTexture():SetTexCoord(122/256, 157/256, 54/512, 102/512)
                Setup.buttons[2]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[2]:GetPushedTexture():SetTexCoord(190/256, 225/256, 432/512, 480/512)
                Setup.buttons[2]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[2]:GetHighlightTexture():SetTexCoord(190/256, 225/256, 432/512, 480/512)
            end

            if Setup.buttons[3] then
                Setup.buttons[3]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[3]:GetNormalTexture():SetTexCoord(162/256, 197/256, 0/512, 48/512)
                Setup.buttons[3]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[3]:GetPushedTexture():SetTexCoord(82/256, 117/256, 0/512, 48/512)
                Setup.buttons[3]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[3]:GetHighlightTexture():SetTexCoord(82/256, 117/256, 0/512, 48/512)
            end

            Setup:LowLevelTalentButton()

            if Setup.buttons[4] then
                Setup.buttons[4]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[4]:GetNormalTexture():SetTexCoord(202/256, 237/256, 270/512, 318/512)
                Setup.buttons[4]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[4]:GetPushedTexture():SetTexCoord(42/256, 77/256, 432/512, 480/512)
                Setup.buttons[4]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[4]:GetHighlightTexture():SetTexCoord(42/256, 77/256, 432/512, 480/512)
            end

            if Setup.buttons[5] then
                Setup.buttons[5]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[5]:GetNormalTexture():SetTexCoord(42/256, 76/256, 54/512, 102/512)
                Setup.buttons[5]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[5]:GetPushedTexture():SetTexCoord(42/256, 77/256, 0/512, 48/512)
                Setup.buttons[5]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[5]:GetHighlightTexture():SetTexCoord(42/256, 77/256, 0/512, 48/512)
            end

            if Setup.buttons[6] then
                Setup.buttons[6]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[6]:GetNormalTexture():SetTexCoord(0/256, 37/256, 269/512, 319/512)
                Setup.buttons[6]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[6]:GetPushedTexture():SetTexCoord(161/256, 197/256, 161/512, 211/512)
                Setup.buttons[6]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[6]:GetHighlightTexture():SetTexCoord(161/256, 197/256, 161/512, 211/512)
            end

            if Setup.buttons[7] then
                Setup.buttons[7]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[7]:GetNormalTexture():SetTexCoord(0/256, 38/256, 161/512, 211/512)
                Setup.buttons[7]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[7]:GetPushedTexture():SetTexCoord(41/256, 78/256, 107/512, 157/512)
                Setup.buttons[7]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[7]:GetHighlightTexture():SetTexCoord(41/256, 78/256, 107/512, 157/512)
            end

            if Setup.buttons[8] then
                Setup.buttons[8]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[8]:GetNormalTexture():SetTexCoord(82/256, 119/256, 325/512, 374/512)
                Setup.buttons[8]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[8]:GetPushedTexture():SetTexCoord(82/256, 119/256, 378/512, 429/512)
                Setup.buttons[8]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[8]:GetHighlightTexture():SetTexCoord(82/256, 119/256, 378/512, 429/512)
            end

            if Setup.buttons[9] then
                Setup.buttons[9]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[9]:GetNormalTexture():SetTexCoord(162/256, 196/256, 107/512, 157/512)
                Setup.buttons[9]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[9]:GetPushedTexture():SetTexCoord(202/256, 237/256, 54/512, 102/512)
                Setup.buttons[9]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[9]:GetHighlightTexture():SetTexCoord(202/256, 237/256, 54/512, 102/512)
            end

            if Setup.buttons[10] then
                Setup.buttons[10]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[10]:GetNormalTexture():SetTexCoord(2/256, 37/256, 107/512, 157/512)
                Setup.buttons[10]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[10]:GetPushedTexture():SetTexCoord(122/256, 157/256, 323/512, 372/512)
                Setup.buttons[10]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[10]:GetHighlightTexture():SetTexCoord(122/256, 157/256, 323/512, 372/512)
            end

            if Setup.buttons[11] then
                Setup.buttons[11]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[11]:GetNormalTexture():SetTexCoord(202/256, 237/256, 215/512, 265/512)
                Setup.buttons[11]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[11]:GetPushedTexture():SetTexCoord(162/256, 198/256, 215/512, 265/512)
                Setup.buttons[11]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[11]:GetHighlightTexture():SetTexCoord(162/256, 198/256, 215/512, 265/512)
            end
        end
    end

    callbacks.smallFPS = function(value)
        if not Setup.netStatsFrame or not Setup.fpsText or not Setup.msText or not Setup.bwText then return end

        local smallFontSize = 8
        local normalFontSize = 9
        local fontPath = "Fonts\\FRIZQT__.TTF"

        if value then
            Setup.bwText:SetAlpha(0)
            Setup.fpsText:ClearAllPoints()
            Setup.fpsText:SetPoint("TOPRIGHT", Setup.netStatsFrame, "TOPRIGHT", -6, -2)
            Setup.msText:ClearAllPoints()
            Setup.msText:SetPoint("TOPRIGHT", Setup.netStatsFrame, "TOPRIGHT", -6, -14)

            Setup.fpsText:SetFont(fontPath, smallFontSize, "")
            Setup.msText:SetFont(fontPath, smallFontSize, "")

            Setup.netStatsFrame:SetWidth(45)
            Setup.netStatsFrame:SetHeight(25)
        else
            Setup.bwText:SetAlpha(1)
            Setup.msText:ClearAllPoints()
            Setup.msText:SetPoint("TOPRIGHT", Setup.netStatsFrame, "TOPRIGHT", -8, -2)
            Setup.fpsText:ClearAllPoints()
            Setup.fpsText:SetPoint("RIGHT", Setup.msText, "LEFT", -10, 0)

            Setup.fpsText:SetFont(fontPath, normalFontSize, "")
            Setup.msText:SetFont(fontPath, normalFontSize, "")

            Setup.netStatsFrame:SetWidth(98)
            Setup.netStatsFrame:SetHeight(26)
        end
    end

    DFRL.activeScripts["NetStatsFrameScript"] = false

    -- execute callbacks
    DFRL:NewCallbacks("Micro", callbacks)
end)
