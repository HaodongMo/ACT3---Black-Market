AddCSLuaFile()

-- the main object
ACT3_BlackMarket = {}
ACT3_BlackMarket.ExcludeFiles = {}
ACT3_BlackMarket.ExcludeDirs = {}

local function omniload(filename)
    local files, directories = file.Find(filename .. "/*", "LUA")

    for _, v in pairs(files or {}) do
        if ACT3_BlackMarket.ExcludeFiles[v] then continue end
        local start = string.sub(v, 1, 2)
        if start == "cl" and v != "cl_init.lua" then
            if CLIENT then
                include(filename .. "/" .. v)
            else
                AddCSLuaFile(filename .. "/" .. v)
            end

            -- print("LOADED CLIENT FILE " .. v)
        elseif start == "sv" then
            if SERVER then
                include(filename .. "/" .. v)
            end

            -- print("LOADED SERVER FILE " .. v)
        elseif start == "sh" then
            include(filename .. "/" .. v)
            if SERVER then
                AddCSLuaFile(filename .. "/" .. v)
            end

            -- print("LOADED SHARED FILE " .. v)
        end
    end

    for _, v in pairs(directories or {}) do
        if ACT3_BlackMarket.ExcludeDirs[v] then continue end
        omniload(filename .. "/" .. v)

        -- print("LOADING DIRECTORY " .. v)
    end
end

omniload("act3bm/")

omniload("act3bmod/")