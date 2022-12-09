--  ▄▀▀ █▄█ █▀▄ █ ▄▀▀ ▀█▀ █▄ ▄█ ▄▀▄ ▄▀▀   ▄▀  █ █ █ ██▀ ▄▀▄ █   █ ▄▀▄ ▀▄▀   ▄▀▄ █▄ █   █▀▄ █ ▄▀▀ ▄▀▀ ▄▀▄ █▀▄ █▀▄
--  ▀▄▄ █ █ █▀▄ █ ▄██  █  █ ▀ █ █▀█ ▄██   ▀▄█ █ ▀▄▀ █▄▄ █▀█ ▀▄▀▄▀ █▀█  █    ▀▄▀ █ ▀█   █▄▀ █ ▄██ ▀▄▄ ▀▄▀ █▀▄ █▄▀

--  https://discord.gg/7aRuZQxnzK
--  https://discord.gg/7aRuZQxnzK
--  https://discord.gg/7aRuZQxnzK

Config = {}

Config.Core = "ESX" -- "ESX" / "QB-Core"
Config.CoreDefineTrigger = "" -- If you are using an older ESX that is defined by a trigger, enter it here example: "esx:getSharedObject"
Config.CoreExport = function()
    return exports['es_extended']:getSharedObject()
    -- [   ESX   ] -- return exports['es_extended']:getSharedObject()
    -- [ QB-Core ] -- return exports['qb-core']:GetCoreObject()
end

Config.snowmanModel = GetHashKey('prop_prlg_snowpile')
Config.presentModel = GetHashKey('vms_gift')

Config.Notification = function(title, msg, time, type, icon)
    if type == 'success' then
        exports['vms_notify']:Notification(title, msg, time, '#42f551', icon)
    elseif type == 'error' then
        exports['vms_notify']:Notification(title, msg, time, '#f54254', icon)
    elseif type == 'info' then
        exports['vms_notify']:Notification(title, msg, time, '#4287f5', icon)
    end
end

Config.Translate = {
    ['SNOWMAN'] = "SNOWMAN",
    ['MAKE_A_SNOWMAN'] = "Start sticking a snowball on a snowman",
    ['MAKED_SNOWMAN'] = "You made a snowman!",
    ['CANNOT_MAKE_SNOWMAN'] = "You can't make two snowmen at the same time",
    ['MAKED_SNOWMAN_EXTRA'] = "Received %s$ bonus for making a snowman!",
    
    ['DEBUG_SNOWMANID_OFF'] = "Snowman ID debug has been disabled",
    ['DEBUG_SNOWMANID_ON'] = "Snowman ID debug has been enabled",
    
    ['PRESENT'] = "PRESENT",
    ['COLLECTED_PRESENT_MONEY'] = "You collected a present and received %s$",
    ['COLLECTED_PRESENT_ITEM'] = "You hit the carrot, with this you can make the snowman and get extra cash",
    ['PRESS_TO_COLLECT_PRESENT'] = "Press ~g~[E]~s~ to collect present",
}

Config.PresentLocations = {
    ['1'] = {coords = vector3(213.65, -809.33, 32.92)},
    ['2'] = {coords = vector3(104.54, -997.57, 28.4)},
    ['3'] = {coords = vector3(189.59, -667.44, 42.34)},
    ['4'] = {coords = vector3(335.67, 174.69, 102.21)},
    ['5'] = {coords = vector3(-79.12, 356.5, 111.44)},
    ['6'] = {coords = vector3(-143.86, 231.01, 98.07)},
    ['7'] = {coords = vector3(-1111.67, -266.65, 37.89)},
    ['8'] = {coords = vector3(-1071.6, 9.53, 51.29)},
    ['9'] = {coords = vector3(-1298.38, -116.58, 49.46)},
    ['10'] = {coords = vector3(-2043.89, -1031.51, 10.98)},
    ['11'] = {coords = vector3(-1816.77, -1202.51, 18.16)},
    ['12'] = {coords = vector3(-1326.4, -1513.77, 9.31)},
    ['13'] = {coords = vector3(-867.44, -2391.2, 17.95)},
    ['14'] = {coords = vector3(105.18, -1941.27, 19.8)},
    ['15'] = {coords = vector3(1700.89, 3291.54, 47.92)},
    ['16'] = {coords = vector3(63.45, 3698.78, 38.76)},
    ['17'] = {coords = vector3(585.11, 2742.38, 41.08)},
    ['18'] = {coords = vector3(-187.38, 6284.8, 31.63)},
    ['19'] = {coords = vector3(-549.81, 5308.34, 113.15)},
    ['20'] = {coords = vector3(-3165.02, 1112.54, 19.84)},
    ['21'] = {coords = vector3(-3080.26, 766.2, 30.35)},
    ['22'] = {coords = vector3(-2947.93, 441.05, 14.26)},
    ['23'] = {coords = vector3(-3023.95, 80.77, 10.61)},
    ['24'] = {coords = vector3(-2186.18, -399.72, 12.27)},
    ['25'] = {coords = vector3(-1837.43, -577.52, 18.46)},
}