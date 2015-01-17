--
-- Project: MTASA CommunityCoding
-- User: StiviK
-- Date: 15.01.2015
-- Time: 19:36
--

MirrorBot = {
    new = function (self, ...) local i = setmetatable({}, {__index = self}) i:constructor(...) return i; end;
    bots = { };
}

function MirrorBot:constructor (pX, pY, pZ, rX, rY, rZ, model)
    if isPedInVehicle(localPlayer) then
        self.valid = true
        self.driver = createPed(166, 0, 0, 0)
        self.carModel = model or getElementModel(getPedOccupiedVehicle(localPlayer))
        self.car = createVehicle(self.carModel, 0, 0, 0)
        self.validControls = {
            ["accelerate"] = true,
            ["brake_reverse"] = true,
            ["handbrake"] = true,
            ["steer_forward"] = true,
            ["steer_back"] = true,
            --["vehicle_left"] = true,
            --["vehicle_right"] = true
        }
        self.positionCols = {};
        self.render = bind(self.render, self)
        addEventHandler("onClientRender", root, self.render)

        local pX, pY, pZ = getAnglePosition(pX, pY, pZ, rX, rY, rZ, 8, 180, 3)
        self.currentPosition = Vector3(pX, pY, pZ)
        self.currentRotation = Vector3(rX, rY, rZ)

        self.car:setPosition(self.currentPosition)
        self.car:setRotation(self.currentRotation)
        warpPedIntoVehicle(self.driver, self.car)

        setElementVelocity(self.car, Vector3(getElementVelocity(getPedOccupiedVehicle(localPlayer))))
        self:setControlState("accelerate", true)

        self.id = #self.bots + 1
        self.bots[self.id] = self

        triggerServerEvent("SERVER:Sync_newRemoteBot", localPlayer, {pX, pY, pZ, rX, rY, rZ, self.carModel, self.id, {getElementVelocity(getPedOccupiedVehicle(localPlayer))}})
        outputDebugString("[MirrorBot] Destructor: Created Bot #"..self.id.."!")
        outputConsole("[MirrorBot] Destructor: Created Bot #"..self.id.."!")
    else
        self.valid = false
    end
end

function MirrorBot:destructor ()
    if self == MirrorBot then
        for i, v in ipairs(self.bots) do
            v:destructor()
        end

        return;
    end
    --[[
    for i, v in ipairs(self.positionCols) do
        if isElement(v[4]) then
            destroyElement(v[4])
        end
    end
    --]]

    self.valid = false
    destroyElement(self.car)
    destroyElement(self.driver)

    outputDebugString("[MirrorBot] Destructor: Destroyed Bot #"..self.id.."!")
    outputConsole("[MirrorBot] Destructor: Destroyed Bot #"..self.id.."!")

    removeEventHandler("onClientRender", root, self.render)
    self.bots[self.id] = nil;
end

function MirrorBot:setControlState (control, state)
    if self.validControls[control] then
        if getPedControlState(self.driver, control) ~= state then
            setPedControlState(self.driver, control, state)
        end
    end
end

function MirrorBot:getControlState (control)
    if self.validControls[control] then
        return getPedControlState(self.driver, control)
    end
end

function MirrorBot:render ()
    if isPedInVehicle(localPlayer) then
        local x, y, z = getElementPosition(getPedOccupiedVehicle(localPlayer))
        local rx, ry, rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
        local x, y, z = getAnglePosition(x, y, z, rx, ry, rz, 3, 180, 0)
        local colSphere = createColSphere(x, y, z, 3)
        colSphere.data = {
            ["accelerate"] = getControlState("accelerate");
            ["brake_reverse"] = getControlState("brake_reverse");
            ["handbrake"] = getControlState("handbrake");
            ["steer_forward"] = getControlState("steer_forward");
            ["steer_back"] = getControlState("steer_back");
            ["vehicle_left"] = getControlState("vehicle_left");
            ["vehicle_right"] = getControlState("vehicle_right");
        }
        local pos = #self.positionCols + 1
        self.positionCols[pos] = {x, y, z, colSphere}
        addEventHandler("onClientColShapeHit", colSphere, bind(self.onColHit, self, pos))

        x, y, z, rx, ry, rz = nil, nil, nil, nil, nil, nil

        triggerServerEvent("SERVER:Sync_setRemoteBotData", localPlayer, {self.id, "rotation", {self.currentPosition.x, self.currentPosition.y, self.currentPosition.z}, {self.currentRotation.x, self.currentRotation.y, self.currentRotation.z}, {getElementVelocity(self.car)}, {getVehicleTurnVelocity(self.car)}})
    else
        if self.valid then
            self:destructor()
        end
    end
end

function MirrorBot:onColHit (pos, ele)
    if ele == self.car then
        if self.positionCols[pos] then
            outputDebugString("[MirrorBot] Found Position #"..pos.."."..self.id.." (Bot-ID: "..self.id..")")
            outputConsole("[MirrorBot] Found Position #"..pos.."."..self.id.." (Bot-ID: "..self.id..")")

            self.currentPosition = Vector3(self.car:getPosition())
            self.currentRotation = Vector3(self.car:getRotation())

            for i, v in pairs(source.data) do
                self:setControlState(i, v)
            end

            destroyElement(source)
            self.positionCols[pos] = nil

            if self.positionCols[pos+1] then
                local rz = findRotation(self.currentPosition.x, self.currentPosition.y, self.positionCols[pos+1][1], self.positionCols[pos+1][2])
                self.currentRotation = Vector3(self.currentRotation.x, self.currentRotation.y, rz)
                self.car:setRotation(self.currentRotation)
            end
            
            --triggerServerEvent("SERVER:Sync_setRemoteBotData", localPlayer, {self.id, "rotation", {self.currentPosition.x, self.currentPosition.y, self.currentPosition.z}, {self.currentRotation.x, self.currentRotation.y, self.currentRotation.z}, {getElementVelocity(self.car)}, {getVehicleTurnVelocity(self.car)}})
        end
    end
end

setDevelopmentMode(true)
