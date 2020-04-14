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
    skills[Constst.skillTag3] = Skill(Constst.skillTag3)
    return setmetatable({
        learnedSkills = Set({Constst.parent}),
        skills = skills,
        skillPoints = 4,
    }, skilltree)
end

function skilltree:getSkillState(tag)
    if self.learnedSkills:contains(tag) then
        return Constst.skillState2
    end
    skill = self.skills[tag]
    if skill:getSkillPoints() <= self.skillPoints and 
       skill:getParents():isSubset(self.learnedSkills) then
        return Constst.skillState1
    else
        return Constst.skillState3
    end
end

function skilltree:addSkill(skillTag)
    skill = self.skills[skillTag]
    if self.skillPoints >= skill:getSkillPoints() then
        self.learnedSkills:add(skillTag)
        self.skillPoints = self.skillPoints - skill:getSkillPoints()
    end
end

function skilltree:isSkillLearned(skillTag)
    return self.learnedSkills:contains(skillTag)
end

function skilltree:getSkillPoints()
    return self.skillPoints
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})