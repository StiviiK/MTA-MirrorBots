--
-- Project: MTASA CommunityCoding
-- User: StiviK
-- Date: 16.01.2015
-- Time: 19:53
--

addEvent("CLIENT:Sync_newRemoteBot", true)
addEvent("CLIENT:Sync_setRemoteBotData", true)
MirrorBot_Sync = {
    bots = { };
    clients = {}
}

function MirrorBot_Sync:newRemoteBot (args)
    if not self.clients[source] then
       self.clients[source] = {}
    end

    local self = setmetatable({}, {__index = self})
    self.driver = createPed(166, 0, 0, 0)
    self.car = createVehicle(args[7], 0, 0, 0)

    self.currentPosition = Vector3(args[1], args[2], args[3])
    self.currentRotation = Vector3(args[4], args[5], args[6])
    self.car:setPosition(self.currentPosition)
    self.car:setRotation(self.currentRotation)
    warpPedIntoVehicle(self.driver, self.car)

    setElementVelocity(self.car, unpack(args[9]))

    self:setControlState("accelerate", true)
    
    MirrorBot_Sync:bindInstance(source, args[8], self)
end
addEventHandler("CLIENT:Sync_newRemoteBot", root, bind(MirrorBot_Sync.newRemoteBot, MirrorBot_Sync))

function MirrorBot_Sync:bindInstance (syncer, id, instance)
    self.clients[syncer][id] = instance;
end

function MirrorBot_Sync:getInstance (syncer, id)
    return (self.clients[source] ~= nil and self.clients[source][id]) or false;
end

function MirrorBot_Sync:setControlState (control, state)
    if getPedControlState(self.driver, control) ~= state then
        setPedControlState(self.driver, control, state)
    end
end

function MirrorBot_Sync:updateBotData (id, data, arg1, arg2, arg3, arg4)
    if self.clients[source] then
        local self = self:getInstance(source, id)

        if data == "rotation" then
            self.currentPosition = Vector3(unpack(arg1))
            self.currentRotation = Vector3(unpack(arg2))
            self.car:setRotation(self.currentRotation)

            setElementVelocity(self.car, Vector3(unpack(arg3)))
            setVehicleTurnVelocity(self.car, Vector3(unpack(arg4)))

            if getDistanceBetweenPoints3D(self.currentPosition, Vector3(getElementPosition(self.car))) > 0.5 then
                self.car:setPosition(self.currentPosition)
            end
        elseif data == "control" then

        end
    end
end
addEventHandler("CLIENT:Sync_setRemoteBotData", root, bind(MirrorBot_Sync.updateBotData, MirrorBot_Sync))