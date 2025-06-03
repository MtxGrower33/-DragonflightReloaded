---@diagnostic disable: undefined-global, deprecated
setfenv(1, DFRL:GetEnvironment())
d.DebugPrint("BOOTING")
-- ALL CODE HERE RUNS RIGHT AWAY, NOT ON MODULE LOAD ("PLAYER_ENTERING_WORLD")

--===========================
-- SHAGUTWEAKS FIXES
--===========================

function _G.ShaguFix()
    -- disable redundant or incompatible features -- config isnt loaded bug
    do
        if not ShaguTweaks then return end
        local T = ShaguTweaks.T
        ShaguTweaks.mods[T["Hide Errors"]].enable = function() end
        ShaguTweaks.mods[T["Darkened UI"]].enable = function() end
        ShaguTweaks.mods[T["Hide Gryphons"]].enable = function() end
        ShaguTweaks.mods[T["MiniMap Clock"]].enable = function() end
        ShaguTweaks.mods[T["MiniMap Tweaks"]].enable = function() end
        ShaguTweaks.mods[T["MiniMap Square"]].enable = function() end
        ShaguTweaks.mods[T["Movable Unit Frames"]].enable = function() end
        ShaguTweaks.mods[T["Real Health Numbers"]].enable = function() end
        ShaguTweaks.mods[T["Unit Frame Big Health"]].enable = function() end
        ShaguTweaks.mods[T["Reduced Actionbar Size"]].enable = function() end
        ShaguTweaks.mods[T["Unit Frame Class Colors"]].enable = function() end
        ShaguTweaks.mods[T["Unit Frame Class Portraits"]].enable = function() end

        local ShaguTweaksExtras = IsAddOnLoaded("ShaguTweaks-Extras")
        if ShaguTweaksExtras then
            ShaguTweaks.mods[T["Dragonflight Gryphons"]].enable = function() end
            ShaguTweaks.mods[T["Show Bags"]].enable = function() end
            ShaguTweaks.mods[T["Floating Actionbar"]].enable = function() end
            ShaguTweaks.mods[T["Show Energy Ticks"]].enable = function() end
            ShaguTweaks.mods[T["Show Micro Menu"]].enable = function() end
            ShaguTweaks.mods[T["Reagent Counter"]].enable = function() end
            ShaguTweaks.mods[T["Center Vertical Actionbar"]].enable = function() end
        end
    end

    -- shagu bag fix (item rarity causes borders on CharacterBagXSlots)
    -- but we still want to keep the feature
    do
        if not ShaguTweaks then return end
        local mod = ShaguTweaks.mods[ShaguTweaks.T["Item Rarity Borders"]]
        if not mod then return end

        local orig = mod.enable
        mod.enable = function(self)
            orig(self)

            local skip = {
                "CharacterBag0Slot","CharacterBag1Slot",
                "CharacterBag2Slot","CharacterBag3Slot",
                "KeyRingButton"
            }

            for _, name in pairs(skip) do
                local btn = _G[name]
                if btn and btn.ShaguTweaks_border then
                btn.ShaguTweaks_border:Hide()
                end
            end
        end
    end

    -- disable GUI
    do
        if not ShaguTweaks then return end
        GameMenuButtonAdvancedOptions:Hide()
        GameMenuButtonAdvancedOptions:SetScript("OnClick", nil)
        AdvancedSettingsGUI:Hide()
        AdvancedSettingsGUI.Show = function() end
    end
end

-- run instant in case it ws loaded already
ShaguFix()

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    if event=="ADDON_LOADED" then

        ShaguFix()

        d.DebugPrint("ShaguTweaks temp hotfix applied ADDON_LOADED")
    end
end)

--===========================
-- BAGSHUI FIXES
--===========================
