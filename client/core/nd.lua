local coreName = 'ND_Core'
if GetResourceState(coreName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData
local jobInfo = {}
local loaded = false

AddEventHandler('ND:characterLoaded', function(character)
    TriggerEvent('bl_bridge:client:playerLoaded')
    jobInfo = character.jobInfo
    jobInfo.name = character.job
    loaded = true
    Wait(1000)
end)

AddEventHandler("ND:characterUnloaded", function(character)
    TriggerEvent('bl_bridge:client:playerUnloaded')
    jobInfo = {}
    loaded = false
end)

RegisterNetEvent('ND:updateCharacter', function(character)
    local jobData = character.jobInfo
    if character.job ~= jobInfo.name or jobInfo.rank ~= jobData.rank then
        TriggerEvent('bl_bridge:client:jobUpdated', { name = character.job, label = jobData.label, onDuty = true, isBoss = jobData.isBoss or false, grade = { name = jobData.rank, label = jobData.rankName, salary = 0 } })
    end
end)

local shared = exports[coreName]

local coreFunctionsOverride = {
    playerData = {
        originalMethod = 'getPlayer',
        modifier = {
            executeFun = true,
            effect = function(originalFun)
                lib.waitFor(function() if loaded then return true end end, nil, 10000)
                local data = originalFun()
                local jobData = data.jobInfo

                local year, month, day = data.dob.birthdate:match("(%d+)-(%d+)-(%d+)")

                return {
                    cid = data.id,
                    money = data.cash,
                    inventory = type(data.inventory) == 'string' and json.decode(data.inventory) or data.inventory,
                    job = { name = data.job, label = jobData.label, onDuty = true, isBoss = jobData.isBoss, grade = { name = jobData.rank, label = jobData.rankName, salary = 0 } },
                    firstName = data.firstname,
                    lastName = data.lastname,
                    phone = 'Unknown',
                    gender = string.lower(data.gender),
                    dob = ('%s/%s/%s'):format(month, day, year),
                }
            end
        }
    },
}

function Core.getPlayerData()
    local wrappedPlayer = retreiveStringIndexedData(shared, coreFunctionsOverride)
    return wrappedPlayer.playerData
end

function Core.playerLoaded()
    return loaded
end

return Core
