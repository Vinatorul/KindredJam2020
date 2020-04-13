local skill = {}
skill.__index = skill


local function new()
    return setmetatable({

    }, skilltree)
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})

return skill