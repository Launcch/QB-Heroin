local QBCore = exports['qb-core']:GetCoreObject()
local busy = false -- check if player already either picking or processing

local isInsideZone = false -- is player inside picking zone
local isInsideProcessingZone = false -- is player inside processing zone

local animLoaded = false -- picking anim loaded 
local processAnimLoaded = false -- processing anim loaded
local playerPed = nil

-- loops state
local cocaHarvestingLoopIsRunning = false
local cocaProcessingLoopIsRunning = false

-- help text (qb-core:drawtext)
local helpTextShowing = false

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end

local function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

-- function that handles picking coca leaves
local function pickOpium()
    if busy then
        return
    end
    busy = true

    local animDict = 'amb@medic@standing@kneel@idle_a'

    if not animLoaded then
        loadAnimDict(animDict)
        animLoaded = true
    end

    local animDuration = 6000
    local anim = 'idle_a'
    TaskPlayAnim(playerPed, animDict, anim, 8.0, 8.0, animDuration, 0)
    Wait(animDuration)

    TriggerServerEvent('qb-herion:server:rewardOpiumSap')
    busy = false
end

-- function that handles coca processing
local function processOpiumIntoHerion()
    if busy then
        return
    end

    local requiredItem = Config['Reward']['opium_sap']['item']
    local requiredAmount = Config['Reward']['heroin_bag']['amountOfLeaves']
    if not QBCore.Functions.HasItem(requiredItem, requiredAmount) then
        QBCore.Functions.Notify(Lang:t("error.not_enough_opium_sap"), "error", 100)
        return
    end

    busy = true

    local animDict = 'anim@amb@business@coc@coc_unpack_cut@'
    local anim = 'fullcut_cycle_cokecutter'

    if not processAnimLoaded then
        loadAnimDict(animDict)
        processAnimLoaded = true
    end

    local animDuration = 12000
    TaskPlayAnim(playerPed, animDict, anim, 8.0, 8.0, animDuration, 0)
    Wait(animDuration)

    TriggerServerEvent('qb-herion:server:processHerion')

    busy = false
end

-- coca picking zone loop
-- this loop is only run when inside zone
local function opiumPickingZoneLoop()
    if not opiumHarvestingLoopIsRunning then
        Citizen.CreateThread(function ()
            opiumHarvestingLoopIsRunning = true
            while isInsideZone do
                if IsControlJustPressed(0, 51) then
                    pickOpium()
                end
                Citizen.Wait(1)
            end
            opiumHarvestingLoopIsRunning = false
        end)
    end
end

-- coca processing zone loop
-- this loop is only run when inside zone
local function opiumProcessingZoneLoop()
    if not cocaProcessingLoopIsRunning then
        exports["qb-core"]:DrawText(Lang:t("info.process_opium"), "left")
        helpTextShowing = true

        Citizen.CreateThread(function ()
            cocaProcessingLoopIsRunning = true
            while isInsideProcessingZone do
                if IsControlJustPressed(0, 51) then
                    processOpiumIntoHerion()
                end
                Citizen.Wait(1)
            end
            opiumProcessingLoopIsRunning = false
        end)
    end
end


-- Buyer Globals
local buyerAnimLoaded = false
local buyerAnimDict = 'mp_ped_interaction'
local buyerAnim = 'handshake_guy_a'

local buyerVehicle = nil
local buyerPed = nil
local bodyguard1 = nil
local bodyguard2 = nil
local buyerZoneIsInside = false
local buyerZoneLoopIsRunning = false

local bodyguardAnimDict = 'anim@move_m@security_guard'
local bodyguardAnim = 'idle_var_01'

local bodyguard2Anim = 'idle_var_02'

-- sell cocaine to buyer function
local function sellHerionToBuyer()
    local requiredItem = Config.Reward['heroin_bag']['item']

    local i = 0
    local amount = 10
    while i < 10 do
        if QBCore.Functions.HasItem(requiredItem, amount) then
            break
        end

        amount = amount-1
        i = i+1
    end

    if amount == 0 then
        QBCore.Functions.Notify(Lang:t("error.has_no_heroin"), "error", 100)
        return
    end

    if not buyerAnimLoaded then
        loadAnimDict(buyerAnimDict)
        buyerAnimLoaded = true
    end

    local animDuration = 1500
    TaskPlayAnim(buyerPed, buyerAnimDict, buyerAnim, 8.0, 8.0, animDuration, 0)
    TaskPlayAnim(playerPed, buyerAnimDict, buyerAnim, 8.0, 8.0, animDuration, 0)
    Wait(animDuration)
    StopAnimTask(buyerPed)

    TriggerServerEvent('qb-herion:server:sellHerion', amount)
end

-- buyer zone loop
local function buyerZoneLoop()
    if not buyerZoneLoopIsRunning then
        Citizen.CreateThread(function ()
            buyerZoneLoopIsRunning = true
            while buyerZoneIsInside do
                QBCore.Functions.DrawText3D(Config.Buyer.pos.x, Config.Buyer.pos.y, Config.Buyer.pos.z + 1.3, Lang:t("info.press_sell_heroin"))
    
                -- detect click
                if IsControlJustPressed(0, 51) then
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local dist = #(playerCoords - Config.Buyer['pos'].xyz)
                    if dist <= 1.5 and not busy then
                        busy = true
                        sellHerionToBuyer() -- trigger sell cocaine function
                        busy = false
                    end
                end
    
                Citizen.Wait(1)
            end
            buyerZoneLoopIsRunning = false
        end)
    end
