-- ArcTech_LAM.lua
local ArcTech = ArcTech

local PANEL_NAME = "ArcTechSettingsPanel"

-- Helper: safe colour tokens
local function C(key)
    local t = ArcTech.Status_Colours or {}
    return t[key] or "|cFFFFFF"
end

local function EndC()
    return "|r"
end

-- Apply colour + reset
local function ColorText(key, text)
    return string.format("%s%s%s", C(key), tostring(text or ""), EndC())
end

-- If disabled, force disabled colour, else use provided colour key (or standard)
local function ColorTextIf(enabled, activeKey, text)
    if not enabled then
        return ColorText("disabled", text)
    end
    return ColorText(activeKey or "standard", text)
end

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
    opts[#opts + 1] = { type = "header", name = ColorText("active", "Guild Houses") }

    -- Button labels: standard unless the button is disabled (then disabled colour)
    local function HouseButton(entry, tooltipText)
        local isEnabled = (entry and (entry.id or 0) ~= 0)
        return {
            type = "button",
            name = function() return ColorTextIf(isEnabled, "standard", entry.label) end,
            tooltip = tooltipText,
            func = function() JumpToHouseEntry(entry) end,
            width = "full",
            disabled = function() return not isEnabled end,
        }
    end

    opts[#opts + 1] = HouseButton(ArcTech.houses.main, "Jump to the Main Guild House.")
    opts[#opts + 1] = HouseButton(ArcTech.houses.pvp, "Jump to the PvP house.")
    opts[#opts + 1] = HouseButton(ArcTech.houses.auction, "Jump to the Auction House.")

    -- ===== Non-member block (apply) =====
    if not IsGuildMember() then
        opts[#opts + 1] = {
            type = "description",
            text = ColorText("standard",
                "You're not currently in Arcanists. You can still use Guild Houses above.\n\nJoin the guild to unlock events and Discord tools."
            ),
        }

        local canApply = CanApplyToGuild and CanApplyToGuild() or false
        opts[#opts + 1] = {
            type = "button",
            name = function() return ColorTextIf(canApply, "standard", "Apply to Arcanists") end,
            tooltip = "Sends an application to the Arcanists Guild",
            disabled = function() return not canApply end,
            func = function()
                ApplyToGuild("Application submitted via the ArcTech console addon")
                RequestLAMRefresh()
            end,
            width = "full",
        }
 end

    -- ===== Officer-only fun button =====
    opts[#opts + 1] = { type = "header", name = ColorText("active", "Super Secret Button") }

    opts[#opts + 1] = {
        type = "button",
        name = function()
            local enabled = not OfficerOnlyDisabled()
            return ColorTextIf(enabled, "standard", "Don't press me!")
        end,
        tooltip = function() return LockedTooltip("What does this do") end,
        func = function() JumpToHouseEntry(ArcTech.houses.main) end,
        width = "full",
        disabled = OfficerOnlyDisabled,
    }

    -- ===== Events (members only) =====
    opts[#opts + 1] = { type = "header", name = ColorText("active", "Events for week commencing: 16-02-26") }

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

    -- Label rules:
    -- - populated event => green (active)
    -- - empty => standard
    -- - if the row is disabled => disabled colour
    local function EventLabel(dayName, dayKey, enabled)
        local v = GetEventText(dayKey)
        local key = (v ~= "" and "active") or "standard"
        return ColorTextIf(enabled, key, dayName)
    end

    local function EventRow(dayName, dayKey)
        return {
            type = "button",
            name = function()
                -- We keep these rows unclickable; colour them as disabled
                local enabled = ArcTech.SV.dayName ~= ""
                return EventLabel(dayName, dayKey, enabled)
            end,
            tooltip = function() return EventTip(dayKey) end,
            disabled = false,
        }
    end

    opts[#opts + 1] = EventRow("Monday", "monday")
    opts[#opts + 1] = {
        type = 'editbox',
        name = 'Edit Monday Event',
        getFunc = function()
            return ArcTech.SV.monday
        end,
        setFunc = function(v)
            print(v)
        end,
        isMultiLine = true,
        requiresReload = true,
        disabled = not IsOfficer(),
        tooltip = 'Edit Mondays Event'
    }
    opts[#opts + 1] = EventRow("Tuesday", "tuesday")
    opts[#opts + 1] = EventRow("Wednesday", "wednesday")
    opts[#opts + 1] = EventRow("Thursday", "thursday")
    opts[#opts + 1] = EventRow("Friday", "friday")
    opts[#opts + 1] = EventRow("Saturday", "saturday")
    opts[#opts + 1] = EventRow("Sunday", "sunday")

    -- ===== Discord / QR (members only) =====
    opts[#opts + 1] = { type = "header", name = ColorText("active", "Discord Access") }

    opts[#opts + 1] = {
        type = "description",
        text = ColorText("standard", "Scan the QR code to access the Discord Server."),
        tooltip = function() return LockedTooltip("Point your phone camera at the QR code (or screenshot it) to join.") end,
    }

    opts[#opts + 1] = {
        type = "custom",
        width = "full",
        disabled = MembersOnlyDisabled,
        createFunc = function(parent)
            if not IsGuildMember() then
                local lbl = WINDOW_MANAGER:CreateControl(nil, parent, CT_LABEL)
                lbl:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
                lbl:SetText(ColorText("disabled", "Join Arcanists to view the QR code."))
                parent:SetHeight(24)
                return lbl
            end

            if not LibQRCode or not LibQRCode.CreateQRControl then
                local lbl = WINDOW_MANAGER:CreateControl(nil, parent, CT_LABEL)
                lbl:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
                lbl:SetText(ColorText("disabled", "LibQRCode missing or not loaded"))
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

    if type(LAM.RequestRefreshIfNeeded) == "function" then
        LAM:RequestRefreshIfNeeded(PANEL_NAME)
    end
end