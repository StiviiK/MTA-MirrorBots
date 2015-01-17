--
-- Project: MTASA CommunityCoding
-- User: StiviK
-- Date: 16.01.2015
-- Time: 20:03
--

addEvent("SERVER:Sync_newRemoteBot", true)
addEventHandler("SERVER:Sync_newRemoteBot", root, function (args)
    for i, v in ipairs(getElementsByType("player")) do
       if v ~= source then
           triggerClientEvent(v, "CLIENT:Sync_newRemoteBot", source, args)
       end
    end
end)

addEvent("SERVER:Sync_setRemoteBotData", true)
addEventHandler("SERVER:Sync_setRemoteBotData", root, function (args)
    for i, v in ipairs(getElementsByType("player")) do
        if v ~= source then
            triggerClientEvent(v, "CLIENT:Sync_setRemoteBotData", source, unpack(args))
        end
    end
end)