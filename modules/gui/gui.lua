---@diagnostic disable: deprecated
DFRL:SetDefaults("gui", {
    enabled = {true},
    hidden = {true},

})

DFRL:RegisterModule("gui", 2, function()
    d:DebugPrint("BOOTING GUI MODULE")

    local texpath = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\"

    -- control settings
    local debugMode = false
    local enableAnim = not debugMode -- will use later

    -- blizzard
    local pairs = pairs
    local ipairs = ipairs
    local tinsert = table.insert
    local GetNetStats = GetNetStats
    local CreateFrame = CreateFrame
    local GetFramerate = GetFramerate
    local UIFrameFadeIn = UIFrameFadeIn
    local UIFrameFadeOut = UIFrameFadeOut

    -- DFRL
    local gui = DFRL.gui
    local tempDB = DFRL.tempDB
    local defaults = DFRL.defaults
    local performance = DFRL.performance

    -- mainframe
    do
        local mainFrame = CreateFrame("Frame", "DFRLMainFrame", UIParent)
        mainFrame:SetWidth(800)
        mainFrame:SetHeight(600)
        mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 50)
        mainFrame:SetFrameStrata("DIALOG")
        mainFrame:EnableMouse(true)
        mainFrame:SetMovable(true)
        mainFrame:SetClampedToScreen(true)
        mainFrame:RegisterForDrag("LeftButton")
        mainFrame:SetScript("OnMouseDown", function()
            this:StartMoving()
        end)
        mainFrame:SetScript("OnMouseUp", function()
            this:StopMovingOrSizing()
        end)
        mainFrame:SetScale(0.8)

        tinsert(UISpecialFrames, mainFrame:GetName())

        -- DFRL bg tex
        local topLeft = mainFrame:CreateTexture(nil, "ARTWORK")
        topLeft:SetTexture(texpath.. "gui\\gui_topleft.tga")
        topLeft:SetPoint("BOTTOMRIGHT", mainFrame, "CENTER", -0, 0)
        topLeft:SetWidth(512)
        topLeft:SetHeight(512)

        local topRight = mainFrame:CreateTexture(nil, "ARTWORK")
        topRight:SetTexture(texpath.. "gui\\gui_topright.tga")
        topRight:SetPoint("BOTTOMLEFT", mainFrame, "CENTER", 0, 0)
        topRight:SetWidth(512)
        topRight:SetHeight(512)

        local botLeft = mainFrame:CreateTexture(nil, "ARTWORK")
        botLeft:SetTexture(texpath.. "gui\\gui_botleft.tga")
        botLeft:SetPoint("TOPRIGHT", mainFrame, "CENTER", -0, -0)
        botLeft:SetWidth(512)
        botLeft:SetHeight(512)

        local botRight = mainFrame:CreateTexture(nil, "ARTWORK")
        botRight:SetTexture(texpath.. "gui\\gui_botright.tga")
        botRight:SetPoint("TOPLEFT", mainFrame, "CENTER", 0, -0)
        botRight:SetWidth(512)
        botRight:SetHeight(512)

        -- title
        local titleXOffset = -45 -- for future, maybe i change my mind about pos

        local titlePart1 = mainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        titlePart1:SetPoint("TOP", mainFrame, "TOP", titleXOffset, -37)
        titlePart1:SetText("|cFFFFD100Dragonflight:|r")
        titlePart1:SetFont("Fonts\\FRIZQT__.TTF", 17, "OUTLINE")

        local titlePart2 = mainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        titlePart2:SetPoint("TOPLEFT", titlePart1, "TOPRIGHT", 5, 0)
        titlePart2:SetText("|cFFFFFFFFReloaded|r")
        titlePart2:SetFont("Fonts\\FRIZQT__.TTF", 17, "OUTLINE")
        titlePart2:SetAlpha(0)

        local function AnimateTitle()
            titlePart2:SetPoint("TOPLEFT", titlePart1, "TOPRIGHT", 5, -10)

            local titleAnim = CreateFrame("Frame")
            titleAnim.elapsed = 0
            titleAnim.duration = 0.6
            titleAnim:SetScript("OnUpdate", function()
                this.elapsed = this.elapsed + arg1
                if this.elapsed > this.duration then
                    titlePart2:SetPoint("TOPLEFT", titlePart1, "TOPRIGHT", 5, 0)
                    titlePart2:SetAlpha(1)
                    this:SetScript("OnUpdate", nil)
                    return
                end

                local progress = this.elapsed / this.duration
                local yOffset = -10 + (10 * progress)
                titlePart2:SetPoint("TOPLEFT", titlePart1, "TOPRIGHT", 5, yOffset)
                titlePart2:SetAlpha(progress)
            end)
        end

        -- close
        local closeButton = CreateFrame("Button", nil, mainFrame)
        closeButton:SetWidth(21)
        closeButton:SetHeight(21)
        closeButton:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -15, -35)
        closeButton:SetNormalTexture(texpath.. "ui\\close_normal.tga")
        closeButton:SetPushedTexture(texpath.. "ui\\close_pushed.tga")
        closeButton:SetHighlightTexture(texpath.. "ui\\close_normal.tga")
        closeButton:SetScript("OnClick", function()
            gui.Toggle()
        end)

        -- main content area
        local contentFrame = CreateFrame("Frame", "DFRLContentFrame", mainFrame)
        contentFrame:SetWidth(mainFrame:GetWidth() - 45)
        contentFrame:SetHeight(mainFrame:GetHeight() - 95)
        contentFrame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 25, -75)

        -- tabs panel
        local tabFrame = CreateFrame("Frame", "DFRLTabFrame", mainFrame)
        tabFrame:SetWidth(150)
        tabFrame:SetHeight(contentFrame:GetHeight() - 20)
        tabFrame:SetPoint("TOPRIGHT", contentFrame, "TOPLEFT", -9, -30)

        local tabBg = tabFrame:CreateTexture(nil, "BACKGROUND")
        tabBg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        tabBg:SetAllPoints(tabFrame)
        ---@diagnostic disable-next-line: undefined-field
        tabBg:SetGradientAlpha("HORIZONTAL", 0, 0, 0, .8, 0, 0, 0, .1)

        local tabTitle = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        tabTitle:SetPoint("TOP", tabFrame, "TOP", 0, -10)
        tabTitle:SetText("Tabs")
        tabTitle:SetTextColor(1,1,1)
        tabTitle:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")


        -- expose
        gui.mainFrame = mainFrame
        gui.contentFrame = contentFrame
        gui.tabFrame = tabFrame
        gui.closeButton = closeButton

        -- toggle open/hide
        gui.Toggle = function()
            if mainFrame:IsShown() then
                UIFrameFadeOut(mainFrame, 0.3, 1, 0)
                mainFrame.fadeInfo.finishedFunc = mainFrame.Hide
                mainFrame.fadeInfo.finishedArg1 = mainFrame
            else
                mainFrame:SetAlpha(0)
                mainFrame:Show()
                UIFrameFadeIn(mainFrame, 0.3, 0, 1)
                AnimateTitle()
            end
        end

        -- slash
        _G["SLASH_DFRLGUI1"] = "/dfrl"
        _G["SlashCmdList"]["DFRLGUI"] = function()
            gui.Toggle()
        end

        -- debug show/hide
        if debugMode then
            mainFrame:Show()
        else
            mainFrame:Hide()
        end
    end

    -- tabs
    do
        local tabButtons = {}
        local tabPanels = {}
        local selectedTab = nil
        local buttonHeight = 24
        local buttonPadding = 5
        local startY = -40
        local goldHighlight = "Interface\\QuestFrame\\UI-QuestTitleHighlight"

        local function SelectTab(tabName)
            if not tabName then return end
            d:DebugPrint("Selecting tab: " .. tabName)

            -- hide all panels first
            for _, panel in tabPanels do
                panel:Hide()
            end

            -- deselect all buttons (remove highlight and reset text color)
            for _, button in tabButtons do
                button.highlightTexture:Hide()
                -- keep ShaguTweaks tab always white
                if not button.isShaguTab then
                    button.text:SetTextColor(1, 0.82, 0)
                end
            end

            -- select the clicked tab
            if tabPanels[tabName] then
                tabPanels[tabName]:Show()
                tabButtons[tabName].highlightTexture:Show()
                tabButtons[tabName].text:SetTextColor(1, 1, 1)
                selectedTab = tabName
                d:DebugPrint("Successfully switched to tab: " .. tabName)
            end
        end

        -- combined tabs list
        local tabsToCreate = {}

        -- regular modules
        if defaults then
            d:DebugPrint("Adding regular modules to tabs")
            for moduleName, _ in defaults do
                -- skip hidden
                local isHidden = true
                if tempDB and tempDB[moduleName] then
                    if tempDB[moduleName].hidden ~= nil then
                        isHidden = tempDB[moduleName].hidden
                    elseif tempDB[moduleName].hidden and tempDB[moduleName].hidden[1] ~= nil then
                        isHidden = tempDB[moduleName].hidden[1]
                    end
                end

                if not isHidden then
                    tabsToCreate[moduleName] = true
                end
            end
        else
            d:DebugPrint("ERROR: defaults not found!")
        end

        -- shagu
        local shaguHotfix = IsAddOnLoaded("ShaguTweaks")
        if DFRL.shagu or shaguHotfix then
            d:DebugPrint("Adding ShaguTweaks to tabs")
            tabsToCreate["ShaguTweaks"] = true
        end

        -- info
        d:DebugPrint("Adding Info to tabs")
        tabsToCreate["Info"] = true
        tabsToCreate["Modules"] = true

        -- sort list of tab names
        local sortedTabs = {}
        for moduleName in tabsToCreate do
            table.insert(sortedTabs, moduleName)
        end
        table.sort(sortedTabs)

        -- create all tabs
        local tabCount = 0
        for i = 1, table.getn(sortedTabs) do
            local moduleName = sortedTabs[i]
            d:DebugPrint("Creating tab for module: " .. moduleName)

            -- tab button
            local tabButton = CreateFrame("Button", "DFRLTab_"..moduleName, gui.tabFrame)
            tabButton:SetWidth(130)
            tabButton:SetHeight(buttonHeight)
            tabButton:SetPoint("TOPLEFT", gui.tabFrame, "TOPLEFT", 10, startY - (tabCount * (buttonHeight + buttonPadding)))

            -- highlight
            local highlightTexture = tabButton:CreateTexture(nil, "OVERLAY")
            highlightTexture:SetTexture(goldHighlight)
            highlightTexture:SetAllPoints(tabButton)
            highlightTexture:SetBlendMode("ADD")
            highlightTexture:Hide()
            tabButton.highlightTexture = highlightTexture

            -- capitalize
            local displayName = string.upper(string.sub(moduleName, 1, 1)) .. string.sub(moduleName, 2)

            -- special case for shagutweaks
            local buttonText = tabButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            buttonText:SetPoint("LEFT", tabButton, "LEFT", 5, 0)
            buttonText:SetText(displayName)
            if moduleName == "ShaguTweaks" then
                buttonText:SetTextColor(1, 1, 1)
                tabButton.isShaguTab = true
            else
                buttonText:SetTextColor(1, 0.82, 0)
            end
            tabButton.text = buttonText

            -- store moduleName
            tabButton.moduleName = moduleName

            -- content panel
            local tabPanel = CreateFrame("Frame", "DFRLPanel_"..moduleName, gui.contentFrame)
            tabPanel:SetPoint("TOPLEFT", gui.contentFrame, "TOPLEFT", 0, 0)
            tabPanel:SetPoint("BOTTOMRIGHT", gui.contentFrame, "BOTTOMRIGHT", 0, 0)
            tabPanel:Hide()

            local scrollFrame = CreateFrame("ScrollFrame", "DFRLScrollFrame_"..moduleName, tabPanel, "UIPanelScrollFrameTemplate")
            scrollFrame:SetPoint("TOPLEFT", tabPanel, "TOPLEFT", 0, -55)
            scrollFrame:SetPoint("BOTTOMRIGHT", tabPanel, "BOTTOMRIGHT", -25, 5)

            local scrollChild = CreateFrame("Frame", "DFRLScrollChild_"..moduleName, scrollFrame)
            scrollChild:SetWidth(scrollFrame:GetWidth())
            scrollChild:SetHeight(1000)

            scrollFrame:SetScrollChild(scrollChild)

            -- scrolling variables
            local targetScrollValue = 0
            local currentScrollValue = 0
            local scrollSpeed = 0.15
            local isScrolling = false
            local scrollStepSize = 40
            local lastKnownScrollValue = 0

            -- update function for scrolling animation
            local function UpdateSmoothScroll()
                -- check if scroll position was changed (by slider)
                local actualScrollValue = scrollFrame:GetVerticalScroll()
                if actualScrollValue ~= lastKnownScrollValue and not isScrolling then
                    -- slider was used, sync our variables
                    ---@diagnostic disable-next-line: cast-local-type
                    targetScrollValue = actualScrollValue
                    ---@diagnostic disable-next-line: cast-local-type
                    currentScrollValue = actualScrollValue
                    ---@diagnostic disable-next-line: cast-local-type
                    lastKnownScrollValue = actualScrollValue
                    return
                end

                if not isScrolling then
                    return
                end

                local diff = targetScrollValue - currentScrollValue
                if diff > -0.5 and diff < 0.5 then
                    currentScrollValue = targetScrollValue
                    scrollFrame:SetVerticalScroll(currentScrollValue)
                    lastKnownScrollValue = currentScrollValue
                    isScrolling = false
                    return
                end

                -- interpolation
                currentScrollValue = currentScrollValue + (diff * scrollSpeed)
                scrollFrame:SetVerticalScroll(currentScrollValue)
                lastKnownScrollValue = currentScrollValue
            end

            -- update frame for animation
            local updateFrame = CreateFrame("Frame")
            updateFrame:SetScript("OnUpdate", function()
                if (this.tick or 0) > GetTime() then return end
                this.tick = GetTime() + 0.01

                if gui.mainFrame:IsVisible() then
                    UpdateSmoothScroll()
                end
            end)

            -- scrollframe anim handler
            scrollFrame:EnableMouseWheel(true)
            scrollFrame:SetScript("OnMouseWheel", function()
                local delta = arg1
                local maxScroll = scrollChild:GetHeight() - scrollFrame:GetHeight()

                if maxScroll <= 0 then
                    return
                end

                -- calculate new target scroll position
                targetScrollValue = targetScrollValue - (delta * scrollStepSize)

                -- clamp to valid range
                if targetScrollValue < 0 then
                    targetScrollValue = 0
                elseif targetScrollValue > maxScroll then
                    targetScrollValue = maxScroll
                end

                -- start scrolling animation if not already
                if not isScrolling then
                    ---@diagnostic disable-next-line: cast-local-type
                    currentScrollValue = scrollFrame:GetVerticalScroll()
                    isScrolling = true
                end
            end)

            -- store
            tabPanel.scrollFrame = scrollFrame
            tabPanel.scrollChild = scrollChild

            -- title background
            local titleBackground = tabPanel:CreateTexture(nil, "BACKGROUND")
            titleBackground:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
            titleBackground:SetPoint("TOP", tabPanel, "TOP", 0, 0)
            titleBackground:SetWidth(433)
            titleBackground:SetHeight(45)
            -- alpha values for each corner (ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
            ---@diagnostic disable-next-line: undefined-field
            titleBackground:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.01, 0, 0, 0, 0.9)

            local panelTitle = tabPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
            panelTitle:SetPoint("TOP", tabPanel, "TOP", 0, -13)
            panelTitle:SetTextColor(1, 1, 1)
            panelTitle:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
            panelTitle:SetText(displayName)

            -- expose
            tabButtons[moduleName] = tabButton
            tabPanels[moduleName] = tabPanel

            -- handlers
            tabButton:SetScript("OnClick", function()
                SelectTab(this.moduleName)
            end)

            tabButton:SetScript("OnEnter", function()
                if selectedTab ~= this.moduleName then
                    this.highlightTexture:Show()
                end
            end)

            tabButton:SetScript("OnLeave", function()
                if selectedTab ~= this.moduleName then
                    this.highlightTexture:Hide()
                end
            end)

            tabCount = tabCount + 1
            d:DebugPrint("Successfully created tab for: " .. moduleName)
        end

        d:DebugPrint("Total tabs created: " .. tabCount)

        -- expose
        gui.tabButtons = tabButtons
        gui.tabPanels = tabPanels

        -- info on open
        d:DebugPrint("Selecting Info tab")
        SelectTab("Info")
    end

    -- generator
    do
        -- ShaguTweaks metadata for integration
        local shaguTweaks = {
            ["Bag Item Click"]           = { true, 1, "checkbox", "bags",          "Use right-click in bags" },
            ["Bag Search Bar"]           = { true, 2, "checkbox", "bags",          "Adds search bar to bags" },
            ["Auto Dismount"]            = { true, 3, "checkbox", "automation",    "Dismounts when casting a mount" },
            ["Auto Stance"]              = { true, 4, "checkbox", "automation",    "Auto switch stance when needed" },
            ["Cooldown Numbers"]         = { true, 5, "checkbox", "combat",        "Show cooldowns as numbers" },
            ["Debuff Timer"]             = { true, 6, "checkbox", "combat",        "Show debuff durations" },
            ["Enemy Castbars"]           = { true, 7, "checkbox", "castbars & plates", "Show enemy unitframe castbars" },
            ["Nameplate Castbar"]        = { true, 8, "checkbox", "castbars & plates", "Show castbar on nameplates" },
            ["Nameplate Scale"]          = { true, 9, "checkbox", "castbars & plates", "Scale nameplates up or down" },
            ["Super WoW Compatibility"]  = { true, 10, "checkbox", "compatibility", "Support Super WoW addons" },
            ["Turtle WoW Compatibility"] = { true, 11, "checkbox", "compatibility", "Support Turtle WoW server" },
            ["Blue Shaman Class Colors"] = { true, 12, "checkbox", "colors",        "Use blue for Shaman class color" },
            ["Nameplate Class Colors"]   = { true, 13, "checkbox", "colors",        "Class color nameplate text" },
            ["WorldMap Class Colors"]    = { true, 14, "checkbox", "colors",        "Class color map icons" },
            ["Chat History"]             = { true, 15, "checkbox", "chat",          "Save recent chat messages" },
            ["Chat Hyperlinks"]          = { true, 16, "checkbox", "chat",          "Enable clickable links in chat" },
            ["Chat Timestamps"]          = { true, 17, "checkbox", "chat",          "Show timestamps in chat" },
            ["Chat Tweaks"]              = { true, 18, "checkbox", "chat",          "Improves chat window behavior" },
            ["Enable Text Shadow"]       = { true, 19, "checkbox", "chat",          "Add shadow to chat text" },
            ["Social Colors"]            = { true, 20, "checkbox", "chat",          "Color names by social status" },
            ["Macro Icons"]              = { true, 21, "checkbox", "macro",         "Use icons in macro list" },
            ["Macro Tweaks"]             = { true, 22, "checkbox", "macro",         "Macro usability improvements" },
            ["Enable Raid Frames"]       = { true, 23, "checkbox", "raid",          "Enable custom raid frames" },
            ["Hide Party Frames"]        = { true, 24, "checkbox", "raid",          "Hide Blizzard party frames" },
            ["Show Dispel Indicators"]   = { true, 25, "checkbox", "raid",          "Mark dispellable debuffs" },
            ["Use As Party Frames"]      = { true, 26, "checkbox", "raid",          "Display party members in raid" },
            ["Show Group Headers"]       = { true, 27, "checkbox", "raid",          "Display group headers on raid frames" },
            ["Show Healing Predictions"] = { true, 28, "checkbox", "raid",          "Show healcomm healing predictions" },
            ["Show Combat Feedback"]     = { true, 29, "checkbox", "raid",          "Show combat feedback numbers on bars" },
            ["Show Aggro Indicators"]    = { true, 30, "checkbox", "raid",          "Show aggro on raid members" },
            ["Use Compact Layout"]       = { true, 31, "checkbox", "raid",          "Use a compact frame layout" },

            ["Equip Compare"]            = { true, 32, "checkbox", "tooltip",       "Compare items in tooltips" },
            ["Item Rarity Borders"]      = { true, 33, "checkbox", "tooltip",       "Outline tooltips by item quality" },
            ["Tooltip Details"]          = { true, 34, "checkbox", "tooltip",       "Add more info to tooltips" },
            ["Sell Junk"]                = { true, 35, "checkbox", "vendor",        "Auto sell gray items" },
            ["Vendor Values"]            = { true, 36, "checkbox", "vendor",        "Show vendor prices in tooltips" },
            ["Reveal World Map"]         = { true, 37, "checkbox", "worldmap",      "Remove map fog of war" },
            ["WorldMap Coordinates"]     = { true, 38, "checkbox", "worldmap",      "Show cursor/player coordinates" },
            ["WorldMap Window"]          = { true, 39, "checkbox", "worldmap",      "Movable windowed world map" },
        }

        -- generate UI
        if gui.tabPanels and defaults then
            for moduleName, panel in gui.tabPanels do
                local configData = nil
                local isShaguTweaks = false

                -- check if this is ShaguTweaks module
                if moduleName == "ShaguTweaks" then
                    configData = shaguTweaks
                    isShaguTweaks = true
                elseif defaults[moduleName] then
                    configData = defaults[moduleName]
                end

                -- the workhorse
                if configData then
                    d:DebugPrint("Generating config UI for: " .. moduleName)

                    -- get the scroll child for this panel
                    local scrollChild = panel.scrollChild
                    if not scrollChild then
                        d:DebugPrint("ERROR: No scrollChild found for panel: " .. moduleName)
                    else
                        -- group settings by category
                        local categories = {}
                        for key, metadata in configData do
                            -- safety check for metadata structure
                            if metadata and table.getn(metadata) >= 4 then
                                local _ = metadata[1]
                                local index = metadata[2]
                                local elementType = metadata[3]
                                local rangeOrCategoryOrOptions = metadata[4]
                                local category, tooltip, minVal, maxVal, options

                                -- handle different formats
                                if elementType == "slider" and type(rangeOrCategoryOrOptions) == "table" then
                                    -- slider with range
                                    minVal = rangeOrCategoryOrOptions[1]
                                    maxVal = rangeOrCategoryOrOptions[2]
                                    category = metadata[5]
                                    tooltip = metadata[6]
                                elseif elementType == "dropdown" and type(rangeOrCategoryOrOptions) == "table" then
                                    -- dropdown with options
                                    options = rangeOrCategoryOrOptions
                                    category = metadata[5]
                                    tooltip = metadata[6]
                                else
                                    -- checkbox or old format
                                    category = rangeOrCategoryOrOptions
                                    tooltip = metadata[5]
                                end

                                if elementType and category then
                                    if not categories[category] then
                                        categories[category] = {}
                                    end

                                    table.insert(categories[category], {
                                        key = key,
                                        index = index or 999,
                                        elementType = elementType,
                                        tooltip = tooltip,
                                        minVal = minVal,
                                        maxVal = maxVal,
                                        options = options
                                    })
                                else
                                    d:DebugPrint("Skipping invalid config: " .. key .. " (missing elementType or category)")
                                end
                            else
                                d:DebugPrint("Skipping invalid metadata for: " .. key)
                            end
                        end

                        -- sorted list of category names
                        local sortedCategoryNames = {}
                        for categoryName in categories do
                            table.insert(sortedCategoryNames, categoryName)
                        end
                        table.sort(sortedCategoryNames)

                        -- sort each category by index
                        for _, settings in categories do
                            table.sort(settings, function(a, b)
                                return a.index < b.index
                            end)
                        end

                        -- CONTROL VARIABLES
                        local LAYOUT = {
                            -- anchor settings
                            anchorPoint = "TOPLEFT",
                            relativePoint = "TOPLEFT",

                            -- starting position
                            startX = 5,
                            startY = -10,

                            -- element spacing
                            elementSpacing = 50,
                            categorySpacing = 50,
                            categoryEndSpacing = 10,

                            -- indentation
                            leftMargin = 15,
                            elementIndent = 5,

                            -- label and element positioning
                            labelWidth = 450,
                            elementOffset = 520,

                            -- scroll child padding
                            bottomPadding = 50
                        }

                        -- initialize
                        local currentY = LAYOUT.startY

                        -- create UI elements vertically in scroll child
                        for i = 1, table.getn(sortedCategoryNames) do
                            local categoryName = sortedCategoryNames[i]
                            local settings = categories[categoryName]

                            -- category header
                            local categoryHeader = CreateCategoryHeader(scrollChild, categoryName)
                            categoryHeader:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                LAYOUT.startX + LAYOUT.leftMargin, currentY)
                            currentY = currentY - LAYOUT.categorySpacing

                            -- create elements for this category
                            for j = 1, table.getn(settings) do
                                local setting = settings[j]
                                local element = nil

                                if setting.elementType == "checkbox" then
                                    local label = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                                    label:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                        LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent, currentY)
                                    label:SetWidth(LAYOUT.labelWidth)
                                    label:SetJustifyH("LEFT")
                                    label:SetText(setting.tooltip or setting.key)
                                    label:SetTextColor(1, 1, 1)

                                    if isShaguTweaks then
                                        element = CreateShaguCheckbox(scrollChild, "ShaguTweaks_"..setting.key, setting.key)
                                    else
                                        element = CreateCheckbox(scrollChild, moduleName.."_"..setting.key, moduleName, setting.key)
                                    end
                                    if element then
                                        element:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                            LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent + LAYOUT.elementOffset, currentY)
                                    end
                                elseif setting.elementType == "slider" then
                                    local label = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                                    label:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                        LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent, currentY)
                                    label:SetWidth(LAYOUT.labelWidth)
                                    label:SetJustifyH("LEFT")
                                    label:SetText(setting.tooltip or setting.key)
                                    label:SetTextColor(1, 1, 1)

                                    element = CreateSlider(scrollChild, moduleName.."_"..setting.key, moduleName, setting.key, setting.minVal, setting.maxVal)
                                    if element then
                                        element:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                            LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent + LAYOUT.elementOffset, currentY)
                                    end
                                elseif setting.elementType == "colourslider" then
                                    local label = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                                    label:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                        LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent, currentY)
                                    label:SetWidth(LAYOUT.labelWidth)
                                    label:SetJustifyH("LEFT")
                                    label:SetText(setting.tooltip or setting.key)
                                    label:SetTextColor(1, 1, 1)

                                    element = CreateColourSlider(scrollChild, moduleName.."_"..setting.key, moduleName, setting.key)
                                    if element then
                                        element:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                            LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent + LAYOUT.elementOffset, currentY)
                                    end
                                elseif setting.elementType == "dropdown" then
                                    local label = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                                    label:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                        LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent, currentY)
                                    label:SetWidth(LAYOUT.labelWidth)
                                    label:SetJustifyH("LEFT")
                                    label:SetText(setting.tooltip or setting.key)
                                    label:SetTextColor(1, 1, 1)

                                    element = CreateConfigDropdown(scrollChild, moduleName.."_"..setting.key, moduleName, setting.key, setting.options)
                                    if element then
                                        element:SetPoint(LAYOUT.anchorPoint, scrollChild, LAYOUT.relativePoint,
                                            LAYOUT.startX + LAYOUT.leftMargin + LAYOUT.elementIndent + LAYOUT.elementOffset, currentY)
                                    end
                                end

                                if element then
                                    currentY = currentY - LAYOUT.elementSpacing
                                end
                            end

                            -- add extra space after each category
                            currentY = currentY - LAYOUT.categoryEndSpacing
                        end

                        -- adjust scroll child height based on content
                        local totalHeight = math.abs(currentY) + LAYOUT.bottomPadding
                        scrollChild:SetHeight(totalHeight)

                        d:DebugPrint("Successfully generated config UI for: " .. moduleName .. " with height: " .. totalHeight)
                    end
                end
            end
        end
    end

    -- info
    do
        local infoPanel = gui.tabPanels["Info"]
        if infoPanel then
            -- welcome text
            local infoText = infoPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            infoText:SetPoint("TOP", infoPanel, "TOP", 0, -57)
            infoText:SetWidth(600)
            infoText:SetJustifyH("CENTER")
            infoText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
            infoText:SetText("Welcome to Dragonflight: Reloaded")
            infoText:SetTextColor(1, 1, 1)

            local leftFrame = CreateFrame("Frame", nil, infoPanel)
            leftFrame:SetWidth(318)
            leftFrame:SetHeight(420)
            leftFrame:SetPoint("TOPLEFT", infoPanel, "TOPLEFT", 10, -80)
            leftFrame:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
            leftFrame:SetBackdropColor(0, 0, 0, 0.7)
            leftFrame:SetBackdropBorderColor(0, 0, 0, .5)

            -- info content
            local version = GetAddOnMetadata("DragonflightReloaded", "Version") or "Unknown"
            local clientVersion, buildNumber, _, _ = GetBuildInfo()
            local locale = GetLocale()
            local realm = GetRealmName()

            -- check if compatible addons are loaded
            local shaguInstalled = IsAddOnLoaded("ShaguTweaks") and "|cFF77CC77(installed)|r" or "|cFF666666(not installed)|r"
            local shaguExtrasInstalled = IsAddOnLoaded("ShaguTweaks-extras") and "|cFF77CC77(installed)|r" or "|cFF666666(not installed)|r"
            local pfQuestInstalled = IsAddOnLoaded("pfQuest") and "|cFF77CC77(installed)|r" or "|cFF666666(not installed)|r"
            local bagShuiInstalled = IsAddOnLoaded("BagShui") and "|cFF77CC77(installed)|r" or "|cFF666666(not installed)|r"

            -- easter egg
            local specialText = UnitName("player") == "Shagu" and "|cFF00FF00Hi Shagu, danke dir für alles. <3|r\n\n\n" or "\n\n\n"

            -- text blocks
            local generalInfo = leftFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            generalInfo:SetPoint("TOPLEFT", leftFrame, "TOPLEFT", 15, -15)
            generalInfo:SetPoint("BOTTOMRIGHT", leftFrame, "BOTTOMRIGHT", -15, 15)
            generalInfo:SetJustifyH("LEFT")
            generalInfo:SetJustifyV("TOP")
            generalInfo:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
            generalInfo:SetText(
                "|cFFFFD100Dragonflight: Reloaded|r - Version: " .. "|cFF77CC77" .. version .. "\n\n" ..
                "|cFFCCCCCCThis addon enhances your vanilla WoW experience with modern design and tweaks.\n\n" ..
                "|cFFFFFFFFUsage:|r\n" ..
                "|cFFCCCCCCOpen menu via ESC or SLASH DFRL.|r\n" ..
                "|cFFCCCCCCMove frames via CTRL + ALT + SHIFT.|r\n\n" ..
                "|cFFFFFFFFSystem Info:|r\n" ..
                "|cFFCCCCCCClient Version: |r|cFF77CC77" .. clientVersion .. "|r\n" ..
                "|cFFCCCCCCBuild: |r|cFF77CC77" .. buildNumber .. "|r\n" ..
                "|cFFCCCCCCLocale: |r|cFF77CC77" .. locale .. "|r\n" ..
                "|cFFCCCCCCRealm: |r|cFF77CC77" .. realm .. "|r\n\n" ..
                "|cFFFFFFFFCompatible with:|r\n" ..
                "|cFFCCCCCC• |r|cFF77CC77ShaguTweaks" .. "                    " .. shaguInstalled .. "|r\n" ..
                "|cFFCCCCCC• |r|cFF77CC77ShaguTweaks-extras" .. "       " .. shaguExtrasInstalled .. "|r\n" ..
                "|cFFCCCCCC• |r|cFF77CC77pfQuest" .. "                               " .. pfQuestInstalled .. "|r\n" ..
                "|cFFCCCCCC• |r|cFF77CC77BagShui" .. "                               " .. bagShuiInstalled .. "|r\n\n" ..
                "|cFFFFFFFFDevelopment Status:|r\n" ..
                "|cFFCCCCCC• |r|cFFCCCCCCBag module is currently under development.\n" ..
                "|cFFCCCCCC• |r|cFFCCCCCCMore config options soon.\n\n\n\n\n\n" ..
                specialText..
                "|cFFFF6666Please report bugs on the Turtle-WoW Forum.|r\n" ..
                "|cFFCCCCCCCheck for known bugs as well before you post.|r\n"
            )

            generalInfo:SetTextColor(0.9, 0.9, 0.9)

            local rightFrame = CreateFrame("Frame", nil, infoPanel)
            rightFrame:SetWidth(420)
            rightFrame:SetHeight(420)
            rightFrame:SetPoint("TOPRIGHT", infoPanel, "TOPRIGHT", -10, -80)
            rightFrame:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
            rightFrame:SetBackdropColor(0, 0, 0, 0.7)
            rightFrame:SetBackdropBorderColor(0, 0, 0, .5)

            -- performance title
            local perfTitle = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            perfTitle:SetPoint("TOPLEFT", rightFrame, "TOPLEFT", 15, -15)
            perfTitle:SetText("|cFFFFFFFFPerformance Metrics|r")
            perfTitle:SetFont("Fonts\\FRIZQT__.TTF", 12, "")

            -- performance stats - fps, ms, bw
            local fpsText = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            fpsText:SetPoint("TOPLEFT", perfTitle, "BOTTOMLEFT", 0, -11)
            fpsText:SetFont("Fonts\\FRIZQT__.TTF", 11, "")

            local msText = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            msText:SetPoint("TOPLEFT", fpsText, "BOTTOMLEFT", 0, -5)
            msText:SetFont("Fonts\\FRIZQT__.TTF", 11, "")

            local bwText = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            bwText:SetPoint("TOPLEFT", msText, "BOTTOMLEFT", 0, 0)
            bwText:SetFont("Fonts\\FRIZQT__.TTF", 11, "")

            -- module performance title
            local modTitle = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            modTitle:SetPoint("TOPLEFT", bwText, "BOTTOMLEFT", 0, -15)
            modTitle:SetText("|cFFFFFFFFModule Performance:|r")
            modTitle:SetFont("Fonts\\FRIZQT__.TTF", 12, "")

            local modStats = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            modStats:SetPoint("TOPLEFT", modTitle, "BOTTOMLEFT", 0, -5)
            modStats:SetPoint("BOTTOMRIGHT", rightFrame, "BOTTOMRIGHT", -0, 15)
            modStats:SetJustifyH("LEFT")
            modStats:SetJustifyV("TOP")
            modStats:SetFont("Fonts\\FRIZQT__.TTF", 11, "")

            local function GetPerformanceRating(memory, time)
                local memRating, timeRating

                if memory < 824 then memRating = 5      -- excellent
                elseif memory < 1067 then memRating = 4  -- good
                elseif memory < 1310 then memRating = 3  -- fair
                elseif memory < 1715 then memRating = 2 -- poor
                else memRating = 1 end                  -- bad

                if time < 0.1 then timeRating = 5      -- excellent
                elseif time < 0.30 then timeRating = 4  -- good
                elseif time < 0.35 then timeRating = 3  -- fair
                elseif time < 0.40 then timeRating = 2  -- poor
                else timeRating = 1 end                 -- bad

                -- average rating
                local avgRating = (memRating + timeRating) / 2

                if avgRating >= 4.5 then return "Excellent"
                elseif avgRating >= 3.5 then return "Good"
                elseif avgRating >= 2.5 then return "Fair"
                elseif avgRating >= 1.5 then return "Poor"
                else return "Bad" end
            end

            local perfUpdateFrame = CreateFrame("Frame")
            perfUpdateFrame:SetScript("OnUpdate", function()
                this.elapsed = (this.elapsed or 0) + arg1
                if this.elapsed < 0.5 then return end
                this.elapsed = 0

                local bandwidthIn, bandwidthOut, latencyHome = GetNetStats()

                fpsText:SetText(string.format("|cFFCCCCCCFramerate: |r|cFF77CC77%d|r |cFFCCCCCC| Latency: |r|cFF77CC77%d|r |cFFCCCCCC| Upload/Download: |r|cFF77CC77%.1f / %.1f|r", GetFramerate(), latencyHome, bandwidthOut, bandwidthIn))

                -- module stats display
                -- hide any existing module fontstrings
                if not rightFrame.moduleTexts then
                    rightFrame.moduleTexts = {}
                else
                    for _, fontString in pairs(rightFrame.moduleTexts) do
                        fontString:Hide()
                    end
                end

                -- sort module names for consistent display
                local sortedModules = {}
                for moduleName in pairs(performance or {}) do
                    table.insert(sortedModules, moduleName)
                end
                table.sort(sortedModules)

                -- layout settings
                local modulesPerColumn = 7
                local columnWidth = 200
                local rowHeight = 35

                -- track totals
                local totalMemory = 0
                local totalTime = 0

                -- position module stats
                for i = 1, table.getn(sortedModules) do
                    local moduleName = sortedModules[i]
                    local perfData = performance[moduleName]

                    if perfData and perfData.loadTime and perfData.memoryUsage then
                        -- totals
                        totalMemory = totalMemory + perfData.memoryUsage
                        totalTime = totalTime + perfData.loadTime

                        -- calculate position
                        local column = math.floor((i-1) / modulesPerColumn)
                        local row = (i-1) - (column * modulesPerColumn)

                        -- create or reuse font string
                        if not rightFrame.moduleTexts[i] then
                            rightFrame.moduleTexts[i] = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                            rightFrame.moduleTexts[i]:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
                            rightFrame.moduleTexts[i]:SetJustifyH("LEFT")
                        end

                        -- position the font string
                        rightFrame.moduleTexts[i]:ClearAllPoints()
                        rightFrame.moduleTexts[i]:SetPoint("TOPLEFT", modTitle, "BOTTOMLEFT",
                            column * columnWidth, -5 - (row * rowHeight))
                        rightFrame.moduleTexts[i]:SetWidth(columnWidth - 10)

                        -- capitalize first letter of module name
                        local capitalizedName = string.upper(string.sub(moduleName, 1, 1)) .. string.sub(moduleName, 2)

                        -- set the text with new colors
                        rightFrame.moduleTexts[i]:SetText(
                            "|cFFFFFFFF" .. capitalizedName .. "|r\n" ..
                            "|cFFCCCCCCMem: |r|cFF77CC77" .. perfData.memoryUsage .. "KB|r |cFFCCCCCC- " ..
                            "Boot: |r|cFF77CC77" .. string.format("%.2f", perfData.loadTime) .. "sec|r"
                        )
                        rightFrame.moduleTexts[i]:Show()
                    end
                end

                -- create or update total stats
                if not rightFrame.totalStats then
                    rightFrame.totalStats = rightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                    rightFrame.totalStats:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
                    rightFrame.totalStats:SetPoint("BOTTOMLEFT", rightFrame, "BOTTOMLEFT", 15, 15)
                    rightFrame.totalStats:SetWidth(400)
                    rightFrame.totalStats:SetJustifyH("LEFT")
                end

                -- convert kb to mb
                local memoryText
                if totalMemory > 1000 then
                    memoryText = string.format("%.2f MB", totalMemory / 1024)
                else
                    memoryText = totalMemory .. " KB"
                end

                rightFrame.totalStats:SetText(
                    "|cFFFF6666TOTAL:|r |cFFCCCCCCMem: |r|cFF77CC77" .. memoryText ..
                    "|r |cFFCCCCCC- Boot: |r|cFF77CC77" .. string.format("%.2f", totalTime) .. " sec|r"..
                    "|cFFCCCCCC - Rating: |r|cFF77CC77" .. GetPerformanceRating(totalMemory, totalTime) .. "|r"
                )
            end)
        end
    end

    -- modules
    do
        local modulesPanel = gui.tabPanels["Modules"]
        if modulesPanel then
            -- bg
            local bg = modulesPanel:CreateTexture(nil, "BACKGROUND")
            bg:SetPoint("TOPLEFT", modulesPanel, "TOPLEFT", 12, -82)
            bg:SetPoint("BOTTOMRIGHT", modulesPanel, "BOTTOMRIGHT", -12, 15)
            bg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
            bg:SetVertexColor(0, 0, 0, 0.7)

            -- title
            local titleText = modulesPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            titleText:SetPoint("TOP", modulesPanel, "TOP", 0, -57)
            titleText:SetWidth(600)
            titleText:SetJustifyH("CENTER")
            titleText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
            titleText:SetText("|cFFFFFFFFEnable or disable modules using the checkboxes below.|r")

            -- frame for checkboxes
            local checkboxFrame = CreateFrame("Frame", nil, modulesPanel)
            checkboxFrame:SetWidth(600)
            checkboxFrame:SetHeight(400)
            checkboxFrame:SetPoint("TOP", titleText, "BOTTOM", 0, -70)

            -- checkboxes for each module
            local sortedModules = {}
            for moduleName, _ in pairs(defaults or {}) do
                local isHidden = false
                if tempDB and tempDB[moduleName] and tempDB[moduleName]["hidden"] == true then
                    isHidden = true
                end

                if not isHidden and moduleName ~= "gui" then
                    table.insert(sortedModules, moduleName)
                end
            end

            table.sort(sortedModules)

            -- layout settings
            local checkboxesPerColumn = 5
            local columnWidth = 200
            local rowHeight = 25

            for i, moduleName in ipairs(sortedModules) do
                -- calculate position
                local column = math.floor((i-1) / checkboxesPerColumn)
                local row = (i-1) - (column * checkboxesPerColumn)

                -- create checkbox
                local checkbox = CreateFrame("CheckButton", "DFRL_ModuleCheckbox_"..moduleName, checkboxFrame, "UICheckButtonTemplate")
                checkbox:SetWidth(24)
                checkbox:SetHeight(24)
                checkbox:SetPoint("TOPLEFT", checkboxFrame, "TOPLEFT",
                    column * columnWidth + 10, -row * rowHeight)

                -- capitalize first letter for display
                local displayName = string.upper(string.sub(moduleName, 1, 1)) .. string.sub(moduleName, 2)

                -- set checkbox text
                local checkboxText = checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                checkboxText:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
                checkboxText:SetText(displayName)
                checkboxText:SetFont("Fonts\\FRIZQT__.TTF", 11, "")

                -- store the lowercase module name on the checkbox
                checkbox.moduleName = string.lower(moduleName)

                -- set initial state
                local isEnabled = true
                if tempDB and tempDB[checkbox.moduleName] and tempDB[checkbox.moduleName]["enabled"] ~= nil then
                    isEnabled = tempDB[checkbox.moduleName]["enabled"]
                end
                checkbox:SetChecked(isEnabled)

                -- set OnClick handler
                checkbox:SetScript("OnClick", function()
                    local checked = this:GetChecked()
                    if checked then
                        DFRL:SetConfig(this.moduleName, "enabled", true)
                    else
                        DFRL:SetConfig(this.moduleName, "enabled", false)
                    end
                end)
            end

            -- save & reload button
            local reloadBtn = CreateFrame("Button", nil, modulesPanel, "GameMenuButtonTemplate")
            reloadBtn:SetWidth(150)
            reloadBtn:SetHeight(30)
            reloadBtn:SetPoint("BOTTOM", modulesPanel, "BOTTOM", 0, 40)
            reloadBtn:SetText("Save & Reload UI")
            reloadBtn:GetNormalTexture():SetVertexColor(0.3, 0.3, 0.3)
            reloadBtn:SetScript("OnClick", function()
                DFRL:SaveDB()
                ReloadUI()
            end)

            -- note
            local noteText = modulesPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            noteText:SetPoint("BOTTOM", reloadBtn, "TOP", 0, 10)
            noteText:SetWidth(400)
            noteText:SetJustifyH("CENTER")
            noteText:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
            noteText:SetText("|cFFCCCCCCChanges will take effect after reloading the UI.|r")
        end
    end

    -- shagu save button
    do
        local modulesPanel = gui.tabPanels["ShaguTweaks"]
        if modulesPanel then
            local reloadBtn = CreateFrame("Button", nil, modulesPanel, "GameMenuButtonTemplate")
            reloadBtn:SetWidth(150)
            reloadBtn:SetHeight(30)
            reloadBtn:SetPoint("BOTTOM", modulesPanel, "BOTTOM", -0, 10)
            reloadBtn:SetText("Save & Reload UI")
            reloadBtn:GetNormalTexture():SetVertexColor(0.3, 0.3, 0.3)
            reloadBtn:SetScript("OnClick", function()
                DFRL:SaveDB()
                ReloadUI()
            end)

            local noteText = modulesPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            noteText:SetPoint("BOTTOM", reloadBtn, "TOP", 0, 1)
            noteText:SetWidth(400)
            noteText:SetJustifyH("CENTER")
            noteText:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
            noteText:SetText("|cFFCCCCCCChanges will take effect\n after reloading the UI.|r")
        end
    end
end)
