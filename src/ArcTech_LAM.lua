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

        { type="description", text="|cc7cdbfMonday|r",    tooltip=function() return SV.events.monday    ~= "" and SV.events.monday    or "No events happening for this day" end },
        { type="description", text="|cc7cdbfTuesday|r",   tooltip=function() return SV.events.tuesday   ~= "" and SV.events.tuesday   or "No events happening for this day" end },
        { type="description", text="|cc7cdbfWednesday|r", tooltip=function() return SV.events.wednesday ~= "" and SV.events.wednesday or "No events happening for this day" end },
        { type="description", text="|cc7cdbfThursday|r",  tooltip=function() return SV.events.thursday  ~= "" and SV.events.thursday  or "No events happening for this day" end },
        { type="description", text="|cc7cdbfFriday|r",    tooltip=function() return SV.events.friday    ~= "" and SV.events.friday    or "No events happening for this day" end },
        { type="description", text="|cc7cdbfSaturday|r",  tooltip=function() return SV.events.saturday  ~= "" and SV.events.saturday  or "No events happening for this day" end },
        { type="description", text="|cc7cdbfSunday|r",    tooltip=function() return SV.events.sunday    ~= "" and SV.events.sunday    or "No events happening for this day" end },

		{ type = "divider" },

        { type = "header",      name = "|c286b1fDiscord Access|r" },

		{ type = "description",	text = "Scan the QR code to access the Discord Server.",tooltip = "Point your phone camera at the QR code (or screenshot it) to join." },

		{ type = "custom", width = "full", createFunc = function(parent) return CreateQRCode(parent) end },
	}
end

function RequestLAMRefresh()
    local LAM = LibAddonMenu2
    if not LAM then return end

    local panelName = panelName or "ArcTechSettingsPanel"
    LAM.RequestRefreshIfNeeded(panelName)
end
