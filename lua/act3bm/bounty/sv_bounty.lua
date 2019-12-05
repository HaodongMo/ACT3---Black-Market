ACT3_BlackMarket.BountyTable = {
   ["default"] = 0,
   ["npc_alyx"] = 125,
   ["npc_antlion"] = 50,
   ["npc_antlion_grub"] = 0,
   ["npc_antlionguard"] = 500,
   ["npc_barnacle"] = 50,
   ["npc_barney"] = 125,
   ["npc_breen"] = 125,
   ["npc_citizen"] = 50,
   ["npc_combine_s"] = 150,
   ["npc_combine_camera"] = 150,
   ["npc_combinedropship"] = 500,
   ["npc_combinegunship"] = 700,
   ["npc_crow"] = 25,
   ["npc_pigeon"] = 25,
   ["npc_headcrab"] = 50,
   ["npc_headcrab_black"] = 75,
   ["npc_headcrab_fast"] = 75,
   ["npc_helicopter"] = 600,
   ["npc_hunter"] = 500,
   ["npc_kleiner"] = 125,
   ["npc_magnusson"] = 125,
   ["npc_manhack"] = 75,
   ["npc_metropolice"] = 100,
   ["npc_monk"] = 125,
   ["npc_mossman"] = 125,
   ["npc_poisonzombie"] = 200,
   ["npc_rollermine"] = 75,
   ["npc_seagull"] = 25,
   ["npc_sniper"] = 200,
   ["npc_turret_ceiling"] = 225,
   ["npc_turret_floor"] = 150,
   ["npc_turret_ground"] = 100,
   ["npc_zombie"] = 150,
   ["npc_zombie_torso"] = 100,
   ["npc_zombine"] = 175
}

hook.Add("OnNPCKilled", "ACT3_BlackMarket_NPCKilled", function(npc, attacker, inflictor)
   if !attacker:IsPlayer() then return end

   local npcclass = npc:GetClass()
   local bounty = 0

   if ACT3_BlackMarket.BountyTable[npcclass] then
      bounty = ACT3_BlackMarket.BountyTable[npcclass]
   else
      bounty = ACT3_BlackMarket.BountyTable["default"]
   end

   if bounty != 0 then
      attacker:ACT3BM_GiveMoney(bounty)
   end
end)