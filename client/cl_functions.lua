Mercy = Config.CoreExport

-- [ Functions ] --

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function IsAuthorized(CitizenId, KeyHolders)
    local Retval = false
    if Mercy.Functions.GetPlayerData().citizenid == CitizenId then
        Retval = true
    end
    return Retval
end

function OpenKeyPad()
    SendNUIMessage({
        Action = "Open"
    })
    SetNuiFocus(true, true)    
end

function OpenStorage(StorageId)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "storage_"..StorageId, {
        maxweight = Config.MaxStashWeight,
        slots = Config.StashSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "storage_"..StorageId)
end

function IsRealEstate()
    local Retval = false
    if Mercy.Functions.GetPlayerData().job.name == Config.EstateJob then
      Retval = true
    end
    return Retval
end