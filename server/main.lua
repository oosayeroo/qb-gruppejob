local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = {}
local PaymentTax = 15
local Bail = {}

RegisterNetEvent('qb-gruppejob:server:PayBail', function(bool, vehInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.GruppeBailPrice then
            Bail[Player.PlayerData.citizenid] = Config.GruppeBailPrice
            Player.Functions.RemoveMoney('cash', Config.GruppeBailPrice, "tow-received-bail")
            TriggerClientEvent('qb-gruppejob:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.GruppeBailPrice then
            Bail[Player.PlayerData.citizenid] = Config.GruppeBailPrice
            Player.Functions.RemoveMoney('bank', Config.GruppeBailPrice, "tow-received-bail")
            TriggerClientEvent('qb-gruppejob:client:SpawnVehicle', src, vehInfo)
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "trucker-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
        end
    end
end)

RegisterNetEvent('qb-gruppejob:server:GiveCrypto', function()
    local chance = math.random(1,100)
    if chance < 20 then
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
        xPlayer.Functions.AddItem("cryptostick", 1, false)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["cryptostick"], "add")
    end

end)

QBCore.Functions.CreateUseableItem("gruppe-case", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("qb-gruppejob:OpenCase", source, item.name)
end)

RegisterNetEvent('qb-gruppejob:server:CollectCase', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item2 = 'gruppe-case'
    local quantity = Config.GruppeCaseAmount

    Player.Functions.AddItem(item2, quantity)
end)

RegisterNetEvent('qb-gruppejob:server:DepositCase', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item2 = 'gruppe-case'
    local quantity = 1

    Player.Functions.RemoveItem(item2, quantity)
end)

RegisterNetEvent('qb-gruppejob:server:InkedBillsReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.InkedBillsValue

    Player.Functions.AddMoney("cash", payment)
end) 

RegisterNetEvent('qb-gruppejob:server:GivePayment', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.DropOffPrice

    Player.Functions.AddMoney('bank', payment)
end)
