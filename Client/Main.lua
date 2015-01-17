--[[
local x, y, z = getElementPosition(localPlayer)
local rx, ry, rz = getElementRotation(localPlayer)
local bot = MirrorBot:new(x, y, z, rx, ry, rz)

local x, y, z = getAnglePosition(x, y, z, rx, ry, rz, 10, 180, 0)
local bot2 = MirrorBot:new(x, y, z, rx, ry, rz)

local x, y, z = getAnglePosition(x, y, z, rx, ry, rz, 10, 180, 0)
local bot3 = MirrorBot:new(x, y, z, rx, ry, rz)
--]]
local a = false
local x, y, z
local rx, ry, rz

function spawnBots (num)
    if isPedInVehicle(localPlayer) then
        if a then
            MirrorBot:destructor()
        end
        a = true

        x, y, z = getElementPosition(getPedOccupiedVehicle(localPlayer))
        rx, ry, rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
        bot = MirrorBot:new(x, y, z, rx, ry, rz)

        for i = 1, num or 1, 1 do
            x, y, z = getAnglePosition(x, y, z, rx, ry, rz, 10, 180, 0)
            bot = MirrorBot:new(x, y, z, rx, ry, rz)
            setVehicleSirensOn(bot.car, true)
        end

        setVehicleDamageProof(getPedOccupiedVehicle(localPlayer), true)
    end
end
bindKey("x", "down", function () spawnBots(2) end)