local metaply = FindMetaTable( "Player" )

function metaply:ACT3BM_SendMoneyAmount()
    if engine.ActiveGamemode() == "darkrp" then
        return
    end

    net.Start("ACT3_BM_SendMoneyAmount")
    net.WriteUInt(self.ACT3BM_Money, 32)
    net.Send(self)
end

function metaply:ACT3BM_GetMoney()
    if engine.ActiveGamemode() == "darkrp" then
        return self:getDarkRPVar("money")
    else
        return self.ACT3BM_Money or 0
    end
end

function metaply:ACT3BM_GiveMoney(amt)
    if engine.ActiveGamemode() == "darkrp" then
        self:addMoney(amt)
    else
        self.ACT3BM_Money = math.Clamp(self:ACT3BM_GetMoney() + amt, 0, math.pow(2, 32))
        self:ACT3BM_SendMoneyAmount()
        ACT3_BlackMarket.SavePlayerStatsToFile(self)
    end
end

function metaply:ACT3BM_TakeMoney(amt)
    if self:ACT3BM_GetMoney() < amt then
        return false
    else
        if engine.ActiveGamemode() == "darkrp" then
            self:addMoney(-amt)
        else
            self.ACT3BM_Money = math.Clamp(self:ACT3BM_GetMoney() - amt, 0, math.pow(2, 32))
            self:ACT3BM_SendMoneyAmount()
        end
        return true
    end
end