if Config.Core == "ESX" then
    ESX = nil
    if Config.CoreDefineTrigger ~= "" and Config.CoreDefineTrigger ~= nil then
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent(Config.CoreDefineTrigger, function(obj) 
                    ESX = obj 
                end)
                Citizen.Wait(0)
            end
        end)
    else
        ESX = Config.CoreExport()
    end
else
    QBCore = Config.CoreExport()
end

RegisterNetEvent('vms_christmasevent:cl:notification', function(title, msg, time, type, icon)
    Config.Notification(title, msg, time, type, icon)
end)

local function ReqModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
    end
end

local function ReqAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

local function DrawText3D(x, y, z, text)
    local vector = vec(x, y, z)
    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vector - camCoords)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextDropShadow()
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(vector.xyz, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

-- ███████╗███╗   ██╗ ██████╗ ██╗    ██╗███╗   ███╗ █████╗ ███╗   ██╗███████╗
-- ██╔════╝████╗  ██║██╔═══██╗██║    ██║████╗ ████║██╔══██╗████╗  ██║██╔════╝
-- ███████╗██╔██╗ ██║██║   ██║██║ █╗ ██║██╔████╔██║███████║██╔██╗ ██║███████╗
-- ╚════██║██║╚██╗██║██║   ██║██║███╗██║██║╚██╔╝██║██╔══██║██║╚██╗██║╚════██║
-- ███████║██║ ╚████║╚██████╔╝╚███╔███╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║███████║
-- ╚══════╝╚═╝  ╚═══╝ ╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝

local snowmans = {}
local isMakingSnowman = false
local isDebuged = false

RegisterNetEvent('vms_christmasevent:cl:sendSnowmans', function(sm)
    snowmans = sm
end)

RegisterNetEvent('vms_christmasevent:cl:spawnSnowman', function()
    if isMakingSnowman then 
        return Config.Notification(Config.Translate["SNOWMAN"], Config.Translate['CANNOT_MAKE_SNOWMAN'], 4000, 'error', "fa-solid fa-snowman")
    end
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    isMakingSnowman = true
    ReqAnim("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(myPed, "amb@prop_human_bum_bin@idle_b", "idle_d", 3.0, 3.0, -1, 50, 0, false, false, false)
    if not Config.makeSnowmanInstant then
        Config.Notification(Config.Translate["SNOWMAN"], Config.Translate['MAKE_A_SNOWMAN'], 7500, 'info', "fa-solid fa-snowman")
        local traveledDistance = 0.0
        while traveledDistance < 10.0 do
            myCoords = GetEntityCoords(myPed)
            Citizen.Wait(50)
            local myNewCoords = GetEntityCoords(myPed)
            local myDistance = #(myCoords - myNewCoords)
            traveledDistance = traveledDistance + myDistance
            Citizen.Wait(100)
        end
    else
        Config.Notification(Config.Translate["SNOWMAN"], Config.Translate['MAKED_SNOWMAN'], 4000, 'success', "fa-solid fa-snowman")
    end
    ReqModel(Config.snowmanModel)
    Citizen.Wait(2000)
    local myOffset = GetOffsetFromEntityInWorldCoords(myPed, 0, 1.0, -1.2)
    local myHeading = GetEntityHeading(myPed)
    local createdSnowman = CreateObject(Config.snowmanModel, myOffset.x, myOffset.y, myOffset.z, true, true)
    FreezeEntityPosition(createdSnowman, true)
    local snowmanCoords = (GetEntityCoords(createdSnowman))
    SetEntityHeading(createdSnowman, myHeading-180.0)
    TriggerServerEvent('vms_christmasevent:sv:saveSnowman', snowmanCoords, createdSnowman)
    Citizen.Wait(100)
    isMakingSnowman = false
    ClearPedTasks(PlayerPedId())
end)

Citizen.CreateThread(function()
    RequestAnimDict('anim@mp_snowball')
    while Config.collectingSnowBalls do
        local sleep = true
        local myPed = PlayerPedId()
        if not IsPedOnVehicle(myPed) and not IsPedInAnyVehicle(myPed, true) and not IsPedSwimming(myPed) and not IsPedSwimmingUnderWater(myPed) and IsNextWeatherType('XMAS') then
            sleep = false
            if not IsPlayerFreeAiming(PlayerId()) and not IsPedRagdoll(myPed) and not IsPedFalling(myPed) and not IsPedRunning(myPed) and not IsPedSprinting(myPed) and GetInteriorFromEntity(myPed) == 0 and not IsPedShooting(myPed) and not IsPedUsingAnyScenario(myPed) and not IsPedInCover(myPed, 0) then
                if IsControlJustPressed(0, Config.keyColletingSnow) then
                    TaskPlayAnim(myPed, 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
                    Citizen.Wait(1950)
                    TriggerServerEvent('vms_christmasevent:sv:collectSnowball')
                end
            end
        end
        if Config.removeDamageFromSnowBalls then
            if GetSelectedPedWeapon(myPed) == GetHashKey('WEAPON_SNOWBALL') then
                SetPlayerWeaponDamageModifier(PlayerId(), 0.0)
            end
        end
        Citizen.Wait(sleep and 1250 or 1)
    end
end)

RegisterCommand('debug_sm', function()
    if isDebuged then
        isDebuged = false
        Config.Notification(Config.Translate["SNOWMAN"], Config.Translate['DEBUG_SNOWMANID_OFF'], 3500, 'success', "fa-solid fa-snowman")
    else
        isDebuged = true
        Config.Notification(Config.Translate["SNOWMAN"], Config.Translate['DEBUG_SNOWMANID_ON'], 3500, 'success', "fa-solid fa-snowman")
        debugSnowmans()
    end
end, false)

function debugSnowmans()
    while isDebuged do
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local sleep = true
        for k, v in pairs(snowmans) do
            local myDistance = #(myCoords - vec(v.coords.x, v.coords.y, v.coords.z))
            if myDistance < 8.0 then
                sleep = false
                DrawText3D(v.coords.x, v.coords.y, v.coords.z+1.5, "ID: "..k)
            end    
        end
        Citizen.Wait(sleep and 1000 or 1)
    end
end

-- ██████╗ ██████╗ ███████╗███████╗███████╗███╗   ██╗████████╗███████╗     ██████╗ ██████╗ ██╗     ██╗     ███████╗████████
-- ██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔════╝    ██╔════╝██╔═══██╗██║     ██║     ██╔════╝╚══██╔══
-- ██████╔╝██████╔╝█████╗  ███████╗█████╗  ██╔██╗ ██║   ██║   ███████╗    ██║     ██║   ██║██║     ██║     █████╗     ██║  
-- ██╔═══╝ ██╔══██╗██╔══╝  ╚════██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║    ██║     ██║   ██║██║     ██║     ██╔══╝     ██║  
-- ██║     ██║  ██║███████╗███████║███████╗██║ ╚████║   ██║   ███████║    ╚██████╗╚██████╔╝███████╗███████╗███████╗   ██║  
-- ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝     ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝   ╚═╝  

local presents, collectedPresents = {}, {}

local function collectPresent(id)
    local myPed = PlayerPedId()
    ReqAnim("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(myPed, "amb@prop_human_bum_bin@idle_b", "idle_d", 3.0, 3.0, -1, 50, 0, false, false, false)
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    TriggerServerEvent('vms_christmasevent:sv:collectPresent', id)
    Citizen.Wait(150)
    ClearPedTasks(PlayerPedId())
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    TriggerServerEvent("vms_christmasevent:sv:getCollected")
    Citizen.Wait(3000)
    ReqModel(Config.presentModel)
    for k, v in pairs(Config.PresentLocations) do
        if not collectedPresents[tostring(k)] then
            presents[k] = CreateObject(Config.presentModel, v.coords.x, v.coords.y, v.coords.z, false, true, 0)
            FreezeEntityPosition(presents[k], true)
        end
    end
    while true do
        local sleep = true
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        for k, v in pairs(Config.PresentLocations) do
            local myDistance = #(myCoords - vec(v.coords.x, v.coords.y, v.coords.z))
            if myDistance < 3.85 and not collectedPresents[k] then
                sleep = false
                DrawText3D(v.coords.x, v.coords.y, v.coords.z+0.635, Config.Translate['PRESS_TO_COLLECT_PRESENT'])
                if IsControlJustPressed(0, 38) and myDistance < 2.25 then
                    collectPresent(k)
                end
            end    
        end
        Citizen.Wait(sleep and 1200 or 2)
    end
end)

RegisterNetEvent("vms_christmasevent:cl:updateCollected")
AddEventHandler("vms_christmasevent:cl:updateCollected", function(collected)
    collectedPresents = collected
end)

RegisterNetEvent("vms_christmasevent:cl:deletePresent")
AddEventHandler("vms_christmasevent:cl:deletePresent", function(id)
    DeleteEntity(presents[id])
end)