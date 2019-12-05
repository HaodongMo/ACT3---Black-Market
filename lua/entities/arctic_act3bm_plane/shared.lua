ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "Plane"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable 			= false

ENT.Speed = 0
ENT.Dir = Vector(0, 0, 0)

AddCSLuaFile()

function ENT:Initialize()
   local pb_vert = 1
   local pb_hor = 1
   self:PhysicsInitBox(Vector(-pb_vert,-pb_hor,-pb_hor), Vector(pb_vert,pb_hor,pb_hor))
   self:SetMoveType(MOVETYPE_NOCLIP)

   self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
   self:SetCollisionBounds(Vector(-2 -2, -2), Vector(2, 2, 2))
   local phys = self:GetPhysicsObject()
   phys:SetMass(1)
   phys:EnableGravity(false)
   phys:Wake()
end

function ENT:Think()
end

function ENT:Draw()
    self:DrawModel()
end