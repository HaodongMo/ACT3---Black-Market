local metaply = FindMetaTable( "Player" )

function metaply:ACT3BM_GetMoney()
    if engine.ActiveGamemode() == "darkrp" then
        return LocalPlayer():getDarkRPVar("money")
    end

    return LocalPlayer().ACT3BM_Money or 0
end

net.Receive("ACT3_BM_SendMoneyAmount", function(ply, len)
    local amt = net.ReadUInt(32)

    LocalPlayer().ACT3BM_Money = amt
end)