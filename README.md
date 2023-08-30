# Current Module and Methods

## Server
## Framework.core
```lua
 local coreModule = Framework.core
 local player = coreModule.GetPlayer(src)
---param@ type: 'cash' | 'bank'
 player.getBalance(type)
 player.removeBalance(type, amount)
 player.addBalance(type, amount)
 coreModule.CommandAdd(name, permission, cb, suggestion, flags)
 coreModule.Players--players data (still will do synced methods for all framework, now every framework have their players data)
```
