DFRL:NewDefaults("Map", {
    enabled = {true},
    mapDarkMode = {0, "slider", {0, 1}, nil, "appearance", 1, "Adjust dark mode intensity", nil, nil},
    mapSquare = {false, "checkbox", nil, nil, "map basic", 2, "Show the Minimap Square design", nil, nil},
    showSunMoon = {false, "checkbox", nil, nil, "map basic", 3, "Show Blzzards sun/moon indicator", nil, nil},
    mapSize = {180, "slider", {140, 350}, nil, "map basic", 4, "Adjusts the overall size of the minimap", "BUG: MOVE CHAR AFTER SETTING MAPSIZE WHEN OUTDOORS (UNFIXABLE)", nil},
    mapAlpha = {1, "slider", {0.1, 1}, nil, "map basic", 5, "Adjusts transparency of the entire minimap", nil, nil},
    mapShadow = {true, "checkbox", nil, nil, "map shadow", 6, "Show or hide the shadow inside the minimap", nil, nil},
    alphaShadow = {0.3, "slider", {0.1, 1}, nil, "map shadow", 7, "Adjusts transparency of the minimap shadow", nil, nil},
    showZoom = {true, "checkbox", nil, nil, "map zoom", 8, "Show or hide zoom buttons on the minimap", nil, nil},
    scaleZoom = {0.8, "slider", {0.2, 2}, nil, "map zoom", 9, "Adjusts size of zoom buttons", nil, nil},
    alphaZoom = {1, "slider", {0.1, 1}, nil, "map zoom", 10, "Adjusts transparency of zoom buttons", nil, nil},
    zoomX = {-5, "slider", {-100, 100}, nil, "map zoom", 11, "Adjusts horizontal position of zoom buttons", nil, nil},
    zoomY = {40, "slider", {-100, 100}, nil, "map zoom", 12, "Adjusts vertical position of zoom buttons", nil, nil},
    showTopPanel = {true, "checkbox", nil, nil, "top panel", 13, "Show or hide the top information panel", nil, nil},
    topPanelWidth = {180, "slider", {100, 600}, nil, "top panel", 14, "Adjusts the width of the top panel", nil, nil},
    topPanelHeight = {12, "slider", {5, 50}, nil, "top panel", 15, "Adjusts the height of the top panel", nil, nil},
    topPanelFont = {"BigNoodleTitling", "dropdown", {
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
    }, nil, "mini text settings", 16, "Change the font used for the minimap", nil, nil},
    zoneTextSize = {10, "slider", {6, 30}, nil, "top panel zone", 17, "Adjusts font size of the zone text", nil, nil},
    zoneTextY = {-3, "slider", {-50, 50}, nil, "top panel zone", 18, "Adjusts vertical position of the zone text", nil, nil},
    zoneTextX = {4, "slider", {-50, 50}, nil, "top panel zone", 19, "Adjusts horizontal position of the zone text", nil, nil},
    mapTime = {true, "checkbox", nil, nil, "top panel time", 20, "Show or hide the time display on the minimap", nil, nil},
    timeSize = {10, "slider", {6, 30}, nil, "top panel time", 21, "Adjusts font size of the time display", nil, nil},
    timeY = {-3, "slider", {-50, 50}, nil, "top panel time", 22, "Adjusts vertical position of the time display", nil, nil},
    timeX = {-4, "slider", {-50, 50}, nil, "top panel time", 23, "Adjusts horizontal position of the time display", nil, nil},
    textColor = {false, "checkbox", nil, nil, "ext. PizzaWorldBuffs", 24, "Colorize the PizzaWorldBuffs Alliance/Horde text", "BUG: slash commands not implemented yet - fix soon", nil},
})

