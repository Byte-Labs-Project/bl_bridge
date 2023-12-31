local Core = {}
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData

AddEventHandler('esx:playerLoaded', function()
    TriggerEvent('bl_bridge:client:playerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    TriggerEvent('bl_bridge:client:playerUnloaded')
end)

RegisterNetEvent('esx:setJob', function(...)
    TriggerEvent('bl_bridge:client:jobUpdated', ...)
end)

local shared = exports['es_extended']:getSharedObject()

local coreFunctionsOverride = {
    playerData = {
        originalMethod = 'PlayerData',
        modifier = {
            executeFun = true,
            effect = function(originalFun)
                local data = originalFun
                local job = data.job
                return {
                    cid = data.identifier,
                    money = data.accounts,
                    inventory = data.inventory,
                    job = {name = job.name, label = job.label, onDuty = true, isBoss = false, grade = {name = job.grade_name, label = job.grade_label, salary = job.grade_salary}},
                    firstName = data.firstName,
                    lastName = data.lastName,
                }
            end
        }
    },
}

function Core.getPlayerData()
    local wrappedPlayer = retreiveStringIndexedData(shared, coreFunctionsOverride)
    return wrappedPlayer.playerData
end

return Core
