local Mercy = Config.CoreExport

local NumberCharset, Charset = {}, {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- [ Code ] --

-- [ Callbacks ] --

Mercy.Functions.CreateCallback('mc-storage/server/get-config', function(source, cb)
	cb(Config)   
end)

Mercy.Functions.CreateCallback('mc-storage/server/check-pincode', function(source, cb, Code, ContainerId)
	MySQL.query("SELECT * FROM storages WHERE name = ?", {ContainerId}, function(StorageData)
		if StorageData[1] ~= nil then
			if StorageData[1].pincode == Code then
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)

-- [ Events ] --

RegisterNetEvent("mc-storage/server/setup-containers", function()
	MySQL.query("SELECT * FROM storages", {}, function(StorageData)
		if StorageData[1] ~= nil then
			for k, v in pairs(StorageData) do
				Config.StorageContainers[v['name']] = {
					['Owner'] = v['owner'],
					['SName'] = v['name'],
					['Coords'] = json.decode(v['coords']),
					['KeyHolders'] = json.decode(v['keyholders'])
				}
				Citizen.Wait(25)
				TriggerClientEvent('mc-storage/client/update-config', -1, Config.StorageContainers)
			end
		else
 			print('No data found..')
		end
	end)
end)

RegisterNetEvent('mc-storage/server/add-new-storage', function(CoordsTable, Pincode, TPlayer)
	local src = source
	local Player = Mercy.Functions.GetPlayer(src)
	if IsRealEstate(Player) then
		MySQL.Async.execute("INSERT INTO storages (owner, name, pincode, coords) VALUES (?, ?, ?, ?)", {TPlayer.PlayerData.citizenid, GenerateStorageId(), Pincode, json.encode(CoordsTable)})
		Citizen.Wait(250)
		TriggerEvent('mc-storage/server/setup-containers')
	else
		Player.Functions.Notify('You are not allowed to do this..', 'error')
	end
end)

-- [ Commands ] --

Mercy.Commands.Add("createstorage", "Create a storage container", {{name="PlayerID", help="PlayerId of the stash owner"}, {name="pincode", help="Pincode of the storage"}}, false, function(source, args)
	local Player = Mercy.Functions.GetPlayer(source)
	local TPlayer = Mercy.Functions.GetPlayer(tonumber(args[1]))
	local Pincode = tonumber(args[2])
	if IsRealEstate(Player) then
		TriggerClientEvent("mc-storage/client/create-storage", source, Pincode, TPlayer)
	else
		Player.Functions.Notify('You are not allowed to do this..', 'error')
	end
end)

-- [ Functions ] --

function GenerateStorageId()
	local StorageId = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
	MySQL.query("SELECT * FROM storages WHERE name = ? ", {StorageId}, function(StorageInfo)
		while (StorageInfo[1] ~= nil) do
			StorageId = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
		end
		return StorageId
	end)
	return StorageId:upper()
end

function IsRealEstate(Player)
	local Retval = false
	if Player.PlayerData.job.name == Config.EstateJob then
		Retval = true
	end
	return Retval
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end