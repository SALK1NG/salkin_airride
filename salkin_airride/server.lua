local ESX = exports["es_extended"]:getSharedObject()

-- Prüfen, ob Airride installiert ist
ESX.RegisterServerCallback('salkin_airride:server:hasAirrideInstalled', function(source, cb, plate)
    exports.oxmysql:scalar('SELECT airride FROM owned_vehicles WHERE plate = ?', {plate}, function(installed)
        cb(installed == 1 or installed == true)
    end)
end)

-- Prüfen, ob der Spieler der Besitzer ist
ESX.RegisterServerCallback('salkin_airride:server:isOwner', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(false) end

    exports.oxmysql:scalar('SELECT 1 FROM owned_vehicles WHERE plate = ? AND owner = ?', {plate, xPlayer.identifier}, function(isOwner)
        cb(isOwner ~= nil)
    end)
end)

-- Erfolgreiche Installation
RegisterNetEvent('salkin_airride:server:installSuccess')
AddEventHandler('salkin_airride:server:installSuccess', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end

    if exports.ox_inventory:RemoveItem(src, Config.ItemName, 1) then
        exports.oxmysql:update('UPDATE owned_vehicles SET airride = 1 WHERE plate = ? AND owner = ?', {plate, xPlayer.identifier})
        
        -- Geändert: Nutzt jetzt den ESX Standard-Notify
        xPlayer.showNotification('Airride erfolgreich installiert!', 'success')
    end
end)

-- Synchronisation der Fahrzeughöhe für alle Spieler
RegisterNetEvent('salkin_airride:server:syncHeight')
AddEventHandler('salkin_airride:server:syncHeight', function(netId, height)
    TriggerClientEvent('salkin_airride:client:applyHeight', -1, netId, height)
end)