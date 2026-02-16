-- ArcTech_LAM.lua
local ArcTech = ArcTech

function InitLAM()
	local LAM = LibAddonMenu2
	if not LAM then return end

	local panelName = "ArcTechSettingsPanel"

	local panelData = {
		type = "panel",
		name = "ArcTech",
		author = "Scribe Rob",
		version = "0.0.6",
		registerForRefresh = true,
		registerForDefaults = false,
	}

	LAM:RegisterAddonPanel(panelName, panelData)
	LAM:RegisterOptionControls(panelName, BuildOptions())
end

function BuildOptions()
	if not IsGuildMember() then
		return {
			{
				type = "description",
				text = "You're not currently in Arcanists.",
			},
			{
				type = "button",
				name = "Apply to Arcanists",
				tooltip = "Sends an application to the Arcanists Guild",
				disabled = function()
					return not CanApplyToGuild()
				end,
				func = function()
					ApplyToGuild("Application submitted via the ArcTech console addon")
				end,
				width = "full",
			},
		}
	end

	return {
		{ type = "header", name = "|c286b1fGuild Houses|r" },

		{
			type = "button",
			name = ArcTech.houses.main.label,
			tooltip = "Jump to the Main Guild House.",
			func = function() JumpToHouseEntry(ArcTech.houses.main) end,
			width = "full",
			disabled = function() return (ArcTech.houses.main.id or 0) == 0 end,
		},
		{
			type = "button",
			name = ArcTech.houses.pvp.label,
			tooltip = "Jump to the PvP house.",
			func = function() JumpToHouseEntry(ArcTech.houses.pvp) end,
			width = "full",
			disabled = function() return (ArcTech.houses.pvp.id or 0) == 0 end,
		},
		{
			type = "button",
			name = ArcTech.houses.auction.label,
			tooltip = "Jump to the Auction House.",
			func = function() JumpToHouseEntry(ArcTech.houses.auction) end,
			width = "full",
			disabled = function() return (ArcTech.houses.auction.id or 0) == 0 end,
		},

		{ type = "divider" },

		{ type = "header", name = "|c286b1fEvents for week commencing: 16-02-26|r" },

        { type="header", name="|cc7cdbfMonday|r",     tooltip=function() return ArcTech.SV.events.monday    ~= "" and ArcTech.SV.events.monday    or "No events happening for this day" end },
        { type="header", name="|cc7cdbfTuesday|r",    tooltip=function() return ArcTech.SV.events.tuesday   ~= "" and ArcTech.SV.events.tuesday   or "No events happening for this day" end },
        { type="header", name="|cc7cdbfWednesday|r",  tooltip=function() return ArcTech.SV.events.wednesday ~= "" and ArcTech.SV.events.wednesday or "No events happening for this day" end },
        { type="header", name="|cc7cdbfThursday|r",   tooltip=function() return ArcTech.SV.events.thursday  ~= "" and ArcTech.SV.events.thursday  or "No events happening for this day" end },
        { type="header", name="|cc7cdbfFriday|r",     tooltip=function() return ArcTech.SV.events.friday    ~= "" and ArcTech.SV.events.friday    or "No events happening for this day" end },
        { type="header", name="|cc7cdbfSaturday|r",   tooltip=function() return ArcTech.SV.events.saturday  ~= "" and ArcTech.SV.events.saturday  or "No events happening for this day" end },
        { type="header", name="|cc7cdbfSunday|r",     tooltip=function() return ArcTech.SV.events.sunday    ~= "" and ArcTech.SV.events.sunday    or "No events happening for this day" end },

		{ type = "divider" },

        { type = "header",      name = "|c286b1fDiscord Access|r" },

        {
            type = "button",
            name = "Scan the QR code to access the Discord Server.",
            tooltip = "Point your phone camera at the QR code (or screenshot it) to join.",
            func = function ()
                LibQRCode.CreateQRCode(ArcTech.QR.size, ArcTech.QR.data)
            end,
		    text = "Scan the QR code to access the Discord Server."
		}
	}
end

function RequestLAMRefresh()
    local LAM = LibAddonMenu2
    if not LAM then return end

    local panelName = panelName or "ArcTechSettingsPanel"
    LAM.RequestRefreshIfNeeded(panelName)
end
