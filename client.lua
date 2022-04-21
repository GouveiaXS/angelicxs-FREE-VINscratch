ESX = nil
QBcore = nil
PlayerJob = nil
PlayerGrade = nil


local isLawEnforcement = false
local PedSpawned = false
local VINRep = 0
local NPC
local DropNPC
local nearType = 'none'
local VehicleName = 'none'
local Number = 0
local Hash = nil
local MissionVehicle = nil
local CoastIsClear = true
local GlobalJob = false
local CurrentJob = false
local MissionType = 'none'
local DropLocationNPC = false
local TrackingDeviceStatus = false
local MissionRoute = nil
local CarAvailable = false
local FindMeBlip = nil

RegisterNetEvent('angelicxs-FREE-VINscratch:Notify', function(message, type)
	if Config.UseCustomNotify then
        TriggerEvent('angelicxs-FREE-VINscratch:CustomNotify',message, type)
	elseif Config.UseESX then
		ESX.ShowNotification(message)
	elseif Config.UseQBCore then
		QBCore.Functions.Notify(message, type)
	end
end)

CreateThread(function()
    if Config.UseESX then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(0)
        end
    
        while not ESX.IsPlayerLoaded() do
            Wait(100)
        end
    
        local playerData = ESX.GetPlayerData()
        PlayerJob = playerData.job.name
        PlayerGrade = playerData.job.grade
        isLawEnforcement = LawEnforcement()

        RegisterNetEvent('esx:setJob', function(job)
            PlayerJob = job.name
            PlayerGrade = job.grade
            isLawEnforcement = LawEnforcement()
        end)

    elseif Config.UseQBCore then

        QBCore = exports['qb-core']:GetCoreObject()	
	
	Wait(200)
        local playerData = QBCore.Functions.GetPlayerData()
			
            PlayerJob = playerData.job.name
            PlayerGrade = playerData.job.grade.level
            isLawEnforcement = LawEnforcement()

        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
            PlayerJob = job.name
            PlayerGrade = job.grade.level
            isLawEnforcement = LawEnforcement()
        end)
    end
    
    if Config.StartVehicleBlip then
		local blip = AddBlipForCoord(Config.StartVehicleLocation[1],Config.StartVehicleLocation[2],Config.StartVehicleLocation[3])
		SetBlipSprite(blip, Config.StartVehicleBlipIcon)
		SetBlipColour(blip, Config.StartVehicleBlipColour)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(Config.StartVehicleBlipText)
		EndTextCommandSetBlipName(blip)
	end
end)



-- Starting NPC Spawn
CreateThread(function()
    while true do
	local Player = PlayerPedId()
        for k, v in pairs(Config.NPCLocations) do
            local Pos = GetEntityCoords(Player)
            local Dist = #(Pos - vector3(v.Coords[1],v.Coords[2],v.Coords[3]))
            if Dist <= 50 and not PedSpawned then
                TriggerEvent('angelicxs-FREE-VINscratch:SpawnNPC',v.Coords,v.Model,v.Scenario,v.Icon)
                PedSpawned = true
            elseif DoesEntityExist(NPC) and PedSpawned then
                local Dist2 = #(Pos - GetEntityCoords(NPC))
                 if Dist2 > 50 then
                    DeleteEntity(NPC)
                    PedSpawned = false
                end
            end
        end
        Wait(2000)
    end
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:SpawnNPC',function(coords,model,scenario,icon)
    local hash = HashGrabber(model)
    NPC = CreatePed(1, hash, coords[1], coords[2], (coords[3]-1), coords[4], false, false)
    FreezeEntityPosition(NPC, true)
    SetEntityInvincible(NPC, true)
    SetBlockingOfNonTemporaryEvents(NPC, true)
    TaskStartScenarioInPlace(NPC,scenario, 0, false)
    SetModelAsNoLongerNeeded(hash)
end)


-- Events

