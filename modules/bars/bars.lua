DFRL:NewDefaults("Bars", {
    enabled = {true},
    movable = {true},

    barsDarkMode = {0, "slider", {0, 1}, nil, "appearance", 1, "Adjust dark mode intensity", nil, nil},

    mainBarBG = {true, "checkbox", nil, nil, "mainbar", 2, "Show or hide main action bar background", nil, nil},
    mainBarScale = {1, "slider", {0.5, 2}, nil, "mainbar", 3, "Adjusts the scale of the main action bar", nil, nil},
    mainBarSpacing = {6, "slider", {0, 20}, nil, "mainbar", 4, "Adjusts spacing between main action bar buttons", nil, nil},
    mainBarAlpha = {1, "slider", {0.1, 1}, nil, "mainbar", 5, "Adjusts transparency of main action bar", nil, nil},
    highlightColor = {{1, 0.82, 0}, "colour", nil, nil, "mainbar", 6, "Changes the colour of action button highlights", nil, nil},

    multiBarOneShow = {false, "checkbox", nil, nil, "multibar 1", 7, "Show or hide bottom left action bar", nil, nil},
    multiBarOneScale = {1, "slider", {0.2, 2}, nil, "multibar 1", 8, "Adjusts scale of bottom left action bar", nil, nil},
    multiBarOneSpacing = {6, "slider", {0.1, 20}, nil, "multibar 1", 9, "Adjusts spacing between bottom left action bar buttons", nil, nil},
    multiBarOneAlpha = {1, "slider", {0.1, 1}, nil, "multibar 1", 10, "Adjusts transparency of bottom left action bar", nil, nil},
    multiBarOneGrid = {1, "slider", {1, 6}, nil, "multibar 1", 11, "Changes the grid layout of bottom left action bar", nil, nil},

    multiBarTwoShow = {false, "checkbox", nil, nil, "multibar 2", 12, "Show or hide bottom right action bar", nil, nil},
    multiBarTwoScale = {1, "slider", {0.2, 2}, nil, "multibar 2", 13, "Adjusts scale of bottom right action bar", nil, nil},
    multiBarTwoSpacing = {6, "slider", {0.1, 20}, nil, "multibar 2", 14, "Adjusts spacing between bottom right action bar buttons", nil, nil},
    multiBarTwoAlpha = {1, "slider", {0.1, 1}, nil, "multibar 2", 15, "Adjusts transparency of bottom right action bar", nil, nil},
    multiBarTwoGrid = {1, "slider", {1, 6}, nil, "multibar 2", 16, "Changes the grid layout of bottom right action bar", nil, nil},

    multiBarThreeShow = {false, "checkbox", nil, nil, "multibar 3", 17, "Show or hide left side action bar", nil, nil},
    multiBarThreeScale = {0.8, "slider", {0.2, 2}, nil, "multibar 3", 18, "Adjusts scale of left action bar", nil, nil},
    multiBarThreeSpacing = {6, "slider", {0.1, 20}, nil, "multibar 3", 19, "Adjusts spacing between left action bar buttons", nil, nil},
    multiBarThreeAlpha = {1, "slider", {0.1, 1}, nil, "multibar 3", 20, "Adjusts transparency of left action bar", nil, nil},
    multiBarThreeGrid = {6, "slider", {1, 6}, nil, "multibar 3", 21, "Changes the grid layout of left action bar", nil, nil},

    multiBarFourShow = {true, "checkbox", nil, nil, "multibar 4", 22, "Show or hide right side action bar", nil, nil},
    multiBarFourScale = {0.8, "slider", {0.2, 2}, nil, "multibar 4", 23, "Adjusts scale of right action bar", nil, nil},
    multiBarFourSpacing = {6, "slider", {0.1, 20}, nil, "multibar 4", 24, "Adjusts spacing between right action bar buttons", nil, nil},
    multiBarFourAlpha = {1, "slider", {0.1, 1}, nil, "multibar 4", 25, "Adjusts transparency of right action bar", nil, nil},
    multiBarFourGrid = {6, "slider", {1, 6}, nil, "multibar 4", 26, "Changes the grid layout of right action bar", nil, nil},
    showGryphoon = {true, "checkbox", nil, nil, "mainbar deco", 27, "Show or hide the gryphon/wyvern decorations", nil, nil},
    altGryphoon = {false, "checkbox", nil, nil, "mainbar deco", 28, "Use the alternative gryphon/wyvern textures", nil, nil},
    flipGryphoon = {false, "checkbox", nil, nil, "mainbar deco", 29, "Flip the gryphon/wyvern textures", nil, nil},
    gryphoonScale = {1, "slider", {0.2, 2}, nil, "mainbar deco", 30, "Adjusts the size of the gryphon/wyvern decorations", nil, nil},
    gryphoonX = {-48, "slider", {-200, 200, 3}, nil, "mainbar deco", 31, "Adjusts horizontal position of gryphon/wyvern decorations", nil, nil},
    gryphoonY = {10, "slider", {-200, 200, 3}, nil, "mainbar deco", 32, "Adjusts vertical position of gryphon/wyvern decorations", nil, nil},

    pagingShow = {true, "checkbox", nil, nil, "mainbar paging", 33, "Show or hide the action bar paging buttons", nil, nil},
    pagingSwap = {true, "checkbox", nil, nil, "mainbar paging", 34, "Swap the anchorpoint of the paging buttons", nil, nil},
    pagingX = {15, "slider", {0, 150}, nil, "mainbar paging", 35, "Adjusts horizontal position of paging buttons", nil, nil},
    pagingScale = {0.9, "slider", {0.7, 1.8}, nil, "mainbar paging", 36, "Adjusts the scale of the paging buttons", nil, nil},

    hotkeyFont = {"BigNoodleTitling", "dropdown", {
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
    }, nil, "text settings", 37, "Change the font used for the hotkeys and macros", nil, nil},

    hotkeyColour = {{1, 0.82, 0}, "colour", nil, nil, "text settings", 38, "Changes the colour of keybind text on action buttons", nil, nil},
    hotkeyShow = {true, "checkbox", nil, nil, "text settings", 39, "Show or hide keybind text on action buttons", nil, nil},
    hotkeyScale = {1.4, "slider", {0.5, 2}, nil, "text settings", 40, "Adjusts the size of keybind text on action buttons", nil, nil},
    hotkeyX = {0, "slider", {-50, 50}, nil, "text settings", 41, "Adjusts horizontal position of keybind text", nil, nil},
    hotkeyY = {-2, "slider", {-50, 50}, nil, "text settings", 42, "Adjusts vertical position of keybind text", nil, nil},

    macroColour = {{1, 1, 1}, "colour", nil, nil, "text settings", 43, "Changes the colour of macro text on action buttons", nil, nil},
    macroShow = {true, "checkbox", nil, nil, "text settings", 44, "Show or hide macro text on action buttons", nil, nil},
    macroScale = {1.3, "slider", {0.5, 2}, nil, "text settings", 45, "Adjusts the size of macro text on action buttons", nil, nil},
    macroX = {0, "slider", {-50, 50}, nil, "text settings", 46, "Adjusts horizontal position of macro text", nil, nil},
    macroY = {2, "slider", {-50, 50}, nil, "text settings", 47, "Adjusts vertical position of macro text", nil, nil},

    petbarScale = {0.8, "slider", {0.2, 2}, nil, "pet bar", 48, "Adjusts the scale of the pet action bar", nil, nil},
    petbarSpacing = {6, "slider", {0.1, 20}, nil, "pet bar", 49, "Adjusts spacing between pet action bar buttons", nil, nil},
    petbarAlpha = {1, "slider", {0.1, 1}, nil, "pet bar", 50, "Adjusts transparency of pet action bar", nil, nil},

    shapeshiftScale = {0.8, "slider", {0.2, 2}, nil, "shapeshift bar", 51, "Adjusts the scale of the shapeshift bar", nil, nil},
    shapeshiftSpacing = {6, "slider", {0.1, 20}, nil, "shapeshift bar", 52, "Adjusts spacing between shapeshift buttons", nil, nil},
    shapeshiftAlpha = {1, "slider", {0.1, 1}, nil, "shapeshift bar", 53, "Adjusts transparency of shapeshift bar", nil, nil},
})

