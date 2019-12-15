function ACT3_BlackMarket:SanitizeSale(k)
    local ent

    if k.saletype == "WPN" then
        ent = weapons.Get(k.class)
    elseif k.saletype == "AMMO" then
        local ammotype = k.class

        if string.sub(k.class, 1, 10) == "act3_ammo_" then
            ammotype = string.sub(k.class, 11)
        end

        local bulletid = ACT3_GetBulletID(ammotype)
        local bullet = ACT3_GetBullet(bulletid)

        ent = bullet
    elseif k.saletype == "ATT" then
        local atttype = k.class

        if string.sub(k.class, 1, 9) == "act3_att_" then
            atttype = string.sub(k.class, 10)
        end

        ent = ACT3_GetAttachment(atttype)
    elseif k.saletype == "MAG" then
        local magtype = k.class

        if string.sub(k.class, 1, 9) == "act3_mag_" then
            magtype = string.sub(k.class, 10)
        end

        ent = ACT3_GetMagazineType(magtype)
    else
        ent = scripted_ents.Get(k.class)
    end

    return ent
end