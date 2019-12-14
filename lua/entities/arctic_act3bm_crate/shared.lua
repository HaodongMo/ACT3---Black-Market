ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "Crate"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable 			= false

AddCSLuaFile()

ENT.Contents = {}
ENT.AttContents = {}
ENT.MagContents = {}
ENT.AmmoContents = {}

ENT.SoundImpact = "Wood.ImpactSoft"
ENT.SoundImpactHard = "Wood.ImpactHard"
ENT.ParachuteOpenTime = 1
ENT.ParachuteOpen = false
ENT.SpawnedContents = false

function ENT:Initialize()
   if SERVER then
      self:SetModel("models/items/item_item_crate.mdl")
      self:PhysicsInit(SOLID_VPHYSICS)
      self:SetMoveType(MOVETYPE_VPHYSICS)
      self:SetSolid(SOLID_VPHYSICS)
      self:SetCollisionGroup(COLLISION_GROUP_NONE)
      self:SetPos(self:GetPos() + Vector(0, 0, 4))

      local phys = self:GetPhysicsObject()
      if phys:IsValid() then
         phys:Wake()
         phys:SetBuoyancyRatio(0)
         phys:SetDragCoefficient(100)
      end

      self:PrecacheGibs()

      self:SetHealth(150)

   else

      self.ParachuteModel = ClientsideModel("models/props_survival/parachute/chute.mdl")

      if !self.ParachuteModel then return end
      if !IsValid(self.ParachuteModel) then return end

      self.ParachuteModel.Weapon = self

      table.insert(ACT3.CSModels, {self.ParachuteModel, self})

      self.ParachuteModel:SetNoDraw(true)
   end

   self.SpawnTime = CurTime()
end

function ENT:OnTakeDamage(dmg)
   self:SetHealth(self:Health() - dmg:GetDamage())
   if self:Health() <= 0 then
      if self.SpawnedContents then return end

      self.SpawnedContents = true
      self:GibBreakClient(Vector(0, 0, 0))
      self:EmitSound("physics/wood/wood_plank_break" .. math.random(1,4) .. ".wav")

      for class, qty in pairs(self.Contents) do
         if qty > 0 then
            for _ = 1, qty do
               local newent = ents.Create(class)
               newent.ACT3_DoNotSpawnWithAtts = true
               newent:SetPos(self:GetPos() + (VectorRand() * 8) + Vector(0, 0, 16))
               newent:SetAngles(AngleRand())
               newent:Spawn()
            end
         end
      end

      if table.Count(self.MagContents) > 0 then
         for mag, qty in pairs(self.MagContents) do
            if qty > 0 then
               local magtbl = ACT3_GetMagazineType(mag)
               for _ = 1, qty do
                  local nm = ents.Create("act3_magazine")
                  nm.DefaultLoad = magtbl.DefaultLoad
                  nm.MagazineTable = {
                     Type = mag,
                     Rounds = {}
                  }
                  nm:SetPos(self:GetPos() + (VectorRand() * 8) + Vector(0, 0, 16))
                  nm:SetAngles(AngleRand())
                  nm:Spawn()
               end
            end
         end
      end

      if table.Count(self.AmmoContents) > 0 then
         local ammocontainer = ents.Create("act3_ammopack")
         ammocontainer.GiveBullets = self.AmmoContents
         ammocontainer.Model = "models/Items/BoxMRounds.mdl"
         ammocontainer:SetPos(self:GetPos() + (VectorRand() * 8) + Vector(0, 0, 16))
         ammocontainer:SetAngles(AngleRand())
         ammocontainer:Spawn()
      end

      if table.Count(self.AttContents) > 0 then
         local attcontainer = ents.Create("act3_attachment")
         attcontainer.GiveAttachments = self.AttContents
         attcontainer:SetPos(self:GetPos() + (VectorRand() * 8) + Vector(0, 0, 16))
         attcontainer:SetAngles(AngleRand())
         attcontainer:Spawn()
      end

      self:Remove()
   end
end

function ENT:Think()
end

function ENT:PhysicsCollide(colData, collider)
   if colData.Speed > 150 then
      self:EmitSound(self.SoundImpactHard)
   else
      self:EmitSound(self.SoundImpact)
   end

   self:TakeDamage(125, self, self)
end

function ENT:OnRemove()
   if SERVER then
      if self.ChuteSound then
         self.ChuteSound:Stop()
      end
   end
end

ENT.ParachuteOpenAmount = 0.1

function ENT:Think()
   if CLIENT then
      if self.SpawnTime + self.ParachuteOpenTime <= CurTime() then
         self.ParachuteOpenAmount = math.Approach(self.ParachuteOpenAmount, 1, FrameTime() * (1 / 0.5))
      end
   else
      if self.SpawnTime + self.ParachuteOpenTime <= CurTime() and !self.ParachuteOpen then
         self.ParachuteOpen = true
         self.ChuteSound = CreateSound(self, "survival/dropzone_parachute_success.wav")
         self.ChuteSound:SetSoundLevel(120)
         self.ChuteSound:Play()
         self.ChuteSound:FadeOut(10)
      end
   end
end

function ENT:Draw()
   self:DrawModel()

   if self.ParachuteModel and IsValid(self.ParachuteModel) then
      local scale = Vector( self.ParachuteOpenAmount, self.ParachuteOpenAmount, 1 )

      local mat = Matrix()
      mat:Scale( scale )

      local sangle = self:GetAngles()
      self.ParachuteModel:SetPos(self:WorldSpaceCenter() - Vector(0, 0, 64))
      self.ParachuteModel:SetAngles(Angle(0, sangle[2], 0))
      self.ParachuteModel:EnableMatrix("RenderMultiply", mat)
      self.ParachuteModel:DrawModel()
   end
end
