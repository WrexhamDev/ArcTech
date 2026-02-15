-- ArcTech_LAM.lua
ArcTech = ArcTech or {}

function ArcTech:InitLAM()
	local LAM = LibAddonMenu2
	if not LAM then return end

	local panelName = "ArcTechSettingsPanel"
	self.panelName = panelName

	local panelData = {
		type = "panel",
		name = "ArcTech",
		author = "Scribe Rob",
		version = "0.1.0",
		registerForRefresh = true,
		registerForDefaults = false,
	}

	LAM:RegisterAddonPanel(panelName, panelData)
	LAM:RegisterOptionControls(panelName, self:BuildOptions())
end

function ArcTech:BuildOptions()
	if not self:IsGuildMember() then
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
					return not ArcTech:CanApplyToGuild()
				end,
				func = function()
					ArcTech:ApplyToGuild("Application submitted via the ArcTech console addon")
				end,
				width = "full",
			},
		}
	end

	local SV = self.SV

	return {
		{ type = "header", name = "|c286b1fGuild Houses|r" },

		{
			type = "button",
			name = self.HOUSES.main.label,
			tooltip = "Jump to the Main Guild House.",
			func = function() self:JumpToHouseEntry(self.HOUSES.main) end,
			width = "full",
			disabled = function() return (self.HOUSES.main.id or 0) == 0 end,
		},
		{
			type = "button",
			name = self.HOUSES.pvp.label,
			tooltip = "Jump to the PvP house.",
			func = function() self:JumpToHouseEntry(self.HOUSES.pvp) end,
			width = "full",
			disabled = function() return (self.HOUSES.pvp.id or 0) == 0 end,
		},
		{
			type = "button",
			name = self.HOUSES.auction.label,
			tooltip = "Jump to the Auction House.",
			func = function() self:JumpToHouseEntry(self.HOUSES.auction) end,
			width = "full",
			disabled = function() return (self.HOUSES.auction.id or 0) == 0 end,
		},

		{ type = "divider" },

		{ type = "header", name = "|c286b1fEvents for week commencing: 16-02-26|r" },

		{ type = "description", text = "|cc7cdbfMonday|r",    tooltip = "No events happening for this day" },
		{ type = "description", text = "|cc7cdbfTuesday|r",   tooltip = "No events happening for this day" },
		{ type = "description", text = "|cc7cdbfWednesday|r", tooltip = "No events happening for this day" },
		{ type = "description", text = "|cc7cdbfThursday|r",  tooltip = function() return SV.nextEventText end },
		{ type = "description", text = "|cc7cdbfFriday|r",    tooltip = "No events happening for this day" },
		{ type = "description", text = "|cc7cdbfSaturday|r",  tooltip = "No events happening for this day" },
		{ type = "description", text = "|cc7cdbfSunday|r",    tooltip = "No events happening for this day" },

		{ type = "divider" },

		{ type = "header", name = "|c286b1fDiscord Access|r" },
		{
			type = "description",
			text = "Scan the QR code to access the Discord Server.",
			tooltip = "Point your phone camera at the QR code (or screenshot it) to join.",
		},
		{
			type = "custom",
			width = "full",
			createFunc = function(parent)
				return self:CreateLAMQRCodeRow(parent)
			end,
		},
	}
end

--function ArcTech:RequestLAMRefresh()
	--local LAM = LibAddonMenu2
	--if not LAM then return end

--	local panelName = self.panelName or "ArcTechSettingsPanel"

	-- Your build seems to NOT have util, so guard it hard.
--	if LAM.util and type(LAM.util.RequestRefreshIfNeeded) == "function" then
--		LAM.util.RequestRefreshIfNeeded(panelName)
--		return
--	end

	-- Some other builds expose it as a direct method
--	if type(LAM.RequestRefreshIfNeeded) == "function" then
--		LAM:RequestRefreshIfNeeded(panelName)
--		return
--	end

-- No supported refresh method on this LAM build: do nothing (no error).
--end