db = exports[GetCurrentResourceName()]

RegisterNetEvent("PollMoney")
RegisterNetEvent("baseevents:onPlayerKilled")
RegisterNetEvent("baseevents:onPlayerDied")

AddEventHandler("playerDropped", function() 
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Leave:"..v.id,source)
		TriggerEvent("Freeroam:Leave",source)
	end
end)
CreateThread(function()
	Wait(1000)
	db:OpenDB("users",function()
		print("^5[INFO]^7 Nexus-Events: DB connection estabilished!")
		TriggerEvent("Freeroam:Start")
	end)
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
	local source = source
	local identifier = Misc.GetPlayerSteamId(source)
	deferrals.defer()
	deferrals.update("Performing some checks...")
	if identifier then
		db:GetUser(identifier, function(result)
			if not result then
				db:InsertUser({id=identifier, money=500, weapons = {}, vehicles = {{spawnName = "regina", Name = "Regina", speed = 5, handling = 15, damage = 10, armour = 100}, {spawnName = "baller2", Name = "RangeRover Evoque", speed = 15, handling = 15, damage = 15, armour = 100}}, planes = {{spawnName = "lazer", Name = "P-996 LAZER", speed = 70, handling = 45, damage = 70, armour = 60},{spawnName = "hydra", Name = "Hydra", speed = 60, handling = 40, damage = 75, armour = 70},{spawnName = "molotok", Name = "V-65 Molotok", speed = 75, handling = 60, damage = 60, armour = 40},{spawnName = "rogue", Name = "Rogue", speed = 75, handling = 60, damage = 60, armour = 40},{spawnName = "nokota", Name = "P-45 Nokota", speed = 75, handling = 60, damage = 60, armour = 40},{spawnName = "starling", Name = "LF-22 Starling", speed = 75, handling = 60, damage = 60, armour = 40}}, banned = false, notes = "", xp = 0}, function()
					print("^5[INFO]^7 Added new user to database: "..name)
					deferrals.done()
				end)
			elseif result.banned == true then
				deferrals.done("You have been banned from this server.")
			else
				deferrals.done()
			end
		end)
	else
		deferrals.done("Steam needs to be running to join this server.")
	end
end)

AddEventHandler("baseevents:onPlayerDied", function()
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Suicide:"..v.id, source)
	end
end)

AddEventHandler("baseevents:onPlayerKilled", function(killerid)
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Kill:"..v.id, killerid, source)
	end
end)

AddEventHandler("PollMoney", function()
	local source = source
	local identifier = Misc.GetPlayerSteamId(source)
	if identifier then
		db:GetUser(identifier, function(result)
			print(result)
			if not result then
				print("^1[ERROR]^7 user not found.")
			else
				TriggerClientEvent("Nexus:UpdateMoney", source, result.money, result.xp)
			end
		end)
	else
		print("^1[ERROR]^7 the user doesn't have an identifier.")
	end
end)

Citizen.CreateThread(function()
	local done = false
	while true do
		Wait(0)
		if GetNumPlayerIndices() == 0 and not done then
			for i,v in ipairs(Gamemodes) do
				--TODO: end game
			end
		end
	end
end)