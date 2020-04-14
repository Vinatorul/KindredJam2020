Constst = require "utils.consts"
Set = require "utils.set"
Skill = require "skill"

local skilltree = {}
skilltree.__index = skilltree

local function new()
    local skills = {}
    skills[Constst.parent] = Skill(Constst.parent)
    skills[Constst.skillTag1] = Skill(Constst.skillTag1)
    skills[Constst.skillTag2] = Skill(Constst.skillTag2)
    return setmetatable({
        learnedSkills = Set({Constst.parent}),
        skills = skills,
    }, skilltree)
end

function skilltree:getSkillState(tag)
    if self.learnedSkills:contains(tag) then
        return Constst.skillState2
    elseif self.skills[tag]:get_parents():isSubset(self.learnedSkills) then
        return Constst.skillState1
    else
        return Constst.skillState3
    end
end

function skilltree:addSkill(skillID)
    self.learnedSkills:add(skillID)
end

function skilltree:isSkillLearned(skillID)
    return self.learnedSkills:contains(skillID)
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})