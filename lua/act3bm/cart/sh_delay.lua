ACT3_BlackMarket.NextCanOrderTime = 0
ACT3_BlackMarket.OrderDelayTime = 30

if SERVER then

function ACT3_BlackMarket:SendDelay(ply)
   local nexttime = math.ceil(CurTime() + ACT3_BlackMarket.OrderDelayTime)
   net.Start("ACT3_BM_SendDelay")
   net.WriteUInt(nexttime, 32)
   net.Send(ply)

   ply.ACT3BM_NextCanOrderTime = nexttime
end

elseif CLIENT then

function ACT3_BlackMarket:CanPlaceOrder()
   return CurTime() > ACT3_BlackMarket.NextCanOrderTime
end

function ACT3_BlackMarket:OrderWaitTime()
   return math.ceil(ACT3_BlackMarket.NextCanOrderTime - CurTime())
end

net.Receive("ACT3_BM_SendDelay", function(len, ply)
   local nexttime = net.ReadUInt(32)
   ACT3_BlackMarket.NextCanOrderTime = nexttime
end)

end