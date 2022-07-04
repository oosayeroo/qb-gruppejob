local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = {}
local GJobsDone = 0
local DropOffDone = {}
local CurrentLocation = nil
local CurrentBlip = nil
local hasCase = false
local atWork = false
local currentCount = 0
local CurrentPlate = nil
local selectedVeh = nil
local GruppeVehBlip = nil
local EnRoute = false
local showMarker = false
local GJMarkerLocation


CreateThread(function()
    if Config.GJDrawText == "enabled" then 
        while true do
            sleep = 100
            local pos = GetEntityCoords(PlayerPedId())
            local PlayerData = QBCore.Functions.GetPlayerData()
  
                if PlayerJob.name == Config.JobName then
                    for k, v in pairs(Config.GruppeLocations["gruppe-duty"]) do
                        local dist = #(pos - v)
                            if dist < 1.8 then
                              DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 16, 227, 86, 86, false, false, false, true, false, false, false)                              if dist < 1.8 then
                                    sleep = 5
                                    if not onDuty then
                                        QBCore.Functions.DrawText3D(v.x, v.y, v.z +0.2, "~g~E~w~ - Go on duty")
                                        --QBCore.Functions.DrawText3D(v.x, v.y, v.z, "~r~E~w~ - Go off duty")
                                    else
                                        QBCore.Functions.DrawText3D(v.x, v.y, v.z +0.2, "~r~E~w~ - Go off duty")
                                        --QBCore.Functions.DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Go on duty")
                                    end
                                    if IsControlJustReleased(0, 38) then
                                        onDuty = not onDuty
                                        TriggerServerEvent("QBCore:ToggleDuty")
                                    end
                                end
                            elseif #(pos - v) < 1.5 then
                                sleep = false
                                QBCore.Functions.DrawText3D(v.x, v.y, v.z, "Time Clock")
                            end
                        end
                    end

                    for k, v in pairs(Config.GruppeLocations["sell-inked-bills"]) do
                        if #(pos - vector3(v.x, v.y, v.z)) < 0.9 then
                            sleep = 5
                            QBCore.Functions.DrawText3D(v.x, v.y, v.z, "~g~[E]~w~ - Sell 10 Bills")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("qb-gruppejob:SellInkedBills")
                            end
                        elseif #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            sleep = 5
                            QBCore.Functions.DrawText3D(v.x, v.y, v.z, "Sell 10 Bills")
                        end
                    end
  
                if PlayerJob.name == Config.JobName and QBCore.Functions.GetPlayerData().job.onduty then
                for k, v in pairs(Config.GruppeLocations["collect-case"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 0.8 then
                      sleep = 5
                      QBCore.Functions.DrawText3D(v.x, v.y, v.z, "~g~[E]~w~ - Collect Cases")
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("qb-gruppejob:CollectCase")
                        end
                    elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                        sleep = 5
                        QBCore.Functions.DrawText3D(v.x, v.y, v.z, "Collect Cases")
                    end
                  end
  
                for k, v in pairs(Config.GruppeLocations["deposit-case"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 0.9 then
                        sleep = 5
                        QBCore.Functions.DrawText3D(v.x, v.y, v.z, "~g~[E]~w~ - Deposit Cases")
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("qb-gruppejob:DepositCase")
                        end
                    elseif #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                        sleep = 5
                        QBCore.Functions.DrawText3D(v.x, v.y, v.z, "Deposit Case")
                    end
                end

            end
        Wait(sleep)
    end
    end
  end)


-- Functions

local function hasDoneLocation(locationId)
    local retval = false
    if DropOffDone ~= nil and next(DropOffDone) ~= nil then
        for _, v in pairs(DropOffDone) do
            if v == locationId then
                retval = true
            end
        end
    end
    return retval
end

local function getNextWorkLocation()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = 0
    local dist = nil

    for k, _ in pairs(Config.GJLocations["banks"]) do
        if current ~= 0 then
            if #(pos - vector3(Config.GJLocations["banks"][k].coords.x, Config.GJLocations["banks"][k].coords.y, Config.GJLocations["banks"][k].coords.z)) < dist then
                if not hasDoneLocation(k) then
                    current = k
                    dist = #(pos - vector3(Config.GJLocations["banks"][k].coords.x, Config.GJLocations["banks"][k].coords.y, Config.GJLocations["banks"][k].coords.z))
                end
            end
        else
            if not hasDoneLocation(k) then
                current = k
                dist = #(pos - vector3(Config.GJLocations["banks"][k].coords.x, Config.GJLocations["banks"][k].coords.y, Config.GJLocations["banks"][k].coords.z))
            end
        end
    end

    return current
end

local function isGruppeVehicle(vehicle)
    local retval = false
    for k in pairs(Config.GJVehicles) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

local function RemoveGruppeBlips()
    if GruppeVehBlip ~= nil then
        RemoveBlip(GruppeVehBlip)
	    ClearAllBlipRoutes()
        GruppeVehBlip = nil
    end

    if CurrentBlip ~= nil then
        RemoveBlip(CurrentBlip)
	    ClearAllBlipRoutes()
        CurrentBlip = nil
    end
end

local function MenuGarage()
    local GruppeMenu = {
        {
            header = "Available Trucks",
            isMenuHeader = true
        }
    }
    for k in pairs(Config.GJVehicles) do
        GruppeMenu[#GruppeMenu+1] = {
            header = Config.GJVehicles[k],
            params = {
                event = "qb-gruppejob:client:TakeOutVehicle",
                args = {
                    vehicle = k
                }
            }
        }
    end

    GruppeMenu[#GruppeMenu+1] = {
        header = "Close Menu",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(GruppeMenu)
end


local function CloseMenuFull()
    exports['qb-menu']:closeMenu()
end

local function CreateZone(type, number)
    local coords
    local heading
    local boxname
    local event
    local label
    local size

    if type == "homebase" then
        event = "qb-gruppejob:client:PaySlip"
        label = "Payslip"
        coords = vector3(Config.GJLocations[type].coords.x, Config.GJLocations[type].coords.y, Config.GJLocations[type].coords.z)
        heading = Config.GJLocations[type].coords.h
        boxname = Config.GJLocations[type].label
        size = 3
    elseif type == "gruppetruck" then
        event = "qb-gruppejob:client:GJVehicles"
        label = "Gruppe Truck"
        coords = vector3(Config.GJLocations[type].coords.x, Config.GJLocations[type].coords.y, Config.GJLocations[type].coords.z)
        heading = Config.GJLocations[type].coords.h
        boxname = Config.GJLocations[type].label
        size = 5
    elseif type == "banks" then
        event = "qb-gruppejob:client:Bank"
        label = "Bank"
        coords = vector3(Config.GJLocations[type][number].coords.x, Config.GJLocations[type][number].coords.y, Config.GJLocations[type][number].coords.z)
        heading = Config.GJLocations[type][number].coords.h
        boxname = Config.GJLocations[type][number].name
        size = 80  --originally 40
    end

    if Config.UseTarget and type == "homebase"then
        exports['qb-target']:AddBoxZone(boxname, coords, size, size, {
            minZ = coords.z - 5.0,
            maxZ = coords.z + 5.0,
            name = boxname,
            heading = heading,
            debugPoly = false,
        }, {
            options = {
                {
                    type = "client",
                    event = event,
                    label = label,
                },
            },
            distance = 2
        })
    else
        local zone = BoxZone:Create(
            coords, size, size, {
                minZ = coords.z - 5.0,
                maxZ = coords.z + 5.0,
                name = boxname,
                debugPoly = false,
                heading = heading,
            })
    
        local zoneCombo = ComboZone:Create({zone}, {name = boxname, debugPoly = false})
        zoneCombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if type == "homebase" then
                    TriggerEvent('qb-gruppejob:client:PaySlip')
                elseif type == "gruppetruck" then
                    TriggerEvent('qb-gruppejob:client:GJVehicles')
                elseif type == "banks" then
                    GJMarkerLocation = coords
                    QBCore.Functions.Notify("Bank Reached, Grab a Case From The Back")
                    TriggerEvent('qb-gruppejob:client:ShowMarker', true)
                    TriggerEvent('qb-gruppejob:client:SetEnRoute', true)
                end
            else
                if type == "banks" then
                    TriggerEvent('qb-gruppejob:client:ShowMarker', false)
                    TriggerEvent('qb-gruppejob:client:SetEnRoute', false)
                end
            end
        end)
        if type == "gruppetruck" then
            local zonedel = BoxZone:Create(
                coords, 40, 40, {
                    minZ = coords.z - 5.0,
                    maxZ = coords.z + 5.0,
                    name = boxname,
                    debugPoly = false,
                    heading = heading,
                })
        
            local zoneCombodel = ComboZone:Create({zonedel}, {name = boxname, debugPoly = false})
            zoneCombodel:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    GJMarkerLocation = coords
                    TriggerEvent('qb-gruppejob:client:ShowMarker', true)
                else
                    TriggerEvent('qb-gruppejob:client:ShowMarker', false)
                end
            end)
        elseif type == "banks" then
            CurrentLocation.zoneCombo = zoneCombo
        end
    end
end

local function ExportNewLocation()
    local location = getNextWorkLocation()
    if location ~= 0 then
        CurrentLocation = {}
        CurrentLocation.id = location
        CurrentLocation.dropoffcount = math.random(2, 2)
        CurrentLocation.store = Config.GJLocations["banks"][location].name
        CurrentLocation.x = Config.GJLocations["banks"][location].coords.x
        CurrentLocation.y = Config.GJLocations["banks"][location].coords.y
        CurrentLocation.z = Config.GJLocations["banks"][location].coords.z
        CreateZone("banks", location)

        CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
        SetBlipColour(CurrentBlip, 3)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 3)
    else
        QBCore.Functions.Notify("Route Done, Take Truck Back")
        if CurrentBlip ~= nil then
            RemoveBlip(CurrentBlip)
	        ClearAllBlipRoutes()
            CurrentBlip = nil
        end
    end
end

local function CreateElements()
    GruppeVehBlip = AddBlipForCoord(Config.GJLocations["gruppetruck"].coords.x, Config.GJLocations["gruppetruck"].coords.y, Config.GJLocations["gruppetruck"].coords.z)
    SetBlipSprite(GruppeVehBlip, 326)
    SetBlipDisplay(GruppeVehBlip, 4)
    SetBlipScale(GruppeVehBlip, 0.6)
    SetBlipAsShortRange(GruppeVehBlip, true)
    SetBlipColour(GruppeVehBlip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.GJLocations["gruppetruck"].label)
    EndTextCommandSetBlipName(GruppeVehBlip)

    local TruckerBlip = AddBlipForCoord(Config.GJLocations["homebase"].coords.x, Config.GJLocations["homebase"].coords.y, Config.GJLocations["homebase"].coords.z)
    SetBlipSprite(TruckerBlip, 479)
    SetBlipDisplay(TruckerBlip, 4)
    SetBlipScale(TruckerBlip, 0.6)
    SetBlipAsShortRange(TruckerBlip, true)
    SetBlipColour(TruckerBlip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.GJLocations["homebase"].label)
    EndTextCommandSetBlipName(TruckerBlip)

    CreateZone("homebase")
    CreateZone("gruppetruck")
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    CurrentLocation = nil
    CurrentBlip = nil
    hasCase = false
    atWork = false
    GJobsDone = 0
    if PlayerJob.name == "gruppe" then
        CreateElements()
    end

end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    RemoveGruppeBlips()
    CurrentLocation = nil
    CurrentBlip = nil
    hasCase = false
    atWork = false
    GJobsDone = 0
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    local OldPlayerJob = PlayerJob.name
    PlayerJob = JobInfo

    if PlayerJob.name == "gruppe" then
        CreateElements()
    end
    if OldPlayerJob == "gruppe" then
        RemoveGruppeBlips()
    end
end)

