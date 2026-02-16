-- ArcTech_LAM.lua
local ArcTech = ArcTech

local PANEL_NAME = "ArcTechSettingsPanel"

function InitLAM()
    local LAM = LibAddonMenu2
    if not LAM then return end

    local panelData = {
        type = "panel",
        name = "ArcTech",
        author = "Scribe Rob",
        version = "0.0.6",
        registerForRefresh = true,
        registerForDefaults = false,
    }

    LAM:RegisterAddonPanel(PANEL_NAME, panelData)
    LAM:RegisterOptionControls(PANEL_NAME, BuildOptions())
end

-- Disable helper: returns true when control should be disabled
local function MembersOnlyDisabled()
    return not IsGuildMember()
end

local function OfficerOnlyDisabled()
    return (not IsGuildMember()) or (not IsOfficer())
end

-- Optional: show a locked tooltip without breaking the control
local function LockedTooltip(original)
    if not IsGuildMember() then
        return "Locked: join Arcanists to access this section."
    end
    return original
end

function BuildOptions()
    local opts = {}

    -- ===== Guild Houses (always visible) =====
    opts[#opts + 1] = { type = "header", name = "|c286b1fGuild Houses|r" }

    opts[#opts + 1] = {
        type = "button",
        name = ArcTech.houses.main.label,
        tooltip = "Jump to the Main Guild House.",
        func = function() JumpToHouseEntry(ArcTech.houses.main) end,
        width = "full",
        disabled = function() return (ArcTech.houses.main.id or 0) == 0 end,
    }

    opts[#opts + 1] = {
        type = "button",
        name = ArcTech.houses.pvp.label,
        tooltip = "Jump to the PvP house.",
        func = function() JumpToHouseEntry(ArcTech.houses.pvp) end,
        width = "full",
        disabled = function() return (ArcTech.houses.pvp.id or 0) == 0 end,
    }

    opts[#opts + 1] = {
        type = "button",
        name = ArcTech.houses.auction.label,
        tooltip = "Jump to the Auction House.",
        func = function() JumpToHouseEntry(ArcTech.houses.auction) end,
        width = "full",
        disabled = function() return (ArcTech.houses.auction.id or 0) == 0 end,
    }

    opts[#opts + 1] = { type = "divider" }

    -- ===== Non-member block (apply) =====
    if not IsGuildMember() then
        opts[#opts + 1] = {
            type = "description",
            text = "You're not currently in Arcanists. You can still use Guild Houses above.\n\nJoin the guild to unlock events and Discord tools.",
        }

        opts[#opts + 1] = {
            type = "button",
            name = "Apply to Arcanists",
            tooltip = "Sends an application to the Arcanists Guild",
            disabled = function() return not CanApplyToGuild() end,
            func = function()
                ApplyToGuild("Application submitted via the ArcTech console addon")
                RequestLAMRefresh()
            end,
            width = "full",
        }

        opts[#opts + 1] = { type = "divider" }
    end

    -- ===== Officer-only fun button (locked if not member/officer) =====
    opts[#opts + 1] = { type = "header", name = "|c286b1fSuper Secret Button|r" }
    opts[#opts + 1] = {
        type = "button",
        name = "Don't press me!",
        tooltip = function() return LockedTooltip("What does this do") end,
        func = function() JumpToHouseEntry(ArcTech.houses.main) end,
        width = "full",
        disabled = OfficerOnlyDisabled,
    }

    opts[#opts + 1] = { type = "divider" }

    -- ===== Events (members only) =====
    opts[#opts + 1] = { type = "header", name = "|c286b1fEvents for week commencing: 16-02-26|r" }

    local function GetEventText(dayKey)
        local events = ArcTech.SV and ArcTech.SV.events
        local v = events and events[dayKey]
        if type(v) ~= "string" then v = "" end
        return v
    end

    local function EventTip(dayKey)
        if not IsGuildMember() then
            return "Locked: join Arcanists to view events."
        end

        local v = GetEventText(dayKey)
        return (v ~= "" and v) or "No events happening for this day"
    end

    local function EventLabel(dayName, dayKey)
        local v = GetEventText(dayKey)

        -- your rule:
        -- c7cdbf if "", ff0000 if it has a value
        local color = (v == "" and "c7cdbf") or "ff0000"

        return string.format("|c%s%s|r", color, dayName)
    end

    local function EventRow(dayName, dayKey)
        return {
            type = "button",
            name = function() return EventLabel(dayName, dayKey) end, -- dynamic
            tooltip = function() return EventTip(dayKey) end,
            disabled = true,
        }
    end

    opts[#opts + 1] = EventRow("Monday", "monday")
    opts[#opts + 1] = EventRow("Tuesday", "tuesday")
    opts[#opts + 1] = EventRow("Wednesday", "wednesday")
    opts[#opts + 1] = EventRow("Thursday", "thursday")
    opts[#opts + 1] = EventRow("Friday", "friday")
    opts[#opts + 1] = EventRow("Saturday", "saturday")
    opts[#opts + 1] = EventRow("Sunday", "sunday")

    opts[#opts + 1] = { type = "divider" }

    -- ===== Discord / QR (members only) =====
    opts[#opts + 1] = { type = "header", name = "|c286b1fDiscord Access|r" }

    opts[#opts + 1] = {
        type = "description",
        text = "Scan the QR code to access the Discord Server.",
        tooltip = function() return LockedTooltip("Point your phone camera at the QR code (or screenshot it) to join.") end,
    }

    -- Render QR as a custom row (NOT a button)
    opts[#opts + 1] = {
        type = "custom",
        width = "full",
        disabled = MembersOnlyDisabled,
        createFunc = function(parent)
            -- If locked, show a small label instead of QR
            if not IsGuildMember() then
                local lbl = WINDOW_MANAGER:CreateControl(nil, parent, CT_LABEL)
                lbl:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
                lbl:SetText("|cFFCC00Join Arcanists to view the QR code.|r")
                parent:SetHeight(24)
                return lbl
            end

            if not LibQRCode or not LibQRCode.CreateQRControl then
                local lbl = WINDOW_MANAGER:CreateControl(nil, parent, CT_LABEL)
                lbl:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
                lbl:SetText("|cFF0000LibQRCode missing or not loaded|r")
                parent:SetHeight(24)
                return lbl
            end

            local size = (ArcTech.QR and ArcTech.QR.size) or 240
            local data = (ArcTech.QR and ArcTech.QR.data) or ""

            local qr = LibQRCode.CreateQRControl(size, data)
            qr:SetParent(parent)
            qr:ClearAnchors()
            qr:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)

            parent:SetHeight(size + 8)
            return qr
        end,
    }

    return opts
end

function RequestLAMRefresh()
    local LAM = LibAddonMenu2
    if not LAM then return end

    -- Depending on LAM build, this may or may not exist. Guard it.
    if type(LAM.RequestRefreshIfNeeded) == "function" then
        LAM:RequestRefreshIfNeeded(PANEL_NAME)
    end
end