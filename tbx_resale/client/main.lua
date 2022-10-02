local SPOTS = Config.Textd
local playerPed, coords, onFoot = PlayerPedId(), vector3(0, 0, 0), false
local duty = false
local order_info = {}
local activeOrder = false
local activeRestaurant = false
local activeDeliver = false
local timerMeterA, timerMeterB, timerMeter = 0, 0, 0
local blips = Config.blip
local playerPed = PlayerPedId()
local coordsPos = vector3(0, 0, 0)
local coords = vector3(0, 0, 0)


ESX = nil -- založení globální proměné ESX, které přiřadíme hodnotu nil

Citizen.CreateThread(function()
    while ESX == nil do -- pokud je ESX nil tak prováděj dokud nebude nil
        TriggerEvent('esx:getSharedObject', function(obj) -- vyvojel client-side event getSharedObject ze scriptu esx a přes funkci vrať proměnou obj
            ESX = obj -- do ESX vlož data z proměné obj
        end) -- konec vovolávání eventu
        Citizen.Wait(0) -- čekej 0 / každý frame
    end
end)


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        coords = GetEntityCoords(playerPed)
        onFoot = IsPedOnFoot(playerPed)
        Citizen.Wait(500)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local sleep = true
        for k,v in pairs(Config.Markers.Base) do
            local mk = v.marker
            local distance = #(coords-v.pos)
            if distance <= 1.5 then
                if IsControlJustReleased(0, 38) and onFoot then
                    ToggleDuty()
                end
            end
        end
    end
end)

--- garage
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local sleep = true
        for k,v in pairs(Config.Markers.Garage) do
            local mk = v.marker
            local distance = #(coords-v.pos)

            if distance <= 10.0 and duty then
                sleep = false

                if distance >= 1.5 then
                    DrawMarker(mk.type, v.pos.x, v.pos.y, v.pos.z, 0, 0, 0, 0, 0, 0, mk.size.x, mk.size.y, mk.size.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, mk.jump, mk.face, 0, mk.rotate)
                end

                if distance <= 1.5 then
                    if onFoot then
                        Draw3DText(v.pos.x, v.pos.y, v.pos.z, v.text, 0.65)
                    else
                        Draw3DText(v.pos.x, v.pos.y, v.pos.z, v.text2, 0.65)
                    end
                end

                if IsControlJustReleased(0, 38) and onFoot then
                    ESX.Game.SpawnVehicle(Config.VehName, vector3(v.pos.x, v.pos.y, v.pos.z), v.heading, function(vehicle)
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        notification('Prekupnik drog', 'zacatek', 'Paráda! pro vyhledání zakazky zmackni sval [K]')
                        local source = GetPlayerServerId(PlayerId())
                        local text = "Hrac vybral vozidlo"
                        TriggerServerEvent("tbx_resale:sendLogToServer", source, text)
                    end)
                elseif IsControlJustReleased(0, 38) and not onFoot then
                    local veh = GetVehiclePedIsIn(playerPed, false)
                    DeleteEntity(veh)
                    Notif("Vozidlo bylo schováno do garáže")
                    local source = GetPlayerServerId(PlayerId())
                    local text = "Hrac ulozil vozidlo"
                    TriggerServerEvent("tbx_resale:sendLogToServer", source, text)
                end
            end

            if sleep then
                Citizen.Wait(1000)
            end
        end
    end
end)


-- Get Task
RegisterKeyMapping("getOrder", "Vyžádat objednávku", "keyboard", "K")

RegisterCommand("getOrder", function(source, args, rawCommand)
    if duty then
        local restaurantData = Config.Restaurants[GetRandomRestaurant()]
        local houseData = Config.Houses[GetRandomHouse()]
        notification('Prekupnik drog', 'prevzati zakazky', 'V gps mas nastavene mýsto pro setkani!')
        table.insert(order_info, { restaurantData = restaurantData, houseData = houseData })
        print(json.encode(order_info))
        activeOrder = true
        activeRestaurant = true
        local rd = restaurantData
        CreateBlip(rd.pos, rd.blip.id, rd.blip.color, rd.text)
        GPS(rd.pos.x, rd.pos.y)
        timerMeterA = GetGameTimer()
    else
        Notif("Nejsi ve službě")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k,v in pairs(order_info) do
            local rd = v.restaurantData
            local hd = v.houseData
            local sleep = false
            local distance = #(coords-rd.pos)

            if distance <= 10 and activeRestaurant then
                sleep = false
                if distance >= 1.5 then
                    local mk = rd.marker
                    DrawMarker(mk.type, rd.pos.x, rd.pos.y, rd.pos.z, 0, 0, 0, 0, 0, 0, mk.size.x, mk.size.y, mk.size.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, mk.jump, mk.face, 0, mk.rotate)
                end

                if distance <= 1.5 then
                    Draw3DText(rd.pos.x, rd.pos.y, rd.pos.z, rd.text2, 0.65)
                    if IsControlJustReleased(0, 38) and onFoot then
                        activeRestaurant = false
                        ProgBar("Bereš objednávku", 3000)
                        Citizen.Wait(3000)
                        RemoveBlip(blip)
                        notification('Prekupnik drog', 'zakazka', 'Do gps jsem ti dal trasu kam mas jet, zajed tam a prodej tu mouku co mas u sebe!')
                        local source = GetPlayerServerId(PlayerId())
                        local text = "Hrac vzal balicek"
                        local data = {displayCode = '10-68', description = 'Ozbrojená loupež', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Klenotnictví'}
                        local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(-633.9, -241.7, 38.1)}
                        TriggerEvent('wf-alerts:svNotify', dispatchData)
                        TriggerServerEvent("tbx_resale:sendLogToServer", source, text)
                        CreateBlip(hd.pos, hd.blip.id, hd.blip.color, hd.text)
                        GPS(hd.pos.x, hd.pos.y)
                        activeDeliver = true
                    end
                end
            end

            if sleep then
                Citizen.Wait(1000)
            end
        end
    end
end)