RegisterNetEvent('qb-gruppejob:client:ShowMarker', function(active)
    if PlayerJob.name == "gruppe" then
        showMarker = active
    end
end)

RegisterNetEvent('qb-gruppejob:client:SetEnRoute', function(active)
    if PlayerJob.name == "gruppe" then
        EnRoute = active
    end
end)




RegisterNetEvent('qb-gruppejob:client:SpawnVehicle', function()
    local vehicleInfo = selectedVeh
    local coords = Config.GJLocations["gruppetruck"].coords
    coords = vector3(coords.x, coords.y, coords.z)
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "GRU6"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        CloseMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = QBCore.Functions.GetPlate(veh)
        ExportNewLocation()
    end, coords, true)
end)

RegisterNetEvent('qb-gruppejob:client:TakeOutVehicle', function(data)
    local vehicleInfo = data.vehicle
    TriggerServerEvent('qb-gruppejob:server:PayBail', true, vehicleInfo)
    selectedVeh = vehicleInfo
end)

RegisterNetEvent('qb-gruppejob:client:GJVehicles', function()
    if IsPedInAnyVehicle(PlayerPedId()) and isGruppeVehicle(GetVehiclePedIsIn(PlayerPedId(), false)) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
            if isGruppeVehicle(GetVehiclePedIsIn(PlayerPedId(), false)) then
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                TriggerServerEvent('qb-gruppejob:server:PayBail', false)
                if CurrentBlip ~= nil then
                    RemoveBlip(CurrentBlip)
                    ClearAllBlipRoutes()
                    CurrentBlip = nil
                end
            else
                QBCore.Functions.Notify("Wrong Vehicle")
            end
        else
            QBCore.Functions.Notify("No Driver")
        end
    else
        MenuGarage()
    end
end)

