DFRL:SetDefaults("bags", {
    enabled = {true},
    hidden = {false},

    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for the bags"},

    toggleBags = {true, 2, "checkbox", "bag basic", "Show or hide small bag slots"},
    bagScale = {1.5, 3, "slider", {0.5, 2.5}, "bag basic", "Adjusts the scale of the main backpack"},
    bagAlpha = {1, 4, "slider", {0.1, 1}, "bag basic", "Adjusts the transparency of all bags"},
    hideBags = {false, 5, "checkbox", "tweaks", "Show or hide the bag frame"},
})

DFRL:RegisterModule("bags", 1, function()
    d:DebugPrint("BOOTING")

    -- move big bag
    do
        MainMenuBarBackpackButton:ClearAllPoints()
        MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 36)
        MainMenuBarBackpackButton:SetClampedToScreen(true)
    end

    -- retexture all bags
    do
        function GetBagSlots(id)
            local slots = GetContainerNumSlots(id)
            return slots
        end

        -- main func to change the bag textures
        function ChangeBackpack()
            local bagAtlas = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\bags\\bagslots2x"
            -- main bag
            do
                local texture = 'Interface\\AddOns\\DragonflightReloaded\\media\\tex\\bags\\bigbag'
                local highlight = 'Interface\\AddOns\\DragonflightReloaded\\media\\tex\\bags\\bigbagHighlight'

                MainMenuBarBackpackButton:SetScale(DFRL:GetConfig("bags", "bagScale"))

                SetItemButtonTexture(MainMenuBarBackpackButton, texture)
                MainMenuBarBackpackButton:SetHighlightTexture(highlight)
                MainMenuBarBackpackButton:SetPushedTexture(highlight)
                if MainMenuBarBackpackButton.SetCheckedTexture then
                    MainMenuBarBackpackButton:SetCheckedTexture(highlight)
                end

                MainMenuBarBackpackButtonNormalTexture:Hide()
                MainMenuBarBackpackButtonNormalTexture:SetTexture()

                if not MainMenuBarBackpackButton.Border then
                    local cutout = 'Interface\\AddOns\\DragonflightReloaded\\media\\tex\\bags\\bagslotCutout'

                    local border = MainMenuBarBackpackButton:CreateTexture('DragonflightUIBigBagBorder')
                    border:SetTexture(cutout)
                    border:SetWidth(30)
                    border:SetHeight(30)
                    border:SetPoint('TOPLEFT', MainMenuBarBackpackButton, 'TOPLEFT', 0, 0)
                    border:SetPoint('BOTTOMRIGHT', MainMenuBarBackpackButton, 'BOTTOMRIGHT', 0, 0)

                    MainMenuBarBackpackButton.Border = border
                end
            end

            -- small bags
            do
                CharacterBag0Slot:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', -12, 0)

                for i = 1, 3 do
                    local gap = 0
                    _G['CharacterBag' .. i .. 'Slot']:SetPoint('RIGHT', _G['CharacterBag' .. (i - 1) .. 'Slot'], 'LEFT', -gap, 0)
                end

                for i = 0, 3 do
                    local slot = _G['CharacterBag' .. i .. 'Slot']
                    slot:SetScale(1)
                    slot:SetWidth(30)
                    slot:SetHeight(30)

                    local size = 30.5

                    local normal = slot:GetNormalTexture()
                    normal:SetTexture(bagAtlas)
                    normal:SetTexCoord(0.576172, 0.695312, 0.5, 0.976562)
                    normal:SetWidth(size)
                    normal:SetHeight(size)
                    normal:SetPoint('CENTER', 2, -1)
                    normal:SetDrawLayer('BACKGROUND', 0)

                    local highlight = slot:GetHighlightTexture()
                    highlight:SetTexture(bagAtlas)
                    highlight:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
                    highlight:SetWidth(size)
                    highlight:SetHeight(size)
                    highlight:ClearAllPoints()
                    highlight:SetPoint('CENTER', 2, -1)

                    local checked = slot:GetCheckedTexture()
                    if checked then
                        checked:SetTexture(bagAtlas)
                        checked:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
                        checked:SetWidth(size)
                        checked:SetHeight(size)
                        checked:ClearAllPoints()
                        checked:SetPoint('CENTER', 2, -1)
                    end

                    local pushed = slot:GetPushedTexture()
                    pushed:SetTexture(bagAtlas)
                    pushed:SetTexCoord(0.576172, 0.695312, 0.5, 0.976562)
                    pushed:SetWidth(size)
                    pushed:SetHeight(size)
                    pushed:ClearAllPoints()
                    pushed:SetPoint('CENTER', 2, -1)
                    pushed:SetDrawLayer('BORDER', 0)

                    local iconTexture = _G['CharacterBag' .. i .. 'SlotIconTexture']
                    iconTexture:ClearAllPoints()
                    iconTexture:SetPoint('CENTER', 0, 0)

                    iconTexture:SetWidth(20)
                    iconTexture:SetHeight(21)
                    iconTexture:SetDrawLayer('BORDER', 2)

                    if not slot.Border then
                        local border = slot:CreateTexture('DragonflightUIBagBorder' .. i)
                        border:SetTexture(bagAtlas)
                        border:SetTexCoord(0.576172, 0.695312, 0.0078125, 0.484375)
                        border:SetWidth(size)
                        border:SetHeight(size)
                        border:SetPoint('CENTER', 2, -1)

                        slot.Border = border
                    end
                end
            end

            -- keyring
            if KeyRingButton then
                KeyRingButton:SetWidth(30)
                KeyRingButton:SetHeight(30)
                KeyRingButton:ClearAllPoints()
                KeyRingButton:SetPoint('RIGHT', _G['CharacterBag3Slot'], 'LEFT', 0, 0)
                KeyRingButton:SetScale(1)

                local size = 30.5

                local normal = KeyRingButton:GetNormalTexture()
                normal:SetTexture(bagAtlas)
                normal:SetTexCoord(0.822266, 0.941406, 0.0078125, 0.484375)
                normal:SetWidth(size)
                normal:SetHeight(size)
                normal:ClearAllPoints()
                normal:SetPoint('CENTER', 2, -1)
                normal:SetDrawLayer('BORDER', 0)

                local highlight = KeyRingButton:GetHighlightTexture()
                highlight:SetTexture(bagAtlas)
                highlight:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
                highlight:SetWidth(size)
                highlight:SetHeight(size)
                highlight:ClearAllPoints()
                highlight:SetPoint('CENTER', 2, -1)

                local pushed = KeyRingButton:GetPushedTexture()
                pushed:SetTexture(bagAtlas)
                pushed:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
                pushed:SetWidth(size)
                pushed:SetHeight(size)
                pushed:ClearAllPoints()
                pushed:SetPoint('CENTER', 2, -1)

                if not KeyRingButton.Icon then
                    local icon = KeyRingButton:CreateTexture('KeyRingIconTexture')
                    icon:SetTexture('Interface\\AddOns\\DragonflightReloaded\\media\\tex\\bags\\KeyRing-Bag-Icon')
                    KeyRingButton.Icon = icon

                    icon:SetWidth(20.5)
                    icon:SetHeight(20.5)
                    icon:SetPoint('CENTER', 0, 0)
                    icon:SetDrawLayer('BORDER', 2)

                end

                if not KeyRingButton.Border then
                    local border = KeyRingButton:CreateTexture('KeyRingBorder')
                    border:SetTexture(bagAtlas)
                    border:SetTexCoord(0.699219, 0.818359, 0.5, 0.976562)
                    border:SetWidth(size)
                    border:SetHeight(size)
                    border:SetPoint('CENTER', 2, -1)

                    KeyRingButton.Border = border
                end
            end

            -- expand toggle
            do
                local bagToggleButton = CreateFrame("Button", "DFRLBagToggleButton", UIParent)
                bagToggleButton:SetWidth(28)
                bagToggleButton:SetHeight(17)
                bagToggleButton:SetScale(0.8)
                bagToggleButton:ClearAllPoints()
                bagToggleButton:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", 11, 0)

                local expandTexture = 'Interface\\AddOns\\DragonflightReloaded\\media\\tex\\bags\\expand'
                bagToggleButton:SetNormalTexture(expandTexture)
                bagToggleButton:SetPushedTexture(expandTexture)
                bagToggleButton:SetHighlightTexture(expandTexture)

                bagToggleButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
                bagToggleButton:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
                bagToggleButton:GetPushedTexture():SetTexCoord(0, 1, 0, 1)

                DFRL.bagToggleButton = bagToggleButton
                DFRL.bagToggleButton:SetScript("OnClick", function()
                    local currentValue = DFRL:GetConfig("bags", "toggleBags")
                    DFRL:SetConfig("bags", "toggleBags", not currentValue)
                end)
            end
        end

        -- update func
        function UpdateBagSlotIcons()
            for i = 0, 3 do
                local iconTexture = _G['CharacterBag' .. i .. 'SlotIconTexture']
                local bagID = i + 1
                local texture = GetInventoryItemTexture("player", ContainerIDToInventoryID(bagID))

                if texture then
                    iconTexture:SetTexture(texture)
                    iconTexture:Show()
                else
                    iconTexture:Hide()
                end
            end
        end

        local bagUpdateFrame = CreateFrame("Frame")
        bagUpdateFrame:RegisterEvent("BAG_UPDATE")
        bagUpdateFrame:SetScript("OnEvent", function()
            UpdateBagSlotIcons()
        end)

        ChangeBackpack()
        UpdateBagSlotIcons()
    end

    -- callbacks
    local callbacks = {}

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        if MainMenuBarBackpackButton.Border then
            MainMenuBarBackpackButton.Border:SetVertexColor(color[1], color[2], color[3])
        end

        for i = 0, 3 do
            local slot = _G['CharacterBag' .. i .. 'Slot']
            if slot.Border then
                slot.Border:SetVertexColor(color[1], color[2], color[3])
            end

            local normal = slot:GetNormalTexture()
            if normal then
                normal:SetVertexColor(color[1], color[2], color[3])
            end

            local pushed = slot:GetPushedTexture()
            if pushed then
                pushed:SetVertexColor(color[1], color[2], color[3])
            end
        end

        if KeyRingButton then
            if KeyRingButton.Border then
                KeyRingButton.Border:SetVertexColor(color[1], color[2], color[3])
            end

            local normal = KeyRingButton:GetNormalTexture()
            if normal then
                normal:SetVertexColor(color[1], color[2], color[3])
            end

            local pushed = KeyRingButton:GetPushedTexture()
            if pushed then
                pushed:SetVertexColor(color[1], color[2], color[3])
            end
        end
    end

    callbacks.toggleBags = function(value)
        -- show/hide only if bags not hidden
        local bagHideValue = DFRL:GetConfig("bags", "hideBags")

        for i = 0, 3 do
            local slot = _G['CharacterBag' .. i .. 'Slot']
            if value and not bagHideValue then
                slot:Show()
            else
                slot:Hide()
            end
        end

        -- KeyRingButton
        if KeyRingButton then
            if value and not bagHideValue then
                local keyringID = KEYRING_CONTAINER or 4
                if GetContainerNumSlots(keyringID) > 0 then
                    KeyRingButton:Show()
                else
                    KeyRingButton:Hide()
                end
            else
                KeyRingButton:Hide()
            end
        end

        -- update
        if value then
            -- normal
            DFRL.bagToggleButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
            DFRL.bagToggleButton:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
            DFRL.bagToggleButton:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
        else
            -- flipped
            DFRL.bagToggleButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
            DFRL.bagToggleButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)
            DFRL.bagToggleButton:GetPushedTexture():SetTexCoord(1, 0, 0, 1)
        end
    end


    callbacks.bagScale = function(value)
        MainMenuBarBackpackButton:SetScale(value)
    end

    callbacks.bagAlpha = function(value)
        MainMenuBarBackpackButton:SetAlpha(value)

        for i = 0, 3 do
            _G['CharacterBag' .. i .. 'Slot']:SetAlpha(value)
        end

        if KeyRingButton then
            KeyRingButton:SetAlpha(value)
        end
    end

    callbacks.hideBags = function (value)
        if value then
            MainMenuBarBackpackButton:Hide()
            for i = 0, 3 do
                _G['CharacterBag' .. i .. 'Slot']:Hide()
            end
            if KeyRingButton then
                KeyRingButton:Hide()
            end
            DFRL.bagToggleButton:Hide()
        else
            MainMenuBarBackpackButton:Show()

            for i = 0, 3 do
                _G['CharacterBag' .. i .. 'Slot']:Show()
            end
            DFRL.bagToggleButton:Show()
            if KeyRingButton then
                local keyringID = KEYRING_CONTAINER or 4
                if GetContainerNumSlots(keyringID) > 0 then
                    KeyRingButton:Show()
                else
                    KeyRingButton:Hide()
                end
            end
        end
    end

    -- execute callbacks
    DFRL:RegisterCallback("bags", callbacks)
end)
