-- local function DelayedExec(delay, func)
--     local timer = 0
--     local frame = CreateFrame("Frame")
--     frame:SetScript("OnUpdate", function()
--         timer = timer + arg1
--         if timer >= delay then
--             func()
--             frame:SetScript("OnUpdate", nil)
--         end
--     end)
-- end


--     local s = 50

--     local f = CreateFrame("PlayerModel", nil, UIParent)
--     f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
--     f:SetWidth(s)
--     f:SetHeight(s)
--     f:SetUnit("player")

--     DelayedExec(0.1, function()
--         f:SetCamera(0)
--     end)

