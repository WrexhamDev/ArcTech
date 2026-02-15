-- ArcTech_Data.lua
local HOUSE_OWNER = '@Scribe Rob'
local ARCANIST_GUILD_ID = 381665

local HOUSES = {
	main = { label = "|cffff00Main - Kthendral Deep Mines|r", owner = HOUSE_OWNER, id = 113 },
	pvp = { label = "|cffff00PvP - Elinhir Arena|r", owner =HOUSE_OWNER, id = 66 },
	auction = { label = "|cffff00Auction - Theatre of the Ancestors|r", owner = HOUSE_OWNER, id = 119 },
}

local QR_DATA = "https://discord.gg/hj2eWtra66"
local QR_SIZE = 240

function InitSavedVars()
	SV = ZO_SavedVars:NewAccountWide("ArcTechSavedVars", 1, nil, {
        events = {
            { day = "monday", text = "" },
            { day = "tuesday", text = "" },
            { day = "wednesday", text = "" },
            { day = "thursday", text = "20:00 - Harrowstorms. Come and destroy the scourge of the Gray Host." },
            { day = "friday", text = "" },
            { day = "saturday",  text = "" },
            { day = "sunday", text = "" }
		},
	})
end