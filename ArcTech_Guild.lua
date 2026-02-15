-- ArcTech_Guild.lua
ArcTech = ArcTech or {}

function ArcTech:IsGuildMember()
	local numGuilds = GetNumGuilds()
	for i = 1, numGuilds do
		local guildId = GetGuildId(i)
		if guildId == self.ARCANIST_GUILD_ID then
			return true
		end
	end
	return false
end

function ArcTech:IsOfficer()

end

function ArcTech:CanApplyToGuild()
	return not self:IsGuildMember()
	and type(SubmitGuildFinderApplication) == "function"
end

function ArcTech:ApplyToGuild(message)
	if type(SubmitGuildFinderApplication) ~= "function" then
		d("|cFF0000Guild Finder application API not available on this client.|r")
		return
	end

	local res = SubmitGuildFinderApplication(self.ARCANIST_GUILD_ID, message or "Application sent via ArcTech")

	-- Always print the raw result for debugging
	--d(string.format("|c3cffbaSubmitGuildFinderApplication returned: %s|r", tostring(res)))

	-- Optional mapping (only works if these globals exist on your client)
	if _G.GUILD_APPLICATION_RESPONSE_SUCCESS and res == _G.GUILD_APPLICATION_RESPONSE_SUCCESS then
		d("|c00ff00Application submitted successfully.|r")
		return
	end

	if _G.GUILD_APPLICATION_RESPONSE_ALREADY_APPLIED and res == _G.GUILD_APPLICATION_RESPONSE_ALREADY_APPLIED then
		d("|cffff00You already have a pending application.|r")
		return
	end

	if _G.GUILD_APPLICATION_RESPONSE_ALREADY_IN_GUILD and res == _G.GUILD_APPLICATION_RESPONSE_ALREADY_IN_GUILD then
		d("|cffff00You are already in this guild.|r")
		return
	end

	if _G.GUILD_APPLICATION_RESPONSE_GUILD_NOT_FOUND and res == _G.GUILD_APPLICATION_RESPONSE_GUILD_NOT_FOUND then
		d("|cFF0000Guild not found in Guild Finder (may not be listed).|r")
		return
	end

	-- Fallback if enum constants are different / missing
	if res == 0 then
		d("|c00ff00Application submitted, a guild officer will review your application shortly!|r")
	else
		d("|cFF0000Application may have failed. Result code: " .. tostring(res) .. "|r")
	end
end