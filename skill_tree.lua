Constst = require "utils.consts"
Set = require "utils.set"

local skilltree = {}
skilltree.__index = skilltree

local function new()
    return setmetatable({
        skills = Set({1}),
    }, skilltree)
end

function skilltree:getSkillState(tag)
    return Constst.skillState1
end

function skilltree:addSkill(skillID)
    self.skills:add(skillID)
end

function skilltree:isSkillLearned(skillID)
    return self.skills:contains(skillID)
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})