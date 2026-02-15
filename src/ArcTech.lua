-- ArcTech.lua
local ArcTech = ArcTech or {}

local ADDON_NAME = "ArcTech"
local initialised = false

local function OnAddOnLoaded(event, addonName)
    if addonName ~= ArcTech.ADDON_NAME then return end
    EVENT_MANAGER:UnregisterForEvent(ArcTech.ADDON_NAME, EVENT_ADD_ON_LOADED)

    Init()
end

function Init()
    if initialised then return end
    initialised = true

    InitSavedVars()
    RegisterSlashCommands()

    if LibAddonMenu2 then
        InitLAM()
    else
        d("|c3cffbaArcTech loaded (LAM missing)|r")
    end

    d("|c3cffbaArcTech loaded|r")
end

function ArcTechSlash(arg)
    arg = string.lower(tostring(arg or ""))

    if arg == 'house' then
        SLASH_COMMANDS["/guildhouse"] = function(arg)
            HandleGuildhouseSlash(arg)
        end
    end

    if arg == 'discord' then
        d('in the future this will open discord QR Code')
    end
end

SLASH_COMMANDS["/arctech"] = ArcTechSlash
SLASH_COMMANDS["/gh"] = function()
    HandleGuildhouseSlash("main")
end

EVENT_MANAGER:RegisterForEvent(ArcTech.ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)