CreateThread(function()
    while true do
	local Player = PlayerPedId()
        local Sleep = 1500
        local Pos = GetEntityCoords(Player)
        for k, v in pairs(Config.NPCLocations) do
            local Dist = #(Pos - vector3(v.Coords[1],v.Coords[2],v.Coords[3]))
            if Dist <= 50 then
                Sleep = 0
                if Dist <= 3 then
                    nearType = v.Type
                    DrawText3Ds(v.Coords[1],v.Coords[2],v.Coords[3], Config.Lang['request'])
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('angelicxs-FREE-VINscratch:RobberyCheck')
                    end
                else
                    nearType = 'none'
                end
            end
        end
        Wait(Sleep)
    end
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:RobberyCheck', function()
    if not CurrentJob then
        if not GlobalJob then
            if Config.RequireMinimumLEO then
                local StartRobbery = false
                if Config.UseESX then
                    ESX.TriggerServerCallback('angelicxs-FREE-VINscratch:PoliceAvailable:ESX', function(cb)
                        StartRobbery = cb
                    end)                                    
                elseif Config.UseQBCore then
                    QBCore.Functions.TriggerCallback('angelicxs-FREE-VINscratch:PoliceAvailable:QBCore', function(cb)
                        StartRobbery = cb
                    end)
                end
                Wait(1000)
                if StartRobbery then
                    CurrentJob = true
                    TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['delay'], Config.LangType['info'])
                    Wait(1000)
                    TriggerEvent('angelicxs-FREE-VINscratch:VINStart', nearType)
                else
                    TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['mincops'], Config.LangType['error'])
                end
            else
                CurrentJob = true
                TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['delay'], Config.LangType['info'])
                Wait(1000)
                TriggerEvent('angelicxs-FREE-VINscratch:VINStart', nearType)
            end
        else
            TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['working'], Config.LangType['error'])
        end
    else
        TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['job'], Config.LangType['error'])
    end
end)


RegisterNetEvent('angelicxs-FREE-VINscratch:VINStart',function(type)
    local Category = type
    local GoForIt = true
    local Classification = 'nil'
    local Allow = true
    MissionType = type

    if not Config.LEOScratches and isLawEnforcement then
        GoForIt = false
        Allow = false
        CurrentJob = false
        TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['nocop'], Config.LangType['error'])
    end
    
    if GoForIt then
        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:GlobalJobTrue')
        if Category == 'vehicle' then
            Classification = 'ZERO'
            TriggerServerEvent('angelicxs-FREE-VINscratch:Server:NotifyPolice',1)
        end
        Wait(0)
        if Allow then
            VehicleSpawner(Classification)
            StartSpot = StartLocation(Classification)
            local hash = HashGrabber(Hash)
            TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['locate']..VehicleName, Config.LangType['info'])
            ClearAreaOfVehicles(StartSpot[1],StartSpot[2],StartSpot[3], 10, false, false, false, false, false)
            MissionVehicle = CreateVehicle(hash, StartSpot[1],StartSpot[2],StartSpot[3], true, true)
            SetEntityHeading(MissionVehicle, StartSpot[4])
            FreezeEntityPosition(MissionVehicle, true)
            SetVehicleOnGroundProperly(MissionVehicle)
            FreezeEntityPosition(MissionVehicle, false)
            SetEntityAsMissionEntity(MissionVehicle, true, true)
            SetVehicleDoorsLockedForAllPlayers(MissionVehicle, true)
            Lockpick(StartSpot)
            SetModelAsNoLongerNeeded(hash)
        end
    end    
end)

function Lockpick(StartSpot)
    local Player = PlayerPedId()
    local FoundIt = false
    local RandomOffset = math.random(-100, 100)
    local FindTime = 30 * 60
    FindMeBlip = AddBlipForRadius((StartSpot[1]+RandomOffset),(StartSpot[2]+RandomOffset),(StartSpot[3]+RandomOffset), 450.0)
    SetBlipSprite(FindMeBlip, 161)
    SetBlipColour(FindMeBlip, 83)
    SetBlipAsShortRange(FindMeBlip,false)
    CreateThread(function()
        while FindTime ~= 0 do
            if Findtime == 'found' then
                break
            elseif FindTime <= 0 then
                RemoveBlip(FindMeBlip)
                TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['failed_locate'], Config.LangType['error'])
                TriggerServerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
                TriggerEvent('angelicxs-FREE-VINscratch:ResetHeist')
                break
            end
            FindTime = FindTime - 1
            Wait(1000)
        end
    end)
    CreateThread(function()
        while not FoundIt do
            local Sleep = 2000
            local Pos = GetEntityCoords(Player)
            if #(Pos - vector3(StartSpot[1],StartSpot[2],StartSpot[3])) <= 50 and not FoundIt  then
                Sleep = 1000
                if #(Pos - vector3(StartSpot[1],StartSpot[2],StartSpot[3])) <= 4 and not FoundIt then
                    Sleep = 0
                    RemoveBlip(FindMeBlip)
                    DrawText3Ds(StartSpot[1],StartSpot[2],StartSpot[3],Config.Lang['lockpick'])
                    if IsControlJustReleased(0, 38) then
                        local CanLockPick = true									
                        if Config.NeedsLockpick then
                            CanLockPick = false
                            if Config.UseESX then
                                ESX.TriggerServerCallback('angelicxs-FREE-VINscratch:lockpick:ESX', function(cb) 
                                    CanLockPick = cb
                                end)                                
                            elseif Config.UseQBCore then
                                local hasItem = QBCore.Functions.HasItem(Config.LockpickName)
                                if hasItem then
                                    QBCore.Functions.TriggerCallback('angelicxs-VINscratch:lockpick:QBCore', function(cb)
                                    end)
                                    CanLockPick = true
                                end
                            end
                        end
                        Wait(500)
                        if CanLockPick == true then
                            Findtime = 'found'
                            FoundIt = true
                            FreezeEntityPosition(Player, true)
                            RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                            while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
                                Wait(10)
                            end
                            TaskPlayAnim(Player,"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",1.0, -1.0, -1, 49, 0, 0, 0, 0)
                            Wait(7500)	
                            ClearPedTasks(Player)
                            FreezeEntityPosition(Player, false)
                            RemoveAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                            SetVehicleDoorsLockedForAllPlayers(MissionVehicle, false)
                            local EndPoint = DropOff(MissionType)
                            CarAvailable = true
                            if Config.CleanGetAway then
                                TriggerServerEvent('angelicxs-FREE-VINscratch:Server:IsCoastClear',EndPoint)
                            end
                            TriggerServerEvent('angelicxs-FREE-VINscratch:Server:NotifyPolice',4)
                            TriggerEvent('angelicxs-FREE-VINscratch:GPSRoute',EndPoint)
                            TriggerEvent('angelicxs-FREE-VINscratch:CustomDisptachFoundIt',Pos)
                            TriggerEvent('angelicxs-FREE-VINscratch:FailConditions')
                        else
                            TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['missing_lockpick'], Config.LangType['error'])
                        end
                    end
                end
            end
            Wait(Sleep)
        end
    end)
