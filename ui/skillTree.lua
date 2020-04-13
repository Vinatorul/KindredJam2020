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
    playerSkillTree:addSkill(2)
end

local function f2()
    playerSkillTree:addSkill(3)
end

local function new()
    local s1 = Button(25, 25, 250, 40, "123", f1)
    table.insert(buttons, s1)
    local s2 = Button(25, 75, 250, 40, "456", f2)
    table.insert(buttons, s2)
end

function skillTree.draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, w, h)
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