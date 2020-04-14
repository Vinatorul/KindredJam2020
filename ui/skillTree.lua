Button = require "ui.button"
Constst = require "utils.consts"

local skillTree = {}
skillTree.__index = skillTree

local w = 350
local h = 600
local buttons = {}
local playerSkillTree = nil
local opened = false
local skillStates = {
    [Constst.skillState1] = {enabled = true, grayed = false},
    [Constst.skillState2] = {enabled = false, grayed = false},
    [Constst.skillState3] = {enabled = false, grayed = true},
}

local function f1()
    playerSkillTree:addSkill(Constst.skillTag1)
end

local function f2()
    playerSkillTree:addSkill(Constst.skillTag2)
end

local function f3()
    playerSkillTree:addSkill(Constst.skillTag3)
end

local function new()
    local s1 = Button(25, 100, 250, 40, Constst.skillTag1, f1)
    table.insert(buttons, s1)
    local s2 = Button(50, 150, 250, 40, Constst.skillTag2, f2)
    table.insert(buttons, s2)
    local s3 = Button(50, 200, 250, 40, Constst.skillTag3, f3)
    table.insert(buttons, s3)
end

function skillTree.draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, w, h)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("SP "..playerSkillTree:getSkillPoints(), 25, 50)
    for i = 1, #buttons do
        buttons[i]:draw()
    end
end

function skillTree.update(dt)
    for i = 1, #buttons do    
        buttons[i]:setEnabled(true)
        buttons[i]:setGrayed(false)
        skillState = skillStates[playerSkillTree:getSkillState(buttons[i].tag)]
        buttons[i]:setEnabled(skillState.enabled)
        buttons[i]:setGrayed(skillState.grayed)
        buttons[i]:update(dt)
    end
end

function skillTree.mousereleased(x, y, mouseButton)
    if mouseButton == 1 then
        for i, button in ipairs(buttons) do
            if button:checkInside(x, y) then
                button:click()
            end 
        end
    end
end

function skillTree.getWidth()
    return w
end

function skillTree.keypressed(key)
    
end

function skillTree.open(__playerSkillTree)
    playerSkillTree = __playerSkillTree
    opened = true
end

function skillTree.close()
    playerSkillTree = nil
    opened = false
end

function skillTree.isOpened()
    return opened
end

new()

return skillTree