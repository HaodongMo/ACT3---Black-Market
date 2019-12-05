function ACT3_BlackMarket:SendCheckout()
   net.Start("ACT3_BM_SendCart")

   for _, k in pairs(ACT3_BlackMarket.LocalCart) do
      net.WriteBool(true)
      net.WriteUInt(k.data.index, 32)
      local merch = k.data.merchant
      local mindex = ACT3_BlackMarket.MerchantIndex[merch]
      net.WriteUInt(mindex, 32)
      net.WriteUInt(k.amt, 32)
   end

   net.WriteBool(false)

   net.SendToServer()
end

ACT3_BlackMarket.CheckoutScreen = function()
   local entries = {
      {title = "CHECKOUT"},
      {title = "---"},
      {title = function() return "Total Cost: $" .. tostring(ACT3_BlackMarket.CartPrice()) end},
      {title = function() return "Your Balance: $" .. tostring(ACT3_BlackMarket.GetMoneyFunc(LocalPlayer())) end,},
      {title = ""},
      {title = "---"},
      {title = function()
         local text = "Call Delivery"
         if !ACT3_BlackMarket:PointExposed(LocalPlayer():GetPos(), LocalPlayer()) then
            text = "Stand Under Sky"
         end
         if ACT3_BlackMarket.CartPrice() > LocalPlayer():ACT3BM_GetMoney() then
            text = "Insufficient Funds"
         end
         if ACT3_BlackMarket.CartPrice() == 0 then
            text = "Cart Is Empty"
         end
         if !ACT3_BlackMarket:CanPlaceOrder() then
            text = "Wait " .. ACT3_BlackMarket:OrderWaitTime() .. "s"
         end
         return text
      end, enterfunc = function()
         if ACT3_BlackMarket.CartPrice() > LocalPlayer():ACT3BM_GetMoney() then return end
         if ACT3_BlackMarket.CartPrice() == 0 then return end
         if !ACT3_BlackMarket:PointExposed(LocalPlayer():GetPos(), LocalPlayer()) then return end

         ACT3_BlackMarket:SendCheckout()
         ACT3_BlackMarket.LocalCart = {}
      end}
   }

   return entries
end