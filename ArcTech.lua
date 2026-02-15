-- ArcTech.lua
ArcTech = ArcTech or {}

ArcTech.ADDON_NAME = "ArcTech"
ArcTech.initialised = false

local function OnAddOnLoaded(event, addonName)
    if addonName ~= ArcTech.ADDON_NAME then return end
    EVENT_MANAGER:UnregisterForEvent(ArcTech.ADDON_NAME, EVENT_ADD_ON_LOADED)

    ArcTech:Init()
end

function ArcTech:Init()
    if self.initialised then return end
    self.initialised = true

    self:InitSavedVars()
    self:RegisterSlashCommands()

    if LibAddonMenu2 then
        self:InitLAM()
    else
        d("|c3cffbaArcTech loaded (LAM missing)|r")
    end

    d("|c3cffbaArcTech loaded|r")
end

function ArcTech:RegisterSlashCommands()
    SLASH_COMMANDS["/guildhouse"] = function(arg)
        self:HandleGuildhouseSlash(arg)
    end
end

EVENT_MANAGER:RegisterForEvent(ArcTech.ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)