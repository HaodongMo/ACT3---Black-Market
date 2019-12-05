ACT3_BlackMarket.TestedForSkybox = false
ACT3_BlackMarket.HasSkybox = true
ACT3_BlackMarket.SkyboxPos = Vector(0, 0, 0)
ACT3_BlackMarket.MinSafeHeight = 32 -- this is something players will have to sort out themselves...
ACT3_BlackMarket.SkyboxScale = 16
ACT3_BlackMarket.Debug = true

function ACT3_BlackMarket:SetupSkybox()
   -- does the map have a 3D skybox?
   if ACT3_BlackMarket.TestedForSkybox then return end
   local skycamera = ents.FindByClass("sky_camera")[1]

   if skycamera then
      ACT3_BlackMarket.HasSkybox = true
      ACT3_BlackMarket.SkyboxPos = skycamera:GetPos()
   end

   ACT3_BlackMarket.TestedForSkybox = true
   print("Skybox tested.")
   if skycamera then
      print("3D Skybox detected. Air Control going into action...")
   else
      print("3D Skybox not detected. Air Control standing down...")
   end
end

function ACT3_BlackMarket:WorldToSky(pos)
   ACT3_BlackMarket:SetupSkybox()

   if !ACT3_BlackMarket.HasSkybox then return pos end

   -- (0, 0, 0) corresponds to 3d skybox location
   -- 3d skybox is 1/16th scale

   local skypos = Vector(pos.x, pos.y, pos.z)

   skypos.x = skypos.x / ACT3_BlackMarket.SkyboxScale
   skypos.y = skypos.y / ACT3_BlackMarket.SkyboxScale
   skypos.z = skypos.z / ACT3_BlackMarket.SkyboxScale

   skypos = skypos + ACT3_BlackMarket.SkyboxPos

   return skypos
end