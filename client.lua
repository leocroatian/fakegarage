local player = GetPlayerIndex()
local playerid = GetPlayerServerId(player)
local playername = GetPlayerName(player)

local vehicle_found = false
local old_vehicle_hash = nil

local playerConnected = false

while not playerConnected do
    if NetworkIsPlayerConnected(player) then
        playerConnected = true
        -- print('player is connected: ' .. playername)
        break
    end
    Wait(1000) -- Prevent deadloop while waiting for connection
end

if playerConnected then
    while true do
        -- Update playerPedId in each loop
        local playerpedid = PlayerPedId() -- reget the player id to make sure it's updated.
        local vehicle = GetVehiclePedIsIn(playerpedid, false)

        if vehicle and vehicle ~= 0 then
            local driverPed = GetPedInVehicleSeat(vehicle, -1)
            if driverPed == playerpedid then
                local modelHash = GetEntityModel(vehicle)
                if modelHash ~= 0 and not old_vehicle_hash ~= modelHash then
                    local modelName = GetDisplayNameFromVehicleModel(modelHash)
                    -- print('Name: ' .. modelName .. ' Hash: ' .. modelHash .. ' ID: ' .. vehicle)
                    
                    for _, car in ipairs(gtrust.vehicles) do
                        if car.hash == modelHash then
                            old_vehicle_hash = modelHash
                            vehicle_found = true
                        end
                    end
                    if not vehicle_found then
                        Wait(500)
                        -- print('This vehicle is not in the system and has been deleted.')
                        TaskLeaveVehicle(playerpedid, vehicle, 1) -- Player leaves vehicle
                        Wait(2000)
                    elseif vehicle_found then
                        vehicle_found = false
                    end
                end 
            end
        end
        Wait(1000)
    end
end