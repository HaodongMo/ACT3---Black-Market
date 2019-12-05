ACT3_BlackMarket.GuidebookEntries = {
   ["Money"] = "Money will automatically integrate into the DarkRP system if it is detected. Otherwise, it will use its own system. Gain money by killing NPCs and collecting HL2 weapons and ammo.",
   ["Ordering"] = "To place an order, you must first go into the Merchants tab and selecting the item you want, then adding it to your cart. Next, simply stand somewhere that is exposed to the sky, so the airdrop can reach you, and go into your My Cart tab, then click \"Checkout\" and then \"Place Order\". Your delivery will be sent via extra-fast delivery jet. The crate will explode into your ordered items when it touches the ground, or can be shot apart for quicker access.",
   ["The Black Market"] = "The Black Market is based on an aircraft carrier, sailing the world and supplying weapons and equipment to its seediest individuals.",
   ["ACT3"] = "ACT3 stands for Arctic's Customizable Thirdperson (Weapons) 3. It is the third instalment in Arctic's thirdperson weapons addon series, though it is the first to use the ACT moniker. Before ACT3 were ASTW2 and ASTW, \"Arctic's Simple Thirdperson Weapons\".",
   ["Arctic"] = "Arctic is the creator of ACT3, as well as many other high-quality addons. You can find his Steam profile at https://steamcommunity.com id/ArcticWinterZzZ/. You can also feel free to join the official Discord server for his addons, which has a link available on his profile page.",
   -- ["The Rift War"] = "In 200X, parts of the world were torn open by an event known as \"The Rift\". Out of it a powerful material, Stardust. It is over deposits of this material, which formed over areas affected by The Rift, that the Rift War was fought, between the nations of the world, each clamoring for control over the valuable resources contained within. The Rift War took place many, many years ago, but its aftershocks still remain. These areas have now been designated as nonsovereign territory by the UN in order to prevent another Rift War from breaking out.",
   -- ["Stardust"] = "Stardust is an extremely heavy \"Island of Stability\" element that fell out of The Rift. Large amounts can still be found in areas that were heavily affected by The Rift. It is a potent energy source, and possesses unique quantum properties capable of enabling macro-scale teleportation, nanomachine technology, and targeted gene mutation. It is extremely valuable. The presence of Stardust has created a new technological boom, despite the fact that it is only available in very limited quantities."
   -- ["Amber Zones"] = "Amber Zones are areas which were heavily affected by The Rift. After the Rift War, a UN treaty declared these areas non-sovereign land, meaning that no nation was allowed sole jurisdiction over them, like international waters, in order to prevent another Rift War. Due to this fact, and the fact that Amber Zones are heavily infested by monsters which were mutated by The Rift, the main method by which Stardust is acquired is now through mercenaries, who enter these zones to collect and sell Stardust. They may be sponsored by world governments, but these areas are still too dangerous for civilian mining operations to take place. Nevertheless, even the meager quantities of Stardust able to be extracted have fuelled a massive boom in technology."
}

ACT3_BlackMarket.GuidebookScreen = function()
   entries = {{title = "GUIDEBOOK"}}

   for title, content in pairs(ACT3_BlackMarket.GuidebookEntries) do
      table.insert(entries, {
         title = title,
         enterfunc = function()
            return {
               endpoint = true,
               content = ACT3_BlackMarket:LineTextBlock(content, "ACT3BM_LCD_10", ScreenScale(500) * 0.37 + ScreenScale(8))
            }
         end,
         endpoint = false,
         submode = 1,
      })
   end

   return entries
end