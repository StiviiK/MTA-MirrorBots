# MTA San Andreas
This are MirrorBots in MultiTheftAuto San Andreas


### Create a Bot:
```lua
bot MirrorBot:new(int posX, int posY, int posZ, int rotX, int rotY, int rotZ)
```

### Destroy the Bot:
```lua
nil bot:destructor()
-- or
nil MirrorBot:destructor() --> this will destroy all bots
```

### Bot variables:
```lua
int bot.id --> the id of the bot
bool bot.valid --> indicates if the bot is invalid
element bot.driver --> this is the bot (ped)
element bot.car --> the car which drives the bot
vector3 bot.currentRotation --> the current rotation of the bot
vector3 bot.cureentPosition --> the current position of the bot
```
