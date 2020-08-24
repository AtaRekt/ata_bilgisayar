ESX 						   = nil
local TimeToFarmAnakart = 4  * 1000
local PlayersHarvestingAnakart   = {}
local TimeToFarmIslemci = 3  * 1000
local PlayersHarvestingIslemci   = {}
local TimeToMontaj = 7  * 1000
local PlayersMontaj   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--#############################
--##	 Anakart Bölümü      ##
--#############################

local function HarvestAnakart(source)	
	SetTimeout(TimeToFarmAnakart, function()

		if PlayersHarvestingAnakart[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

            
            if xPlayer.getWeight() + 8 <= 100 then
                xPlayer.addInventoryItem('anakart', 1)
                xPlayer.removeMoney(1000)
                HarvestAnakart(source)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Ağırlık Sınırı Aşıldı!', style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            end

		end
	end)
end

RegisterServerEvent('ata:startHarvestAnakart')
AddEventHandler('ata:startHarvestAnakart', function()
	local _source = source

	PlayersHarvestingAnakart[_source] = true
	HarvestAnakart(_source)
end)

RegisterServerEvent('ata:stopHarvestAnakart')
AddEventHandler('ata:stopHarvestAnakart', function()
	local _source = source

	PlayersHarvestingAnakart[_source] = false
end)

--#############################
--##	 Anakart Bölümü      ##
--#############################

--#############################
--##	 İşlemci Bölümü      ##
--#############################

local function HarvestIslemci(source)	
	SetTimeout(TimeToFarmIslemci, function()

		if PlayersHarvestingIslemci[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

            
            if xPlayer.getWeight() + 8 <= 15 then
                xPlayer.addInventoryItem('islemci', 1)
                xPlayer.removeMoney(2000)
                HarvestIslemci(source)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Ağırlık Sınırı Aşıldı!', style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            end

		end
	end)
end

RegisterServerEvent('ata:startHarvestIslemci')
AddEventHandler('ata:startHarvestIslemci', function()

	local _source = source

	PlayersHarvestingIslemci[_source] = true

	HarvestIslemci(_source)

end)

RegisterServerEvent('ata:stopHarvestIslemci')
AddEventHandler('ata:stopHarvestIslemci', function()

	local _source = source

	PlayersHarvestingIslemci[_source] = false

end)

--#############################
--##	 İşlemci Bölümü      ##
--#############################

--#############################
--##	 Montaj Bölümü      ##
--#############################

local function Montaj(source)	
	SetTimeout(TimeToMontaj, function()

		if PlayersMontaj[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			local islemci = xPlayer.getInventoryItem('islemci').count
			local anakart = xPlayer.getInventoryItem('anakart').count
			if islemci  >= 2 and anakart  >= 2 then
				xPlayer.removeInventoryItem('islemci', 2)
				xPlayer.removeInventoryItem('anakart', 2)
				xPlayer.addInventoryItem('hacker_tablet', 1) -- Buraya hacker laptop iteminizi yazın
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Bilgisayar Topandı!', style = { ['background-color'] = '#07db07', ['color'] = '#fffff' } })
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Yeterince Anakartı ve İşlemcin yok!', style = { ['background-color'] = '#ff1919', ['color'] = '#fffff' } })
			end
			Montaj(source)

		end
	end)
end

RegisterServerEvent('ata:startMontaj')
AddEventHandler('ata:startMontaj', function()

	local _source = source

	PlayersMontaj[_source] = true

	Montaj(_source)

end)


RegisterServerEvent('ata:stopMontaj')
AddEventHandler('ata:stopMontaj', function()

	local _source = source

	PlayersMontaj[_source] = false

end)

--#############################
--##	 Montaj Bölümü      ##
--#############################
