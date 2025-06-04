---@diagnostic disable: deprecated
DFRL:SetDefaults("ui", {
    enabled = {true},
    hidden = {false},

    questLog = {false, 1, "checkbox", "appearance", "Enable dark mode for the questlog"},
    gameMenu = {false, 2, "checkbox", "appearance", "Enable dark mode for the game menu"},
    characterPanel = {false, 3, "checkbox", "appearance", "Enable dark mode for the character panel"},
    errorMessage = {false, 4, "checkbox", "tweaks", "Hide the top UI error message (e.g. 'Spell is not ready')"},

})

DFRL:RegisterModule("ui", 1, function()
    d:DebugPrint("BOOTING")

    -- hide stuff
    do
        PetPaperDollCloseButton:Hide()
        SkillFrameCancelButton:Hide()
    end

    -- close button
    do
        local closeButtonData = {
            {"CharacterFrame", "CharacterFrameCloseButton", -36, -16},
            {"SpellBookFrame", "SpellBookCloseButton", -36, -15},
            {"TalentFrame", "TalentFrameCloseButton", -36, -17},
            {"QuestLogFrame", "QuestLogFrameCloseButton", -91, -15},
            {"FriendsFrame", "FriendsFrameCloseButton", -36, -15},
            {"ShopFrame", "ShopFrameFrameCloseButton", -9, -17},
            {"HelpFrame", "HelpFrameCloseButton", -50, -10},
            {"QuestFrame", "QuestFrameCloseButton", -34, -22},
            {"GuildMemberDetailFrame", "GuildMemberDetailCloseButton", -10, -10},

        }

        FriendsFrameCloseButton:SetFrameLevel(100) -- for some reason this button is always behind the other frames
        FriendsFrameCloseButton:Show()



        for i = 1, 5 do
            table.insert(closeButtonData, {"ContainerFrame"..i, "ContainerFrame"..i.."CloseButton", -8, -8})
        end

        local path = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\close_normal.tga"
        local pathpushed = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\close_pushed.tga"

        for _, data in ipairs(closeButtonData) do
            local frameName, buttonName, offsetX, offsetY = unpack(data)
            local frame = _G[frameName]
            local button = _G[buttonName]

            if button then
                button:SetNormalTexture(path)
                button:SetPushedTexture(pathpushed)
                button:SetHighlightTexture(path)
                button:SetWidth(17)
                button:SetHeight(17)
                button:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', offsetX, offsetY)
            end
        end
    end

    -- questlog
    do
        local questLogFrame = QuestLogFrame
        if questLogFrame then
            local regions = {questLogFrame:GetRegions()}
            for i, region in ipairs(regions) do
                if region:GetObjectType() == "Texture" then
                    local texture = region:GetTexture()
                    if texture then
                        if texture == "Interface\\QuestFrame\\UI-QuestLog-Left" then
                            region:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\questlog_left.tga")
                        elseif texture == "Interface\\QuestFrame\\UI-QuestLog-Right" then
                            region:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\questlog_right.tga")
                        end
                    end
                end
            end
        end
    end

    -- characterframe
    do
        local tex = {
            "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_top_left.tga",
            "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_top_right.tga",
            "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_bot_left.tga",
            "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_bot_right.tga",
        }

        local function ReplaceFrameTextures(frame)
            if not frame then return end
            frame:SetFrameStrata("MEDIUM")

            local regions = { frame:GetRegions() }
            local texIndex = 1
            for i = 1, table.getn(regions) do
                local r = regions[i]
                if r and r:IsObjectType("Texture") then
                    local name = r:GetName()
                    if not name or not string.find(name, "Portrait") then
                        r:ClearAllPoints()
                        if texIndex == 1 then
                            r:SetPoint("TOPLEFT", 0, 0)
                        elseif texIndex == 2 then
                            r:SetPoint("TOPLEFT", 256, 0)
                        elseif texIndex == 3 then
                            r:SetPoint("TOPLEFT", 0, -256)
                        elseif texIndex == 4 then
                            r:SetPoint("TOPLEFT", 256, -256)
                        end
                        r:SetTexture(tex[texIndex])
                        texIndex = texIndex + 1
                        if texIndex > table.getn(tex) then break end
                    end
                end
            end
        end

        HookScript(CharacterFrame, "OnShow", function()
            ReplaceFrameTextures(CharacterFrame)
        end)

        local subFrames = {
            "PaperDollFrame",
            "PetPaperDollFrame",
            "ReputationFrame",
            "SkillFrame",
            "HonorFrame",

        }

        for i = 1, table.getn(subFrames) do
            local f = getglobal(subFrames[i])
            if f then
                HookScript(f, "OnShow", function()
                    ReplaceFrameTextures(f)
                end)
            end
        end
    end

    -- friendsframe
    do
        local function ApplyCustomTextures(frame)
            if not frame then return end

            if not frame.customTopLeft then
                frame.customTopLeft = frame:CreateTexture(nil, "OVERLAY")
                frame.customTopLeft:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_top_left.tga")
                frame.customTopLeft:SetWidth(256)
                frame.customTopLeft:SetHeight(256)
                frame.customTopLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, 0)

                frame.customTopRight = frame:CreateTexture(nil, "OVERLAY")
                frame.customTopRight:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_top_right.tga")
                frame.customTopRight:SetWidth(128)
                frame.customTopRight:SetHeight(256)
                frame.customTopRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, 0)

                frame.customBottomLeft = frame:CreateTexture(nil, "OVERLAY")
                frame.customBottomLeft:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_bot_left.tga")
                frame.customBottomLeft:SetWidth(256)
                frame.customBottomLeft:SetHeight(256)
                frame.customBottomLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, -256)

                frame.customBottomRight = frame:CreateTexture(nil, "OVERLAY")
                frame.customBottomRight:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_bot_right.tga")
                frame.customBottomRight:SetWidth(128)
                frame.customBottomRight:SetHeight(256)
                frame.customBottomRight:SetPoint("TOPLEFT", frame, "TOPLEFT", 253, -256)
            end
        end

        WhoFrameTotals:SetDrawLayer("OVERLAY", 10)
        GuildFrameNotesText:SetDrawLayer("OVERLAY", 10)

        GuildFrameTotals:SetDrawLayer("OVERLAY", 10)
        GuildFrameOnlineTotals:SetDrawLayer("OVERLAY", 10)

        local function ReplaceCharacterTextures()
            ApplyCustomTextures(FriendsFrame)
            ApplyCustomTextures(WhoFrame)
            ApplyCustomTextures(GuildFrame)
        end

        if FriendsFrame then
            HookScript(FriendsFrame, "OnShow", ReplaceCharacterTextures)
        end

        ReplaceCharacterTextures()
    end

    -- spellbookframe
    do
        local function ApplyCustomTextures(frame)
            if not frame then return end

            if not frame.customTopLeft then
                frame.customTopLeft = frame:CreateTexture(nil, "OVERLAY")
                frame.customTopLeft:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_top_left.tga")
                frame.customTopLeft:SetWidth(256)
                frame.customTopLeft:SetHeight(256)
                frame.customTopLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, 0)

                frame.customTopRight = frame:CreateTexture(nil, "OVERLAY")
                frame.customTopRight:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_top_right.tga")
                frame.customTopRight:SetWidth(128)
                frame.customTopRight:SetHeight(256)
                frame.customTopRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, 0)

                frame.customBottomLeft = frame:CreateTexture(nil, "OVERLAY")
                frame.customBottomLeft:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_bot_left.tga")
                frame.customBottomLeft:SetWidth(256)
                frame.customBottomLeft:SetHeight(256)
                frame.customBottomLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, -256)

                frame.customBottomRight = frame:CreateTexture(nil, "OVERLAY")
                frame.customBottomRight:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\paperdoll_bot_right.tga")
                frame.customBottomRight:SetWidth(128)
                frame.customBottomRight:SetHeight(256)
                frame.customBottomRight:SetPoint("TOPLEFT", frame, "TOPLEFT", 253, -256)

                -- spell button bg
                for i = 1, 12 do
                    local button = _G["SpellButton" .. i]
                    if button then
                        local bg = button:CreateTexture("DFRL_SpellButtonBG" .. i, "BACKGROUND", 7)
                        bg:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\ui\\spell_bg.tga")
                        bg:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
                        bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
                    end
                end
            end
        end

        local function ReplaceSpellBookTextures()
            ApplyCustomTextures(SpellBookFrame)
        end

        if SpellBookFrame then
            HookScript(SpellBookFrame, "OnShow", ReplaceSpellBookTextures)
        end

        ReplaceSpellBookTextures()
    end

    -- gamemenu
    do
        local gamemenuBtn = CreateFrame("Button", "DFRLGameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
        gamemenuBtn:SetText("|cFFFFD100Dragonflight:|r Reloaded")
        gamemenuBtn:SetPoint("TOP", GameMenuFrame, "TOP", 0, -35)
        gamemenuBtn:SetHeight(30)
        gamemenuBtn:SetWidth(150)
        gamemenuBtn:SetScript("OnClick", function()
            HideUIPanel(GameMenuFrame)
            DFRL.gui.Toggle()
        end)

        GameMenuButtonShop:ClearAllPoints()
        GameMenuButtonShop:SetPoint("TOP", gamemenuBtn, "BOTTOM", 0, -15)

        GameMenuFrame:SetWidth(GameMenuFrame:GetWidth() + 10)
        GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + 60)

        DFRL.gui.gamemenuBtn = gamemenuBtn
    end

    -- zoom
    ConsoleExec("CameraDistanceMaxFactor 5")

    -- callbacks
    local callbacks = {}

    callbacks.questLog = function(value)
        local r, g, b, a
        if value then
            r, g, b, a = 0.4, 0.4, 0.4, 1
        else
            r, g, b, a = 1, 1, 1, 1
        end

        local function IsBlacklisted(texture)
            local name = texture:GetName()
            local tex = texture:GetTexture()
            if not tex then return true end

            if name then
                if string.find(name, "Button") or string.find(name, "Icon") or string.find(name, "Portrait") then
                return true
                end
            end

            if string.find(tex, "Button") or string.find(tex, "Icon") or string.find(tex, "Portrait") or string.find(tex, "StationeryTest") then
                return true
            end

            return nil
        end

        local function AddBackground(frame)
            if not frame.Material then
                local tex = frame:CreateTexture(nil, "OVERLAY")
                tex:SetTexture("Interface\\Stationery\\StationeryTest1")
                tex:SetWidth(frame:GetWidth())
                tex:SetHeight(frame:GetHeight())
                tex:SetPoint("TOPLEFT", frame, 0, 0)
                tex:SetVertexColor(.8, .8, .8)
                frame.Material = tex
            end
            frame.Material:Show()
        end

        local function Darken(frame)
            if frame and frame.GetRegions then
                local name = frame.GetName and frame:GetName()

                if value and name and string.find(name, "^QuestLogDetailScrollFrame$") then
                AddBackground(frame)
                elseif frame.Material then
                frame.Material:Hide()
                end

                for _, region in pairs({frame:GetRegions()}) do
                if region and region.GetObjectType and region:GetObjectType() == "Texture" and region.SetVertexColor then
                    if not IsBlacklisted(region) then
                    region:SetVertexColor(r, g, b, a)
                    end
                end
                end
            end
        end

        Darken(QuestLogFrame)
        Darken(QuestLogDetailScrollFrame)
        Darken(QuestFrame)

        for _, name in pairs({"QuestFrameGreetingPanel", "QuestFrameProgressPanel", "QuestFrameRewardPanel", "QuestFrameDetailPanel"}) do
            Darken(_G[name])
        end
    end

    callbacks.gameMenu = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local lightColor = {1, 1, 1}
        local color = value and darkColor or lightColor

        local function ShouldExclude(frame)
            if not frame or not frame.GetName then return false end

            local name = frame:GetName()
            if not name then return false end

            return string.find(name, "MacroButton") or string.find(name, "CheckButton") or string.find(name, "Slider")
        end

        local function DarkenFrame(frame)
            if not frame then return end

            if ShouldExclude(frame) then return end

            if frame.SetBackdropColor then
                frame:SetBackdropColor(color[1], color[2], color[3], 1)
            end
            if frame.SetBackdropBorderColor then
                frame:SetBackdropBorderColor(color[1], color[2], color[3], 1)
            end

            local regions = {frame:GetRegions()}
            for i = 1, table.getn(regions) do
                local region = regions[i]
                if region:GetObjectType() == "Texture" then
                    local parent = region:GetParent()
                    if parent and not ShouldExclude(parent) then
                        region:SetVertexColor(color[1], color[2], color[3])
                    end
                end
            end

            local children = {frame:GetChildren()}
            for i = 1, table.getn(children) do
                local child = children[i]
                DarkenFrame(child)
            end
        end

        if GameMenuFrame then
            DarkenFrame(GameMenuFrame)
        end
    end

    callbacks.characterPanel = function(value)
        local darkColor = {0.4, 0.4, 0.4, 1}
        local lightColor = {1, 1, 1, 1}
        local color = value and darkColor or lightColor

        local function IsBlacklisted(texture)
            local name = texture:GetName()
            local tex = texture:GetTexture()
            if not tex then return true end

            if name then
                if string.find(name, "Icon") or string.find(name, "Portrait") or string.find(name, "Check") then
                    return true
                end
            end

            if string.find(tex, "Icon") or string.find(tex, "Portrait")  or string.find(tex, "Check") then
                return true
            end

            return nil
        end

        local function Darken(frame)
            if not frame or not frame.GetRegions then return end

            for _, region in pairs({frame:GetRegions()}) do
                if region and region.GetObjectType and region:GetObjectType() == "Texture" and region.SetVertexColor then
                    if not IsBlacklisted(region) then
                        region:SetVertexColor(unpack(color))
                    end
                end
            end

            local children = {frame:GetChildren()}
            for _, child in pairs(children) do
                if child and child:GetName() and not string.find(child:GetName(), "CharacterFrameCloseButton") then
                    Darken(child)
                end
            end
        end

        Darken(CharacterFrame)

        local subFrames = {
            "PaperDollFrame",
            "PetPaperDollFrame",
            "ReputationFrame",
            "SkillFrame",
            "HonorFrame"
        }

        for _, frameName in pairs(subFrames) do
            local frame = _G[frameName]
            if frame then
                Darken(frame)
            end
        end
    end

    callbacks.errorMessag = function (value)
        if value then
            UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
        else
            UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
        end
    end

    -- execute  callbacks
    DFRL:RegisterCallback("ui", callbacks)
end)
