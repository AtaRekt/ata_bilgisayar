local anakart = {x=287.09, y=2843.46, z=44.70}
local islemci = {x=803.3, y=2175.37, z=53.07}
local montaj = {x=1260.13, y=2738.46, z=38.98}

ESX                           = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(anakart.x, anakart.y,anakart.z)
    SetBlipSprite(blip, 521)
    SetBlipDisplay(blip, 6)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Anakart Toplama")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(islemci.x, islemci.y,islemci.z)
    SetBlipSprite(blip, 521)
    SetBlipDisplay(blip, 6)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("İşlemci Toplama")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(montaj.x, montaj.y,montaj.z)
    SetBlipSprite(blip, 402)
    SetBlipDisplay(blip, 6)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 1.1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bilgisayar Montaj")
    EndTextCommandSetBlipName(blip)
end)



RegisterCommand("tp", function(source, args)
    SetEntityCoords(PlayerPedId(), tp.x, tp.y, tp.z, true, true, true, false)
    SetEntityHeading(PlayerPedId(), tp.h)
end)

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.40, 0.40)
        SetTextFont(6)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        --local factor = (string.len(text)) / 250
        --DrawRect(_x,_y+0.0190, factor, 0.050, 41, 11, 41, 68)
    end    
end


local HasAlreadyEnteredMarker = false

Citizen.CreateThread(function()          
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        
        local dist = GetDistanceBetweenCoords(pos, anakart.x, anakart.y, anakart.z, true)
        local dist2 = GetDistanceBetweenCoords(pos, islemci.x, islemci.y, islemci.z, true)
        local dist3 = GetDistanceBetweenCoords(pos, montaj.x, montaj.y, montaj.z, true) 
        if dist < 10 then
            Draw3DText(anakart.x, anakart.y, anakart.z + 0.20, 1.0, "Anakart toplamak için [~g~E~s~] tusuna basın. ~o~[~g~Fiyat:1000$~o~]")
            DrawMarker(1, anakart.x, anakart.y, anakart.z - 1 , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 100, 200, 100, false, true, 2, false, false, false, false)
            if dist < 0.5 then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('ata:HarvestAnakartAnimation')
                    HasAlreadyEnteredMarker = true
                    TriggerServerEvent('ata:startHarvestAnakart')
                end
            else
                TriggerServerEvent('ata:stopHarvestAnakart')
                HasAlreadyEnteredMarker = false    
            end
        else
            HasAlreadyEnteredMarker = false    
        end
        if dist2 < 10 then
            Draw3DText(islemci.x, islemci.y, islemci.z + 0.20, 1.0, "Islemci toplamak için [~g~E~s~] tusuna basın. ~o~[~g~Fiyat:2000$~o~]")
            DrawMarker(1, islemci.x, islemci.y, islemci.z - 1 , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 100, 200, 100, false, true, 2, false, false, false, false)
            if dist2 < 0.5 then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('ata:HarvestAnakartAnimation')
                    HasAlreadyEnteredMarker = true
                    TriggerServerEvent('ata:startHarvestIslemci')
                end
            else
                TriggerServerEvent('ata:stopHarvestIslemci')
                HasAlreadyEnteredMarker = false    
            end
        else
            HasAlreadyEnteredMarker = false    
        end
        if dist3 < 10 then
            Draw3DText(montaj.x, montaj.y, montaj.z + 0.20, 1.0, "Montaja baslamak [~g~E~s~] tusuna basın.")
            DrawMarker(1, montaj.x, montaj.y, montaj.z - 1 , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 100, 200, 100, false, true, 2, false, false, false, false)
            if dist3 < 0.5 then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('ata:HarvestAnakartAnimation')
                    HasAlreadyEnteredMarker = true
                    TriggerServerEvent('ata:startMontaj')
                end
            else
                TriggerServerEvent('ata:stopMontaj')
                HasAlreadyEnteredMarker = false    
            end
        else
            HasAlreadyEnteredMarker = false    
        end                       
    end                     
end)

RegisterNetEvent('ata:HarvestAnakartAnimation')
AddEventHandler('ata:HarvestAnakartAnimation', function()
    local ped = GetPlayerPed(-1)
    if not IsEntityPlayingAnim(ped, "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_stand_checkingleaves_kneeling_01_inspector", 3) then
        RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
        while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do
            Citizen.Wait(100)
        end
        Wait(100)
        TaskPlayAnim(ped, "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_stand_checkingleaves_kneeling_01_inspector", 8.0, -8, -1, 49, 0, 0, 0, 0)
        Wait(2000)
        while IsEntityPlayingAnim(ped, "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_stand_checkingleaves_kneeling_01_inspector", 3) do
            Wait(1)
            if (IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)) then
                ClearPedTasksImmediately(ped)
                break
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if HasAlreadyEnteredMarker then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
		else
			Citizen.Wait(500)
		end
	end
end)