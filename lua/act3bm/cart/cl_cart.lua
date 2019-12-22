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

         local txt = "QTY: " .. tostring(amt)

         if data.saletype == "AMMO" then
            local ammotype = data.class

            if string.sub(data.class, 1, 10) == "act3_ammo_" then
               ammotype = string.sub(data.class, 11)
            end

            local bulletid = ACT3_GetBulletID(ammotype)
            local bullet = ACT3_GetBullet(bulletid)
            txt = txt .. " (x" .. tostring(data.ammoquantity or (bullet.GiveCount or 24)) .. ")"
         end

         return txt end,
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

   if data.saletype == "AMMO" or data.saletype == "ATT" or data.extrainfo then
      entries[3] = {
         title = "More Info",
         entertext = "See",
         submode = 1,
         enterfunc = function()
            if data.saletype == "AMMO" or data.saletype == "ATT" then
               local thing = nil
               if data.saletype == "AMMO" then
                  local act3name = string.sub(data.class, 11)
                  local bulletid = ACT3_GetBulletID(act3name)
                  if bulletid then
                     local bullet = ACT3_GetBullet(bulletid)
                     if bullet then
                        thing = bullet
                     end
                  end
               else
                  local act3name = string.sub(data.class, 10)
                  local att = ACT3_GetAttachment(act3name)
                  if att then
                     thing = att
                  end
               end

               if thing and thing.Description then
                  return {
                     endpoint = true,
                     content = ACT3_BlackMarket:LineTextMultiBlock(thing.Description, "ACT3BM_LCD_10", ScreenScale(500) * 0.37 + ScreenScale(8))
                  }
               else
                  return nil
               end
            else
               return {
                  endpoint = true,
                  content = ACT3_BlackMarket:LineTextBlock(data.extrainfo, "ACT3BM_LCD_10", ScreenScale(500) * 0.37 + ScreenScale(8))
               }
            end
         end,
      }
   end

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

      local ent = ACT3_BlackMarket:SanitizeSale(k.data)

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