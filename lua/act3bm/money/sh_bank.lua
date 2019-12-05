ACT3_BlackMarket.GetMoneyFunc = function(ply)
   return ply:ACT3BM_GetMoney()
end

ACT3_BlackMarket.BankScreen = function()
   local entries = {
      {title = "BANK", entertext = ""},
      {title = "---", entertext = ""},
      {title = "My Balance", entertext = ""},
      {title = function() return "  $" .. tostring(ACT3_BlackMarket.GetMoneyFunc(LocalPlayer())) end, entertext = ""},
      {title = "---", entertext = ""},
      {title = "Send Money", entertext = "Enter"},
   }

   return entries
end