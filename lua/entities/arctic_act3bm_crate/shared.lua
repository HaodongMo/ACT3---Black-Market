ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "Crate"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable 			= false

AddCSLuaFile()

ENT.Contents = {}

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

      self:SetHealth(10)

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
               newent:SetPos(self:GetPos() + VectorRand() + Vector(0, 0, 8))
               newent:SetAngles(AngleRand())
               newent:Spawn()
            end
         end
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

   self:TakeDamage(100, self, self)
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
