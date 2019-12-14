ACT3_BlackMarket.TimeToDrop = 5

function ACT3_BlackMarket:SendDeliveryPlane(pos, cart)
   if !ACT3_BlackMarket.HasSkybox then return end -- no point continuing really

   if table.Count(cart) == 0 then return end -- buy nothing??? okay

   local plane = {
      model = "models/planespotting/super_galeb_skybox.mdl",
      scale = 12,
      speed = 250,
      offset = Angle(0, 0, 0),
      trail = "trails/smoke",
      traillength = 10,
      trailsize = 12,
   }

   local tr = util.TraceLine({
      start = ACT3_BlackMarket:WorldToSky(pos),
      endpos = ACT3_BlackMarket:WorldToSky(pos) + Vector(0, 0, 36000),
      mask = MASK_OPAQUE
   })

   local wtr = util.TraceLine({
      start = pos,
      endpos = pos + Vector(0, 0, 36000),
      mask = MASK_OPAQUE
   })

   -- pick an entry point and exit point

   timer.Simple(ACT3_BlackMarket.TimeToDrop, function()
      local crate = ents.Create("arctic_act3bm_crate")

      if !IsValid(crate) then return end

      local contents = {}
      local ammocontents = {}
      local attcontents = {}

      for _, k in pairs(cart) do
         if !k.purchase then continue end
         if k.amt == 0 then continue end

         if k.purchase.saletype == "AMMO" then
            local ammotype = k.purchase.class

            print(string.sub(k.purchase.class, 1, 10))

            if string.sub(k.purchase.class, 1, 10) == "act3_ammo_" then
               ammotype = string.sub(k.purchase.class, 11)
            end

            local bulletid = ACT3_GetBulletID(ammotype)
            local bullet = ACT3_GetBullet(bulletid)

            if bullet then
               ammocontents[ammotype] = k.amt * (k.purchase.quantity or 1) * (k.purchase.ammoquantity or (bullet.GiveCount or 24))
            end
         elseif k.purchase.saletype == "ATT" then
            local atttype = k.purchase.class

            if string.sub(k.purchase.class, 1, 9) == "act3_att_" then
               atttype = string.sub(k.purchase.class, 10)
            end
            attcontents[atttype] = k.amt * (k.purchase.quantity or 1)
         else
            contents[k.purchase.class] = k.amt * (k.purchase.quantity or 1)
         end
      end

      crate.AmmoContents = ammocontents
      crate.AttContents = attcontents
      crate.Contents = contents

      crate:SetPos(wtr.HitPos + Vector(0, 0, -32))
      crate:SetAngles(Angle(0, 0, 0))
      crate:Spawn()
   end)

   local entry = nil
   local exit = nil
   local totest = 180
   local monte = {}
   local offset = math.random(0, 180)

   for i = 1, 180 do
      monte[i] = i
   end

   local skypos = tr.HitPos - Vector(0, 0, math.Rand(0, ACT3_BlackMarket.MinSafeHeight))

   while !entry and totest > 0 do
      -- do a trace to try to see if this random angle is okay
      local testaoa = table.Random(monte) + offset

      local aoatr = util.TraceLine({
         start = skypos,
         endpos = skypos + (Angle(0, testaoa, 0):Forward() * 100000),
         mask = MASK_OPAQUE
      })

      local aoatr2 = util.TraceLine({
         start = skypos,
         endpos = skypos + (Angle(0, testaoa + 180, 0):Forward() * 100000),
         mask = MASK_OPAQUE
      })

      if aoatr.HitSky and aoatr2.HitSky then
         entry = aoatr.HitPos
         exit = aoatr2.HitPos
      else
         table.remove(monte, testaoa)
         totest = totest - 1
      end
   end

   if !entry or !exit then
      print("WARNING: Failed to spawn aircraft. No valid possible entry/exit points...")
      -- ???
      return
   end

   local speed = entry:Distance(tr.HitPos) / ACT3_BlackMarket.TimeToDrop

   local timetoleave = entry:Distance(exit) / speed

   local planeentity = ents.Create("arctic_act3bm_plane")
   if !IsValid(planeentity) then return end
   planeentity:SetModel(plane.model)
   planeentity:SetModelScale((plane.scale or 1) / 16, 0)
   planeentity:SetColor(plane.color or Color(255, 255, 255, 255))
   planeentity:SetPos(entry)
   planeentity:SetAbsVelocity((exit - entry):GetNormalized() * speed)
   planeentity:SetAngles((exit - entry):GetNormalized():Angle() + (plane.offset or Vector(0, 0, 0)))
   planeentity:Spawn()

   local tsound = math.Clamp(ACT3_BlackMarket.TimeToDrop - 1, 0, math.huge)

   util.PrecacheSound("animation/jets/jet_flyby_01.wav")

   timer.Simple(tsound, function()
      sound.Play( "animation/jets/jet_flyby_01.wav", wtr.HitPos, 150, 100, 1 )
   end)

   if plane.bodygroups then
      planeentity:SetBodyGroups(plane.bodygroups)
   end

   if plane.skin then
      planeentity:SetSkin(plane.skin)
   end

   if plane.trail then
      util.SpriteTrail( planeentity, 0, Color(255, 255, 255, 100), false, plane.trailsize or 8, 0, plane.traillength or 10, 1 / 4, plane.trail )
   end

   if (exit - entry):Length() <= 1 then
         SafeRemoveEntity(planeentity)
      return
   end

   -- print("Spawned plane.")

   timer.Simple(timetoleave + (plane.traillength or 10), function()
      if !IsValid(planeentity) then return end

      SafeRemoveEntity(planeentity)
   end)
end