RegisterNetEvent('qb-gruppejob:client:TakeFromTrunk', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then
        local pos = GetEntityCoords(PlayerPedId(), true)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
        if isGruppeVehicle(vehicle) and CurrentPlate == QBCore.Functions.GetPlate(vehicle) then
            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
            if #(pos - vector3(trunkpos.x, trunkpos.y, trunkpos.z)) < 4.0 and not atWork then
                atWork = true
                QBCore.Functions.Progressbar("work_carrycase", "Grabbing Case", 2000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@facility@servers@",
                    anim = "hotwire",
                    flags = 16,
                }, {}, {}, function() -- Done
                    atWork = false
                    StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    TriggerEvent('animations:client:EmoteCommandStart', {"suitcase2"})
                    hasCase = true
                end, function() -- Cancel
                    atWork = false
                    StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    QBCore.Functions.Notify("Cancelled..", "error")
                end)
            end
        end
    end
end)

RegisterNetEvent('qb-gruppejob:client:DropOffCase', function()
    atWork = true
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    Wait(500)
    TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
    TriggerServerEvent('QBCore:Server:RemoveItem', "gruppe-case", 1)
    QBCore.Functions.Progressbar("work_dropbox", "Deliver Case", 2000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        atWork = false
        ClearPedTasks(PlayerPedId())
        hasCase = false
        currentCount = currentCount + 1
        if currentCount == CurrentLocation.dropoffcount then
            DropOffDone[#DropOffDone+1] = CurrentLocation.id
            QBCore.Functions.Notify("Go To The Next Bank")
            exports['qb-core']:HideText()
            EnRoute = false
            showMarker = false
            TriggerServerEvent('qb-gruppejob:server:GivePayment')
            if CurrentBlip ~= nil then
                RemoveBlip(CurrentBlip)
                ClearAllBlipRoutes()
                CurrentBlip = nil
            end
            CurrentLocation.zoneCombo:destroy()
            CurrentLocation = nil
            currentCount = 0
            GJobsDone = GJobsDone + 1
            ExportNewLocation()
        else
            QBCore.Functions.Notify("Go Get Another Case")
        end
    end, function() -- Cancel
        atWork = false
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Cancelled..", "error")
    end)

end)

-- Threads
CreateThread(function()
    local sleep
    while true do
        sleep = 1000
        if showMarker then
            DrawMarker(2, GJMarkerLocation.x, GJMarkerLocation.y, GJMarkerLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
            sleep = 0
        end
        if EnRoute then
            if IsControlJustReleased(0, 38) then
                if not hasCase then
                    TriggerEvent('qb-gruppejob:client:TakeFromTrunk')
                else
                    TriggerEvent('qb-gruppejob:client:DropOffCase')
                end
            end
            sleep = 0
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('qb-gruppejob:CollectCase', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"idle"})
    QBCore.Functions.Progressbar('falar_empregada', 'Picking up Cases...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
    QBCore.Functions.Notify('You got some cases, now go deliver them', 'primary', 7500)

    TriggerServerEvent('qb-gruppejob:server:CollectCase')
    end)
end)

RegisterNetEvent('qb-gruppejob:DepositCase', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"idle"})
    QBCore.Functions.Progressbar('falar_empregada', 'Depositing  Cases...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
    QBCore.Functions.Notify('You deposited spare cases, job well done', 'primary', 7500)

    TriggerServerEvent('qb-gruppejob:server:DepositCase')
    end)
