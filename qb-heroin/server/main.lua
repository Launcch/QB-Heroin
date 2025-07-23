local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-herion:server:rewardOpiumSap')
AddEventHandler('qb-herion:server:rewardOpiumSap', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local rewardItem = Config['Reward']['opium_sap']['item']
    local min = Config['Reward']['opium_sap']['minAmount']
    local max = Config['Reward']['opium_sap']['maxAmount']
    local randomAmount = math.random(min, max)
    Player.Functions.AddItem(rewardItem, randomAmount)

    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[rewardItem], 'add')
end)

RegisterServerEvent('qb-herion:server:processHerion')
AddEventHandler('qb-herion:server:processHerion', function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local item = Config['Reward']['opium_sap']['item']
    local minAmount = Config['Reward']['heroin_bag']['amountOfLeaves']
    if not QBCore.Functions.HasItem(src, item, minAmount) then
        QBCore.Functions.Notify(src, Lang:t("error.not_enough_opium_sap"), "error")
        return
    end

    Player.Functions.RemoveItem(item, minAmount)

    local rewardItem = Config['Reward']['heroin_bag']['item']
    local rewardAmount = math.random(1, 2)
    Player.Functions.AddItem(rewardItem, rewardAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[rewardItem], 'add')
end)

RegisterServerEvent('qb-herion:server:sellHerion')
AddEventHandler('qb-herion:server:sellHerion', function (amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not QBCore.Functions.HasItem(src, Config.Reward['heroin_bag']['item'], amount) then
        QBCore.Functions.Notify(src, Lang:t("error.not_enough_heroin"), "error", 200)
        return
    end

    Player.Functions.RemoveItem(Config.Reward['heroin_bag']['item'], amount)

    local rewardMoneyType = Config.RewardMoneyType
    local rewardAmount = amount * Config.SellPrice
    Player.Functions.AddMoney(rewardMoneyType, rewardAmount)

    QBCore.Functions.Notify(src, Lang:t("success.sold_amount", { amount = amount, reward = rewardAmount}), "success", 1000)
end)