end

local function createPeds()
    loadModel(Config.Buyer.vehicle)
    loadModel(Config.Buyer.ped)
    loadModel(Config.Buyer.bodyguard)
    loadAnimDict(bodyguardAnimDict)

    local vPos = Config.Buyer.vehiclePos
    buyerVehicle = CreateVehicle(GetHashKey(Config.Buyer.vehicle), vPos.xyz, vPos.w, false, false)
    while not DoesEntityExist(buyerVehicle) do
        Wait(100)
    end
    if DoesEntityExist(buyerVehicle) then
        SetVehicleCustomPrimaryColour(buyerVehicle, 0, 0, 0)
        SetVehicleDoorsLocked(buyerVehicle, 2)
        FreezeEntityPosition(buyerVehicle, true)
        SetEntityInvincible(buyerVehicle, true)
        SetVehicleEngineOn(buyerVehicle, true, true)
        SetVehicleLights(buyerVehicle, 2)
    end

    buyerPed = CreatePed(0, GetHashKey(Config.Buyer.ped), Config.Buyer.pos.x, Config.Buyer.pos.y, Config.Buyer.pos.z, Config.Buyer.pos.w, false)
    while not DoesEntityExist(buyerPed) do
        Wait(100)
    end
    SetBlockingOfNonTemporaryEvents(buyerPed, true)
    FreezeEntityPosition(buyerPed, true)
    SetEntityInvincible(buyerPed, true)

    bodyguard1 = CreatePed(0, GetHashKey(Config.Buyer.bodyguard), Config.Buyer.bodyguard1Pos.xyz, Config.Buyer.bodyguard1Pos.w, false)
    while not DoesEntityExist(bodyguard1) do
        Wait(100)
    end
    SetBlockingOfNonTemporaryEvents(bodyguard1, true)
    FreezeEntityPosition(bodyguard1, true)
    SetEntityInvincible(bodyguard1, true)
    TaskPlayAnim(bodyguard1, bodyguardAnimDict, bodyguardAnim, 8.0, 8.0, -1, 1)

    bodyguard2 = CreatePed(0, GetHashKey(Config.Buyer.bodyguard), Config.Buyer.bodyguard2Pos.xyz, Config.Buyer.bodyguard2Pos.w, false)
    while not DoesEntityExist(bodyguard2) do
        Wait(100)
    end
    SetEntityInvincible(bodyguard2, true)
    SetBlockingOfNonTemporaryEvents(bodyguard2, true)
    FreezeEntityPosition(bodyguard2, true)
    TaskPlayAnim(bodyguard2, bodyguardAnimDict, bodyguard2Anim, 8.0, 8.0, -1, 1)
end

-- Event handler that deletes created peds and vehicle
AddEventHandler("onResourceStop", function (resource)
    if resource == GetCurrentResourceName() then
        DeleteEntity(buyerPed)
        DeleteEntity(buyerVehicle)
        DeleteEntity(bodyguard1)
        DeleteEntity(bodyguard2)
    end
end)

-- function that insures that peds and vehicle creation
-- it is called non-stop until peds and vehicle is created
local startingPeds = false
local function startPeds()
    if not startingPeds then
        startingPeds = true
        CreateThread(function ()
            createPeds()
        end)
        startingPeds = false
    end
end

-- =========
-- MAIN LOOP
-- =========
CreateThread(function ()
    createPeds()

    while true do
        playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerHeading = GetEntityHeading(playerPed)
        local cocaFieldCoords = Config.PickingZone

        -- ==================
        -- === Harvesting ===
        -- ==================
        -- picking zone
        local dist = #(playerCoords - cocaFieldCoords)

        -- if is near coca field, then start loop and show help text
        if dist <= 17.0 then
            isInsideZone = true
            exports['qb-core']:DrawText(Lang:t("info.pick_opium_sap"), 'left')
            helpTextShowing = true
            opiumPickingZoneLoop()
        else -- if not then stop showing help text as the player is far away
            isInsideZone = false
        end

        -- ==================
        -- === Processing ===
        -- ==================
        dist = #(playerCoords - Config.ProcessingZone)
        if dist <= 10.0 and (playerHeading <= 360.0 and playerHeading >= 305.0) then
            isInsideProcessingZone = true
            exports["qb-core"]:DrawText(Lang:t("info.process_opium"), "left")
            helpTextShowing = true
            opiumProcessingZoneLoop()
        else
            isInsideProcessingZone = false
        end

        if helpTextShowing and not isInsideZone and not isInsideProcessingZone then
            exports["qb-core"]:HideText()
            helpTextShowing = false
        end

        -- =============
        -- === Buyer ===
        -- =============

        dist = #(playerCoords - Config['Buyer']['pos'].xyz)
        if dist <= 50.0 then -- if player is near buyer
            if buyerPed == nil or buyerPed == 0 then
                startPeds() -- create peds and vehicle if not already done
            end
        else
        end

        if dist <= 3.0 and (playerHeading <= 360.0 and playerHeading >= 260.0) then
            buyerZoneIsInside = true
            buyerZoneLoop()
        else
            buyerZoneIsInside = false
        end

        -- wait 1 seconds
        Wait(1000)
    end
end)
