DFRL:SetDefaults("chat", {
    enabled = {true},
    hidden = {false},

    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for the chat"},
    showButtons = {true, 2, "checkbox", "chat basic", "Show or hide chat buttons"},
    blizzardButtons = {true, 3, "checkbox", "chat basic", "Use original Blizzard chat buttons"},
    fadeChat = {false, 4, "checkbox", "tweaks", "Fade out chat text after 10 seconds"}

})

DFRL:RegisterModule("chat", 1, function()
    d:DebugPrint("BOOTING")

    ChatFrame1Tab:SetClampedToScreen(true)

    -- callbacks
    local callbacks = {}

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        for i = 1, 5 do
            local tab = _G["ChatFrame"..i.."Tab"]
            if tab then
                local tabLeft = _G["ChatFrame"..i.."TabLeft"]
                local tabMiddle = _G["ChatFrame"..i.."TabMiddle"]
                local tabRight = _G["ChatFrame"..i.."TabRight"]

                if tabLeft then tabLeft:SetVertexColor(color[1], color[2], color[3]) end
                if tabMiddle then tabMiddle:SetVertexColor(color[1], color[2], color[3]) end
                if tabRight then tabRight:SetVertexColor(color[1], color[2], color[3]) end
            end
        end

        if ChatFrameMenuButton then
            local normalTexture = ChatFrameMenuButton:GetNormalTexture()
            if normalTexture then
                normalTexture:SetVertexColor(color[1], color[2], color[3])
            end

            local pushedTexture = ChatFrameMenuButton:GetPushedTexture()
            if pushedTexture then
                pushedTexture:SetVertexColor(color[1], color[2], color[3])
            end
        end

        for i = 1, 5 do
            local upButton = _G["ChatFrame"..i.."UpButton"]
            local downButton = _G["ChatFrame"..i.."DownButton"]
            local bottomButton = _G["ChatFrame"..i.."BottomButton"]

            if upButton then
                local normalTexture = upButton:GetNormalTexture()
                if normalTexture then
                    normalTexture:SetVertexColor(color[1], color[2], color[3])
                end

                local pushedTexture = upButton:GetPushedTexture()
                if pushedTexture then
                    pushedTexture:SetVertexColor(color[1], color[2], color[3])
                end
            end

            if downButton then
                local normalTexture = downButton:GetNormalTexture()
                if normalTexture then
                    normalTexture:SetVertexColor(color[1], color[2], color[3])
                end

                local pushedTexture = downButton:GetPushedTexture()
                if pushedTexture then
                    pushedTexture:SetVertexColor(color[1], color[2], color[3])
                end
            end

            if bottomButton then
                local normalTexture = bottomButton:GetNormalTexture()
                if normalTexture then
                    normalTexture:SetVertexColor(color[1], color[2], color[3])
                end

                local pushedTexture = bottomButton:GetPushedTexture()
                if pushedTexture then
                    pushedTexture:SetVertexColor(color[1], color[2], color[3])
                end
            end
        end
    end

    callbacks.showButtons = function(value)
        if ChatFrameMenuButton then
            if value then
                ChatFrameMenuButton:Show()
            else
                ChatFrameMenuButton:Hide()
            end
        end

        for i = 1, 5 do
            local upButton = _G["ChatFrame"..i.."UpButton"]
            local downButton = _G["ChatFrame"..i.."DownButton"]
            local bottomButton = _G["ChatFrame"..i.."BottomButton"]

            if upButton then
                if value then
                    upButton:Show()
                else
                    upButton:Hide()
                end
            end

            if downButton then
                if value then
                    downButton:Show()
                else
                    downButton:Hide()
                end
            end

            if bottomButton then
                if value then
                    bottomButton:Show()
                else
                    bottomButton:Hide()
                end
            end
        end
    end

    callbacks.blizzardButtons = function(value)
        local buttonScale = 0.8

        if value then
            if ChatFrameMenuButton then
                ChatFrameMenuButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Up")
                ChatFrameMenuButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
                ChatFrameMenuButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Down")
                ChatFrameMenuButton:SetScale(buttonScale)
            end

            for i = 1, 5 do
                local upButton = _G["ChatFrame"..i.."UpButton"]
                local downButton = _G["ChatFrame"..i.."DownButton"]
                local bottomButton = _G["ChatFrame"..i.."BottomButton"]

                if upButton then
                    upButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
                    upButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
                    upButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
                    upButton:SetScale(buttonScale)
                end

                if downButton then
                    downButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
                    downButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
                    downButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
                    downButton:SetScale(buttonScale)
                end

                if bottomButton then
                    bottomButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Up")
                    bottomButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
                    bottomButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Down")
                    bottomButton:SetScale(buttonScale)
                end
            end
        else
            local menuTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\chat\\chat_menu"
            local upTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\chat\\chat_up"
            local downTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\chat\\chat_down"
            local downFullTexture = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\chat\\chat_down_full"

            if ChatFrameMenuButton then
                ChatFrameMenuButton:SetNormalTexture(menuTexture)
                ChatFrameMenuButton:SetHighlightTexture(menuTexture)
                ChatFrameMenuButton:SetPushedTexture(menuTexture)
                ChatFrameMenuButton:SetScale(buttonScale)
            end

            for i = 1, 5 do
                local upButton = _G["ChatFrame"..i.."UpButton"]
                local downButton = _G["ChatFrame"..i.."DownButton"]
                local bottomButton = _G["ChatFrame"..i.."BottomButton"]

                if upButton then
                    upButton:SetNormalTexture(upTexture)
                    upButton:SetHighlightTexture(upTexture)
                    upButton:SetPushedTexture(upTexture)
                    upButton:SetScale(buttonScale)
                end

                if downButton then
                    downButton:SetNormalTexture(downTexture)
                    downButton:SetHighlightTexture(downTexture)
                    downButton:SetPushedTexture(downTexture)
                    downButton:SetScale(buttonScale)
                end

                if bottomButton then
                    bottomButton:SetNormalTexture(downFullTexture)
                    bottomButton:SetHighlightTexture(downFullTexture)
                    bottomButton:SetPushedTexture(downFullTexture)
                    bottomButton:SetScale(buttonScale)
                end
            end
        end

        -- dark mode if enabled
        callbacks.darkMode(DFRL:GetConfig("chat", "darkMode"))
    end

    callbacks.fadeChat = function(value)
        for i = 1, NUM_CHAT_WINDOWS do
            local f = _G["ChatFrame"..i]
            if value then
                f:SetFadeDuration(0.1)
                f:SetTimeVisible(10)
            else
                f:SetFadeDuration(3)
                f:SetTimeVisible(180)
            end
        end
    end

    -- execute callbacks
    DFRL:RegisterCallback("chat", callbacks)
end)
