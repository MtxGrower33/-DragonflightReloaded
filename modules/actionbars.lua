DFRL:SetDefaults("actionbars", {
    enabled = {true},
    movable = {true},
    hidden = {false},

    -- key = { value, index, elementType, category, Tooltip text}
    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for action bars"},

    multiBarOneScale = {0.95, 37, "slider", {0.2, 2}, "multibar 1", "Adjusts scale of bottom left action bar"},
    multiBarOneSpacing = {6, 2, "slider", {0.1, 20}, "multibar 1", "Adjusts spacing between bottom left action bar buttons"},
    multiBarOneAlpha = {1, 3, "slider", {0.1, 1}, "multibar 1", "Adjusts transparency of bottom left action bar"},

    multiBarTwoScale = {0.9, 4, "slider", {0.2, 2}, "multibar 2", "Adjusts scale of bottom right action bar"},
    multiBarTwoSpacing = {6, 5, "slider", {0.1, 20}, "multibar 2", "Adjusts spacing between bottom right action bar buttons"},
    multiBarTwoAlpha = {1, 6, "slider", {0.1, 1}, "multibar 2", "Adjusts transparency of bottom right action bar"},

    multiBarThreeScale = {0.8, 7, "slider", {0.2, 2}, "multibar 3", "Adjusts scale of left action bar"},
    multiBarThreeSpacing = {6, 8, "slider", {0.1, 20}, "multibar 3", "Adjusts spacing between left action bar buttons"},
    multiBarThreeAlpha = {1, 9, "slider", {0.1, 1}, "multibar 3", "Adjusts transparency of left action bar"},

    multiBarFourScale = {0.8, 10, "slider", {0.2, 2}, "multibar 4", "Adjusts scale of right action bar"},
    multiBarFourSpacing = {6, 11, "slider", {0.1, 20}, "multibar 4", "Adjusts spacing between right action bar buttons"},
    multiBarFourAlpha = {1, 12, "slider", {0.1, 1}, "multibar 4", "Adjusts transparency of right action bar"},

    showGryphoon = {true, 14, "checkbox", "multibar deco", "Show or hide the gryphon/wyvern decorations"},
    altGryphoon = {false, 15, "checkbox", "multibar deco", "Use the alternative gryphon/wyvern textures"},
    flipGryphoon = {false, 16, "checkbox", "multibar deco", "Flip the gryphon/wyvern textures"},
    gryphoonScale = {1, 36, "slider", {0.2, 2}, "multibar deco", "Adjusts the size of the gryphon/wyvern decorations"},
    gryphoonX = {-48, 17, "slider", {-200, 200}, "multibar deco", "Adjusts horizontal position of gryphon/wyvern decorations"},
    gryphoonY = {10, 18, "slider", {-200, 200}, "multibar deco", "Adjusts vertical position of gryphon/wyvern decorations"},

    pagingShow = {true, 19, "checkbox", "multibar paging", "Show or hide the action bar paging buttons"},
    pagingSwap = {true, 45, "checkbox", "multibar paging", "Swap the anchorpoint of the paging buttons"},
    pagingX = {15, 46, "slider", {0, 150}, "multibar paging", "Adjusts horizontal position of paging buttons"},

    hotkeyColour = {{1, 0.82, 0}, 21, "colourslider", "multibar hotkeys", "Changes the colour of keybind text on action buttons"},
    hotkeyShow = {true, 20, "checkbox", "multibar hotkeys", "Show or hide keybind text on action buttons"},
    hotkeyScale = {1, 22, "slider", {0.5, 2}, "multibar hotkeys", "Adjusts the size of keybind text on action buttons"},
    hotkeyX = {0, 23, "slider", {-50, 50}, "multibar hotkeys", "Adjusts horizontal position of keybind text"},
    hotkeyY = {-2, 24, "slider", {-50, 50}, "multibar hotkeys", "Adjusts vertical position of keybind text"},

    macroColour = {{1, 1, 1}, 26, "colourslider", "multibar macros", "Changes the colour of macro text on action buttons"},
    macroShow = {true, 25, "checkbox", "multibar macros", "Show or hide macro text on action buttons"},
    macroScale = {1, 27, "slider", {0.5, 2}, "multibar macros", "Adjusts the size of macro text on action buttons"},
    macroX = {0, 28, "slider", {-50, 50}, "multibar macros", "Adjusts horizontal position of macro text"},
    macroY = {2, 29, "slider", {-50, 50}, "multibar macros", "Adjusts vertical position of macro text"},

    petbarScale = {0.8, 30, "slider", {0.2, 2}, "pet bar", "Adjusts the scale of the pet action bar"},
    petbarSpacing = {6, 32, "slider", {0.1, 20}, "pet bar", "Adjusts spacing between pet action bar buttons"},
    petbarAlpha = {1, 33, "slider", {0.1, 1}, "pet bar", "Adjusts transparency of pet action bar"},

    shapeshiftScale = {0.8, 31, "slider", {0.2, 2}, "shapeshift bar", "Adjusts the scale of the shapeshift bar"},
    shapeshiftSpacing = {6, 34, "slider", {0.1, 20}, "shapeshift bar", "Adjusts spacing between shapeshift buttons"},
    shapeshiftAlpha = {1, 35, "slider", {0.1, 1}, "shapeshift bar", "Adjusts transparency of shapeshift bar"},

})

