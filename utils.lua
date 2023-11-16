local Utils = {}

local function retreiveExportsData(export, override)
    local newMethods = {}

    for k,v in pairs(override) do
        local method = export[v.originalMethod]
        if method then
            v.selfEffect = function(...)
                return method(export, ...)
            end
            newMethods[k] = v
        end
    end
    return newMethods
end

local function modifyMethods(data, overrides, src)
    local newMethods = {}

    for dataIndex, dataValue in ipairs(data) do
        for method, modification in pairs(overrides) do
            local originalMethod = modification.originalMethod
            local originalMethodRef = originalMethod and (modification.selfEffect or dataValue[originalMethod])

            if originalMethod == 'none' then
                local hasKeys = modification.hasKeys
                for _, key in ipairs(hasKeys) do
                    if dataValue[key] then
                        newMethods[dataIndex] = newMethods[dataIndex] or {}
                        newMethods[dataIndex][method] = {[key] = dataValue[key]}
                    end
                end
            elseif originalMethodRef then
                local modifier = modification.modifier
                newMethods[dataIndex] = newMethods[dataIndex] or {}
                
                local lastEffect
                if modifier then
                    local executeFun, effect, passSource in modifier

                    if passSource and executeFun then
                        lastEffect = originalMethodRef(src)
                    elseif passSource then
                        lastEffect = function(...)
                            return originalMethodRef(src, ...)
                        end
                    elseif executeFun then
                        lastEffect = effect(originalMethodRef)
                    else
                        lastEffect = function(...)
                            return passSource and effect(originalMethodRef, src, ...) or effect(originalMethodRef, ...)
                        end
                    end
                else
                    lastEffect = originalMethodRef
                end

                newMethods[dataIndex][method] = lastEffect
            end
        end
    end

    return newMethods
end

local function retreiveStringIndexedData(wrappedData, functionsOverride, src)
    local newMethods = {}

    -- local function modifyMethods(data, overrides)
    --     for method, modification in pairs(overrides) do
    --         if type(modification) == 'table' then
    --             local selfEffect = modification.selfEffect
    --             local originalMethod = selfEffect or modification.originalMethod
    --             local ref = selfEffect or data[originalMethod]
    --             local modifier = modification.modifier
    --             if ref and originalMethod then
    --                 local lastEffect
    --                 if modifier then
    --                     local executeFun, effect, passSource in modifier

    --                     if passSource and executeFun then
    --                         lastEffect = ref(src)
    --                     elseif passSource then
    --                         lastEffect = function(...)
    --                             return ref(src, ...)
    --                         end
    --                     elseif executeFun then
    --                         lastEffect = effect(ref)
    --                     else
    --                         lastEffect = function(...)
    --                             return passSource and effect(ref, src, ...) or effect(ref, ...)
    --                         end
    --                     end
    --                 else
    --                     lastEffect = ref
    --                 end
    --                 newMethods[method] = lastEffect
    --             end
    --         end
    --     end
    -- end

    local function processTable(tableToProcess, overrides)
        for method, modification in pairs(overrides) do
            if type(modification) == 'table' and not modification.originalMethod and not modification.add then
                processTable(tableToProcess[method], modification)
            else
                modifyMethods(tableToProcess, overrides, src)
            end
        end
    end

    processTable(wrappedData, functionsOverride)
    return newMethods
end

local function retreiveNumberIndexedData(playerTable, functionsOverride)
    local newMethods = {}

    -- local function modifyMethods(data, overrides)
    --     for dataIndex, dataValue in ipairs(data) do
    --         for method, modification in pairs(overrides) do
    --             local originalMethod = modification.originalMethod
    --             local originalMethodRef = originalMethod and dataValue[originalMethod]

    --             if originalMethod == 'none' then
    --                 local hasKeys = modification.hasKeys
    --                 for _, key in ipairs(hasKeys) do
    --                     if dataValue[key] then
    --                         newMethods[dataIndex] = newMethods[dataIndex] or {}
    --                         newMethods[dataIndex][method] = {[key] = dataValue[key]}
    --                     end
    --                 end
    --             elseif originalMethodRef then
    --                 local modifier = modification.modifier
    --                 newMethods[dataIndex] = newMethods[dataIndex] or {}
    --                 newMethods[dataIndex][method] = modifier and (modifier.executeFun and modifier.effect(originalMethodRef) or function(...)
    --                     return modifier.effect(originalMethodRef, ...)
    --                 end) or originalMethodRef
    --             end
                
    --         end
    --     end
    -- end

    local function processTable(tableToProcess, overrides)
        for _, value in ipairs(tableToProcess) do
            for method, modification in pairs(overrides) do
                if type(modification) == 'table' and not modification.originalMethod then
                    processTable(value[method], modification)
                else
                    modifyMethods(tableToProcess, overrides)
                end
            end
        end

    end

    processTable(playerTable, functionsOverride)
    return newMethods
end

local function UUID(num)
    num = type(num) == 'number' and num or 5
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    
    local uuid = string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)

    local timestamp = os.time()
    local uuidWithTime = string.format("%s-%s", uuid, timestamp)
    
    if num > 0 and num <= #uuidWithTime then
        uuidWithTime = string.sub(uuidWithTime, 1, num)
    end

    return uuidWithTime
end
exports('UUID', UUID)

local math_random = math.random

exports('generatePlate', function()
    local platerandomizer = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
	local newPlate = math_random(1,9) .. math_random(1, 9) .. platerandomizer[math_random(1,#platerandomizer)] .. platerandomizer[math_random(1,#platerandomizer)] .. platerandomizer[math_random(1,#platerandomizer)] .. platerandomizer[math_random(1,#platerandomizer)] .. math_random(1,9) .. math_random(1,9)
    return newPlate
end)

Utils.retreiveStringIndexedData = retreiveStringIndexedData
Utils.retreiveExportsData = retreiveExportsData
Utils.retreiveNumberIndexedData = retreiveNumberIndexedData
Utils.UUID = UUID
return Utils