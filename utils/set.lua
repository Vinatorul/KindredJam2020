local set = {}
set.__index = set

local function new(list)
    local innerData = {}
    for i, item in ipairs(list) do
        innerData[item] = true
    end
    return setmetatable({
        innerData = innerData
    }, set)
end

function set:add(t)
    self.innerData[t] = true
end

function set:remove(t)
    self.innerData[t] = nil
end

function set:contains(t)
    return self.innerData[t] ~= nil
end

function set:size()
    return #self.innerData
end

function set:union(other)
    local list = {}
    for item in pairs(self.innerData) do
        table.insert(list, item)
    end
    for item in pairs(other.innerData) do
        table.insert(list, item)
    end
    return Set(list)
end

function set:intersection(other)
    local list = {}
    for item in pairs(self.innerData) do
        if other:contains(item) then
            table.insert(list, item)
        end
    end
    return Set(list)
end

function set:isSubset(other)
    for item in pairs(self.innerData) do
        if not other:contains(item) then
            return false
        end
    end
    return true
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})