ACT3_BlackMarket.LocalCart = {}

ACT3_BlackMarket.AddItemToCart = function(item, qty, cost, data)
   if !ACT3_BlackMarket.LocalCart[item] then
      ACT3_BlackMarket.LocalCart[item] = {amt = qty, cost = cost, data = data}
   else
      ACT3_BlackMarket.LocalCart[item].amt = ACT3_BlackMarket.LocalCart[item].amt + qty
   end
end

ACT3_BlackMarket.RemoveFromCart = function(item, qty)
   if !ACT3_BlackMarket.LocalCart[item] then
      return
   else
      if ACT3_BlackMarket.GetCartItemQuantity(item) < qty then
         qty = ACT3_BlackMarket.LocalCart[item].amt
      end

      ACT3_BlackMarket.LocalCart[item].amt = ACT3_BlackMarket.LocalCart[item].amt - qty
   end
end

ACT3_BlackMarket.GetCartItemQuantity = function(item)
   if !ACT3_BlackMarket.LocalCart[item] then
      return 0
   else
      return ACT3_BlackMarket.LocalCart[item].amt
   end
end

ACT3_BlackMarket.CartScreen = function(item, ent, cost, data)
   local entries = {
      {title = ent.PrintName, entertext = ""},
      {title = function()
         local amt = ACT3_BlackMarket.GetCartItemQuantity(item) or 0
         return "QTY: " .. tostring(amt) end,
      entertext = ""},
      {title = "", entertext = ""},
      {title = function()
         local amt = ACT3_BlackMarket.GetCartItemQuantity(item) or 0
         return "$" .. tostring(cost) .. " ($" .. tostring(cost * amt) .. ")" end,
      entertext = ""},
      {title = "", entertext = ""},
      {title = "Add To Cart", entertext = "Buy", enterfunc = function() ACT3_BlackMarket.AddItemToCart(item, 1, cost, data) end},
      -- {title = "Add 10 To Cart", entertext = "Buy", enterfunc = function() ACT3_BlackMarket.AddItemToCart(item, 10, cost, data) end},
      {title = "Remove From Cart", entertext = "Remove", enterfunc = function() ACT3_BlackMarket.RemoveFromCart(item, 1, cost) end},
      -- {title = "Remove 10 From Cart", entertext = "Remove", enterfunc = function() ACT3_BlackMarket.RemoveFromCart(item, 10) end},
      {title = "Remove ALL From Cart", entertext = "Remove", enterfunc = function() ACT3_BlackMarket.RemoveFromCart(item, math.huge) end},
   }

   return entries
end

ACT3_BlackMarket.CartPrice = function()
   local price = 0

   for _, k in pairs(ACT3_BlackMarket.LocalCart) do
      price = price + (k.amt * k.cost)
   end

   return price
end

ACT3_BlackMarket.ViewFullCart = function()
   local entries = {
      {title = "MY CART", entertext = ""},
      {title = "---", entertext = ""},
      {title = function() return "Total Cost: $" .. tostring(ACT3_BlackMarket.CartPrice()) end, entertext = ""},
      {title = function() return "Your Balance: $" .. tostring(ACT3_BlackMarket.GetMoneyFunc(LocalPlayer())) end,},
      {title = "", entertext = ""},
   }

   for class, k in pairs(ACT3_BlackMarket.LocalCart) do
      if k.amt == 0 then continue end

      local ent

      if k.data.saletype == "WPN" then
         ent = weapons.Get(class)
      else
         ent = scripted_ents.Get(class)
      end

      local pname = ent.PrintName

      table.insert(entries, {
         title = function()
            return pname .. " (x" .. tostring(ACT3_BlackMarket.GetCartItemQuantity(class)) .. ")"
         end,
         entertext = "Change",
         enterfunc = function()
            return ACT3_BlackMarket.CartScreen(class, ent, k.cost, k.data)
         end,
         submode = 0
      })
   end

   table.insert(entries, {title = "---", entertext = ""})

   table.insert(entries, {
      title = "Checkout",
      entertext = "Enter",
      enterfunc = function() return ACT3_BlackMarket.CheckoutScreen() end,
      submode = 0
   })

   table.insert(entries, {
      title = "Remove All From Cart",
      entertext = "Remove",
      enterfunc = function()
         for _, k in pairs(ACT3_BlackMarket.LocalCart) do
            ACT3_BlackMarket.RemoveFromCart(k.data.class, math.huge)
         end
      end,
   })

   return entries
end