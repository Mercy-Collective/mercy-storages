local CurrentStorageId = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function() 
        Mercy.Functions.TriggerCallback('mc-storage/server/get-config', function(ConfigData)
           Config = ConfigData
        end)
        Citizen.Wait(250)
        TriggerServerEvent('mc-storage/server/setup-containers')
    end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.isLoggedIn then
            local NearStorage = false
            for k, v in pairs(Config.StorageContainers) do
                local Dist = #(GetEntityCoords(PlayerPedId()) - vector3(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z']))
                if Dist <= 3.5 and IsAuthorized(v['Owner'], v['KeyHolders']) then
                    NearStorage = true
                    DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] + 0.15, '~g~E~s~ - Storage ('..v['SName']..')')
                    if IsControlJustReleased(0, 38) then
                        CurrentStorageId = v['SName']
                        OpenKeyPad()
                    end
                end
            end
            if not NearStorage then
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ NUI Callbacks ] --

RegisterNUICallback("CheckPincode", function(data, cb)
    Mercy.Functions.TriggerCallback('mc-storage/server/check-pincode', function(AcceptedPincode)
        if AcceptedPincode then
            OpenStorage(CurrentStorageId)
        else
            Mercy.Functions.Notify('You have entered a wrong pincode..', 'error')
        end
    end, tonumber(data.pincode), CurrentStorageId)
end)

RegisterNUICallback("Close", function(data, cb)
    SetNuiFocus(false, false)
end)

-- [ Events ] --

RegisterNetEvent('mc-storage/client/create-storage', function(PinCode, TPlayer)
    if IsRealEstate() then
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local PlayerHeading = GetEntityHeading(PlayerPedId())
        local CoordsTable = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['H'] = PlayerHeading}
        TriggerServerEvent('mc-storage/server/add-new-storage', CoordsTable, PinCode, TPlayer)
    else
        Mercy.Functions.Notify('And what are you doing exactly?', 'error')
    end
end)

RegisterNetEvent("mc-storage/client/update-config", function(ContainerData)
    Config.StorageContainers = ContainerData
end)