function ACT3_BlackMarket:PointExposed(pos, ply)
   local tr = util.TraceLine({
      start = pos,
      endpos = pos + Vector(0, 0, 32000),
      mask = MASK_OPAQUE,
      filter = {ply}
   })

   if tr.HitSky then
      return tr.HitPos
   else
      return nil
   end
end