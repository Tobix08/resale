

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent("tbx_resale:addMoney")
AddEventHandler("tbx_resale:addMoney", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(amount)
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("tbx_resale:sendLogToServer")
AddEventHandler("tbx_resale:sendLogToServer", function(source, text)
    DiscordLog(source, text)
end)

function DiscordLog(source, text)
    local xPlayer = ESX.GetPlayerFromId(source)
    local connect = {
        {
            ["color"] = "16718105",
            ["title"] = GetPlayerName(source).." (".. xPlayer.identifier ..")",
            ["description"] = text,
            ["footer"] = {
                ["text"] = os.date('%H:%M - %d. %m. %Y', os.time()),
                ["icon_url"] = "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/apple/271/honeybee_1f41d.png",},
        }
    }

    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Resale log", embeds = connect}), { ['Content-Type'] = 'application/json' })
end

function DatabaseLog(source, text)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('INSERT INTO dev_logs (identifier, text) VALUES (@identifier, @text)',
            { ['@identifier'] = xPlayer.identifier, ['@text'] = text},
            function(affectedRows)
                print(affectedRows)
            end)
end