DFRL:NewMod("Map", 1, function()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function()
        -- setup
        local Setup = {
            texpath = "Interface\\AddOns\\-DragonflightReloaded\\media\\tex\\minimap\\",

            minimapBorder = nil,
            minimapShadow = nil,
            topPanel = nil,
            bgTexture = nil,
            timeFrame = nil,
            timeText = nil,
            updateTimer = nil,
            mailIcon = nil,
            questframe = nil,
        }

        function Setup:HideBlizzard()
            Minimap:ClearAllPoints()
            Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -35, -60)
            Minimap:SetFrameStrata("MEDIUM")

            MinimapCluster:EnableMouse(false)
            MinimapBorder:Hide()
            MinimapBorderTop:Hide()
            MinimapToggleButton:Hide()

            GameTimeFrame:SetScale(0.8)
            GameTimeFrame:ClearAllPoints()
            GameTimeFrame:SetPoint("BOTTOMLEFT", Minimap, "TOPRIGHT", -10, -30)
            KillFrame(MinimapShopFrame)
        end

        function Setup:Minimap()
            self.minimapBorder = Minimap:CreateTexture("MinimapBorder", "OVERLAY")
            self.minimapBorder:SetTexture(self.texpath .. "uiminimapborder.tga")

            self.minimapShadow = Minimap:CreateTexture("MinimapShadow", "BORDER")
            self.minimapShadow:SetTexture(self.texpath .. "uiminimapshadow.tga")

            Minimap:EnableMouseWheel(true)
            Minimap:SetScript("OnMouseWheel", function()
                if arg1 > 0 then
                    MinimapZoomIn:Click()
                elseif arg1 < 0 then
                    MinimapZoomOut:Click()
                end
            end)
        end

        function Setup:TopPanel()
            self.topPanel = CreateFrame("Frame", "MinimapTopPanel", Minimap)
            self.topPanel:SetWidth(200)
            self.topPanel:SetHeight(13)
            self.topPanel:SetPoint("BOTTOM", Minimap, "TOP", 0, 30)

            self.bgTexture = self.topPanel:CreateTexture(nil, "BACKGROUND")
            self.bgTexture:SetTexture(self.texpath .. "uiminimap_toppanel.tga")
            self.bgTexture:SetPoint("TOPLEFT", self.topPanel, "TOPLEFT", 0, 0)
            self.bgTexture:SetPoint("BOTTOMRIGHT", self.topPanel, "BOTTOMRIGHT", 5, -20)

            MinimapZoneTextButton:ClearAllPoints()
            MinimapZoneTextButton:SetParent(self.topPanel)
            MinimapZoneTextButton:SetPoint("LEFT", self.topPanel, "LEFT", 4, -2)
            MinimapZoneText:SetJustifyH("LEFT")
            MinimapZoneText:SetFont("Fonts\\FRIZQT__.TTF", 11, "")

            self.timeFrame = CreateFrame("Frame", "MinimapTimeFrame", self.topPanel)
            self.timeFrame:SetWidth(40)
            self.timeFrame:SetHeight(20)
            self.timeFrame:SetPoint("RIGHT", self.topPanel, "RIGHT", -4, -2)
            self.timeFrame:EnableMouse(true)

            self.timeText = self.timeFrame:CreateFontString("MinimapTimeText", "OVERLAY", "GameFontNormal")
            self.timeText:SetPoint("CENTER", self.timeFrame, "CENTER", 0, 0)
            self.timeText:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
            self.timeText:SetTextColor(1, 1, 1, 1)

            self.updateTimer = CreateFrame("Frame")
            self.updateTimer:SetScript("OnUpdate", function()
                if (this.tick or 0) > GetTime() then
                    return
                end
                this.tick = GetTime() + 5

                local localTime = date("%H:%M")
                self.timeText:SetText(localTime)
                DFRL.activeScripts["MapTimeScript"] = true
            end)

            self.timeFrame:SetScript("OnEnter", function()
                GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
                local hour, minute = GetGameTime()
                local serverTime = format("%d:%02d", hour, minute)
                GameTooltip:AddLine("Time")
                GameTooltip:AddLine("Local: " .. date("%H:%M"), 1, 1, 1)
                GameTooltip:AddLine("Server: " .. serverTime, 1, 1, 1)
                GameTooltip:Show()
            end)

            self.timeFrame:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            DFRL.topPanel = self.topPanel
        end

        function Setup:ZoomButtons()
            MinimapZoomIn:ClearAllPoints()
            MinimapZoomIn:SetParent(Minimap)
            MinimapZoomIn:SetPoint("TOPLEFT", Minimap, "BOTTOMRIGHT", -5, 40)
            MinimapZoomIn:SetScale(0.9)

            MinimapZoomIn:SetNormalTexture(self.texpath.. "ZoomIn32.tga")
            MinimapZoomIn:SetDisabledTexture(self.texpath.. "ZoomIn32-disabled.tga")
            MinimapZoomIn:SetHighlightTexture(self.texpath.. "ZoomIn32-over.tga")
            MinimapZoomIn:SetPushedTexture(self.texpath.. "ZoomIn32-push.tga")

            MinimapZoomOut:ClearAllPoints()
            MinimapZoomOut:SetParent(Minimap)
            MinimapZoomOut:SetPoint("TOPRIGHT", MinimapZoomIn, "BOTTOMLEFT", 0, 0)
            MinimapZoomOut:SetScale(0.9)

            MinimapZoomOut:SetNormalTexture(self.texpath.. "ZoomOut32.tga")
            MinimapZoomOut:SetDisabledTexture(self.texpath.. "ZoomOut32-disabled.tga")
            MinimapZoomOut:SetHighlightTexture(self.texpath.. "ZoomOut32-over.tga")
            MinimapZoomOut:SetPushedTexture(self.texpath.. "ZoomOut32-push.tga")
        end

        function Setup:Mail()
            MiniMapMailFrame:ClearAllPoints()
            MiniMapMailFrame:SetPoint("TOPLEFT", self.topPanel, "BOTTOMLEFT", -2, -1)
            MiniMapMailIcon:SetTexture(self.texpath .. "mail.tga")
            MiniMapMailIcon:SetWidth(32)
            MiniMapMailIcon:SetHeight(32)
            MiniMapMailBorder:Hide()

            self.mailIcon = MiniMapMailIcon
        end

        function Setup:Buffs()
            BuffButton0:ClearAllPoints()
            BuffButton0:SetPoint("TOPRIGHT", Setup.topPanel, "TOPLEFT", -50, 0)

            BuffButton8:ClearAllPoints()
            BuffButton8:SetPoint("TOPRIGHT", Setup.topPanel, "TOPLEFT", -50, -15)

            TempEnchant1:ClearAllPoints()
            TempEnchant1:SetPoint("TOPRIGHT", Setup.topPanel, "TOPLEFT", -50, -75)

            BuffButton16:ClearAllPoints()
            BuffButton16:SetPoint("TOPRIGHT", Setup.topPanel, "TOPLEFT", -50, -120)
        end

        function Setup:Tracker()
            MiniMapTrackingFrame:ClearAllPoints()
            MiniMapTrackingFrame:SetPoint("TOPRIGHT", self.topPanel, "TOPLEFT", -15, 0)
            MiniMapTrackingFrame:SetScale(0.6)
            MiniMapTrackingBorder:Hide()
        end

        function Setup:Durability()
            DurabilityFrame:ClearAllPoints()
            ---@diagnostic disable-next-line: redundant-parameter
            DurabilityFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMLEFT", 15, 15)
            DurabilityFrame.SetPoint = function() return end
            DurabilityFrame:SetScale(0.7)
        end

        function Setup:Questlog()
            self.questframe = CreateFrame("Frame", "DFRL_questframe", UIParent)
            self.questframe:SetPoint("LEFT", Minimap, -150, -130)
            self.questframe:SetWidth(170)
            self.questframe:SetHeight(5)

            QuestWatchFrame:SetParent(self.questframe)
            QuestWatchFrame:SetAllPoints(self.questframe)
            QuestWatchFrame:SetFrameLevel(1)
            QuestWatchFrame.SetPoint = function() end

            DFRL.questframe = self.questframe
        end

        function Setup:LFT()
            LFTMinimapButton:Hide()
            LFTMinimapButton:ClearAllPoints()
            LFTMinimapButton:SetParent(Minimap)
            LFTMinimapButton:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 45, 20)
            if LFT_OnQueueEnter and LFT_OnQueueLeave then
                hooksecurefunc("LFT_OnQueueEnter", function()
                    LFTMinimapButton:Show()
                end)
                hooksecurefunc("LFT_OnQueueLeave", function()
                    LFTMinimapButton:Hide()
                end)
            end
        end

        function Setup:EBC()
            if _G.EBC_Minimap then
                _G.EBC_Minimap:Hide()
                _G.EBC_Minimap.Show = function() end

                self.ebcMinimap = _G.EBC_Minimap
            end
        end

        local PWBInit
        function Setup:PizzaWorldBuffs()
            local currentColorMode = true

            function PWBInit(color)
                currentColorMode = color and true or false

                -- single check should be good enough
                local PWB_Panel = _G["DFRL_PWB_Panel"]
                if not PWB_Panel and PizzaWorldBuffs then
                    PWB_Panel = CreateFrame("Frame", "DFRL_PWB_Panel", UIParent)
                    PWB_Panel:SetFrameStrata("MEDIUM")
                    PWB_Panel:SetPoint("TOP", Minimap, "BOTTOM", -0, -45)
                    PWB_Panel:SetWidth(110)
                    PWB_Panel:SetHeight(160)

                    PWB_Panel.bg = PWB_Panel:CreateTexture(nil, "BACKGROUND")
                    PWB_Panel.bg:SetTexture("Interface\\Buttons\\WHITE8X8")
                    PWB_Panel.bg:SetAllPoints()
                    ---@diagnostic disable-next-line: undefined-field
                    PWB_Panel.bg:SetGradientAlpha("VERTICAL", 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0.7)
                    DFRL.PWB_Panel = PWB_Panel
                end

                -- hook
                HookAddonOrVariable("PizzaWorldBuffs", function()
                    local CONTROL = {
                        anchor_point = "TOP",
                        anchor_parent = PWB_Panel,
                        anchor_to = "TOP",
                        x_offset = -0,
                        y_offset = -10,

                        font_path = "Fonts\\FRIZQT__.TTF",
                        font_flags = "OUTLINE",
                        font_custom = 13,
                        font_size = 10,

                        frame_width = 200,
                        frame_height = 20,

                        custom_text  = color and "|cffff9999Horde"    or "|cffddddddHorde",
                        custom_text2 = color and "|cff99ccffAlliance" or "|cffddddddAlliance",
                        custom_text3 = "",

                        line_spacing = 0,

                        color_prefix = "|cffffcc00",
                        color_suffix = "|cffeeeeee",
                        color_header = "|cffeeeeee"
                    }

                    local function getCustomText()
                        if currentColorMode then
                            return "|cffff9999Horde", "|cff99ccffAlliance"
                        else
                            return "|cffddddddHorde", "|cffddddddAlliance"
                        end
                    end

                    local PWB_txt1 = _G["DFRLCustomBuffText"]
                    if not PWB_txt1 then
                        PWB_txt1 = CreateFrame("Frame", "DFRLCustomBuffText", PizzaWorldBuffs.frame)
                        PWB_txt1:SetWidth(CONTROL.frame_width)
                        PWB_txt1:SetHeight(CONTROL.frame_height)
                        PWB_txt1.text = PWB_txt1:CreateFontString(nil, "MEDIUM", "GameFontWhite")
                        PWB_txt1.text:SetPoint("BOTTOM", 0, 0)
                    end
                    -- PWB_txt1.text:SetFont(CONTROL.font_path, CONTROL.font_custom, CONTROL.font_flags)
                    -- PWB_txt1.text:SetText(CONTROL.custom_text)

                    local PWB_txt2 = _G["DFRLCustomBuffText2"]
                    if not PWB_txt2 then
                        PWB_txt2 = CreateFrame("Frame", "DFRLCustomBuffText2", PizzaWorldBuffs.frame)
                        PWB_txt2:SetWidth(CONTROL.frame_width)
                        PWB_txt2:SetHeight(CONTROL.frame_height)
                        PWB_txt2.text = PWB_txt2:CreateFontString(nil, "MEDIUM", "GameFontWhite")
                        PWB_txt2.text:SetPoint("BOTTOM", 0, 0)
                    end
                    -- PWB_txt2.text:SetFont(CONTROL.font_path, CONTROL.font_custom, CONTROL.font_flags)
                    -- PWB_txt2.text:SetText(CONTROL.custom_text2)

                    local PWB_txt3 = _G["DFRLCustomBuffText3"]
                    if not PWB_txt3 then
                        PWB_txt3 = CreateFrame("Frame", "DFRLCustomBuffText3", PizzaWorldBuffs.frame)
                        PWB_txt3:SetWidth(CONTROL.frame_width)
                        PWB_txt3:SetHeight(CONTROL.frame_height)
                        PWB_txt3.text = PWB_txt3:CreateFontString(nil, "MEDIUM", "GameFontWhite")
                        PWB_txt3.text:SetPoint(CONTROL.anchor_point, 0, 0)
                    end
                    -- PWB_txt3.text:SetFont(CONTROL.font_path, CONTROL.font_custom, CONTROL.font_flags)
                    -- PWB_txt3.text:SetText(CONTROL.custom_text3)

                    -- update
                    local hordeText, allianceText = getCustomText()
                    PWB_txt1.text:SetFont(CONTROL.font_path, CONTROL.font_custom, CONTROL.font_flags)
                    PWB_txt1.text:SetText(hordeText)
                    PWB_txt2.text:SetFont(CONTROL.font_path, CONTROL.font_custom, CONTROL.font_flags)
                    PWB_txt2.text:SetText(allianceText)
                    PWB_txt3.text:SetFont(CONTROL.font_path, CONTROL.font_custom, CONTROL.font_flags)
                    PWB_txt3.text:SetText("") -- hack to give us a free space

                    if not PizzaWorldBuffs.frame._dfrl_update_hooked then
                        local originalUpdateFrames = PizzaWorldBuffs.frame.updateFrames
                        PizzaWorldBuffs.frame.updateFrames = function()
                            originalUpdateFrames()

                            local yOffset = 0
                            local frameCount = 0
                            local headerFound = false

                            PizzaWorldBuffs.frame:SetParent(PWB_Panel)
                            PizzaWorldBuffs.frame:ClearAllPoints()
                            PizzaWorldBuffs.frame:SetPoint("TOP", PWB_Panel, "TOP", 0, 0)

                            for i, frame in ipairs(PizzaWorldBuffs.frames) do
                                if frame.frame and frame.frame.text and frame.frame:IsShown() then
                                    if frame.name == "PizzaWorldBuffsHeader" then
                                        headerFound = true

                                        frame.frame:ClearAllPoints()
                                        frame.frame:SetPoint(CONTROL.anchor_point, CONTROL.anchor_parent, CONTROL.anchor_to, CONTROL.x_offset, CONTROL.y_offset + yOffset)
                                        yOffset = yOffset - frame.frame.text:GetHeight() - CONTROL.line_spacing

                                        PWB_txt1:ClearAllPoints()
                                        PWB_txt1:SetPoint(CONTROL.anchor_point, CONTROL.anchor_parent, CONTROL.anchor_to, CONTROL.x_offset, CONTROL.y_offset + yOffset)
                                        PWB_txt1:Show()
                                        yOffset = yOffset - CONTROL.frame_height - CONTROL.line_spacing
                                    else
                                        frameCount = frameCount + 1

                                        if frameCount == 3 then
                                            PWB_txt2:ClearAllPoints()
                                            PWB_txt2:SetPoint(CONTROL.anchor_point, CONTROL.anchor_parent, CONTROL.anchor_to, CONTROL.x_offset, CONTROL.y_offset + yOffset)
                                            PWB_txt2:Show()
                                            yOffset = yOffset - CONTROL.frame_height - CONTROL.line_spacing
                                        end

                                        if frameCount == 5 then
                                            PWB_txt3:ClearAllPoints()
                                            PWB_txt3:SetPoint(CONTROL.anchor_point, CONTROL.anchor_parent, CONTROL.anchor_to, CONTROL.x_offset, CONTROL.y_offset + yOffset)
                                            PWB_txt3:Show()
                                            yOffset = yOffset - CONTROL.frame_height - CONTROL.line_spacing
                                        end

                                        frame.frame:ClearAllPoints()
                                        frame.frame:SetPoint(CONTROL.anchor_point, CONTROL.anchor_parent, CONTROL.anchor_to, CONTROL.x_offset, CONTROL.y_offset + yOffset)
                                        yOffset = yOffset - frame.frame.text:GetHeight() - CONTROL.line_spacing
                                    end

                                    local text = frame.frame.text:GetText()
                                    if text then
                                        frame.frame.text:SetFont(CONTROL.font_path, CONTROL.font_size, CONTROL.font_flags)

                                        text = string.gsub(text, "|c%x%x%x%x%x%x%x%x", "")
                                        text = string.gsub(text, "|r", "")

                                        if frame.name == "PizzaWorldBuffsHeader" then
                                            text = CONTROL.color_header .. text
                                            frame.frame.text:SetText(text)
                                        else
                                            local colonPos = string.find(text, ":")
                                            if colonPos then
                                                local before = string.sub(text, 1, colonPos-1)
                                                local after = string.sub(text, colonPos)
                                                text = CONTROL.color_prefix .. before .. CONTROL.color_suffix .. after
                                                frame.frame.text:SetText(text)
                                            end
                                        end
                                    end
                                end
                            end
                            if not headerFound then
                                PWB_txt1:Hide()
                                PWB_txt2:Hide()
                                PWB_txt3:Hide()
                            end

                            -- update custom frame
                            local hordeText2, allianceText2 = getCustomText()
                            PWB_txt1.text:SetText(hordeText2)
                            PWB_txt2.text:SetText(allianceText2)
                        end
                        PizzaWorldBuffs.frame._dfrl_update_hooked = true
                    end

                    -- force update to apply new color
                    if PizzaWorldBuffs.frame.updateFrames and PizzaWorldBuffs.frames then
                        PizzaWorldBuffs.frame:updateFrames()
                    end
                end)

                -- minimap toggle
                local toggleButton
                if PizzaWorldBuffs then
                    toggleButton = CreateFrame("Button", "MinimapButtonCollectorToggle", UIParent)
                    toggleButton:SetWidth(16)
                    toggleButton:SetHeight(16)
                    toggleButton:SetPoint("TOP", Minimap, "BOTTOM", -1, -15)
                    toggleButton:SetNormalTexture(self.texpath.. "dfrl_collector_toggle.tga")
                    toggleButton:GetNormalTexture():SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
                    toggleButton:SetHighlightTexture(self.texpath.. "dfrl_collector_toggle.tga")
                    toggleButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)

                    local panelVisible = DFRL:GetTempValue("pwb", "visible")
                    if panelVisible == false then
                        PWB_Panel:Hide()
                    else
                        PWB_Panel:Show()
                    end

                    toggleButton:SetScript("OnClick", function()
                        if PWB_Panel:IsVisible() then
                            UIFrameFadeOut(PWB_Panel, 0.3, 1, 0)
                            PWB_Panel.fadeInfo.finishedFunc = PWB_Panel.Hide
                            PWB_Panel.fadeInfo.finishedArg1 = PWB_Panel
                            DFRL:SetTempDBNoCallback("pwb", "visible", false)
                        else
                            PWB_Panel:SetAlpha(0)
                            PWB_Panel:Show()
                            UIFrameFadeIn(PWB_Panel, 0.3, 0, 1)
                            DFRL:SetTempDBNoCallback("pwb", "visible", true)
                        end
                    end)

                    DFRL.PWBtoggleButton = toggleButton
                end
            end

            PWBInit(true)
        end

        -- init setup
        function Setup:Run()
            Setup:HideBlizzard()
            Setup:Minimap()
            Setup:TopPanel()
            Setup:ZoomButtons()
            Setup:Mail()
            Setup:Buffs()
            Setup:Tracker()
            Setup:Durability()
            Setup:Questlog()
            Setup:LFT()
            Setup:EBC()

            -- Setup:Collector()
            Setup:PizzaWorldBuffs()
        end

        Setup:Run()

        -- callbacks
        local callbacks = {}

        local function CalculateTexOffset(size)
            local minSize, maxSize = 140, 350
            local minOffset, maxOffset = 10, 26

            local offset = minOffset + (size - minSize) * (maxOffset - minOffset) / (maxSize - minSize)
            return offset
        end

        callbacks.mapDarkMode = function(value)
            local intensity = DFRL:GetTempDB("Map", "mapDarkMode")
            local darkColor = {1 - intensity, 1 - intensity, 1 - intensity}
            local lightColor = {1, 1, 1}
            local color = value and darkColor or lightColor

            Setup.minimapBorder:SetVertexColor(color[1], color[2], color[3])

            local zoomInNormal = MinimapZoomIn:GetNormalTexture()
            local zoomOutNormal = MinimapZoomOut:GetNormalTexture()
            zoomInNormal:SetVertexColor(color[1], color[2], color[3])
            zoomOutNormal:SetVertexColor(color[1], color[2], color[3])

            local zoomInDisabled = MinimapZoomIn:GetDisabledTexture()
            local zoomOutDisabled = MinimapZoomOut:GetDisabledTexture()
            zoomInDisabled:SetVertexColor(color[1], color[2], color[3])
            zoomOutDisabled:SetVertexColor(color[1], color[2], color[3])

            if DFRL.PWBtoggleButton then
                local pwbNormalTex = DFRL.PWBtoggleButton:GetNormalTexture()
                local pwbHighlightTex = DFRL.PWBtoggleButton:GetHighlightTexture()
                if pwbNormalTex then pwbNormalTex:SetVertexColor(color[1], color[2], color[3]) end
                if pwbHighlightTex then pwbHighlightTex:SetVertexColor(color[1], color[2], color[3]) end
            end
        end

        callbacks.mapSize = function(value)
            Minimap:SetHeight(value)
            Minimap:SetWidth(value)

            local offset = CalculateTexOffset(value)

            Setup.minimapBorder:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -offset, offset)
            Setup.minimapBorder:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", offset, -offset)

            Setup.minimapShadow:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -offset, offset)
            Setup.minimapShadow:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", offset, -offset)
        end

        callbacks.mapShadow = function(value)
            if value then
                Setup.minimapShadow:Show()
            else
                Setup.minimapShadow:Hide()
            end
        end

        callbacks.alphaShadow = function(value)
            Setup.minimapShadow:SetAlpha(value)
        end

        callbacks.showZoom = function(value)
            if value then
                MinimapZoomIn:Show()
                MinimapZoomOut:Show()
            else
                MinimapZoomIn:Hide()
                MinimapZoomOut:Hide()
            end
        end

        callbacks.scaleZoom = function(value)
            MinimapZoomIn:SetScale(value)
            MinimapZoomOut:SetScale(value)
        end

        callbacks.alphaZoom = function(value)
            MinimapZoomIn:SetAlpha(value)
            MinimapZoomOut:SetAlpha(value)
        end

        callbacks.mapAlpha = function(value)
            Minimap:SetAlpha(value)
        end

        callbacks.showTopPanel = function(value)
            if value then
                Setup.topPanel:Show()
            else
                Setup.topPanel:Hide()
            end
        end

        callbacks.topPanelWidth = function(value)
            Setup.topPanel:SetWidth(value)
        end

        callbacks.topPanelHeight = function(value)
            Setup.topPanel:SetHeight(value)
        end

        callbacks.zoneTextSize = function(value)
            local fontPath
            local fontValue = DFRL:GetTempDB("Map", "topPanelFont")
            if fontValue == "Expressway" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Expressway.ttf"
            elseif fontValue == "Homespun" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Homespun.ttf"
            elseif fontValue == "Hooge" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Hooge.ttf"
            elseif fontValue == "Myriad-Pro" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Myriad-Pro.ttf"
            elseif fontValue == "Prototype" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Prototype.ttf"
            elseif fontValue == "PT-Sans-Narrow-Bold" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Bold.ttf"
            elseif fontValue == "PT-Sans-Narrow-Regular" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Regular.ttf"
            elseif fontValue == "RobotoMono" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\RobotoMono.ttf"
            elseif fontValue == "BigNoodleTitling" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\BigNoodleTitling.ttf"
            elseif fontValue == "Continuum" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Continuum.ttf"
            elseif fontValue == "DieDieDie" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\DieDieDie.ttf"
            else
                fontPath = "Fonts\\FRIZQT__.TTF"
            end
            MinimapZoneText:SetFont(fontPath, value, "")
        end

        callbacks.zoneTextY = function(value)
            MinimapZoneTextButton:ClearAllPoints()
            MinimapZoneTextButton:SetPoint("LEFT", Setup.topPanel, "LEFT", DFRL:GetTempDB("Map", "zoneTextX"), value)
        end

        callbacks.zoneTextX = function(value)
            MinimapZoneTextButton:ClearAllPoints()
            MinimapZoneTextButton:SetPoint("LEFT", Setup.topPanel, "LEFT", value, DFRL:GetTempDB("Map", "zoneTextY"))
        end

        callbacks.timeSize = function(value)
            local fontPath
            local fontValue = DFRL:GetTempDB("Map", "topPanelFont")
            if fontValue == "Expressway" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Expressway.ttf"
            elseif fontValue == "Homespun" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Homespun.ttf"
            elseif fontValue == "Hooge" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Hooge.ttf"
            elseif fontValue == "Myriad-Pro" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Myriad-Pro.ttf"
            elseif fontValue == "Prototype" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Prototype.ttf"
            elseif fontValue == "PT-Sans-Narrow-Bold" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Bold.ttf"
            elseif fontValue == "PT-Sans-Narrow-Regular" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Regular.ttf"
            elseif fontValue == "RobotoMono" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\RobotoMono.ttf"
            elseif fontValue == "BigNoodleTitling" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\BigNoodleTitling.ttf"
            elseif fontValue == "Continuum" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Continuum.ttf"
            elseif fontValue == "DieDieDie" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\DieDieDie.ttf"
            else
                fontPath = "Fonts\\FRIZQT__.TTF"
            end
            Setup.timeText:SetFont(fontPath, value, "")
        end

        callbacks.timeY = function(value)
            Setup.timeText:ClearAllPoints()
            Setup.timeText:SetPoint("RIGHT", Setup.topPanel, "RIGHT", DFRL:GetTempDB("Map", "timeX"), value)
        end

        callbacks.timeX = function(value)
            Setup.timeText:ClearAllPoints()
            Setup.timeText:SetPoint("RIGHT", Setup.topPanel, "RIGHT", value, DFRL:GetTempDB("Map", "timeY"))
        end

        callbacks.mapTime = function(value)
            if value then
                Setup.timeText:Show()
            else
                Setup.timeText:Hide()
            end
        end

        callbacks.mapSquare = function(value)
            if value then
                Setup.minimapBorder:SetTexture(Setup.texpath.. "map_dragonflight_square2.tga")
                Setup.minimapShadow:SetTexture(Setup.texpath.. "map_dragonflight_square_shadow.tga")
                Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
            else
                Setup.minimapBorder:SetTexture(Setup.texpath.. "uiminimapborder.tga")
                Setup.minimapShadow:SetTexture(Setup.texpath.. "uiminimapshadow.tga")
                Minimap:SetMaskTexture("Textures\\MinimapMask")
            end
        end

        callbacks.zoomX = function(value)
            MinimapZoomIn:ClearAllPoints()
            MinimapZoomIn:SetPoint("TOPLEFT", Minimap, "BOTTOMRIGHT", value, DFRL:GetTempDB("Map", "zoomY"))
        end

        callbacks.zoomY = function(value)
            MinimapZoomIn:ClearAllPoints()
            MinimapZoomIn:SetPoint("TOPLEFT", Minimap, "BOTTOMRIGHT", DFRL:GetTempDB("Map", "zoomX"), value)
        end

        callbacks.textColor = function(value)
            PWBInit(value and true or false)
        end

        callbacks.showSunMoon = function(value)
            if value then
                GameTimeFrame:Show()
            else
                GameTimeFrame:Hide()
            end
        end

        callbacks.topPanelFont = function(value)
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

            MinimapZoneText:SetFont(fontPath, DFRL:GetTempDB("Map", "zoneTextSize"), "")
            Setup.timeText:SetFont(fontPath, DFRL:GetTempDB("Map", "timeSize"), "")
        end

        -- execute callbacks
        DFRL:NewCallbacks("Map", callbacks)

        f:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end)
end)
