ACT3_BlackMarket.GetMoneyFunc = function(ply)
   return ply:ACT3BM_GetMoney()
end

ACT3_BlackMarket.SendMoneyToPlayer = function(ply)
   local sendamount = 0
   local entries = {
      {title = "Send Money To: " .. ply:Nick(), entertext = ""},
      {title = "Amount: $" .. tostring(sentamount)},
   }

   return entries
end

ACT3_BlackMarket.SendMoneyMenu = function()
   local entries = {}

   for _, ply in pairs(player.GetAll()) do
      table.insert(entries, {
         title = ply:Nick(),
         entertext = "Send",
         enterfunc = function()
            return ACT3_BlackMarket.SendMoneyToPlayer(ply)
         end
      })
   end

   return entries
end

ACT3_BlackMarket.BankScreen = function()
   local entries = {
      {title = "BANK", entertext = ""},
      {title = "---", entertext = ""},
      {title = "My Balance", entertext = ""},
      {title = function() return "  $" .. tostring(ACT3_BlackMarket.GetMoneyFunc(LocalPlayer())) end, entertext = ""},
      -- {title = "---", entertext = ""},
      -- {title = "Send Money", entertext = "Enter", enterfunc = ACT3_BlackMarket.SendMoneyMenu},
   }

   return entries
end