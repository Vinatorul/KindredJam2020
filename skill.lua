Constst = require "utils.consts"
Set = require "utils.set"

local skill = {}
skill.__index = skill

local skillsInfo = {
    [Constst.parent] = {
        parents = {},
    },
    [Constst.skillTag1] = {
        parents = {Constst.parent},
    },
    [Constst.skillTag2] = {
        parents = {Constst.skillTag1}
    }
}

local function new(tag)
    return setmetatable({
        tag = tag,
        parents = Set(skillsInfo[tag].parents)
    }, skill)
end

function skill:get_parents()
    return self.parents
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})

