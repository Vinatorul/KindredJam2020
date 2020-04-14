Constst = require "utils.consts"
Set = require "utils.set"

local skill = {}
skill.__index = skill

local skillsInfo = {
    [Constst.parent] = {
        parents = {},
        skillPoints = 0,
    },
    [Constst.skillTag1] = {
        parents = {Constst.parent},
        skillPoints = 1,
    },
    [Constst.skillTag2] = {
        parents = {Constst.skillTag1},
        skillPoints = 2,
    },
    [Constst.skillTag3] = {
        parents = {Constst.skillTag1},
        skillPoints = 2,
    }
}

local function new(tag)
    local skillInfo = skillsInfo[tag] 
    return setmetatable({
        tag = tag,
        parents = Set(skillInfo.parents),
        skillPoints = skillInfo.skillPoints,
    }, skill)
end

function skill:getParents()
    return self.parents
end

function skill:getSkillPoints()
    return self.skillPoints
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})