-- House / Zákazník
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k,v in pairs(order_info) do
            local hd = v.houseData
            local sleep = true
            local distance = #(coords-hd.pos)

            if distance <= 10 and activeDeliver then
                if distance >= 1.5 then
                    local mk = hd.marker
                    DrawMarker(mk.type, hd.pos.x, hd.pos.y, hd.pos.z, 0, 0, 0, 0, 0, 0, mk.size.x, mk.size.y, mk.size.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, mk.jump, mk.face, 0, mk.rotate)
                end

                if distance <= 1.5 then
                    Draw3DText(hd.pos.x, hd.pos.y, hd.pos.z, hd.text2, 0.65)
                    if IsControlJustReleased(0, 38) then
                        ProgBar("Předávání balíčků", 3000)
                        local source = GetPlayerServerId(PlayerId())
                        local text = "Hrac dorucil tajný balicek a dostal peníze"
                        TriggerServerEvent("tbx_resale:sendLogToServer", source, text)
                        Citizen.Wait(3000)
                        activeDeliver = false
                        activeOrder = false
                        RemoveBlip(blip)
                        TriggerServerEvent("tbx_resale:addMoney", GetPlayerServerId(PlayerId()), 500)
                        notification('Prekupnik drog', 'prodaní drogy', ' zmackni [K] pro dalsi zakazku', mugshotStr, 1)
                    end
                end
            end
        end
    end
end)




































    -- Functions
    function ToggleDuty()
        if duty then
            ProgBar("rikate panovy co vse jste udelal", 3000)
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_COP_IDLES", 0, true)
            Citizen.Wait(3000)
            ClearPedTasks(playerPed)
            duty = false
            notification('Prekupnik drog', 'konec', 'děkuji ti za pomoc!')
            local source = GetPlayerServerId(PlayerId())
            local text = "Hrac Prestal pracovat"
            TriggerServerEvent("tbx_resale:sendLogToServer", source, text)
        else
            ProgBar("domlouvate se s panem na praci", 3000)
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_COP_IDLES", 0, true)
            Citizen.Wait(3000)
            ClearPedTasks(playerPed)
            duty = true
            notification('Prekupnik drog', 'zacatek', 'uprostred mistnosti si vezmi vozidlo!')
            local source = GetPlayerServerId(PlayerId())
            local text = "Hrac zacal pracovat"
            TriggerServerEvent("tbx_resale:sendLogToServer", source, text)
        end
    end

function notification(title, subject, msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end



function ProgBar(msg, time)
    exports['progressBars']:startUI(time, msg)
end

function Notif(text)
    ESX.ShowNotification(text)
end



    -- 3dtext
    local function DrawText3D(x, y, z, text)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        local factor = (string.len(text)) / 370
        DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 41, 11, 41, 60)
        ClearDrawOrigin()
    end


    CreateThread(function ()
        while true do

            for key, value in pairs(SPOTS) do
                local coords = value.coords
                local label = value.label
                if #(coords - GetEntityCoords(PlayerPedId())) <= 5 then
                    DrawText3D(coords.x,coords.y,coords.z,label)
                end

            end
            Wait(1)
        end
    end)


function Draw3DText(x,y,z,text,scale)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
    local pX,pY,pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(scale, scale)
    SetTextFont(Config.FontId or 4)
    SetTextProportional(1)
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    if Config.UseCustomFont then
        AddTextComponentString("<font face='"..Config.FontName.."'>"..text.."</font>")
    else
        AddTextComponentString(text)
    end
    DrawText(_x,_y)
    SetTextOutline()
end

function GetRandomRestaurant()
    local restaurant = math.random(1, #Config.Restaurants)
    return restaurant
end

function GetRandomHouse()
    local house = math.random(1, #Config.Houses)
    return house
end


function CreateBlip(pos, id, color, text)
    blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(blip, id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

function GPS(x, y)
    SetNewWaypoint(x, y)
end



local blips = Config.blip

Citizen.CreateThread(function()

    for k, v in pairs(blips) do
        v.blip = AddBlipForCoord(v.coordsPos.x, v.coordsPos.y, v.coordsPos.z) -- vytvo�en� samotn�ho blipu
        SetBlipSprite(v.blip, v.id) -- zvolen� typu blipu (tvar)
        SetBlipDisplay(v.blip, 4) -- typ zobrazen� blipu
        SetBlipScale(v.blip, 1.0) -- velikost blipu
        SetBlipColour(v.blip, v.color) -- barva blipu
        SetBlipAsShortRange(v.blip, true) -- m� b�t blip pouze na bl�zko?
        BeginTextCommandSetBlipName("STRING") -- chci, aby blip m�l text
        AddTextComponentString(v.title) -- n�zev blipu
        EndTextCommandSetBlipName(v.blip) -- ukon�en� n�zvu blipu
    end
end)
