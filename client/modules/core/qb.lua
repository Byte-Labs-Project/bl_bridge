local Core = {}
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('bl_bridge:client:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent('bl_bridge:client:playerUnloaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(...)
    TriggerEvent('bl_bridge:client:jobUpdated', ...)
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(...)
    TriggerEvent('bl_bridge:client:gangUpdated', ...)
end)

local shared = exports['qb-core']:GetCoreObject()

local coreFunctionsOverride = {
    Functions = {
        playerData = {
            originalMethod = 'GetPlayerData',
            modifier = {
                executeFun = true,
                effect = function(originalFun)
                    local data = originalFun()
                    local job = data.job
                    local gang = data.gang
                    return {
                        cid = data.citizenid,
                        money = data.money,
                        inventory = data.inventory,
                        job = { name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, grade = { name = job.grade.level, label = job.grade.label, salary = job.payment } },
                        gang = { name = gang.name, label = gang.label, isBoss = gang.isboss, grade = { name = gang.grade.level, label = gang.grade.label } },
                        firstName = data.charinfo.firstname,
                        lastName = data.charinfo.lastname,
                    }
                end
            }
        },
    },
}

function Core.getPlayerData()
    local wrappedPlayer = retreiveStringIndexedData(shared, coreFunctionsOverride)
    return wrappedPlayer.playerData
end

return Core
