-- ArcTech_Housing.lua
ArcTech = ArcTech or {}

function ArcTech:JumpToHouseEntry(entry)
	if not entry or not entry.id or entry.id == 0 then return end

	local owner = entry.owner
	local houseId = entry.id

	local me = string.lower(GetDisplayName() or "")
	local ownerLower = owner and string.lower(owner) or ""

	if ownerLower == "" or ownerLower == me then
		RequestJumpToHouse(houseId)
	else
		JumpToSpecificHouse(owner, houseId, false)
	end
end

function ArcTech:HandleGuildhouseSlash(arg)
	arg = string.lower(tostring(arg or ""))

	if arg == "" or arg == "main" then self:JumpToHouseEntry(self.HOUSES.main) return end
	if arg == "pvp" then self:JumpToHouseEntry(self.HOUSES.pvp) return end
	if arg == "auction" then self:JumpToHouseEntry(self.HOUSES.auction) return end

	d("|cffff00ArcTech|r usage: /guildhouse main | pvp | auction")
end