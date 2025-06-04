DFRL:SetDefaults("tooltip", {
    enabled = {true},
    hidden = {false},

    toolTipMouse = {false, 1, "checkbox", "tweaks", "Show the tooltip above your cursor"},

})

DFRL:RegisterModule("tooltip", 1, function()
    d:DebugPrint("BOOTING")

    -- callbacks
    local callbacks = {}

    callbacks.toolTipMouse = function(value)
        if value then
            _G.GameTooltip_SetDefaultAnchor = function(tooltip, parent)
                tooltip:SetOwner(parent, "ANCHOR_CURSOR", 20, 0)
            end
        else
            _G.GameTooltip_SetDefaultAnchor = function(tooltip, parent)
                tooltip:SetOwner(parent, "ANCHOR_NONE")
                tooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
            end
        end
    end

    -- execute  callbacks
    DFRL:RegisterCallback("tooltip", callbacks)
end)
