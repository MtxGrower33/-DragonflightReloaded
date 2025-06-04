DFRL:SetDefaults("castbar", {
    enabled = {true},
    hidden = {false},

    darkMode = {false, 1, "checkbox", "appearance", "Enable dark mode for the castbar"},

    setFillDirection = {"left", 2, "dropdown", { "left", "right", "center" }, "castbar basic", "Set fill direction"},
    showShadow = {true, 3, "checkbox", "castbar basic", "Show drop shadow below the castbar"},
    barWidth = {200, 4, "slider", {120, 350}, "castbar basic", "Change castbar width"},
    barHeight = {16, 5, "slider", {10, 30}, "castbar basic", "Change castbar height"},

    showTime = {true, 6, "checkbox", "text", "Show casting time"},
    showSpell = {true, 7, "checkbox", "text", "Show spell name text"},
    fontSize = {12, 8, "slider", {5, 25}, "text", "Change castbar font size"},
    fontY = {-16, 9, "slider", {-20, 20}, "text", "Change castbar font Y offset"},

    carColor = {{1, 0.82, 0}, 10, "colourslider", "castbar color", "Change castbar color"},

})

DFRL:RegisterModule("castbar", 1, function()
    d:DebugPrint("BOOTING")

    local GetTime = GetTime
    local type = type
    local tostring = tostring
    local string = string
    local assert = assert
    local CreateFrame = CreateFrame
    local UIParent = UIParent
    local FAILED = FAILED
    local INTERRUPTED = INTERRUPTED

    -- hide stuff
    do
        CastingBarFrame:Hide()
        CastingBarFrame:SetScript("OnEvent", nil)
        CastingBarFrame:SetScript("OnUpdate", nil)
    end

    local castbar = {
        frame       = nil,
        barTexture  = nil,
        spark       = nil,
        spark2      = nil,  -- for centerr mode
        flashTex    = nil,
        backdrop    = nil,
        borderframe = nil,
        dropshadow  = nil,
        text        = nil,
        timeText    = nil,

        config = {
            width            = 200,
            height           = 16,
            bgTexture        = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\castbar\\CastingBarBackground.blp",
            barTexture       = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\castbar\\CastingBarStandard3.blp",
            dropshadow       = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\castbar\\CastingBarFrameDropShadow.blp",
            spark            = "Interface\\CastingBar\\UI-CastingBar-Spark",
            flashTex         = "Interface\\AddOns\\DragonflightReloaded\\media\\tex\\castbar\\CastingBarFrameFlash.tga",
            barColor         = { r = 1, g = 0.82, b = 0 },
            alphaSpeed       = 3.0,
            flashSpeed       = 5.0,
            holdTimeDuration = 1,
            font             = "Fonts\\FRIZQT__.TTF",
            fontSizeName     = 12,
            fontSizeTime     = 12,
            textColorName    = { r = 1, g = 1, b = 1 },
            textColorTime    = { r = 1, g = 1, b = 1 },
            fillDirection    = "left",
            animations = {
            useSpark = true,
            useFlash = true,
            },
        },

        state = {
            casting    = false,
            channeling = false,
            fadeOut    = false,
            flash      = false,
            holdTime   = 0,
            startTime  = 0,
            maxValue   = 0,
            endTime    = 0,
            duration   = 0,
            mode       = nil,
            flashAlpha = 0,
            currentProgress = 0, -- 0 to 1
        },
    }

    function castbar:Create(parent)
        local f = CreateFrame("Frame", "MyCastBarFrame", parent or UIParent)
        f:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
        f:SetHeight(self.config.height)
        f:SetWidth(self.config.width)
        f:Hide()

        _G.DFRL.castbar = f

        local bd = f:CreateTexture(nil, "BACKGROUND", 7)
        bd:SetAllPoints(f)
        bd:SetTexture(self.config.bgTexture)
        self.backdrop = bd

        local bar = f:CreateTexture(nil, "BORDER")
        bar:SetPoint("LEFT", f, "LEFT", 0, 0)
        bar:SetHeight(self.config.height)
        bar:SetWidth(0)
        bar:SetTexture(self.config.barTexture)
        bar:SetVertexColor(self.config.barColor.r, self.config.barColor.g, self.config.barColor.b)
        self.barTexture = bar

        _G.DFRL.castbar.bar = bar

        local borderFrame = f:CreateTexture(nil, "ARTWORK")
        borderFrame:SetAllPoints(f)
        borderFrame:SetTexture("Interface\\AddOns\\DragonflightReloaded\\media\\tex\\castbar\\CastingBarFrame.blp")
        self.borderframe = borderFrame

        local dropshadow = f:CreateTexture(nil, "BACKGROUND", 1)
        dropshadow:SetWidth(self.config.width + 1)
        dropshadow:SetHeight(self.config.height + 9)
        dropshadow:SetPoint("TOP", f, "BOTTOM", 0, 5)
        dropshadow:SetTexture(self.config.dropshadow)
        self.dropshadow = dropshadow

        -- spark
        if self.config.animations.useSpark then
            local spark = f:CreateTexture(nil, "OVERLAY")
            spark:SetHeight(self.config.height + 15)
            spark:SetWidth(25)
            spark:SetTexture(self.config.spark)
            spark:SetBlendMode("ADD")
            spark:Hide()
            self.spark = spark

            local spark2 = f:CreateTexture(nil, "OVERLAY")
            spark2:SetHeight(self.config.height + 15)
            spark2:SetWidth(25)
            spark2:SetTexture(self.config.spark)
            spark2:SetBlendMode("ADD")
            spark2:Hide()
            self.spark2 = spark2
        end

        -- flash
        if self.config.animations.useFlash then
            local flash = f:CreateTexture(nil, "OVERLAY")
            flash:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 5)
            flash:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, -5)
            flash:SetTexture(self.config.flashTex)
            -- flash:SetVertexColor(1, 1, 1)
            self.flashTex = flash
        end

        -- spellname
        local ts = f:CreateFontString(nil, "OVERLAY")
        ts:SetFont(self.config.font, self.config.fontSizeName, "OUTLINE")
        ts:SetPoint("LEFT", f, "LEFT", 5, -16)
        ts:SetTextColor(self.config.textColorName.r, self.config.textColorName.g, self.config.textColorName.b)
        self.text = ts

        -- time
        local tt = f:CreateFontString(nil, "OVERLAY")
        tt:SetFont(self.config.font, self.config.fontSizeTime, "OUTLINE")
        tt:SetPoint("RIGHT", f, "RIGHT", -5, -16)
        tt:SetTextColor(self.config.textColorTime.r, self.config.textColorTime.g, self.config.textColorTime.b)
        self.timeText = tt

        -- events
        f:RegisterEvent("SPELLCAST_START")
        f:RegisterEvent("SPELLCAST_STOP")
        f:RegisterEvent("SPELLCAST_FAILED")
        f:RegisterEvent("SPELLCAST_INTERRUPTED")
        f:RegisterEvent("SPELLCAST_DELAYED")
        f:RegisterEvent("SPELLCAST_CHANNEL_START")
        f:RegisterEvent("SPELLCAST_CHANNEL_UPDATE")
        f:RegisterEvent("SPELLCAST_CHANNEL_STOP")

        f:SetScript("OnEvent", function()
            castbar:HandleEvent(event, arg1, arg2)
        end)

        f:SetScript("OnUpdate", function()
            castbar:OnUpdate(arg1)
        end)

        self.frame = f
    end

    function castbar:UpdateBarVisual(progress)
        assert(type(progress) == "number", "Progress must be a number")
        assert(self.frame, "Frame must exist before updating visuals")
        assert(self.barTexture, "Bar texture must exist before updating")
        assert(self.config.fillDirection == "left" or self.config.fillDirection == "right" or self.config.fillDirection == "center",
                "Invalid fill direction: " .. tostring(self.config.fillDirection))

        if progress < 0 then progress = 0 end
        if progress > 1 then progress = 1 end

        local totalWidth = self.config.width
        local newWidth = progress * totalWidth
        if newWidth < 0.1 then newWidth = 0.1 end -- putting this to 0 bugs out center mode so keep 0.1

        -- handle fill
        if self.config.fillDirection == "left" then
            -- left to right
            self.barTexture:SetPoint("LEFT", self.frame, "LEFT", 0, 0)
            self.barTexture:SetWidth(newWidth)
            self.barTexture:SetTexCoord(0, progress, 0, 1)

        elseif self.config.fillDirection == "right" then
            -- right to left
            local xOffset = totalWidth - newWidth
            self.barTexture:SetPoint("LEFT", self.frame, "LEFT", xOffset, 0)
            self.barTexture:SetWidth(newWidth)
            self.barTexture:SetTexCoord(1-progress, 1, 0, 1)

        elseif self.config.fillDirection == "center" then
            local halfWidth = newWidth / 2
            local xOffset = (totalWidth / 2) - halfWidth
            self.barTexture:SetPoint("LEFT", self.frame, "LEFT", xOffset, 0)
            self.barTexture:SetWidth(newWidth)

            local halfProgress = progress / 2
            self.barTexture:SetTexCoord(0.5-halfProgress, 0.5+halfProgress, 0, 1)
        end

        -- update spark position
        if self.spark and progress > 0 and progress < 1 then
            if self.config.fillDirection == "left" then
                local sparkPos = newWidth
                self.spark:SetPoint("CENTER", self.frame, "LEFT", sparkPos, 0)
                self.spark:Show()
                if self.spark2 then self.spark2:Hide() end
            elseif self.config.fillDirection == "right" then
                local sparkPos = totalWidth - newWidth
                self.spark:SetPoint("CENTER", self.frame, "LEFT", sparkPos, 0)
                self.spark:Show()
                if self.spark2 then self.spark2:Hide() end
            elseif self.config.fillDirection == "center" then
                -- two sparks at both edges
                local halfWidth = newWidth / 2
                local centerPoint = totalWidth / 2
                local leftSparkPos = centerPoint - halfWidth
                local rightSparkPos = centerPoint + halfWidth

                self.spark:SetPoint("CENTER", self.frame, "LEFT", leftSparkPos, 0)
                self.spark:Show()

                if self.spark2 then
                    self.spark2:SetPoint("CENTER", self.frame, "LEFT", rightSparkPos, 0)
                    self.spark2:Show()
                end
            end
        elseif self.spark then
            self.spark:Hide()
            if self.spark2 then self.spark2:Hide() end
        end
    end

    function castbar:OnUpdate(elapsed)
        local s = self.state
        local c = self.config
        local now = GetTime()

        if s.casting then
            local targetProgress = (now - s.startTime) / (s.maxValue - s.startTime)
            if targetProgress > 1 then targetProgress = 1 end
            if targetProgress < 0 then targetProgress = 0 end

            local progressDiff = targetProgress - s.currentProgress
            local step = elapsed * 2

            -- handle both forward progress and pushback
            if progressDiff > 0 then
                s.currentProgress = s.currentProgress + step
                if s.currentProgress > targetProgress then
                    s.currentProgress = targetProgress
                end
            elseif progressDiff < 0 then
                -- pushback occurred - move bar backward quickly
                s.currentProgress = s.currentProgress + (step * progressDiff * 12)
                if s.currentProgress < targetProgress then
                    s.currentProgress = targetProgress
                end
            end

            self:UpdateBarVisual(s.currentProgress)
            if self.flashTex then self.flashTex:Hide() end

        elseif s.channeling then
            local timeLeft = s.endTime - now
            if timeLeft <= 0 then
            s.channeling = false
            s.fadeOut = true
            s.currentProgress = 0
            self:UpdateBarVisual(0)
            return
            end

            local targetProgress = timeLeft / (s.endTime - s.startTime)
            if targetProgress < 0 then targetProgress = 0 end
            if targetProgress > 1 then targetProgress = 1 end

            local progressDiff = targetProgress - s.currentProgress
            local step = elapsed * 2

            if progressDiff < 0 then
            s.currentProgress = s.currentProgress + step * progressDiff
            if s.currentProgress < targetProgress then
                s.currentProgress = targetProgress
            end
            end

            self:UpdateBarVisual(s.currentProgress)
            if self.flashTex then self.flashTex:Hide() end

        elseif now < s.holdTime then
            -- hold state - no fade yet
            return

        elseif s.flash and self.flashTex then
            s.flashAlpha = s.flashAlpha + (c.flashSpeed * elapsed)
            if s.flashAlpha > 1 then s.flashAlpha = 1 end

            self.flashTex:SetAlpha(s.flashAlpha)
            self.flashTex:Show()

            if s.flashAlpha >= 1 then
                s.flash = false
                s.fadeOut = true
            end


        elseif s.fadeOut then
            local currentAlpha = self.frame:GetAlpha()
            local newAlpha = currentAlpha - (c.alphaSpeed * elapsed)

            if newAlpha <= 0 then
            s.fadeOut = false
            self.frame:Hide()
            self.frame:SetAlpha(1)
            if self.flashTex then
                self.flashTex:SetAlpha(0)
                self.flashTex:Hide()
            end
            else
            self.frame:SetAlpha(newAlpha)
            end
        end

        -- update time during cast/channel
        if s.casting or s.channeling then
            local remaining
            if s.casting then
            remaining = s.maxValue - now
            else
            remaining = s.endTime - now
            end

            if remaining < 0 then remaining = 0 end

            -- time formatting
            local timeStr
            if remaining >= 10 then
            timeStr = string.format("%.0f", remaining)
            elseif remaining >= 1 then
            timeStr = string.format("%.1f", remaining)
            else
            timeStr = string.format("%.2f", remaining)
            end

            self.timeText:SetText(timeStr)
        end
    end

    -- event handler
    function castbar:HandleEvent(event, arg1, arg2)
        assert(event, "Event name cannot be nil")
        assert(self.frame, "Frame must exist before handling events")
        assert(self.state, "State table must exist")

        local s = self.state
        local c = self.config

        if event == "SPELLCAST_START" then
            s.startTime = GetTime()
            s.maxValue = s.startTime + (arg2 / 1000)
            s.currentProgress = 0

            self.barTexture:SetVertexColor(c.barColor.r, c.barColor.g, c.barColor.b)
            self:UpdateBarVisual(0)

            self.text:SetText(arg1)
            s.holdTime = 0
            s.casting = true
            s.channeling = false
            s.fadeOut = false
            s.flash = false
            s.flashAlpha = 0
            s.mode = "casting"
            self.flashTex:SetVertexColor(1, 1, 1) -- reset to white
            self.frame:SetAlpha(1)
            self.frame:Show()

        elseif event == "SPELLCAST_STOP" or event == "SPELLCAST_CHANNEL_STOP" then
            if self.frame:IsShown() then
            -- complete the bar instantly like blizz
            s.currentProgress = 1
            self:UpdateBarVisual(1)
            self.barTexture:SetVertexColor(0, 1, 0)

            if event == "SPELLCAST_STOP" then
                s.casting = false
            else
                s.channeling = false
            end

            s.flash = true
            s.flashAlpha = 0

            self.flashTex:SetVertexColor(0, 1, 0)
            self.flashTex:Show()

            s.fadeOut = true
            s.mode = "flash"
            end

        elseif event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" then
            if self.frame:IsShown() and not s.channeling then
            s.currentProgress = 1
            self:UpdateBarVisual(1)
            self.barTexture:SetVertexColor(1, 0, 0)

            if event == "SPELLCAST_INTERRUPTED" then
                self.flashTex:SetVertexColor(1, 0, 0)
            else
                self.flashTex:SetVertexColor(0, 1, 0)
            end

            if event == "SPELLCAST_FAILED" then
                self.text:SetText(FAILED)
            else
                self.text:SetText(INTERRUPTED)
            end

            s.casting = false
            s.fadeOut = true
            s.holdTime = GetTime() + c.holdTimeDuration
            s.mode = "hold"
            end

        elseif event == "SPELLCAST_DELAYED" then
            if self.frame:IsShown() then
            s.startTime = s.startTime + (arg1 / 1000)
            s.maxValue = s.maxValue + (arg1 / 1000)
            s.mode = "delayed"
            end

        elseif event == "SPELLCAST_CHANNEL_START" then
            s.startTime = GetTime()
            s.duration = arg1 / 1000
            s.endTime = s.startTime + s.duration
            s.currentProgress = 1 -- channeling starts full

            self.barTexture:SetVertexColor(c.barColor.r, c.barColor.g, c.barColor.b)
            self:UpdateBarVisual(1)

            self.text:SetText(arg2)
            s.holdTime = 0
            s.casting = false
            s.channeling = true
            s.fadeOut = false
            s.flash = false
            s.flashAlpha = 0
            s.mode = "channeling"
            self.frame:SetAlpha(1)
            self.frame:Show()

        elseif event == "SPELLCAST_CHANNEL_UPDATE" then
            if self.frame:IsShown() then
            local origDur = s.endTime - s.startTime
            s.endTime = GetTime() + (arg1 / 1000)
            s.startTime = s.endTime - origDur
            s.mode = "channel_update"
            end
        end
    end

    castbar:Create()

    -- callbacks
    local callbacks = {}

    callbacks.darkMode = function(value)
        local darkColor = {0.2, 0.2, 0.2}
        local specialDark = {0.5, 0.5, 0.5}
        local lightColor = {1, 1, 1}

        local color = value and darkColor or lightColor
        if castbar.backdrop then
            castbar.backdrop:SetVertexColor(color[1], color[2], color[3])
        end

        local _ = value and specialDark or lightColor
        if castbar.backdrop then
            local finalColor = value and {0.35, 0.35, 0.35} or lightColor
            castbar.backdrop:SetVertexColor(finalColor[1], finalColor[2], finalColor[3])
        end

        if castbar.borderframe then
            local borderColor = value and specialDark or lightColor
            castbar.borderframe:SetVertexColor(borderColor[1], borderColor[2], borderColor[3])
        end
    end

    callbacks.setFillDirection = function(direction)
        if direction == "left" or direction == "right" or direction == "center" then
            castbar.config.fillDirection = direction
            if castbar.frame and castbar.frame:IsShown() then
                castbar:UpdateBarVisual(castbar.state.currentProgress)
            end
        end
    end

    callbacks.showTime = function(value)
        if value then
            castbar.timeText:Show()
        else
            castbar.timeText:Hide()
        end
    end

    callbacks.showSpell = function(value)
        if value then
            castbar.text:Show()
        else
            castbar.text:Hide()
        end
    end

    callbacks.showShadow = function(value)
        if value then
            castbar.dropshadow:Show()
        else
            castbar.dropshadow:Hide()
        end
    end

    callbacks.barWidth = function(value)
        castbar.config.width = value

        if castbar.frame then
            castbar.frame:SetWidth(value)
        end

        if castbar.dropshadow then
            castbar.dropshadow:SetWidth(value + 1)
        end

        if castbar.frame and castbar.frame:IsShown() then
            castbar:UpdateBarVisual(castbar.state.currentProgress)
        end
    end

    callbacks.barHeight = function(value)
        castbar.config.height = value
        if castbar.frame then
            castbar.frame:SetHeight(value)
            castbar.barTexture:SetHeight(value)
            if castbar.spark then castbar.spark:SetHeight(value + 15) end
            if castbar.spark2 then castbar.spark2:SetHeight(value + 15) end
            castbar.dropshadow:SetHeight(value + 9)
        end
    end

    callbacks.fontSize = function(value)
        castbar.config.fontSizeName = value
        castbar.config.fontSizeTime = value
        if castbar.text then castbar.text:SetFont(castbar.config.font, value, "OUTLINE") end
        if castbar.timeText then castbar.timeText:SetFont(castbar.config.font, value, "OUTLINE") end
    end

    callbacks.carColor = function(value)
        castbar.config.barColor = {r = value[1], g = value[2], b = value[3]}
        if castbar.barTexture then
            castbar.barTexture:SetVertexColor(value[1], value[2], value[3])
        end
    end

    callbacks.fontY = function(value)
        if castbar.text then
            castbar.text:SetPoint("LEFT", castbar.frame, "LEFT", 5, value)
        end
        if castbar.timeText then
            castbar.timeText:SetPoint("RIGHT", castbar.frame, "RIGHT", -5, value)
        end
    end

    -- execute callbacks
    DFRL:RegisterCallback("castbar", callbacks)
end)
