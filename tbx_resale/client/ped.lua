local peds = Config.Peds

Citizen.CreateThread(function()
    for k,v in pairs(peds) do
        local hash = GetHashKey(v.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(1)
        end

        ped = CreatePed(v.type, hash, v.coordsPos.x, v.coordsPos.y, v.coordsPos.z-0.90, v.coordsPos.w, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
    end
end)