end

RegisterNetEvent('angelicxs-FREE-VINscratch:NotifyPolice')
AddEventHandler('angelicxs-FREE-VINscratch:NotifyPolice',function(Message)
    if not Config.PoliceDispatch then
        if isLawEnforcement then
            if Message == 1 then
                TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['startvehicle'], Config.LangType['info'])
            elseif Message == 2 then
                TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['startboat'], Config.LangType['info'])
            elseif Message == 3 then
                TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['startheli'], Config.LangType['info'])
            elseif Message == 4 then
                TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['track_on'], Config.LangType['info'])
            elseif Message == 5 then
                TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['track_off'], Config.LangType['info'])
            end
        end
    end
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:GPSRoute',function(coords)
    local Player = PlayerPedId()
    local DropPed = false
    local Tracker = true
    DropLocationNPC = true
    CreateThread(function()
        while CurrentJob do
            while DropLocationNPC do
                local Sleep = 1500
                local Pos = GetEntityCoords(Player)
                local Dist = #(Pos - vector3(coords[1], coords[2], coords[3]))
                    if Dist <= 100 and not DropPed then
                        local hash = HashGrabber(Config.DropOffModel)
                        DropNPC = CreatePed(1, hash, coords[1], coords[2], (coords[3]-1), coords[4], false, false)
                        FreezeEntityPosition(DropNPC, true)
                        SetEntityInvincible(DropNPC, true)
                        SetBlockingOfNonTemporaryEvents(DropNPC, true)
                        TaskStartScenarioInPlace(DropNPC,'WORLD_HUMAN_CLIPBOARD', 0, false)
                        SetModelAsNoLongerNeeded(hash)
                        DropPed = true
                    elseif DoesEntityExist(DropNPC) and DropPed then
                        if Dist > 100 then
                            DeleteEntity(DropNPC)
                            DropPed = false
                        end
                    end
                    if Dist <= 3 then
                        Sleep = 0
                        DrawText3Ds(coords[1], coords[2], coords[3], Config.Lang['dropoff'])
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('angelicxs-FREE-VINscratch:Completion',coords)
                        elseif IsControlJustReleased(0,47) then
                            TriggerEvent('angelicxs-FREE-VINscratch:KeepScratch',coords)
                        end
                    end
                Wait(Sleep)
            end
        end
    end)
    CreateThread(function()
        while Tracker do
            Wait(1000)
            local Pos2 = GetEntityCoords(Player)
            local DrivingVehicle = GetVehiclePedIsIn(Player, false)

            if IsPedInAnyVehicle(Player, true) then
                Wait(200)
                if #(Pos2 - vector3(coords[1], coords[2], coords[3])) < Config.TrackerDistance then
                    TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['tracker_removed'], Config.LangType['success'])
                    TriggerServerEvent('angelicxs-FREE-VINscratch:Server:NotifyPolice',5)
                    Tracker = false
                elseif DrivingVehicle == MissionVehicle then
                    if Tracker then
                        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:TrackerCoords', Pos2)
                    end
                end
            end
        end		
    end)
    TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['find_dropoff'], Config.LangType['info'])
    Wait(60*1000)
    MissionRoute = AddBlipForCoord(coords[1], coords[2], coords[3])
    SetBlipColour(MissionRoute,5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.Lang['delivery_blip'])
	EndTextCommandSetBlipName(MissionRoute)
	SetBlipRoute(MissionRoute, true)
	SetBlipRouteColour(MissionRoute, 2)
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:FailConditions', function()
    local Player = PlayerPedId()

    CreateThread(function()
        while CarAvailable do
            if IsPedInAnyVehicle(Player, true) then
                Wait(1500)
                local DrivingVehicle = GetVehiclePedIsIn(Player, false)
                if DrivingVehicle ~=0 then
                    if DrivingVehicle ~= MissionVehicle then
                        TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['failed_vehicleswap'], Config.LangType['error'])
                        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
                        TriggerEvent('angelicxs-FREE-VINscratch:ResetHeist')
                        break
                    end
                end
            end
        Wait(1000)
        end
    end)
    CreateThread(function()
        local TimeLimit = Config.TimeLimit * 60
        while CarAvailable do
            while TimeLimit ~= 0 do
                Wait(1000)
                TimeLimit = TimeLimit - 1
                if TimeLimit <= 0 then
                    TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['failed_timeup'], Config.LangType['error'])
                    TriggerServerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
                    TriggerEvent('angelicxs-FREE-VINscratch:ResetHeist')
                    break
                end
            end
        end
    end)
