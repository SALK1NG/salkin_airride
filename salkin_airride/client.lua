local hasAirride = false
local currentLimits = { min = 0.0, max = 0.0 }
local currentHeight = 0.0
local lastVehicle = nil
local isStiff = false
local originalForce = 0.0
local isHolding = false

-- Fahrzeug-Daten aus Config anhand von Hash finden
function GetVehicleConfig(veh)
    local model = GetEntityModel(veh)
    for name, data in pairs(Config.VehicleWhitelist) do
        if GetHashKey(name) == model then
            return data, name:lower()
        end
    end
    return nil, nil
end

-- Export für ox_inventory Item-Nutzung
exports('installAirride', function(data, slot)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    
    if veh == 0 then 
        ESX.ShowNotification('Du musst im Auto sitzen!', 'error')
        return 
    end
    
    local vehicleData, modelName = GetVehicleConfig(veh)
    if not vehicleData then
        ESX.ShowNotification('Dieses Modell unterstützt kein Airride!', 'error')
        return
    end

    local plate = GetVehicleNumberPlateText(veh)
    ESX.TriggerServerCallback('salkin_airride:server:isOwner', function(owner)
        if not owner then 
            ESX.ShowNotification('Nicht dein Fahrzeug!', 'error')
            return 
        end
        
        -- Fortschrittsbalken (ox_lib)
        if lib.progressBar({
            duration = Config.InstallTime,
            label = 'Airride wird installiert...',
            disable = { car = false, move = true }
        }) then
            TriggerServerEvent('salkin_airride:server:installSuccess', plate)
            hasAirride = true
            updateVehicleLimits(veh, modelName)
            ESX.ShowNotification('Airride erfolgreich installiert!', 'success')
        else
            ESX.ShowNotification('Einbau abgebrochen.', 'info')
        end
    end, plate)
end)

-- Berechnet Limits inkl. Mechaniker-Tuning
function updateVehicleLimits(veh, modelName)
    local baseLimits = Config.VehicleWhitelist[modelName]
    if not baseLimits then return end

    local modLevel = GetVehicleMod(veh, 15)
    local reduction = (modLevel >= 0) and ((modLevel + 1) * Config.TuningReductionFactor) or 0.0

    currentLimits.min = baseLimits.min
    currentLimits.max = baseLimits.max - reduction
    if currentLimits.max < currentLimits.min then currentLimits.max = currentLimits.min end
end

-- Schaltet Federung starr & limitiert Speed auf 50kmh
function SetStiffnessAndSpeed(veh, stiff)
    if stiff and not isStiff then
        originalForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionForce')
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionForce', Config.StiffSuspensionForce)
        
        -- Speed auf 50 km/h begrenzen
        SetEntityMaxSpeed(veh, 50.0 / 3.6)
        isStiff = true
    elseif not stiff and isStiff then
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionForce', originalForce)
        
        -- Speed-Limit aufheben
        SetEntityMaxSpeed(veh, GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveMaxFlatVel"))
        isStiff = false
    end
end

-- Haupt-Loop
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 then
            if veh ~= lastVehicle then
                lastVehicle = veh
                local vehicleData, modelName = GetVehicleConfig(veh)
                
                if vehicleData then
                    ESX.TriggerServerCallback('salkin_airride:server:hasAirrideInstalled', function(installed)
                        hasAirride = installed
                        if hasAirride then
                            updateVehicleLimits(veh, modelName)
                        end
                        currentHeight = 0.0
                    end, GetVehicleNumberPlateText(veh))
                else
                    hasAirride = false
                end
            end

            if hasAirride and GetPedInVehicleSeat(veh, -1) == ped then
                sleep = 0
                
                -- Hilfe-Text anzeigen (ESX Standard links oben)
                ESX.ShowHelpNotification('Nutze ~INPUT_CELLPHONE_UP~ / ~INPUT_CELLPHONE_DOWN~ um das Airride zu steuern')

                local changed = false
                if IsControlPressed(0, Config.Controls.Up) then
                    if currentHeight > currentLimits.min then
                        currentHeight = currentHeight - Config.ChangeSpeed
                        changed = true
                        isHolding = true
                    end
                elseif IsControlPressed(0, Config.Controls.Down) then
                    if currentHeight < currentLimits.max then
                        currentHeight = currentHeight + Config.ChangeSpeed
                        changed = true
                        isHolding = true
                    end
                end

                if changed then
                    SetVehicleSuspensionHeight(veh, currentHeight)
                    SetStiffnessAndSpeed(veh, currentHeight >= (currentLimits.max - 0.005))
                end

                if isHolding and not IsControlPressed(0, Config.Controls.Up) and not IsControlPressed(0, Config.Controls.Down) then
                    TriggerServerEvent('salkin_airride:server:syncHeight', VehToNet(veh), currentHeight)
                    isHolding = false
                end
            end
        else
            hasAirride = false
            lastVehicle = nil
            isStiff = false
            sleep = 1000
        end
        Citizen.Wait(sleep)
    end
end)

-- Empfange Synchronisation
RegisterNetEvent('salkin_airride:client:applyHeight')
AddEventHandler('salkin_airride:client:applyHeight', function(netId, height)
    if NetworkDoesNetworkIdExist(netId) then
        local veh = NetToVeh(netId)
        if DoesEntityExist(veh) then SetVehicleSuspensionHeight(veh, height) end
    end
end)