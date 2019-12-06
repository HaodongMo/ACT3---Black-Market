ACT3_BlackMarket.Merchants = {}
ACT3_BlackMarket.MerchantIndex = {}
ACT3_BlackMarket.IndexToMerchant = {}

-- saletypes:
-- "AMMO" - act3 ammo, class = ammo name
-- "ATT" - act3 attachment, class = att name
-- "WPN" - any weapon
-- "ENT" - misc entity

-- ACT3_BlackMarket.Base = {
--    merchant = "Battlemage",
--    category = "Weapons",
--    class = "act3_akm",
--    quantity = 1,
--    saletype = "WPN",
--    cost = 500,
-- }

-- ACT3_BlackMarket.Base = {
--    merchant = "Battlemage",
--    fluff = true,
--    title = ""
--    text = ""
-- }

function ACT3_BlackMarket:CanUseMerchant(ply, merchant)
   return true
end

function ACT3_BlackMarket:LoadItemToMerchant(tbl)
   if !ACT3_BlackMarket.Merchants[tbl.merchant] then
      ACT3_BlackMarket.Merchants[tbl.merchant] = {}
      ACT3_BlackMarket.MerchantIndex[tbl.merchant] = table.Count(ACT3_BlackMarket.MerchantIndex)
      ACT3_BlackMarket.IndexToMerchant[ACT3_BlackMarket.MerchantIndex[tbl.merchant]] = tbl.merchant

      -- print("Loaded Merchant: " .. tbl.merchant)
   end

   local index = table.insert(ACT3_BlackMarket.Merchants[tbl.merchant], tbl)
   ACT3_BlackMarket.Merchants[tbl.merchant][index].index = index
end

ACT3_BlackMarket.GetMerchantsEntries = function()
   local entries = {}

   for name, k in pairs(ACT3_BlackMarket.Merchants) do
      table.insert(entries, {
         title = name,
         enterfunc = function()
            return ACT3_BlackMarket.GetEntriesForMerchant(name)
         end,
         submode = 0
      })
   end

   return entries
end

ACT3_BlackMarket.GetEntriesForMerchant = function(merchant, subcat)

   if !ACT3_BlackMarket.Merchants[merchant] then return end

   if !ACT3_BlackMarket:CanUseMerchant(LocalPlayer(), merchant) then
      return
   end

   if !subcat then
      local entries = {}
      local cats = {}
      for _, k in pairs(ACT3_BlackMarket.Merchants[merchant]) do
         if k.fluff then
            table.insert(entries, {
               title = k.title,
               enterfunc = function()
                  return {
                     endpoint = true,
                     content = ACT3_BlackMarket:LineTextBlock(k.text, "ACT3BM_LCD_10", ScreenScale(500) * 0.37 + ScreenScale(8))
                  }
               end,
               endpoint = false,
               submode = 1,
            })
         elseif k.category then
            cats[k.category] = true
         end
      end

      for j, __ in pairs(cats) do
         table.insert(entries, {
            title = j,
            enterfunc = function()
               return ACT3_BlackMarket.GetEntriesForMerchant(merchant, j)
            end,
            submode = 0
         })
      end

      return entries
   else
      local entries = {}

      for _, k in pairs(ACT3_BlackMarket.Merchants[merchant]) do
         if k.category == subcat then
            local ent

            if k.saletype == "WPN" then
               ent = weapons.Get(k.class)
            else
               ent = scripted_ents.Get(k.class)
            end

            if !ent then continue end

            -- local content = {
            --    ent.PrintName,
            -- }

            -- local muzzlevel = math.Round(ent.MuzzleVelocity * ACT3.Conversions.HutoM, 0)
            -- local recoil = math.Truncate(ent.Recoil * ACT3.Conversions.RecoilToLBFPS, 1)
            -- local precision = ent.Precision * ACT3.Conversions.GMBP_To_MOA
            -- local rof = 60 / ent.ShootingDelay
            -- local magcapacity = "N/A"

            -- if ent.Magazine then
            --    local magtype = ACT3_GetMagazineType(ent.Magazine.Type)

            --    magcapacity = tostring(magtype.MagSize)
            -- elseif ent.DefaultMagazine then
            --    local magtype = ACT3_GetMagazineType(ent.DefaultMagazine.Type)

            --    magcapacity = tostring(magtype.MagSize)
            -- end

            -- rof = math.Round(rof, 0)
            -- precision = math.Truncate(precision, 1)

            -- if ent.ACT3Weapon then
            --    content = {
            --     "Name: " .. ent.PrintName,
            --     "Country: " .. ent.Desc_Country or "Unknown",
            --     "Manufacturer: " .. ent.Desc_Manufacturer or "Unknown",
            --     "Mechanism: " .. ent.Desc_Mechanism or "Unknown",
            --     "Year: " .. tostring(ent.Desc_Year or "Unknown"),
            --     "Weight: " .. tostring(ent.Desc_Weight or "Unknown") .. " KG",
            --     "Muzzle Velocity: " .. tostring(muzzlevel) .. " m/s",
            --     "Precision: " .. tostring(precision) .. " MOA",
            --     "ROF: " .. tostring(rof) .. " RPM",
            --     "Calibre: " .. ent.PrintCalibre,
            --     "Noise: " .. ent.SoundShootVol .. "dB",
            --     "Mag Capacity: " .. magcapacity,
            --     "Recoil Momentum: " .. recoil .. " lb-fps",
            -- }
            -- end

            -- content = ACT3_BlackMarket:LineTextMultiBlock(content, "ACT3BM_LCD_10", ScrH() * 0.37 + ScreenScale(8))

            table.insert(entries, {
               title = " " .. ent.PrintName .. " ($" .. tostring(k.cost) .. ")",
               enterfunc = function()
                  return ACT3_BlackMarket.CartScreen(k.class, ent, k.cost, k)
               end,
               entertext = "Buy",
               endpoint = false,
               submode = 0,
               cost = k.cost
            })
         end

         if subcat == "Weapons" then
            table.SortByMember(entries, "cost", true)
         else
            table.SortByMember(entries, "title", true)
         end
      end

      if table.Count(entries) == 0 then
         PrintTable(entries)
         entries = {
            {title = "No Items Available"}
         }
      end

      return entries
   end
end
