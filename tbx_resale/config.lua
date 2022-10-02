Config = {}

Config.ResourceName = GetCurrentResourceName()
Config.FontId = 4
Config.UseCustomFont = 4
Config.FontName = "Fire Sans"
Config.Locale = "cs"
Config.Webhook = "YOUR_WEBHOOK"

Config.VehName = "zentorno"

Config.blip = {
    {title="Prekupnik drog", -- name of blip
     color=67, -- color of blip
     id=478, -- id of blip
     coordsPos = vector3(-1155.8, -2000.96, 13.2)}, -- position
}

Config.Peds = {
    { type=4, model="cs_stevehains", coordsPos = vector4(-1148.28, -1999.8, 13.2, 129.88) },
    { type=3, model="g_m_y_famdnf_01", coordsPos = vector4(-1790.0, -367.76, 44.84, 337.2) },
    { type=6, model="mp_m_bogdangoon", coordsPos = vector4(-778.64, -1324.36, 5.0, 171.16) },
    { type=5, model="g_m_y_lost_02", coordsPos = vector4(-1995.88, -511.4, 11.96, 140.0) }
}

Config.Textd = {
    {
        ['name'] = 'dreugy',
        ['coords'] = vector3(-1148.28, -1999.8, 13.2),
        ['label'] = 'Pro zacatek prevážení drog zmackni [E]',
    }
}

Config.Markers = {
    Base = {
        [1] = {
            pos = vector3(-1148.28, -1999.8, 13.2),
            text = "Jít do služby",
            text2 = "Jít ze služby"
        }
    },

    Garage = {
        [1] = {
            pos = vector3(-1158.24, -2009.2, 13.2),
            heading = 195.4935,
            marker = { type = 36, size = { x = 1.0, y = 1.0, z = 1.0 }, color = { r = 255, g = 0, b = 0, a = 100 }, jump = true, face = false, rotate = true },
            text = "Vzít vozidlo",
            text2 = "Uložit vozidlo"
        }
    },
}

Config.Restaurants = {
    [1] = {
        pos = vector3(-1790.0, -367.76, 44.84),
        marker = { type = 36, size = { x = 1.0, y = 1.0, z = 1.0 }, color = { r = 255, g = 0, b = 0, a = 100 }, jump = true, face = false, rotate = true },
        blip = { color = 2, id = 51 },
        text = "Prodejce drog1",
        text2 = "Zmacki [E] pro prijati drog"
    },
    [2] = {
        pos = vector3(-778.64, -1324.36, 5.0),
        marker = { type = 36, size = { x = 1.0, y = 1.0, z = 1.0 }, color = { r = 255, g = 0, b = 0, a = 100 }, jump = true, face = false, rotate = true },
        blip = { color = 2, id = 51 },
        text = "Prodejce drog2",
        text2 = "Zmacki [E] pro prijati drog"
    },
    [3] = {
        pos = vector3(-1995.88, -511.4, 11.96),
        marker = { type = 36, size = { x = 1.0, y = 1.0, z = 1.0 }, color = { r = 255, g = 0, b = 0, a = 100 }, jump = true, face = false, rotate = true },
        blip = { color = 2, id = 51 },
        text = "Prodejce drog3",
        text2 = "Zmacki [E] pro prijati drog"
    }
}

Config.Houses = {
    [1] = {
        pos = vector3(-762.08, 431.4, 100.2),
        marker = { type = 36, size = { x = 1.0, y = 1.0, z = 1.0 }, color = { r = 255, g = 0, b = 0, a = 100 }, jump = true, face = false, rotate = true },
        blip = { color = 0, id = 414 },
        text = "Street 1",
        text2 = "Zmacki [E] pro doruceni drog"
    },
    [2] = {
        pos = vector3(-489.76, 411.64, 99.16),
        marker = { type = 36, size = { x = 1.0, y = 1.0, z = 1.0 }, color = { r = 255, g = 0, b = 0, a = 100 }, jump = true, face = false, rotate = true },
        blip = { color = 0, id = 414 },
        text = "Street 2",
        text2 = "Zmacki [E] pro doruceni drog"
    },
    [3] = {
        pos = vector3(-1503.36, -4.4, 56.28),
        marker = { type = 36, size = { x = 1.0, y = 1.0, z = 1.0 }, color = { r = 255, g = 0, b = 0, a = 100 }, jump = true, face = false, rotate = true },
        blip = { color = 0, id = 414 },
        text = "Street 3",
        text2 = "Zmacki [E] pro doruceni drog"
    }
}