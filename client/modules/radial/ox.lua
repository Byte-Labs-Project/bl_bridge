---@diagnostic disable: duplicate-set-field


Radial = {}

---@param items RadialMenuItem | RadialMenuItem[]
function Radial.addOption(items)
    lib.addRadialItem(items)
end

---@param id string
function Radial.removeOption(id)
    lib.removeRadialItem(id)
end

---Registers a radial sub menu with predefined options.
---@param radial RadialMenuProps
function Radial.registerRadial(radial)
    lib.registerRadial(radial)
end

---Removes all items from the global radial menu.
function Radial.clear()
    lib.clearRadialItems()
end


---Disables the global radial menu.
---@param state boolean
function Radial.disable(state)
    lib.disableRadial(state)
end

---Returns the current radial menu id.
function Radial.getCurrentId()
    return lib.getCurrentRadialId()
end