end)


RegisterNetEvent('angelicxs-FREE-VINscratch:TrackingVehicle')
AddEventHandler('angelicxs-FREE-VINscratch:TrackingVehicle', function(targetCoords)
	if isLawEnforcement then		
		local Alpha = 80
		local TrackerDevice = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)
		SetBlipHighDetail(TrackerDevice, true)
		SetBlipColour(TrackerDevice, 1)
		SetBlipAlpha(TrackerDevice, Alpha)
		SetBlipAsShortRange(TrackerDevice, true)
		while Alpha ~= 0 do
			Wait(100)
			Alpha = Alpha - 1
			SetBlipAlpha(TrackerDevice, Alpha)
			if Alpha == 0 then
				RemoveBlip(TrackerDevice)
				return
			end
		end		
	end
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:Completion',function(coords)
    local Player = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(Player,true)
    local Dist = #(GetEntityCoords(Vehicle) - vector3(coords[1], coords[2], coords[3]))
    if Dist <= 15 and CoastIsClear then
        RemoveBlip(MissionRoute)
        SetEntityAsMissionEntity(MissionVehicle, false, false)
        DeleteVehicle(MissionVehicle)
        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:Completion')
        TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['reward'], Config.LangType['success'])
        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
        TriggerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
        Wait(60000)
        DeleteEntity(DropNPC)
    elseif not CoastIsClear then
        TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['notclear'], Config.LangType['error'])
    else
        TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['faraway'], Config.LangType['error'])
    end
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:KeepScratch',function(coords)
    local Player = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(Player,true)
    local Dist = #(GetEntityCoords(Vehicle) - vector3(coords[1], coords[2], coords[3]))
    if Config.AllowKeepingVehicle then
        if Dist <= 15 and CoastIsClear then
            if Config.UseESX then
                local VehiclePlate = ESX.Game.GetVehicleProperties(MissionVehicle)
                local OwnerPlate = exports['esx_vehicleshop']:GeneratePlate()
                VehiclePlate.plate = OwnerPlate
                TriggerServerEvent('angelicxs-FREE-VINscratch:Server:KeepScratch', VehiclePlate)
            elseif Config.UseQBCore then
                TriggerServerEvent('angelicxs-FREE-VINscratch:Server:KeepScratch', MissionVehicle)
            end
            RemoveBlip(MissionRoute)
            SetEntityAsMissionEntity(MissionVehicle, false, false)
            DeleteVehicle(MissionVehicle)
            TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['garage'], Config.LangType['success'])
            TriggerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
            TriggerEvent('angelicxs-FREE-VINscratch:ResetHeist')
            Wait(60000)
            DeleteEntity(DropNPC)
        elseif not CoastIsClear then
            TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['notclear'], Config.LangType['error'])
        else
            TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['faraway'], Config.LangType['error'])
        end 
    else
        TriggerEvent('angelicxs-FREE-VINscratch:Notify',Config.Lang['no_scratch'], Config.LangType['error'])
    end
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:CoastIsClearTrue')
AddEventHandler('angelicxs-FREE-VINscratch:CoastIsClearTrue', function()
    CoastIsClear = true
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:CoastIsClearFalse')
AddEventHandler('angelicxs-FREE-VINscratch:CoastIsClearFalse', function()
    CoastIsClear = false
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:GlobalJobTrue')
AddEventHandler('angelicxs-FREE-VINscratch:GlobalJobTrue', function()
    GlobalJob = true
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:GlobalJobFalse')
AddEventHandler('angelicxs-FREE-VINscratch:GlobalJobFalse', function()
    GlobalJob = false
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:ResetHeist')
AddEventHandler('angelicxs-FREE-VINscratch:ResetHeist', function()
    if MissionVehicle ~= nil then
        SetVehicleDoorsLockedForAllPlayers(MissionVehicle, false)
        SetEntityAsMissionEntity(MissionVehicle, false, false)
        MissionVehicle = nil
    end
    if GlobalJob then
        GlobalJob = false
        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:GlobalJobFalse')
    end
    if not CoastIsClear then
        CoastIsClear = true
        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:CoastIsClearTrue')
    end
    if TrackingDeviceStatus then
        TrackingDeviceStatus = false
    end    
    if MissionRoute ~= nil then
        RemoveBlip(MissionRoute)
        MissionRoute = nil
    end
    if FindMeBlip ~= nil then
        RemoveBlip(FindMeBlip)
        FindMeBlip = nil
    end
    NotifyCopType = 'none'
    MissionType = 'none'
    DropLocationNPC = false
    CurrentJob = false
    CarAvailable = false 
end)

RegisterNetEvent('angelicxs-FREE-VINscratch:IsCoastClear')
AddEventHandler('angelicxs-FREE-VINscratch:IsCoastClear', function(DropCoords)
    CreateThread(function()
        if not Config.LEOScratches and isLawEnforcement then
            while GlobalJob do
                local Sleep = 2000
                local Player = PlayerPedId()
                local Distance = #(GetEntityCoords(Player)-vector3(DropCoords[1],DropCoords[2],DropCoords[3]))
                if Distance <= Config.CleanGetAWayRadius then
                    Sleep = 500
                    TriggerServerEvent('angelicxs-FREE-VINscratch:Server:CoastIsClearFalse')
                else
                    TriggerServerEvent('angelicxs-FREE-VINscratch:Server:CoastIsClearTrue')
                end
            Wait(Sleep)
            end
        end
    end)
end)

-- Functions

function LawEnforcement()
    if not PlayerJob then
        return false
    elseif PlayerJob ~= Config.LEOJobName then
        return false
    elseif PlayerJob == Config.LEOJobName then
        return true
    end
end

function VehicleSpawner(category)
    local List = nil
    local Number = 0
    if category == 'ZERO' then
        List = Config.ClassZero
    end

    local Selection = math.random(1, #List)
    for i = 1, #List do
        local Model = List[i]
        Number = Number + 1
        if Number == Selection then
            Number = 0
            VehicleName = Model.Name
            Hash = Model.Hash
            break
        end
    end
end

function StartLocation(category)
    local List = nil
    local Number = 0
    if category == 'ZERO' then
        List = Config.ClassZeroLocation
    end

    local Selection = math.random(1, #List)
    for i = 1, #List do
        local Destination = List[i]
        Number = Number + 1
        if Number == Selection then
            Number = 0
            return Destination
        end
    end
end

function DropOff(category)
    local List = nil
    local Number = 0
    if category == 'vehicle' then
        List = Config.VINClassDropLocation
    end

    local Selection = math.random(1, #List)
    for i = 1, #List do
        local Destination = List[i]
        Number = Number + 1
        if Number == Selection then
            Number = 0
            return Destination
        end
    end
end

function HashGrabber(model)
    local hash = GetHashKey(model)
    
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Wait(10)
    end
    while not HasModelLoaded(hash) do
      Wait(10)
    end
    return hash
end

-- 3D Text Functionality
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

AddEventHandler('esx:onPlayerDeath', function()
	if GlobalJob and CurrentJob then
        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
        TriggerEvent('angelicxs-FREE-VINscratch:ResetHeist')
        TriggerEvent('angelicxs-FREE-VINscratch:Notify', Config.Lang['failed_death'], Config.LangType['info'])
	end
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        TriggerServerEvent('angelicxs-FREE-VINscratch:Server:ResetHeist')
        TriggerEvent('angelicxs-FREE-VINscratch:ResetHeist')
    end
end)
