-- ArcTech_Data.lua
ArcTech = ArcTech or {}

ArcTech.HOUSE_OWNER = '@Scribe Rob'
ArcTech.ARCANIST_GUILD_ID = 381665

ArcTech.HOUSES = {
	main = { label = "|cffff00Main - Kthendral Deep Mines|r", owner = ArcTech.HOUSE_OWNER, id = 113 },
	pvp = { label = "|cffff00PvP - Elinhir Arena|r", owner =ArcTech.HOUSE_OWNER, id = 66 },
	auction = { label = "|cffff00Auction - Theatre of the Ancestors|r", owner = ArcTech.HOUSE_OWNER, id = 119 },
}

ArcTech.QR_DATA = "https://discord.gg/hj2eWtra66"
ArcTech.QR_SIZE = 240

function ArcTech:InitSavedVars()
	self.SV = ZO_SavedVars:NewAccountWide("ArcTechSavedVars", 1, nil, {
		nextEventText = "Thursday - 19th February - 20:00 - Harrowstorms. Come and destroy the scourge of the Gray Host.",
	})
end