DFRL:RegisterModule("actionbars", 1, function()
    d:DebugPrint("BOOTING")

    -- hide stuff
    do
        HideFrameTextures(MainMenuBar)
        HideFrameTextures(MainMenuBarArtFrame)
        HideFrameTextures(PetActionBarFrame)

        MainMenuBar:EnableMouse(false)
        MainMenuBarArtFrame:EnableMouse(false)
        PetActionBarFrame:EnableMouse(false)

        ---@diagnostic disable-next-line: undefined-field
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

        -- hide ShapeshiftButton bg
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

    -- reposition bars
    do
        UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = nil
        UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil

        DFRL.mainBar = CreateFrame("Frame", "DFRL_MainBar", UIParent)
        DFRL.mainBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 55)
        DFRL.mainBar:SetHeight(45)
        DFRL.mainBar:SetWidth(500)

        ActionButton1:ClearAllPoints()
        ActionButton1:SetPoint("BOTTOMLEFT", DFRL.mainBar, "BOTTOMLEFT", -0, 0)

        BonusActionButton1:ClearAllPoints()
        BonusActionButton1:SetPoint("BOTTOMLEFT", DFRL.mainBar, "BOTTOMLEFT", -0, 0)

        local actionBarFrame = CreateFrame("Frame", "DFRL_ActionBar", UIParent)
        actionBarFrame:SetPoint("TOPLEFT", ActionButton1, "TOPLEFT", 0, 0)
        actionBarFrame:SetPoint("BOTTOMRIGHT", ActionButton12, "BOTTOMRIGHT", 0, 0)

        MultiBarBottomLeft:ClearAllPoints()
        MultiBarBottomLeft:SetPoint("BOTTOM", actionBarFrame, "TOP", 0, 12)

        MultiBarBottomRight:ClearAllPoints()
        MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 10)

        MultiBarRight:ClearAllPoints()
        MultiBarRight:SetPoint("RIGHT", UIParent, "RIGHT", -15, -50)

        local newPetBar = CreateFrame("Frame", "DFRL_PetBar", UIParent)
        newPetBar:SetPoint("BOTTOM", actionBarFrame, "TOP", 0, 8)
        newPetBar:SetHeight(36)
        newPetBar:SetWidth(360)

        for i=1, 10 do
            local button = _G["PetActionButton"..i]
            button:SetParent(newPetBar)
            button:ClearAllPoints()
            button:SetPoint("LEFT", newPetBar, "LEFT", (i-1)*36, 0)
        end

        local newShapeshiftBar = CreateFrame("Frame", "DFRL_ShapeshiftBar", UIParent)
        newShapeshiftBar:SetPoint("BOTTOM", newPetBar, "TOP", 0, 8)
        newShapeshiftBar:SetHeight(36)
        newShapeshiftBar:SetWidth(360)

        for i=1, 10 do
            local button = _G["ShapeshiftButton"..i]
            button:SetParent(newShapeshiftBar)
            button:ClearAllPoints()
            button:SetPoint("LEFT", newShapeshiftBar, "LEFT", (i-1)*43, 0)
        end

        -- blizz doesnt hide actionbuttons when bonusbuttons are shown, they just put
        -- a texture ontop of them, but i dont want that so I use this workaround
        local bonusBarWatcher = CreateFrame("Frame")
        bonusBarWatcher:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
        bonusBarWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
        bonusBarWatcher:SetScript("OnEvent", function()
            local bonusBarActive = GetBonusBarOffset() > 0
            for i = 1, 12 do
                if bonusBarActive then
                    _G["ActionButton"..i]:SetAlpha(0)
                else
                    _G["ActionButton"..i]:SetAlpha(1)
                end
            end
        end)

        -- expose
        DFRL.actionBarFrame = actionBarFrame
        DFRL.newShapeshiftBar = newShapeshiftBar
        DFRL.newPetBar = newPetBar
    end

    -- retexture buttons
    do
        local borderTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\border.blp"
        local highlightTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\uiactionbariconframehighlight.tga"

        local function AddBorderOverlay(button)
            local overlay = button:CreateTexture(button:GetName() .. "DFRL_BorderOverlay", "OVERLAY")
            overlay:SetTexture(borderTexture)
            overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
            overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
            overlay:SetVertexColor(0.9, 0.9, 0.9, 1)

            button:SetHighlightTexture(highlightTexture)
            local highlight = button:GetHighlightTexture()
            highlight:SetAllPoints(button)
            highlight:SetBlendMode("ADD")

            -- hook original SetNormalTexture function
            local oldSetNormalTexture = button.SetNormalTexture
            button.SetNormalTexture = function(self, tex)
                oldSetNormalTexture(self, tex)

                if tex and tex ~= "Interface\\Buttons\\UI-Quickslot" then
                    overlay:Show()
                else
                    overlay:Hide()
                end
            end

            -- init
            if button:GetNormalTexture() and button:GetNormalTexture():GetTexture() ~= "Interface\\Buttons\\UI-Quickslot" then
                overlay:Show()
            else
                overlay:Hide()
            end
        end

        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "PetActionButton",
            "ShapeshiftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button then
                    AddBorderOverlay(button)
                end
            end
        end
    end

    -- paging buttons
    do
        local pagingContainer = CreateFrame("Frame", "DFRL_PagingContainer", UIParent)
        pagingContainer:SetWidth(ActionBarUpButton:GetWidth())
        pagingContainer:SetHeight(65)
        pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", 15, -1)
        pagingContainer:SetFrameStrata("DIALOG")
        pagingContainer:SetFrameLevel(5)

        ActionBarUpButton:SetNormalTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\page_up_normal.tga")
        ActionBarUpButton:SetPushedTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\page_up_pushed.tga")
        ActionBarUpButton:SetHighlightTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\page_up_highlight.tga")

        ActionBarDownButton:SetNormalTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\page_down_normal.tga")
        ActionBarDownButton:SetPushedTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\page_down_pushed.tga")
        ActionBarDownButton:SetHighlightTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\page_down_highlight.tga")

        ActionBarUpButton:ClearAllPoints()
        ActionBarUpButton:SetPoint("TOP", pagingContainer, "TOP", -1, 0)
        ActionBarUpButton:SetFrameStrata("DIALOG")
        ActionBarUpButton:SetHeight(25)
        ActionBarUpButton:SetWidth(25)

        MainMenuBarPageNumber:ClearAllPoints()
        MainMenuBarPageNumber:SetParent(pagingContainer)
        MainMenuBarPageNumber:SetPoint("CENTER", pagingContainer, "CENTER", -1, 1)

        ActionBarDownButton:ClearAllPoints()
        ActionBarDownButton:SetPoint("BOTTOM", pagingContainer, "BOTTOM", 1, 0)
        ActionBarDownButton:SetFrameStrata("DIALOG")
        ActionBarDownButton:SetHeight(25)
        ActionBarDownButton:SetWidth(25)

        -- expose
        DFRL.pagingContainer = pagingContainer
    end

    -- move bars on conditional
    do
        -- this func will position the actionbars if not user placed
        local function UpdateBarPositions()
            -- check if bars are user placed
            local movable = DFRL:GetConfig("actionbars", "movable")
            if movable ~= true then
                return
            end

            -- get blizz interface setting
            local bottomLeftState, bottomRightState = GetActionBarToggles()

            -- MultiBarBottomRight
            MultiBarBottomRight:ClearAllPoints()
            if bottomLeftState then
                MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 5)
            else
                MultiBarBottomRight:SetPoint("BOTTOM", DFRL.actionBarFrame, "TOP", 0, 10)
            end

            -- PetBar
            DFRL.newPetBar:ClearAllPoints()
            if bottomLeftState and bottomRightState then
                DFRL.newPetBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
            elseif bottomLeftState then
                DFRL.newPetBar:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 9)
            elseif bottomRightState then
                DFRL.newPetBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
            else
                DFRL.newPetBar:SetPoint("BOTTOM", DFRL.actionBarFrame, "TOP", 0, 9)
            end

            -- ShapeshiftBar
            DFRL.newShapeshiftBar:ClearAllPoints()
            if bottomLeftState and bottomRightState then
                DFRL.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
            elseif bottomLeftState then
                DFRL.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 9)
            elseif bottomRightState then
                DFRL.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
            else
                DFRL.newShapeshiftBar:SetPoint("BOTTOM", DFRL.actionBarFrame, "TOP", 0, 9)
            end
        end

        -- small delay otherwise it bugs
        local updateTimer = 0
        local barPositionFrame = CreateFrame("Frame")
        barPositionFrame:RegisterEvent("CVAR_UPDATE")
        barPositionFrame:SetScript("OnEvent", function()
            updateTimer = 1
            barPositionFrame:SetScript("OnUpdate", function()
                updateTimer = updateTimer - arg1
                if updateTimer <= 0 then
                    UpdateBarPositions()
                    barPositionFrame:SetScript("OnUpdate", nil)
                end
            end)
        end)

        -- init
        UpdateBarPositions()
    end

    --hotkey text
    do
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton",
            "ShapeshiftButton", "PetActionButton"
        }

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
            for _, buttonType in ipairs(buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and button.DFRL_KeybindText then
                        local key1 = GetBindingKey(commandMap[buttonType] .. i)
                        if key1 then
                            -- format the key text
                            key1 = string.gsub(key1, "BUTTON", "M")
                            key1 = string.gsub(key1, "SHIFT%-", "S-")
                            key1 = string.gsub(key1, "CTRL%-", "C-")
                            key1 = string.gsub(key1, "ALT%-", "A-")
                            button.DFRL_KeybindText:SetText(key1)
                        else
                            button.DFRL_KeybindText:SetText("")
                        end
                    end
                end
            end
        end

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button then
                    -- hide original hotkey
                    local hotkey = _G[button:GetName() .. "HotKey"]
                    if hotkey then
                        hotkey:Hide()
                    end

                    -- custom keybind text
                    local keybindText = button:CreateFontString(button:GetName() .. "DFRL_KeybindText", "OVERLAY")
                    keybindText:SetPoint("BOTTOM", button, "BOTTOM", 0, -2)
                    keybindText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                    keybindText:SetTextColor(1, 0.82, 0)

                    -- expose
                    button.DFRL_KeybindText = keybindText
                end
            end
        end

        -- event handler
        local bindingFrame = CreateFrame("Frame")
        bindingFrame:RegisterEvent("UPDATE_BINDINGS")
        bindingFrame:SetScript("OnEvent", function()
            UpdateHotkeys()
        end)

        -- init
        UpdateHotkeys()
    end

    -- reposition and recolor macro text
    do
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button then
                    local macroName = _G[button:GetName() .. "Name"]
                    if macroName then
                        macroName:ClearAllPoints()
                        macroName:SetPoint("TOP", button, "TOP", 0, 2)
                        macroName:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
                        macroName:SetTextColor(1, 1, 1, 1)
                    end
                end
            end
        end
    end

    -- action bar background textures
    do
        local barTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\HDActionBar.tga"

        local leftTexture = DFRL.actionBarFrame:CreateTexture("DFRL_ActionBarLeftTexture", "BACKGROUND")
        leftTexture:SetTexture(barTexture)
        leftTexture:SetPoint("RIGHT", ActionButton6, "RIGHT", 3, 0)
        leftTexture:SetPoint("LEFT", ActionButton1, "LEFT", -5, 0)
        leftTexture:SetPoint("TOP", ActionButton1, "TOP", 0, 14)
        leftTexture:SetPoint("BOTTOM", ActionButton1, "BOTTOM", 0, -14)

        local rightTexture = DFRL.actionBarFrame:CreateTexture("DFRL_ActionBarRightTexture", "BACKGROUND")
        rightTexture:SetTexture(barTexture)
        rightTexture:SetPoint("LEFT", ActionButton7, "LEFT", -3, 0)
        rightTexture:SetPoint("RIGHT", ActionButton12, "RIGHT", 5, 0)
        rightTexture:SetPoint("TOP", ActionButton7, "TOP", 0, 14)
        rightTexture:SetPoint("BOTTOM", ActionButton7, "BOTTOM", 0, -14)
        rightTexture:SetTexCoord(1, 0, 0, 1) -- flip
    end

    -- button background textures and borders
    do
        local buttonBgTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\HDActionBarBtn.tga"
        local borderTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\border.blp"

        for i = 1, 12 do
            local bgTexture = DFRL.actionBarFrame:CreateTexture("DFRL_ActionButtonBg" .. i, "BORDER")
            bgTexture:SetTexture(buttonBgTexture)
            bgTexture:SetPoint("CENTER", _G["ActionButton" .. i], "CENTER", 0, 0)
            bgTexture:SetWidth(ActionButton1:GetWidth() + 5)
            bgTexture:SetHeight(ActionButton1:GetHeight() + 5)

            local borderTex = DFRL.actionBarFrame:CreateTexture("DFRL_ActionButtonBorder" .. i, "BORDER")
            borderTex:SetTexture(borderTexture)
            borderTex:SetPoint("CENTER", _G["ActionButton" .. i], "CENTER", 0, 0)
            borderTex:SetWidth(ActionButton1:GetWidth() + 5)
            borderTex:SetHeight(ActionButton1:GetHeight() + 5)
        end
    end

    -- gryphoons
    do
        local gryphonContainer = CreateFrame("Frame", "DFRL_GryphonContainer", UIParent)
        gryphonContainer:SetFrameStrata("HIGH")
        gryphonContainer:SetFrameLevel(10)
        gryphonContainer:SetAllPoints(DFRL.actionBarFrame)

        local leftGryphon = gryphonContainer:CreateTexture("DFRL_LeftGryphon", "OVERLAY")
        local rightGryphon = gryphonContainer:CreateTexture("DFRL_RightGryphon", "OVERLAY")

        leftGryphon:SetPoint("RIGHT", DFRL.actionBarFrame, "LEFT", 45, 10)
        rightGryphon:SetPoint("LEFT", DFRL.actionBarFrame, "RIGHT", -45, 10)

        local faction = UnitFactionGroup("player")
        local texturePath
        if faction == "Alliance" then
            texturePath = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\GryphonNew.tga"
        else
            texturePath = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\WyvernNew.tga"
        end

        leftGryphon:SetTexture(texturePath)
        rightGryphon:SetTexture(texturePath)

        leftGryphon:SetWidth(180)
        leftGryphon:SetHeight(180)
        rightGryphon:SetWidth(180)
        rightGryphon:SetHeight(180)

        rightGryphon:SetTexCoord(1, 0, 0, 1) -- flip
    end

    -- range indicator
    do
        local buttonTypes = {
            "ActionButton",
            "BonusActionButton",
        }

        local function CreateRangeIndicator(button)
            if button.rangeIndicator then
                return -- has indicator
            end

            local dot = button:CreateTexture(nil, "OVERLAY")
            dot:SetTexture("Interface\\Buttons\\WHITE8x8")
            dot:SetVertexColor(1, 0, 0)
            dot:SetWidth(4)
            dot:SetHeight(4)
            dot:SetPoint("TOPRIGHT", button, "TOPRIGHT", -4, -4)
            dot:Hide()

            button.rangeIndicator = dot
        end

        local function IsInRange(button)
            if not button or not button:IsVisible() then
                return true
            end

            local slot = button:GetID()
            if not slot or slot == 0 then
                return true
            end

            if not UnitExists("target") then
                return true
            end

            if not UnitCanAttack("player", "target") then
                return true
            end

            local inRange = IsActionInRange(slot)
            if inRange == 0 then
                return false
            end

            return true
        end

        local function UpdateRangeIndicator(button)
            if not button.rangeIndicator then
                return
            end

            if IsInRange(button) then
                button.rangeIndicator:Hide()
            else
                button.rangeIndicator:Show()
            end
        end

        local function UpdateAllRangeIndicators()
            for _, buttonType in ipairs(buttonTypes) do
                local i = 1
                while true do
                    local button = getglobal(buttonType .. i)
                    if not button then
                        break
                    end
                    UpdateRangeIndicator(button)
                    i = i + 1
                end
            end
        end

        local function InitializeRangeIndicators()
            for _, buttonType in ipairs(buttonTypes) do
                local i = 1
                while true do
                    local button = getglobal(buttonType .. i)
                    if not button then
                        break
                    end
                    CreateRangeIndicator(button)
                    i = i + 1
                end
            end
        end

        local frame = CreateFrame("Frame")
        frame:RegisterEvent("ADDON_LOADED")
        frame:RegisterEvent("PLAYER_TARGET_CHANGED")
        frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("SPELLS_CHANGED")
        frame:SetScript("OnEvent", function()
            if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
                InitializeRangeIndicators()
            end
            UpdateAllRangeIndicators()
        end)

        local updateTimer = 0
        frame:SetScript("OnUpdate", function()
            updateTimer = updateTimer + arg1
            if updateTimer >= 0.1 then
                UpdateAllRangeIndicators()
                updateTimer = 0
            end
        end)
    end

    -- callbacks
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

        if leftGryphon then
            leftGryphon:ClearAllPoints()
            leftGryphon:SetPoint("RIGHT", DFRL.actionBarFrame, "LEFT", -value, DFRL:GetConfig("actionbars", "gryphoonY"))
        end

        if rightGryphon then
            rightGryphon:ClearAllPoints()
            rightGryphon:SetPoint("LEFT", DFRL.actionBarFrame, "RIGHT", value, DFRL:GetConfig("actionbars", "gryphoonY"))
        end
    end

    callbacks.gryphoonY = function(value)
        local leftGryphon = _G["DFRL_LeftGryphon"]
        local rightGryphon = _G["DFRL_RightGryphon"]

        if leftGryphon then
            leftGryphon:ClearAllPoints()
            leftGryphon:SetPoint("RIGHT", DFRL.actionBarFrame, "LEFT", DFRL:GetConfig("actionbars", "gryphoonX"), value)
        end

        if rightGryphon then
            rightGryphon:ClearAllPoints()
            rightGryphon:SetPoint("LEFT", DFRL.actionBarFrame, "RIGHT", -DFRL:GetConfig("actionbars", "gryphoonX"), value)
        end
    end

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

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

        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "PetActionButton",
            "ShapeshiftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
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

    callbacks.hotkeyColour = function(value)
        local r, g, b = unpack(value)

        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button and button.DFRL_KeybindText then
                    button.DFRL_KeybindText:SetTextColor(r, g, b)
                end
            end
        end
    end

    callbacks.hotkeyShow = function(value)
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
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
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button and button.DFRL_KeybindText then
                    button.DFRL_KeybindText:SetFont("Fonts\\FRIZQT__.TTF", 10 * scale, "OUTLINE")
                end
            end
        end
    end

    callbacks.hotkeyX = function(value)
        local xOffset = value
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button and button.DFRL_KeybindText then
                    button.DFRL_KeybindText:ClearAllPoints()
                    button.DFRL_KeybindText:SetPoint("BOTTOM", button, "BOTTOM", xOffset, DFRL:GetConfig("actionbars", "hotkeyY"))
                end
            end
        end
    end

    callbacks.hotkeyY = function(value)
        local yOffset = value
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button and button.DFRL_KeybindText then
                    button.DFRL_KeybindText:ClearAllPoints()
                    button.DFRL_KeybindText:SetPoint("BOTTOM", button, "BOTTOM", DFRL:GetConfig("actionbars", "hotkeyX"), yOffset)
                end
            end
        end
    end

    callbacks.macroColour = function(value)
        local r, g, b = unpack(value)

        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
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
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
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
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button then
                    local macroName = _G[button:GetName() .. "Name"]
                    if macroName then
                        macroName:SetFont("Fonts\\FRIZQT__.TTF", 9 * scale, "OUTLINE")
                    end
                end
            end
        end
    end

    callbacks.macroX = function(value)
        local xOffset = value
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button then
                    local macroName = _G[button:GetName() .. "Name"]
                    if macroName then
                        macroName:ClearAllPoints()
                        macroName:SetPoint("TOP", button, "TOP", xOffset, DFRL:GetConfig("actionbars", "macroY"))
                    end
                end
            end
        end
    end

    callbacks.macroY = function(value)
        local yOffset = value
        local buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"
        }

        for _, buttonType in ipairs(buttonTypes) do
            for i = 1, 12 do
                local button = _G[buttonType .. i]
                if button then
                    local macroName = _G[button:GetName() .. "Name"]
                    if macroName then
                        macroName:ClearAllPoints()
                        macroName:SetPoint("TOP", button, "TOP", DFRL:GetConfig("actionbars", "macroX"), yOffset)
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
                texturePath = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\altGyph.tga"
            else
                texturePath = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\altWyv.tga"
            end
        else
            if faction == "Alliance" then
                texturePath = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\GryphonNew.tga"
            else
                texturePath = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\actionbars\\WyvernNew.tga"
            end
        end

        if leftGryphon and rightGryphon then
            leftGryphon:SetTexture(texturePath)
            rightGryphon:SetTexture(texturePath)

            -- maintain flip
            local isFlipped = DFRL:GetConfig("actionbars", "flipGryphoon")
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
            local isSwapped = DFRL:GetConfig("actionbars", "pagingSwap")
            DFRL.pagingContainer:ClearAllPoints()
            if isSwapped then
                DFRL.pagingContainer:SetPoint("RIGHT", ActionButton1, "LEFT", -value, -1)
            else
                DFRL.pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", value, -1)
            end
        end
    end

    -- execute callbacks
    DFRL:RegisterCallback("actionbars", callbacks)
end)
