ACT3_BlackMarket.PlayerDataDir = "ACT3_BlackMarket/PlayerData/"
ACT3_BlackMarket.StartMoney = 500

function ACT3_BlackMarket.LoadPlayerStatsFromFile(ply)
    if engine.ActiveGamemode() == "darkrp" then
        return
    end

    local id = ply:SteamID64() or "SP"

    local f = file.Read(ACT3_BlackMarket.PlayerDataDir .. id .. ".dat", "DATA")

    if !f then
        ply.ACT3BM_Money = ACT3_BlackMarket.StartMoney

        ACT3_BlackMarket.SavePlayerStatsToFile(ply)
    else
        ply.ACT3BM_Money = tonumber(f)
    end

    ply:ACT3BM_SendMoneyAmount()
end

function ACT3_BlackMarket.SavePlayerStatsToFile(ply)
    if engine.ActiveGamemode() == "darkrp" then
        return
    end

    local id = ply:SteamID64() or "SP"

    file.Write(ACT3_BlackMarket.PlayerDataDir .. id .. ".dat", tostring(ply.ACT3BM_Money))
end

hook.Add("PlayerInitialSpawn", "ACT3_BM_PlayerSpawn", function(ply, transition)
   timer.Simple(5, function()
      ACT3_BlackMarket.LoadPlayerStatsFromFile(ply)
   end)
end)