end)		

RegisterNetEvent('qb-gruppejob:SellInkedBills', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"idle"})
    TriggerServerEvent('QBCore:Server:RemoveItem', "inked-bills", Config.InkedBillsGiven)
    QBCore.Functions.Progressbar('falar_empregada', 'Selling Bills...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
    QBCore.Functions.Notify('You Sold Inked Bills', 'primary', 7500)

    TriggerServerEvent('qb-gruppejob:server:InkedBillsReward')
    end)
end)		


RegisterNetEvent("qb-gruppejob:OpenCase")
AddEventHandler("qb-gruppejob:OpenCase", function()
    TriggerServerEvent("qb-gruppejob:server:GruppeCaseOpen")
		local randomCase = math.random(1,15)
        --remove case
		TriggerServerEvent('QBCore:Server:RemoveItem', "gruppe-case", 1)
		--add items from case
		TriggerServerEvent('QBCore:Server:AddItem', "inked-bills", Config.InkedBillsAmount)

		if randomCase < 4 then
					TriggerServerEvent('QBCore:Server:AddItem', "lockpick", 10)
					
		elseif randomCase == 4 then
					TriggerServerEvent('QBCore:Server:AddItem', "goldbar", 1)
            		
		elseif randomCase < 10 and randomCase > 4 then
					TriggerServerEvent('QBCore:Server:AddItem', "diamond", 1)
					
		elseif randomCase == 10 then
					TriggerServerEvent('QBCore:Server:AddItem', "goldchain", 1)
            		
		elseif randomCase > 10 and randomCase < 15 then
            		QBCore.Functions.Notify("No extra item found", "error")
		elseif randomCase == 15 then
					TriggerServerEvent('QBCore:Server:AddItem', "advancedlockpick", 1)
            					
        end
end) 