DFRL:NewMod("Bars", 1, function()
    debugprint(">> BOOTING")
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function()
        f:UnregisterEvent("PLAYER_ENTERING_WORLD")

        --=================
        -- SETUP
        --=================
        local Setup = {
            texpath = "Interface\\AddOns\\-DragonflightReloaded\\media\\tex\\actionbars\\",
            fontpath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\",

            mainBar = nil,
            actionBarFrame = nil,
            newPetBar = nil,
            newShapeshiftBar = nil,
            pagingContainer = nil,
            actionBarBGleft = nil,
            actionBarBGright = nil,
            gryphonContainer = nil,
            leftGryphon = nil,
            rightGryphon = nil,

            buttonTypes = {
                "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
                "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton",
                "ShapeshiftButton", "PetActionButton"
            },

            layouts = {
                [1] = {rows = 1, cols = 12},
                [2] = {rows = 2, cols = 6},
                [3] = {rows = 3, cols = 4},
                [4] = {rows = 4, cols = 3},
                [5] = {rows = 6, cols = 2},
                [6] = {rows = 12, cols = 1}
            },

            hightlightColor = {1, 0.82, 0},

            texts = {
                hotkey = nil,
                macro = nil,
                config = {
                    font = "Fonts\\FRIZQT__.TTF",
                    hotkeyFontSize = 10,
                    macroFontSize = 9,
                    hotkeyColor = {1, 0.82, 0},
                    macroColor = {1, 1, 1},
                    outline = "OUTLINE",
                }
            }
        }

        function Setup:HideBlizzard()
            HideFrameTextures(MainMenuBar)
            HideFrameTextures(MainMenuBarArtFrame)
            HideFrameTextures(PetActionBarFrame)

            MainMenuBar:EnableMouse(false)
            MainMenuBarArtFrame:EnableMouse(false)
            PetActionBarFrame:EnableMouse(false)

            KillFrame(_G.ExhaustionTick)

            SlidingActionBarTexture0:SetTexture(nil)
            SlidingActionBarTexture1:SetTexture(nil)

            BonusActionBarTexture0:Hide()
            BonusActionBarTexture1:Hide()

            ShapeshiftBarLeft:Hide()
            ShapeshiftBarMiddle:Hide()
            ShapeshiftBarRight:Hide()
            ShapeshiftBarLeft:SetAlpha(0)
            ShapeshiftBarMiddle:SetAlpha(0)
            ShapeshiftBarRight:SetAlpha(0)

            for i = 1, 10 do
                local button = _G["ShapeshiftButton"..i]
                if button then
                    local name = button:GetName()
                    local background = _G[name.."Background"]
                    local normalTexture = _G[name.."NormalTexture"]
                    if background then background:Hide() end
                    if normalTexture then normalTexture:Hide() end
                end
            end
        end

        function Setup:MainBarFrames()
            UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil

            self.mainBar = CreateFrame("Frame", "DFRL_MainBar", UIParent)
            self.mainBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 55)
            self.mainBar:SetHeight(45)
            self.mainBar:SetWidth(500)
            self.mainBar:SetClampedToScreen(true)
            self.mainBar:SetFrameStrata("LOW")
            self.mainBar:SetFrameLevel(1)

            ActionButton1:ClearAllPoints()
            ActionButton1:SetPoint("BOTTOMLEFT", self.mainBar, "BOTTOMLEFT", 0, 0)

            BonusActionButton1:ClearAllPoints()
            BonusActionButton1:SetPoint("BOTTOMLEFT", self.mainBar, "BOTTOMLEFT", 0, 0)

            self.actionBarFrame = CreateFrame("Frame", "DFRL_ActionBar", UIParent)
            self.actionBarFrame:SetPoint("TOPLEFT", ActionButton1, "TOPLEFT", 0, 0)
            self.actionBarFrame:SetPoint("BOTTOMRIGHT", ActionButton12, "BOTTOMRIGHT", 0, 0)
            self.actionBarFrame:SetFrameStrata("LOW")
            self.actionBarFrame:SetFrameLevel(2)
        end

        function Setup:RepositionBars()
            local function RepositionBars()
                local movable = DFRL:GetTempDB("Bars", "movable")
                if movable ~= true then return end

                local bottomLeftState = _G["SHOW_MULTI_ACTIONBAR_1"]
                local bottomRightState = _G["SHOW_MULTI_ACTIONBAR_2"]

                if not (DFRL_FRAMEPOS and DFRL_FRAMEPOS["MultiBarBottomRight"]) then
                    MultiBarBottomRight:ClearAllPoints()
                    if bottomLeftState then
                        MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 10)
                    else
                        MultiBarBottomRight:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 10)
                    end
                end

                if self.newPetBar and not (DFRL_FRAMEPOS and DFRL_FRAMEPOS["DFRL_PetBar"]) then
                    self.newPetBar:ClearAllPoints()
                    if bottomLeftState and bottomRightState then
                        self.newPetBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    elseif bottomLeftState then
                        self.newPetBar:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 9)
                    elseif bottomRightState then
                        self.newPetBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    else
                        self.newPetBar:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 9)
                    end
                end

                if self.newShapeshiftBar and not (DFRL_FRAMEPOS and DFRL_FRAMEPOS["DFRL_ShapeshiftBar"]) then
                    self.newShapeshiftBar:ClearAllPoints()
                    if bottomLeftState and bottomRightState then
                        self.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    elseif bottomLeftState then
                        self.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 9)
                    elseif bottomRightState then
                        self.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    else
                        self.newShapeshiftBar:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 9)
                    end
                end
            end

            local updateTimer = 0
            local barPositionFrame = CreateFrame("Frame")
            barPositionFrame:RegisterEvent("CVAR_UPDATE")
            barPositionFrame:SetScript("OnEvent", function()
                updateTimer = 1
                barPositionFrame:SetScript("OnUpdate", function()
                    updateTimer = updateTimer - arg1
                    if updateTimer <= 0 then
                        RepositionBars()
                        barPositionFrame:SetScript("OnUpdate", nil)
                        DFRL.activeScripts["BarRepositionScript"] = false
                    else
                        DFRL.activeScripts["BarRepositionScript"] = true
                    end
                end)
            end)

            RepositionBars()
        end

        function Setup:MainBarBackground()
            self.actionBarBGleft = self.actionBarFrame:CreateTexture("DFRL_ActionBarLeftTexture", "BACKGROUND")
            self.actionBarBGleft:SetTexture(self.texpath .. "HDActionBar.tga")
            self.actionBarBGleft:SetPoint("LEFT", self.actionBarFrame, "LEFT", -6, 0)
            self.actionBarBGleft:SetPoint("RIGHT", self.actionBarFrame, "CENTER", 0, 0)
            self.actionBarBGleft:SetPoint("TOP", self.actionBarFrame, "TOP", 0, 14)
            self.actionBarBGleft:SetPoint("BOTTOM", self.actionBarFrame, "BOTTOM", 0, -14)

            self.actionBarBGright = self.actionBarFrame:CreateTexture("DFRL_ActionBarRightTexture", "BACKGROUND")
            self.actionBarBGright:SetTexture(self.texpath .. "HDActionBar.tga")
            self.actionBarBGright:SetPoint("LEFT", self.actionBarFrame, "CENTER", 0, 0)
            self.actionBarBGright:SetPoint("RIGHT", self.actionBarFrame, "RIGHT", 6, 0)
            self.actionBarBGright:SetPoint("TOP", self.actionBarFrame, "TOP", 0, 14)
            self.actionBarBGright:SetPoint("BOTTOM", self.actionBarFrame, "BOTTOM", 0, -14)
            self.actionBarBGright:SetTexCoord(1, 0, 0, 1)

        end

        function Setup:ButtonBackgroundsAndBorders()
            local buttonBgTexture = self.texpath .. "HDActionBarBtn.tga"
            local borderTexture = self.texpath .. "border.blp"

            for i = 1, 12 do
                local bgTexture = self.actionBarFrame:CreateTexture("DFRL_ActionButtonBg" .. i, "BORDER")
                bgTexture:SetTexture(buttonBgTexture)
                bgTexture:SetPoint("CENTER", _G["ActionButton" .. i], "CENTER", 0, 0)
                bgTexture:SetWidth(ActionButton1:GetWidth() + 5)
                bgTexture:SetHeight(ActionButton1:GetHeight() + 5)

                local borderTex = self.actionBarFrame:CreateTexture("DFRL_ActionButtonBorder" .. i, "BORDER")
                borderTex:SetTexture(borderTexture)
                borderTex:SetPoint("CENTER", _G["ActionButton" .. i], "CENTER", 0, 0)
                borderTex:SetWidth(ActionButton1:GetWidth() + 5)
                borderTex:SetHeight(ActionButton1:GetHeight() + 5)
            end
        end

        function Setup:ButtonBorderHighlight()
            local borderTexture = self.texpath .. "border.blp"
            local highlightTexture = self.texpath .. "uiactionbariconframehighlight.tga"

            for _, buttonType in ipairs(self.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and not button.DFRL_BorderOverlay then
                        local overlayName = button:GetName() .. "DFRL_BorderOverlay"
                        local overlay = button:CreateTexture(overlayName, "OVERLAY")
                        overlay:SetTexture(borderTexture)
                        overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
                        overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
                        overlay:SetVertexColor(0.9, 0.9, 0.9, 1)
                        button.DFRL_BorderOverlay = overlay

                        button:SetHighlightTexture(highlightTexture)
                        local highlight = button:GetHighlightTexture()
                        highlight:SetAllPoints(button)
                        highlight:SetBlendMode("ADD")
                        overlay:Show()
                    end
                end
            end
        end

        function Setup:PositionMultiBars()
            MultiBarBottomLeft:ClearAllPoints()
            MultiBarBottomLeft:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 12)
            MultiBarBottomLeft:SetClampedToScreen(true)
            MultiBarBottomLeft:SetFrameStrata("LOW")
            MultiBarBottomLeft:SetFrameLevel(1)

            MultiBarBottomRight:ClearAllPoints()
            MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 10)
            MultiBarBottomRight:SetClampedToScreen(true)
            MultiBarBottomRight:SetFrameStrata("LOW")
            MultiBarBottomRight:SetFrameLevel(1)

            MultiBarRight:ClearAllPoints()
            MultiBarRight:SetPoint("RIGHT", UIParent, "RIGHT", -15, -50)
            MultiBarRight:SetClampedToScreen(true)
            MultiBarRight:SetFrameStrata("LOW")
            MultiBarRight:SetFrameLevel(1)

            MultiBarLeft:SetClampedToScreen(true)
            MultiBarLeft:SetFrameStrata("LOW")
            MultiBarLeft:SetFrameLevel(1)
        end

        function Setup:PetBar()
            self.newPetBar = CreateFrame("Frame", "DFRL_PetBar", UIParent)
            self.newPetBar:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 8)
            self.newPetBar:SetHeight(36)
            self.newPetBar:SetWidth(360)
            self.newPetBar:SetFrameStrata("LOW")
            self.newPetBar:SetFrameLevel(1)

            for i = 1, 10 do
                local button = _G["PetActionButton"..i]
                button:SetParent(self.newPetBar)
                button:ClearAllPoints()
                button:SetPoint("LEFT", self.newPetBar, "LEFT", (i-1)*36, 0)
            end
        end

        function Setup:ShapeshiftBar()
            self.newShapeshiftBar = CreateFrame("Frame", "DFRL_ShapeshiftBar", UIParent)
            self.newShapeshiftBar:SetPoint("BOTTOM", self.newPetBar, "TOP", 0, 8)
            self.newShapeshiftBar:SetHeight(36)
            self.newShapeshiftBar:SetWidth(360)
            self.newShapeshiftBar:SetFrameStrata("LOW")
            self.newShapeshiftBar:SetFrameLevel(1)

            for i = 1, 10 do
                local button = _G["ShapeshiftButton"..i]
                button:SetParent(self.newShapeshiftBar)
                button:ClearAllPoints()
                button:SetPoint("LEFT", self.newShapeshiftBar, "LEFT", (i-1)*43, 0)
            end
        end

        function Setup:BonusBarWatcher()
            local bonusBarWatcher = CreateFrame("Frame")
            bonusBarWatcher:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
            bonusBarWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
            bonusBarWatcher:SetScript("OnEvent", function()
                local bonusBarActive = GetBonusBarOffset() > 0
                for i = 1, 12 do
                    if bonusBarActive then
                        _G["ActionButton"..i]:SetAlpha(0)
                        _G["ActionButton"..i]:EnableMouse(false)
                    else
                        _G["ActionButton"..i]:SetAlpha(1)
                        _G["ActionButton"..i]:EnableMouse(true)
                    end
                end
            end)
        end

        function Setup:PagingButtons()
            self.pagingContainer = CreateFrame("Frame", "DFRL_PagingContainer", UIParent)
            self.pagingContainer:SetWidth(ActionBarUpButton:GetWidth())
            self.pagingContainer:SetHeight(65)
            self.pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", 15, -1)
            self.pagingContainer:SetFrameStrata("MEDIUM")
            self.pagingContainer:SetFrameLevel(5)

            ActionBarUpButton:SetNormalTexture(self.texpath.. "page_up_normal.tga")
            ActionBarUpButton:SetPushedTexture(self.texpath.. "page_up_pushed.tga")
            ActionBarUpButton:SetHighlightTexture(self.texpath.. "page_up_highlight.tga")

            ActionBarDownButton:SetNormalTexture(self.texpath.. "page_down_normal.tga")
            ActionBarDownButton:SetPushedTexture(self.texpath.. "page_down_pushed.tga")
            ActionBarDownButton:SetHighlightTexture(self.texpath.. "page_down_highlight.tga")

            ActionBarUpButton:ClearAllPoints()
            ActionBarUpButton:SetPoint("TOP", self.pagingContainer, "TOP", -1, 0)
            ActionBarUpButton:SetFrameStrata("MEDIUM")
            ActionBarUpButton:SetFrameLevel(6)
            ActionBarUpButton:SetHeight(25)
            ActionBarUpButton:SetWidth(25)

            MainMenuBarPageNumber:ClearAllPoints()
            MainMenuBarPageNumber:SetParent(self.pagingContainer)
            MainMenuBarPageNumber:SetPoint("CENTER", self.pagingContainer, "CENTER", -1, 1)

            ActionBarDownButton:ClearAllPoints()
            ActionBarDownButton:SetPoint("BOTTOM", self.pagingContainer, "BOTTOM", 1, 0)
            ActionBarDownButton:SetFrameStrata("MEDIUM")
            ActionBarDownButton:SetFrameLevel(6)
            ActionBarDownButton:SetHeight(25)
            ActionBarDownButton:SetWidth(25)
        end

        function Setup:HotkeyMacroText()
            local config = self.texts.config

            local commandMap = {
                ["ActionButton"] = "ACTIONBUTTON",
                ["MultiBarBottomLeftButton"] = "MULTIACTIONBAR1BUTTON",
                ["MultiBarBottomRightButton"] = "MULTIACTIONBAR2BUTTON",
                ["MultiBarRightButton"] = "MULTIACTIONBAR3BUTTON",
                ["MultiBarLeftButton"] = "MULTIACTIONBAR4BUTTON",
                ["BonusActionButton"] = "ACTIONBUTTON",
                ["ShapeshiftButton"] = "SHAPESHIFTBUTTON",
                ["PetActionButton"] = "BONUSACTIONBUTTON"
            }

            local function UpdateHotkeys()
                for _, buttonType in ipairs(Setup.buttonTypes) do
                    for i = 1, 12 do
                        local button = _G[buttonType .. i]
                        if button and button.DFRL_KeybindText then
                            local key1 = GetBindingKey(commandMap[buttonType] .. i)
                            if key1 then
                                key1 = string.gsub(key1, "BUTTON", "M")
                                key1 = string.gsub(key1, "SHIFT%-", "S-")
                                key1 = string.gsub(key1, "CTRL%-", "C-")
                                key1 = string.gsub(key1, "ALT%-", "A-")
                                key1 = string.gsub(key1, "MOUSEWHEELUP", "MWU")
                                key1 = string.gsub(key1, "MOUSEWHEELDOWN", "MWD")
                                button.DFRL_KeybindText:SetText(key1)
                            else
                                button.DFRL_KeybindText:SetText("")
                            end
                        end
                    end
                end
            end

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local hotkey = _G[button:GetName() .. "HotKey"]
                        if hotkey then
                            hotkey:Hide()
                        end

                        local keybindText = button:CreateFontString(button:GetName() .. "DFRL_KeybindText", "OVERLAY")
                        keybindText:SetPoint("BOTTOM", button, "BOTTOM", 0, -2)
                        keybindText:SetFont(config.font, config.hotkeyFontSize, config.outline)
                        keybindText:SetTextColor(unpack(config.hotkeyColor))
                        button.DFRL_KeybindText = keybindText

                        local macroName = _G[button:GetName() .. "Name"]
                        if macroName then
                            macroName:SetFont(config.font, config.macroFontSize, config.outline)
                            macroName:SetTextColor(unpack(config.macroColor))
                        end
                    end
                end
            end

            -- event handler
            if not self.hotkeyBindingFrame then
                self.hotkeyBindingFrame = CreateFrame("Frame", "DFRL_HotkeyBinding")
                self.hotkeyBindingFrame:RegisterEvent("UPDATE_BINDINGS")
                self.hotkeyBindingFrame:SetScript("OnEvent", function()
                    UpdateHotkeys()
                end)
            end

            UpdateHotkeys()
        end

        function Setup:Gryphoons()
            self.gryphonContainer = CreateFrame("Frame", "DFRL_GryphonContainer", UIParent)
            self.gryphonContainer:SetFrameStrata("LOW")
            self.gryphonContainer:SetFrameLevel(3)
            self.gryphonContainer:SetAllPoints(self.actionBarFrame)

            self.leftGryphon = self.gryphonContainer:CreateTexture("DFRL_LeftGryphon", "OVERLAY")
            self.rightGryphon = self.gryphonContainer:CreateTexture("DFRL_RightGryphon", "OVERLAY")

            self.leftGryphon:SetPoint("RIGHT", self.actionBarFrame, "LEFT", 45, 10)
            self.rightGryphon:SetPoint("LEFT", self.actionBarFrame, "RIGHT", -45, 10)

            local faction = UnitFactionGroup("player")
            local texturePath
            if faction == "Alliance" then
                texturePath = self.texpath .. "GryphonNew.tga"
            else
                texturePath = self.texpath .. "WyvernNew.tga"
            end

            self.leftGryphon:SetTexture(texturePath)
            self.rightGryphon:SetTexture(texturePath)

            self.leftGryphon:SetWidth(180)
            self.leftGryphon:SetHeight(180)
            self.rightGryphon:SetWidth(180)
            self.rightGryphon:SetHeight(180)

            self.rightGryphon:SetTexCoord(1, 0, 0, 1)
        end

        function Setup:Run()
            self:HideBlizzard()
            self:MainBarFrames()
            self:PositionMultiBars()
            self:PetBar()
            self:ShapeshiftBar()
            self:BonusBarWatcher()
            self:ButtonBorderHighlight()
            self:PagingButtons()
            self:MainBarBackground()
            self:ButtonBackgroundsAndBorders()
            self:HotkeyMacroText()
            self:Gryphoons()
        end

        --=================
        -- INIT
        --=================
        Setup:Run()

        --=================
        -- EXPOSE
        --=================
        DFRL.mainBar = Setup.mainBar
        DFRL.actionBarFrame = Setup.actionBarFrame
        DFRL.newPetBar = Setup.newPetBar
        DFRL.newShapeshiftBar = Setup.newShapeshiftBar
        DFRL.pagingContainer = Setup.pagingContainer
        DFRL.actionBarBGleft = Setup.actionBarBGleft
        DFRL.actionBarBGright = Setup.actionBarBGright

        --=================
        -- CALLBACKS
        --=================
        local callbacks = {}

        callbacks.multiBarOneScale = function(value)
            local scale = value

            MultiBarBottomLeft:SetScale(scale)
        end

        callbacks.multiBarOneSpacing = function(value)
            local spacing = value
            for i = 2, 12 do
                local button = _G["MultiBarBottomLeftButton"..i]
                button:ClearAllPoints()
                button:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..(i-1)], "RIGHT", spacing, 0)
            end
        end

        callbacks.multiBarOneAlpha = function(value)
            local alpha = value
            MultiBarBottomLeft:SetAlpha(alpha)
        end

        callbacks.multiBarTwoScale = function(value)
            local scale = value
            MultiBarBottomRight:SetScale(scale)
        end

        callbacks.multiBarTwoSpacing = function(value)
            local spacing = value
            for i = 2, 12 do
                local button = _G["MultiBarBottomRightButton"..i]
                button:ClearAllPoints()
                button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..(i-1)], "RIGHT", spacing, 0)
            end
        end

        callbacks.multiBarTwoAlpha = function(value)
            local alpha = value
            MultiBarBottomRight:SetAlpha(alpha)
        end

        callbacks.multiBarThreeScale = function(value)
            local scale = value
            MultiBarLeft:SetScale(scale)
        end

        callbacks.multiBarThreeSpacing = function(value)
            local spacing = value
            for i = 2, 12 do
                local button = _G["MultiBarLeftButton"..i]
                button:ClearAllPoints()
                button:SetPoint("TOP", _G["MultiBarLeftButton"..(i-1)], "BOTTOM", 0, -spacing)
            end
        end

        callbacks.multiBarThreeAlpha = function(value)
            local alpha = value
            MultiBarLeft:SetAlpha(alpha)
        end

        callbacks.multiBarFourScale = function(value)
            local scale = value
            MultiBarRight:SetScale(scale)
        end

        callbacks.multiBarFourSpacing = function(value)
            local spacing = value
            for i = 2, 12 do
                local button = _G["MultiBarRightButton"..i]
                button:ClearAllPoints()
                button:SetPoint("TOP", _G["MultiBarRightButton"..(i-1)], "BOTTOM", 0, -spacing)
            end
        end

        callbacks.multiBarFourAlpha = function(value)
            local alpha = value
            MultiBarRight:SetAlpha(alpha)
        end

        callbacks.gryphoonScale = function(value)
            local scale = value
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            if leftGryphon then
                leftGryphon:SetWidth(180 * scale)
                leftGryphon:SetHeight(180 * scale)
            end

            if rightGryphon then
                rightGryphon:SetWidth(180 * scale)
                rightGryphon:SetHeight(180 * scale)
            end
        end

        callbacks.showGryphoon = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            if leftGryphon then
                if value then
                    leftGryphon:Show()
                else
                    leftGryphon:Hide()
                end
            end

            if rightGryphon then
                if value then
                    rightGryphon:Show()
                else
                    rightGryphon:Hide()
                end
            end
        end

        callbacks.gryphoonX = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]
            local yOffset = DFRL:GetTempDB("Bars", "gryphoonY")

            if leftGryphon then
                leftGryphon:ClearAllPoints()
                leftGryphon:SetPoint("RIGHT", DFRL.actionBarFrame, "LEFT", -value, yOffset)
            end

            if rightGryphon then
                rightGryphon:ClearAllPoints()
                rightGryphon:SetPoint("LEFT", DFRL.actionBarFrame, "RIGHT", value, yOffset)
            end
        end

        callbacks.gryphoonY = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]
            local xOffset = DFRL:GetTempDB("Bars", "gryphoonX")

            if leftGryphon then
                leftGryphon:ClearAllPoints()
                leftGryphon:SetPoint("RIGHT", DFRL.actionBarFrame, "LEFT", -xOffset, value)
            end

            if rightGryphon then
                rightGryphon:ClearAllPoints()
                rightGryphon:SetPoint("LEFT", DFRL.actionBarFrame, "RIGHT", xOffset, value)
            end
        end

        callbacks.barsDarkMode = function(value)
            local intensity = value or 0
            local color = {1 - intensity, 1 - intensity, 1 - intensity}

            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]
            if leftGryphon then leftGryphon:SetVertexColor(color[1], color[2], color[3]) end
            if rightGryphon then rightGryphon:SetVertexColor(color[1], color[2], color[3]) end

            local leftTexture = _G["DFRL_ActionBarLeftTexture"]
            local rightTexture = _G["DFRL_ActionBarRightTexture"]
            if leftTexture then leftTexture:SetVertexColor(color[1], color[2], color[3]) end
            if rightTexture then rightTexture:SetVertexColor(color[1], color[2], color[3]) end

            for i = 1, 12 do
                local borderTex = _G["DFRL_ActionButtonBorder" .. i]
                if borderTex then borderTex:SetVertexColor(color[1], color[2], color[3]) end
            end

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local overlay = _G[button:GetName() .. "DFRL_BorderOverlay"]
                        if overlay then overlay:SetVertexColor(color[1], color[2], color[3]) end
                    end
                end
            end
        end

        callbacks.pagingShow = function(value)
            if DFRL.pagingContainer then
                if value then
                    DFRL.pagingContainer:Show()
                    ActionBarUpButton:Show()
                    ActionBarDownButton:Show()
                    MainMenuBarPageNumber:Show()
                else
                    DFRL.pagingContainer:Hide()
                    ActionBarUpButton:Hide()
                    ActionBarDownButton:Hide()
                    MainMenuBarPageNumber:Hide()
                end
            end
        end

        callbacks.pagingScale = function(value)
            DFRL.pagingContainer:SetScale(value)
        end

        callbacks.hotkeyColour = function(value)
            local r, g, b = unpack(value)

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and button.DFRL_KeybindText then
                        button.DFRL_KeybindText:SetTextColor(r, g, b)
                    end
                end
            end
        end

        callbacks.hotkeyShow = function(value)
            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and button.DFRL_KeybindText then
                        if value then
                            button.DFRL_KeybindText:Show()
                        else
                            button.DFRL_KeybindText:Hide()
                        end
                    end
                end
            end
        end

        callbacks.hotkeyScale = function(value)
            local scale = value
            local fontName = DFRL:GetTempDB("Bars", "hotkeyFont")
            local fontPath

            if fontName == "Expressway" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Expressway.ttf"
            elseif fontName == "Homespun" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Homespun.ttf"
            elseif fontName == "Hooge" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Hooge.ttf"
            elseif fontName == "Myriad-Pro" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Myriad-Pro.ttf"
            elseif fontName == "Prototype" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Prototype.ttf"
            elseif fontName == "PT-Sans-Narrow-Bold" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Bold.ttf"
            elseif fontName == "PT-Sans-Narrow-Regular" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Regular.ttf"
            elseif fontName == "RobotoMono" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\RobotoMono.ttf"
            elseif fontName == "BigNoodleTitling" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\BigNoodleTitling.ttf"
            elseif fontName == "Continuum" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Continuum.ttf"
            elseif fontName == "DieDieDie" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\DieDieDie.ttf"
            else
                fontPath = "Fonts\\FRIZQT__.TTF"
            end

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and button.DFRL_KeybindText then
                        button.DFRL_KeybindText:SetFont(fontPath, 10 * scale, "OUTLINE")
                    end
                end
            end
        end

        callbacks.hotkeyX = function(value)
            local xOffset = value
            local yOffset = DFRL.tempDB["Bars"]["hotkeyY"]

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and button.DFRL_KeybindText then
                        button.DFRL_KeybindText:ClearAllPoints()
                        button.DFRL_KeybindText:SetPoint("BOTTOM", button, "BOTTOM", xOffset, yOffset)
                    end
                end
            end
        end

        callbacks.hotkeyY = function(value)
            local yOffset = value
            local xOffset = DFRL.tempDB["Bars"]["hotkeyX"]

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and button.DFRL_KeybindText then
                        button.DFRL_KeybindText:ClearAllPoints()
                        button.DFRL_KeybindText:SetPoint("BOTTOM", button, "BOTTOM", xOffset, yOffset)
                    end
                end
            end
        end

        callbacks.macroColour = function(value)
            local r, g, b = unpack(value)

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local macroName = _G[button:GetName() .. "Name"]
                        if macroName then
                            macroName:SetTextColor(r, g, b)
                        end
                    end
                end
            end
        end

        callbacks.macroShow = function(value)
            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local macroName = _G[button:GetName() .. "Name"]
                        if macroName then
                            if value then
                                macroName:Show()
                            else
                                macroName:Hide()
                            end
                        end
                    end
                end
            end
        end

        callbacks.macroScale = function(value)
            local scale = value
            local fontName = DFRL:GetTempDB("Bars", "hotkeyFont")
            local fontPath

            if fontName == "Expressway" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Expressway.ttf"
            elseif fontName == "Homespun" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Homespun.ttf"
            elseif fontName == "Hooge" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Hooge.ttf"
            elseif fontName == "Myriad-Pro" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Myriad-Pro.ttf"
            elseif fontName == "Prototype" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Prototype.ttf"
            elseif fontName == "PT-Sans-Narrow-Bold" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Bold.ttf"
            elseif fontName == "PT-Sans-Narrow-Regular" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\PT-Sans-Narrow-Regular.ttf"
            elseif fontName == "RobotoMono" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\RobotoMono.ttf"
            elseif fontName == "BigNoodleTitling" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\BigNoodleTitling.ttf"
            elseif fontName == "Continuum" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\Continuum.ttf"
            elseif fontName == "DieDieDie" then
                fontPath = "Interface\\AddOns\\-DragonflightReloaded\\media\\fnt\\DieDieDie.ttf"
            else
                fontPath = "Fonts\\FRIZQT__.TTF"
            end

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local macroName = _G[button:GetName() .. "Name"]
                        if macroName then
                            macroName:SetFont(fontPath, 9 * scale, "OUTLINE")
                        end
                    end
                end
            end
        end

        callbacks.macroX = function(value)
            local xOffset = value
            local yOffset = DFRL.tempDB["Bars"]["macroY"]

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local macroName = _G[button:GetName() .. "Name"]
                        if macroName then
                            macroName:ClearAllPoints()
                            macroName:SetPoint("TOP", button, "TOP", xOffset, yOffset)
                        end
                    end
                end
            end
        end

        callbacks.macroY = function(value)
            local yOffset = value
            local xOffset = DFRL.tempDB["Bars"]["macroX"]

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local macroName = _G[button:GetName() .. "Name"]
                        if macroName then
                            macroName:ClearAllPoints()
                            macroName:SetPoint("TOP", button, "TOP", xOffset, yOffset)
                        end
                    end
                end
            end
        end

        callbacks.petbarScale = function(value)
            local scale = value
            if DFRL.newPetBar then
                DFRL.newPetBar:SetScale(scale)
            end
        end

        callbacks.shapeshiftScale = function(value)
            local scale = value
            if DFRL.newShapeshiftBar then
                DFRL.newShapeshiftBar:SetScale(scale)
            end
        end

        callbacks.petbarSpacing = function(value)
            local spacing = value
            for i = 2, 10 do
                local button = _G["PetActionButton"..i]
                if button then
                    button:ClearAllPoints()
                    button:SetPoint("LEFT", _G["PetActionButton"..(i-1)], "RIGHT", spacing, 0)
                end
            end
        end

        callbacks.petbarAlpha = function(value)
            local alpha = value
            if DFRL.newPetBar then
                DFRL.newPetBar:SetAlpha(alpha)
            end
        end

        callbacks.shapeshiftSpacing = function(value)
            local spacing = value
            for i = 2, 10 do
                local button = _G["ShapeshiftButton"..i]
                if button then
                    button:ClearAllPoints()
                    button:SetPoint("LEFT", _G["ShapeshiftButton"..(i-1)], "RIGHT", spacing, 0)
                end
            end
        end

        callbacks.shapeshiftAlpha = function(value)
            local alpha = value
            if DFRL.newShapeshiftBar then
                DFRL.newShapeshiftBar:SetAlpha(alpha)
            end
        end

        callbacks.flipGryphoon = function (value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            if value then
                leftGryphon:SetTexCoord(1, 0, 0, 1)
                rightGryphon:SetTexCoord(0, 1, 0, 1)
            else
                leftGryphon:SetTexCoord(0, 1, 0, 1)
                rightGryphon:SetTexCoord(1, 0, 0, 1)
            end
        end

        callbacks.altGryphoon = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            local faction = UnitFactionGroup("player")
            local texturePath

            if value then
                if faction == "Alliance" then
                    texturePath = Setup.texpath.. "altGyph.tga"
                else
                    texturePath = Setup.texpath.. "altWyv.tga"
                end
            else
                if faction == "Alliance" then
                    texturePath = Setup.texpath.. "GryphonNew.tga"
                else
                    texturePath = Setup.texpath.. "WyvernNew.tga"
                end
            end

            if leftGryphon and rightGryphon then
                leftGryphon:SetTexture(texturePath)
                rightGryphon:SetTexture(texturePath)

                -- maintain flip
                local isFlipped = DFRL:GetTempDB("Bars", "flipGryphoon")
                if isFlipped then
                    leftGryphon:SetTexCoord(1, 0, 0, 1)
                    rightGryphon:SetTexCoord(0, 1, 0, 1)
                else
                    leftGryphon:SetTexCoord(0, 1, 0, 1)
                    rightGryphon:SetTexCoord(1, 0, 0, 1)
                end
            end
        end

        callbacks.pagingSwap = function(value)
            if DFRL.pagingContainer then
                DFRL.pagingContainer:ClearAllPoints()
                if value then
                    DFRL.pagingContainer:SetPoint("RIGHT", ActionButton1, "LEFT", -15, -1)
                else
                    DFRL.pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", 15, -1)
                end
            end
        end

        callbacks.pagingX = function(value)
            if DFRL.pagingContainer then
                local isSwapped = DFRL:GetTempDB("Bars", "pagingSwap")
                DFRL.pagingContainer:ClearAllPoints()
                if isSwapped then
                    DFRL.pagingContainer:SetPoint("RIGHT", ActionButton1, "LEFT", -value, -1)
                else
                    DFRL.pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", value, -1)
                end
            end
        end

        callbacks.multiBarOneGrid = function(value)
            -- convert floating point slider value to integer "layouts" index
            local layoutIndex = math.floor(value + 0.5)
            if layoutIndex < 1 then layoutIndex = 1 end
            if layoutIndex > 6 then layoutIndex = 6 end

            local layout = Setup.layouts[layoutIndex]
            if not layout then return end

            local rows = layout.rows
            local cols = layout.cols
            local spacing = DFRL:GetTempDB("Bars", "multiBarOneSpacing")
            local buttonSize = MultiBarBottomLeftButton1:GetWidth()

            for i = 1, 12 do
                local button = _G["MultiBarBottomLeftButton"..i]
                if button then
                    button:ClearAllPoints()

                    local row = math.floor((i-1) / cols)
                    local col = (i-1) - (row * cols)

                    button:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "BOTTOMLEFT",
                        col * (buttonSize + spacing),
                        row * (buttonSize + spacing))
                end
            end

            MultiBarBottomLeft:SetHeight((buttonSize + spacing) * rows - spacing)
            MultiBarBottomLeft:SetWidth((buttonSize + spacing) * cols - spacing)
        end

        callbacks.multiBarTwoGrid = function(value)
            -- convert floating point slider value to integer "layouts" index
            local layoutIndex = math.floor(value + 0.5)
            if layoutIndex < 1 then layoutIndex = 1 end
            if layoutIndex > 6 then layoutIndex = 6 end

            local layout = Setup.layouts[layoutIndex]
            if not layout then return end

            local rows = layout.rows
            local cols = layout.cols
            local spacing = DFRL:GetTempDB("Bars", "multiBarTwoSpacing")
            local buttonSize = MultiBarBottomRightButton1:GetWidth()

            for i = 1, 12 do
                local button = _G["MultiBarBottomRightButton"..i]
                if button then
                    button:ClearAllPoints()

                    local row = math.floor((i-1) / cols)
                    local col = (i-1) - (row * cols)

                    button:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "BOTTOMLEFT",
                        col * (buttonSize + spacing),
                        row * (buttonSize + spacing))
                end
            end

            MultiBarBottomRight:SetHeight((buttonSize + spacing) * rows - spacing)
            MultiBarBottomRight:SetWidth((buttonSize + spacing) * cols - spacing)
        end

        callbacks.multiBarThreeGrid = function(value)
            -- convert floating point slider value to integer "layouts" index
            local layoutIndex = math.floor(value + 0.5)
            if layoutIndex < 1 then layoutIndex = 1 end
            if layoutIndex > 6 then layoutIndex = 6 end

            local layout = Setup.layouts[layoutIndex]
            if not layout then return end

            local rows = layout.rows
            local cols = layout.cols
            local spacing = DFRL:GetTempDB("Bars", "multiBarThreeSpacing")
            local buttonSize = MultiBarLeftButton1:GetWidth()

            for i = 12, 1, -1 do
                local button = _G["MultiBarLeftButton"..i]
                if button then
                    button:ClearAllPoints()

                    local reverseIndex = 13 - i
                    local row = math.floor((reverseIndex-1) / cols)
                    local col = (reverseIndex-1) - (row * cols)

                    button:SetPoint("BOTTOMLEFT", MultiBarLeft, "BOTTOMLEFT",
                        col * (buttonSize + spacing),
                        row * (buttonSize + spacing))
                end
            end

            MultiBarLeft:SetHeight((buttonSize + spacing) * rows - spacing)
            MultiBarLeft:SetWidth((buttonSize + spacing) * cols - spacing)
        end

        callbacks.multiBarFourGrid = function(value)
            -- convert floating point slider value to integer "layouts" index
            local layoutIndex = math.floor(value + 0.5)
            if layoutIndex < 1 then layoutIndex = 1 end
            if layoutIndex > 6 then layoutIndex = 6 end

            local layout = Setup.layouts[layoutIndex]
            if not layout then return end

            local rows = layout.rows
            local cols = layout.cols
            local spacing = DFRL:GetTempDB("Bars", "multiBarFourSpacing")
            local buttonSize = MultiBarRightButton1:GetWidth()

            for i = 12, 1, -1 do
                local button = _G["MultiBarRightButton"..i]
                if button then
                    button:ClearAllPoints()

                    local reverseIndex = 13 - i
                    local row = math.floor((reverseIndex-1) / cols)
                    local col = (reverseIndex-1) - (row * cols)

                    button:SetPoint("BOTTOMLEFT", MultiBarRight, "BOTTOMLEFT",
                        col * (buttonSize + spacing),
                        row * (buttonSize + spacing))
                end
            end

            MultiBarRight:SetHeight((buttonSize + spacing) * rows - spacing)
            MultiBarRight:SetWidth((buttonSize + spacing) * cols - spacing)
        end

        callbacks.mainBarScale = function(value)
            local scale = value

            DFRL.mainBar:SetScale(scale)
            DFRL.actionBarFrame:SetScale(scale)

            for i = 1, 12 do
                local button = _G["ActionButton"..i]
                button:SetScale(scale)

                local bonusButton = _G["BonusActionButton"..i]
                bonusButton:SetScale(scale)

                if i > 1 then
                    button:ClearAllPoints()
                    button:SetPoint("LEFT", _G["ActionButton"..(i-1)], "RIGHT", 6, 0)

                    bonusButton:ClearAllPoints()
                    bonusButton:SetPoint("LEFT", _G["BonusActionButton"..(i-1)], "RIGHT", 6, 0)
                end
            end
        end

        callbacks.mainBarSpacing = function(value)
            local spacing = value
            local buttonSize = ActionButton1:GetWidth()

            for i = 2, 12 do
                local button = _G["ActionButton"..i]
                button:ClearAllPoints()
                button:SetPoint("LEFT", _G["ActionButton"..(i-1)], "RIGHT", spacing, 0)

                local bonusButton = _G["BonusActionButton"..i]
                bonusButton:ClearAllPoints()
                bonusButton:SetPoint("LEFT", _G["BonusActionButton"..(i-1)], "RIGHT", spacing, 0)
            end

            -- adjust width
            local totalWidth = (buttonSize * 12) + (spacing * 11)
            DFRL.mainBar:SetWidth(totalWidth)
            DFRL.actionBarFrame:SetWidth(totalWidth)
        end

        callbacks.mainBarAlpha = function(value)
            local alpha = value

            DFRL.mainBar:SetAlpha(alpha)
            DFRL.actionBarFrame:SetAlpha(alpha)

            for i = 1, 12 do
                local button = _G["ActionButton"..i]
                button:SetAlpha(alpha)

                local bonusButton = _G["BonusActionButton"..i]
                bonusButton:SetAlpha(alpha)
            end
        end

        callbacks.mainBarBG = function(value)
            if DFRL.actionBarBGleft then
                if value then
                    DFRL.actionBarBGleft:Show()
                else
                    DFRL.actionBarBGleft:Hide()
                end
            end

            if DFRL.actionBarBGright then
                if value then
                    DFRL.actionBarBGright:Show()
                else
                    DFRL.actionBarBGright:Hide()
                end
            end
        end

        callbacks.hotkeyFont = function(value)
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

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        -- update keybind
                        if button.DFRL_KeybindText then
                            button.DFRL_KeybindText:SetFont(fontPath, 10 * DFRL:GetTempDB("Bars", "hotkeyScale"), "OUTLINE")
                        end

                        -- update macro
                        local macroName = _G[buttonType .. i .. "Name"]
                        if macroName then
                            macroName:SetFont(fontPath, 10 * DFRL:GetTempDB("Bars", "macroScale"), "OUTLINE")
                        end
                    end
                end
            end
        end

        callbacks.multiBarOneShow = function(value)
            debugprint("[DEBUG] multiBarOneShow called with value: " .. tostring(value))
            debugprint("[DEBUG] Current SHOW_MULTI_ACTIONBAR_1: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_1"]))
            debugprint("[DEBUG] MultiBarBottomLeft visibility before: " .. tostring(MultiBarBottomLeft:IsVisible()))

            if value then
                debugprint("[DEBUG] Showing MultiBarBottomLeft")
                MultiBarBottomLeft:Show()
                _G["SHOW_MULTI_ACTIONBAR_1"] = 1
                Setup:RepositionBars()
            else
                debugprint("[DEBUG] Hiding MultiBarBottomLeft")
                MultiBarBottomLeft:Hide()
                _G["SHOW_MULTI_ACTIONBAR_1"] = nil
                Setup:RepositionBars()
            end

            debugprint("[DEBUG] MultiBarBottomLeft visibility after: " .. tostring(MultiBarBottomLeft:IsVisible()))
            debugprint("[DEBUG] Final SHOW_MULTI_ACTIONBAR_1: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_1"]))
        end

        callbacks.multiBarTwoShow = function(value)
            debugprint("[DEBUG] multiBarTwoShow called with value: " .. tostring(value))
            debugprint("[DEBUG] Current SHOW_MULTI_ACTIONBAR_2: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_2"]))
            debugprint("[DEBUG] MultiBarBottomRight visibility before: " .. tostring(MultiBarBottomRight:IsVisible()))

            if value then
                debugprint("[DEBUG] Showing MultiBarBottomRight")
                MultiBarBottomRight:Show()
                _G["SHOW_MULTI_ACTIONBAR_2"] = 1
                Setup:RepositionBars()
            else
                debugprint("[DEBUG] Hiding MultiBarBottomRight")
                MultiBarBottomRight:Hide()
                _G["SHOW_MULTI_ACTIONBAR_2"] = nil
                Setup:RepositionBars()
            end

            debugprint("[DEBUG] MultiBarBottomRight visibility after: " .. tostring(MultiBarBottomRight:IsVisible()))
            debugprint("[DEBUG] Final SHOW_MULTI_ACTIONBAR_2: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_2"]))
        end

        callbacks.multiBarThreeShow = function(value)
            debugprint("[DEBUG] multiBarThreeShow called with value: " .. tostring(value))
            debugprint("[DEBUG] Current SHOW_MULTI_ACTIONBAR_3: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_3"]))
            debugprint("[DEBUG] MultiBarLeft visibility before: " .. tostring(MultiBarLeft:IsVisible()))

            if value then
                debugprint("[DEBUG] Showing MultiBarLeft")
                MultiBarLeft:Show()
                _G["SHOW_MULTI_ACTIONBAR_3"] = 1
            else
                debugprint("[DEBUG] Hiding MultiBarLeft")
                MultiBarLeft:Hide()
                _G["SHOW_MULTI_ACTIONBAR_3"] = nil
            end

            debugprint("[DEBUG] MultiBarLeft visibility after: " .. tostring(MultiBarLeft:IsVisible()))
            debugprint("[DEBUG] Final SHOW_MULTI_ACTIONBAR_3: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_3"]))
        end

        callbacks.multiBarFourShow = function(value)
            debugprint("[DEBUG] multiBarFourShow called with value: " .. tostring(value))
            debugprint("[DEBUG] Current SHOW_MULTI_ACTIONBAR_4: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_4"]))
            debugprint("[DEBUG] MultiBarRight visibility before: " .. tostring(MultiBarRight:IsVisible()))

            if value then
                debugprint("[DEBUG] Showing MultiBarRight")
                MultiBarRight:Show()
                _G["SHOW_MULTI_ACTIONBAR_4"] = 1
            else
                debugprint("[DEBUG] Hiding MultiBarRight")
                MultiBarRight:Hide()
                _G["SHOW_MULTI_ACTIONBAR_4"] = nil
            end

            debugprint("[DEBUG] MultiBarRight visibility after: " .. tostring(MultiBarRight:IsVisible()))
            debugprint("[DEBUG] Final SHOW_MULTI_ACTIONBAR_4: " .. tostring(_G["SHOW_MULTI_ACTIONBAR_4"]))
        end

        callbacks.highlightColor = function(value)
            Setup.hightlightColor = value

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local highlight = button:GetHighlightTexture()
                        if highlight then
                            highlight:SetVertexColor(unpack(value))
                        end
                    end
                end
            end
        end

        DFRL.activeScripts["BarRepositionScript"] = false

        -- execute callbacks
        DFRL:NewCallbacks("Bars", callbacks)

        _G["MultiActionBar_Update"] = function() end

        local checkboxes = {33, 34, 35, 36}
        for i = 1, 4 do
            local checkbox = _G["UIOptionsFrameCheckButton" .. checkboxes[i]]
            if checkbox then
                checkbox:Hide()
            end
        end

        f:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end)
end)
