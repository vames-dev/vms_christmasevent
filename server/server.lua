if Config.Core == "ESX" then
    ESX = nil
    if Config.CoreDefineTrigger ~= "" and Config.CoreDefineTrigger ~= nil then
        TriggerEvent(Config.CoreDefineTrigger, function(obj) 
            ESX = obj 
        end)
    else
        ESX = Config.CoreExport()
    end
else
    QBCore = Config.CoreExport()
end

-- ███████╗███╗   ██╗ ██████╗ ██╗    ██╗███╗   ███╗ █████╗ ███╗   ██╗███████╗
-- ██╔════╝████╗  ██║██╔═══██╗██║    ██║████╗ ████║██╔══██╗████╗  ██║██╔════╝
-- ███████╗██╔██╗ ██║██║   ██║██║ █╗ ██║██╔████╔██║███████║██╔██╗ ██║███████╗
-- ╚════██║██║╚██╗██║██║   ██║██║███╗██║██║╚██╔╝██║██╔══██║██║╚██╗██║╚════██║
-- ███████║██║ ╚████║╚██████╔╝╚███╔███╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║███████║
-- ╚══════╝╚═╝  ╚═══╝ ╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝

local snowmans = {}

if not Config.RequiredCarrot then
    if Config.Core == "ESX" then
        ESX.RegisterUsableItem(Config.SnowballsItem, function(playerId)
            TriggerClientEvent('vms_christmasevent:cl:spawnSnowman', playerId)
        end)
    else
        QBCore.Functions.CreateUseableItem(Config.SnowballsItem, function(source, item)
            TriggerClientEvent('vms_christmasevent:cl:spawnSnowman', source)
        end)
    end
end

if Config.RequiredCarrot then
    if Config.Core == "ESX" then
        ESX.RegisterUsableItem(Config.CarrotItem, function(playerId)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            TriggerClientEvent('vms_christmasevent:cl:spawnSnowman', playerId)
            xPlayer.removeInventoryItem(Config.CarrotItem, 1)
        end)
    else
        QBCore.Functions.CreateUseableItem(Config.CarrotItem, function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)
            TriggerClientEvent('vms_christmasevent:cl:spawnSnowman', source)
            Player.Functions.RemoveItem(Config.CarrotItem, 1)
        end)
    end
end

RegisterNetEvent('vms_christmasevent:sv:saveSnowman', function(snowmancoords, snowmanId)
    local source = source
    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    local myIdentifier = Config.Core == "ESX" and xPlayer.identifier or QBCore.Functions.GetIdentifier(source)
    local currentSnowmanId = nil
    MySQL.Async.fetchAll('SELECT id FROM `vms_snowmans` WHERE id = (SELECT MAX(id) FROM vms_snowmans)', {}, function(result)
        if result[1] then
            currentSnowmanId = result[1].id + 1
            MySQL.update('INSERT INTO `vms_snowmans` (id, creator, coords) VALUES (?, ?, ?)', {currentSnowmanId, myIdentifier, json.encode(snowmancoords)})
            if Config.RewardForSnowman then
                if Config.Core == "ESX" then
                    xPlayer.addMoney(Config.RewardForSnowman)
                else
                    xPlayer.Functions.AddMoney('cash', Config.RewardForSnowman)
                end
                TriggerClientEvent('vms_christmasevent:cl:notification', source, Config.Translate['SNOWMAN'], Config.Translate['MAKED_SNOWMAN_EXTRA'], 4000, 'success', "fa-solid fa-snowman")
                Webhook_Log("Collect Snowman Extra Money", GetPlayerName(source).." ["..source.."] collected extra money "..Config.RewardForSnowman.."$ from a snowman id "..snowmanId.." at coords: "..snowmancoords, myIdentifier)
            else
                Webhook_Log("Make Snowman", GetPlayerName(source).." ["..source.."] make a snowman id "..snowmanId.." at coords: "..snowmancoords, myIdentifier)
            end
            snowmans[currentSnowmanId] = {obj = snowmanId, coords = snowmancoords}
            TriggerClientEvent("vms_christmasevent:cl:sendSnowmans", -1, snowmans)
        end
    end)
end)

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT id, coords FROM `vms_snowmans` WHERE id = (SELECT MAX(id) FROM vms_snowmans)', {}, function(result)
        for k, v in pairs(result) do
            local coords = json.decode(v.coords)
            snowmans[v.id] = {}
            snowmans[v.id].obj = CreateObject(Config.snowmanModel, coords.x, coords.y, coords.z, true, true)
            snowmans[v.id].coords = vec(coords.x, coords.y, coords.z)
            FreezeEntityPosition(snowmans[v.id].obj, true)
        end
        TriggerClientEvent("vms_christmasevent:cl:sendSnowmans", -1, snowmans)
    end)
end)

