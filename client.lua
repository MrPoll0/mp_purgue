ESX = nil
ESXLoaded = false

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(25)
	end

	ESXLoaded = true 
end)

local weapons = {
	[1] = {
		["WEAPON_SWITCHBLADE"] = "Navaja",
		["WEAPON_DAGGER"] = "Daga",
		["WEAPON_BAT"] = "Bate",
		["WEAPON_MACHETE"] = "Machete",
		["WEAPON_KNUCKLE"] = "Puños americanos",
	},
	[2] = {
		["WEAPON_PISTOL"] = "Pistola",
		["WEAPON_PISTOL50"] = "Pistola .50",
		["WEAPON_FLAREGUN"] = "Pistola de bengalas",
		["WEAPON_REVOLVER"] = "Revolver",
		["WEAPON_DOUBLEACTION"] = "Revolver de doble acción",
	},
	[3] = {
		["WEAPON_MICROSMG"] = "Microsubfusil",
		["WEAPON_SMG"] = "Subfusil",
		["WEAPON_MINISMG"] = "Minisubfusil",
		["WEAPON_ASSAULTSMG"] = "P90",
		["WEAPON_GUSENBERG"] = "Gusenberg",
	},
	[4] = {
		["WEAPON_ASSAULTRIFLE"] = "AK-47",
		["WEAPON_COMPACTRIFLE"] = "Fusil compacto",
	},
}
local cooldown = {}
for k,v in pairs(weapons) do 
	for a,b in pairs(v) do 
		cooldown[a] = 0
	end
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0)
		if IsControlJustPressed(0, 82) then 
			OpenMenu()
		end
	end
end)

function OpenMenu()
	local menuElements = {}
	for k,v in pairs(weapons) do 
		if k == 1 then 
			table.insert(menuElements,{label = '<b><span style="color: white;"> <---- [ Armas blancas ] ----> </span></b>'})
			for a,b in pairs(v) do 
				table.insert(menuElements, {
			        ["label"] = "<span style='color: white;'>"..b.."</span>",
			        ["action"] = a,
			    })
			end
		end
	end
	for k,v in pairs(weapons) do 
		if k == 2 then 
			table.insert(menuElements,{label = '<b><span style="color: yellow;"> <---- [ Pistolas ] ----> </span></b>'})
			for a,b in pairs(v) do 
				table.insert(menuElements, {
			        ["label"] = "<span style='color: yellow;'>"..b.."</span>",
			        ["action"] = a,
			    })
			end
		end
	end
	for k,v in pairs(weapons) do 
		if k == 3 then 
			table.insert(menuElements,{label = '<b><span style="color: orange;"> <---- [ Armas semiautomáticas (subfusiles) ] ----> </span></b>'})
			for a,b in pairs(v) do 
				table.insert(menuElements, {
			        ["label"] = "<span style='color: orange;'>"..b.."</span>",
			        ["action"] = a,
			    })
			end
		end
	end
	for k,v in pairs(weapons) do 
		if k == 4 then 
			table.insert(menuElements,{label = '<b><span style="color: red;"> <---- [ Fusiles de asalto ] ----> </span></b>'})
			for a,b in pairs(v) do 
				table.insert(menuElements, {
			        ["label"] = "<span style='color: red;'>"..b.."</span>",
			        ["action"] = a,
			    })
			end
		end
	end
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_menu", {
        ["title"] = "Armas",
        ["align"] = "right",
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
    local action = menuData["current"]["action"] 
    local label = menuData["current"]["label"] 

    if cooldown[action] == 0 then 
    	GiveWeaponToPed(PlayerPedId(), GetHashKey(action), 999, false, true)
    	cooldown[action] = 180
    	while cooldown[action] > 0 do 
    		Citizen.Wait(1000)
    		cooldown[action] = cooldown[action] - 1
    	end
    	cooldown[action] = 0
    else
    	ESX.ShowNotification("["..label.."] Cooldown: "..cooldown[action].." segundos")
    end

    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end
