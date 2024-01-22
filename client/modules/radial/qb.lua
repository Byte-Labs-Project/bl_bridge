---@diagnostic disable: duplicate-set-field


Radial = {}

local qbRadial = exports['qb-radialmenu']


local overRideData = {
    id = {
        originalMethod = 'id',
    },
    txt = {
        originalMethod = 'description',
    },
    icon = {
        originalMethod = 'icon',
    },
    menu = {
        originalMethod = 'menu',
    },
    label = {
        originalMethod = 'title',
    },
}

---@param items RadialMenuItem | RadialMenuItem[]
function Radial.addOption(items)

    if type(items) == 'table' then
        for _, item in ipairs(items) do
            local id = item.id

            for key, value in pairs(overRideData) do
                if item[key] then
                    item[value.originalMethod] = item[key]
                    item[key] = nil
                end
            end

            qbRadial:AddOption(item, id)
        end
    else
        local id = items.id


        qbRadial:AddOption(items, id)
    end
end

---@param id string
function Radial.removeOption(id)
    qbRadial:RemoveOption(id)
end

---Registers a radial sub menu with predefined options.
---@param radial RadialMenuProps
function Radial.registerRadial(radial)
    -- lib.registerRadial(radial)
    return
end

---Removes all items from the global radial menu.
function Radial.clear()
    -- lib.clearRadialItems()
    return
end


---Disables the global radial menu.
---@param state boolean
function Radial.disable(state)
    -- lib.disableRadial(state)
    return
end

---Returns the current radial menu id.
function Radial.getCurrentId()
    -- return lib.getCurrentRadialId()
    return
end