RegisterNetEvent('vms_christmasevent:sv:collectSnowball', function()
    local source = source
    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    if Config.Core == "ESX" then
        if Config.Snowballs == 'item' then
            xPlayer.addInventoryItem(Config.SnowballsItem, Config.SnowballsItemCount)
        elseif Config.Snowballs == 'weapon' then
            GiveWeaponToPed(GetPlayerPed(source), GetHashKey('WEAPON_SNOWBALL'), 1)
        end
    else
        xPlayer.Functions.AddItem(Config.SnowballsItem, Config.SnowballsItemCount)
    end
end)



-- ██████╗ ██████╗ ███████╗███████╗███████╗███╗   ██╗████████╗███████╗     ██████╗ ██████╗ ██╗     ██╗     ███████╗████████
-- ██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔════╝    ██╔════╝██╔═══██╗██║     ██║     ██╔════╝╚══██╔══
-- ██████╔╝██████╔╝█████╗  ███████╗█████╗  ██╔██╗ ██║   ██║   ███████╗    ██║     ██║   ██║██║     ██║     █████╗     ██║  
-- ██╔═══╝ ██╔══██╗██╔══╝  ╚════██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║    ██║     ██║   ██║██║     ██║     ██╔══╝     ██║  
-- ██║     ██║  ██║███████╗███████║███████╗██║ ╚████║   ██║   ███████║    ╚██████╗╚██████╔╝███████╗███████╗███████╗   ██║  
-- ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝     ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝   ╚═╝  

local presents, collectedPresents = {}, {}

Citizen.CreateThread(function()
    local collectedFile = LoadResourceFile(GetCurrentResourceName(), "./collected.json")
	collectedPresents = json.decode(collectedFile) or {}
	SaveResourceFile(GetCurrentResourceName(), "collected.json", json.encode(collectedPresents), -1)
	TriggerClientEvent("vms_christmasevent:cl:updateCollected", -1, collectedPresents)
end)

RegisterNetEvent('vms_christmasevent:sv:getCollected', function()
    local source = source
	TriggerClientEvent("vms_christmasevent:cl:updateCollected", source, collectedPresents)
end)

RegisterNetEvent('vms_christmasevent:sv:collectPresent', function(id)
    if collectedPresents[id] then return end
    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    local myIdentifier = Config.Core == "ESX" and xPlayer.identifier or QBCore.Functions.GetIdentifier(source)
	collectedPresents[id] = true
	TriggerClientEvent("vms_christmasevent:cl:deletePresent", -1, id)
	TriggerClientEvent("vms_christmasevent:cl:updateCollected", -1, collectedPresents)
    if Config.EnableMoneyRewardsForPresents then
        local randomizeMoney = type(Config.RewardForPresent) == 'table' and math.random(Config.RewardForPresent[1], Config.RewardForPresent[2]) or Config.RewardForPresent
        if Config.Core == "ESX" then
            xPlayer.addMoney(randomizeMoney)
        else
            xPlayer.Functions.AddMoney('cash', randomizeMoney)
        end
        TriggerClientEvent("vms_christmasevent:cl:notification", source, Config.Translate['PRESENT'], Config.Translate['COLLECTED_PRESENT_MONEY']:format(randomizeMoney), 4000, 'success', "fa-solid fa-gift")
        Webhook_Log("Collect Present Money", GetPlayerName(source).." ["..source.."] collected "..randomizeMoney.."$ from present id "..id, myIdentifier)
    end
    if Config.EnableItemRewardsFroPresents then
        local randomizeCarrot = math.random(1, 100)
        if randomizeCarrot <= Config.RewardCarrotPercent then
            if Config.Core == "ESX" then
                xPlayer.addInventoryItem(Config.CarrotItem, 1)
            else
                xPlayer.Functions.AddItem(Config.CarrotItem, 1)
            end
            TriggerClientEvent("vms_christmasevent:cl:notification", source, Config.Translate['PRESENT'], Config.Translate['COLLECTED_PRESENT_ITEM'], 4000, 'success', "fa-solid fa-gift")
            Webhook_Log("Collect Present Carrot", GetPlayerName(source).." ["..source.."] collected carrot from present id "..id, myIdentifier)
        end
    end
    SaveResourceFile(GetCurrentResourceName(), "collected.json", json.encode(collectedPresents), -1)
end)

function Webhook_Log(WH_Title, WH_Description, WH_Footer)
    local WH_Footer = WH_Footer or ''
    local embeds = {
        {
            ["title"] = WH_Title,
            ["type"] = "rich",
            ["description"] = WH_Description,
            ["color"] = 5422079,
            ["footer"] = {
                ["text"] = WH_Footer..' | '..os.date(),
            },
        }
    }
    PerformHttpRequest(Config.WebhookEvent, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embeds}), {['Content-Type'] = 'application/json'})
end
  