--
-- Project: MTASA CommunityCoding
-- User: StiviK
-- Date: 15.01.2015
-- Time: 19:36
--

function getAnglePosition(x, y, z, rx, ry, rz, distance, angle, height)
    local nrx = math.rad(rx);
    local nry = math.rad(ry);
    local nrz = math.rad(angle - rz);

    local dx = math.sin(nrz) * distance;
    local dy = math.cos(nrz) * distance;
    local dz = math.sin(nrx) * distance;

    local newX = x + dx;
    local newY = y + dy;
    local newZ = z + height - dz;

    return newX, newY, newZ;
end

function findRotation(x1,y1,x2,y2)
    local t = -math.deg(math.atan2(x2-x1,y2-y1))
    if t < 0 then t = t + 360 end;

    return t;
end

function table.find(tab, value)
    for k, v in pairs(tab) do
        if v == value then
            return k
        end
    end
    return nil
end

function table.copy(tab, recursive)
    local ret = {}
    for key, value in pairs(tab) do
        if (type(value) == "table") and recursive then ret[key] = table.copy(value)
        else ret[key] = value end
    end
    return ret
end