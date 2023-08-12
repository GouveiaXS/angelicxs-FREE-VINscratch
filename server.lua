ESX = nil
QBcore = nil

if Config.UseESX then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end


--- Are LEOs Available
if Config.UseESX then
    ESX.RegisterServerCallback('angelicxs-FREE-VINscratch:PoliceAvailable:ESX',function(source,cb)
        local xPlayers = ESX.GetPlayers()
        local cops = 0

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if LawEnforcementServer(xPlayer.job.name) then
                cops = cops + 1
            end
        end
        
        if cops >= Config.RequiredNumberLEO then
            cb(true)
        else
            cb(false)
        end	
    end)
elseif Config.UseQBCore then
    QBCore.Functions.CreateCallback('angelicxs-FREE-VINscratch:PoliceAvailable:QBCore', function(source, cb)
        local cops = 0
        local players = QBCore.Functions.GetQBPlayers()
        for k, v in pairs(players) do
            if LawEnforcementServer(v.PlayerData.job.name) then
                cops = cops + 1
            end
        end

        if cops >= Config.RequiredNumberLEO then
            cb(true)
        else
            cb(false)
        end	
    end)
end

-- Item Callback & Removal
if Config.UseESX then
    ESX.RegisterServerCallback('angelicxs-FREE-VINscratch:lockpick:ESX', function(source,cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getInventoryItem(Config.LockpickName).count >= 1 then
            if Config.RemoveLockpick then
                xPlayer.removeInventoryItem(Config.LockpickName,1)
            end
            cb(true)
        else
            cb(false)
        end
    end)
elseif Config.UseQBCore then
    QBCore.Functions.CreateCallback('angelicxs-FREE-VINscratch:lockpick:QBCore', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
            if Config.RemoveLockpick then
                Player.Functions.RemoveItem(Config.LockpickName, 1)
            end
    end)
end
--- Rewards

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:KeepScratch')
AddEventHandler('angelicxs-FREE-VINscratch:Server:KeepScratch', function(VehiclePlate)
    if Config.UseESX then
        local xPlayer = ESX.GetPlayerFromId(source)
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
                ['@owner']   = xPlayer.identifier,
                ['@plate']   = VehiclePlate.plate,
                ['@vehicle'] = json.encode(VehiclePlate)
                }, function(rowsChanged)
            end)
    elseif Config.UseQBCore then
        local vehicle = VehiclePlate
        local pData = QBCore.Functions.GetPlayer(source)
        local cid = pData.PlayerData.citizenid
        local plate = PlateQBGen()
        MySQL.Async.execute('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (@license, @citizenid, @vehicle, @hash, @mods, @plate, @state, @garage)', {
            ['@license'] = pData.PlayerData.license,
            ['@citizenid'] = cid,
            ['@vehicle'] = vehicle[2],
            ['@hash'] = vehicle[1],
            ['@mods'] = '{}',
            ['@plate'] = plate,
            ['@state'] = 1,
            ['@garage'] = "pillboxgarage"
            }, function(rowsChanged)
        end)
    end
end)

function PlateQBGen()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return PlateQBGen()
    else
        return plate:upper()
    end
end

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:Completion')
AddEventHandler('angelicxs-FREE-VINscratch:Server:Completion', function()
    local funds = 0
    if Config.RandomMoneyAmount then
        funds = math.random(Config.RandomMoneyAmountMin, Config.RandomMoneyAmountMax)
    else
        funds = Config.MoneyAmount
    end
    if Config.UseESX then
        local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.addAccountMoney(Config.AccountMoney,funds)
    elseif Config.UseQBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddMoney(Config.AccountMoney, funds)
    end
end)

-- Global Syncs

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:NotifyPolice')
AddEventHandler('angelicxs-FREE-VINscratch:Server:NotifyPolice', function(msg)
	TriggerClientEvent('angelicxs-FREE-VINscratch:NotifyPolice',-1,msg)
end)

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
AddEventHandler('angelicxs-FREE-VINscratch:Server:ResetHeist', function()
	TriggerClientEvent('angelicxs-FREE-VINscratch:ResetHeist',-1)
end)

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:GlobalJobTrue')
AddEventHandler('angelicxs-FREE-VINscratch:Server:GlobalJobTrue', function()
	TriggerClientEvent('angelicxs-FREE-VINscratch:GlobalJobTrue',-1)
end)

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:GlobalJobFalse')
AddEventHandler('angelicxs-FREE-VINscratch:Server:GlobalJobFalse', function()
	TriggerClientEvent('angelicxs-FREE-VINscratch:GlobalJobFalse',-1)
end)

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:IsCoastClear')
AddEventHandler('angelicxs-FREE-VINscratch:Server:IsCoastClear', function(coords)
	TriggerClientEvent('angelicxs-FREE-VINscratch:IsCoastClear',-1,coords)
end)

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:CoastIsClearTrue')
AddEventHandler('angelicxs-FREE-VINscratch:Server:CoastIsClearTrue', function()
	TriggerClientEvent('angelicxs-FREE-VINscratch:CoastIsClearTrue',-1)
end)

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:CoastIsClearFalse')
AddEventHandler('angelicxs-FREE-VINscratch:Server:CoastIsClearFalse', function()
	TriggerClientEvent('angelicxs-FREE-VINscratch:CoastIsClearFalse',-1)
end)

RegisterServerEvent('angelicxs-FREE-VINscratch:Server:TrackerCoords')
AddEventHandler('angelicxs-FREE-VINscratch:Server:TrackerCoords', function(coords)
	TriggerClientEvent('angelicxs-FREE-VINscratch:TrackingVehicle',-1,coords)
end)

function LawEnforcementServer(jobname)
    for i = 1, #Config.LEOJobName do
        if jobname == Config.LEOJobName[i] then
            return true
        end
    end
    return false
end
