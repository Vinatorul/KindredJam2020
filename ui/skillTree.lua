Button = require "ui.button"

local skillTree = {}
skillTree.__index = skillTree

local function new()
    local buttons = {}
    return setmetatable({
        w = 350,
        h = 600,
        buttons = buttons
        }, skillTree)
end

function skillTree:draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, self.w, self.h)
    for i = 1, #self.buttons do
        self.buttons[i]:draw()
    end
end

function skillTree:update(dt)
    for i = 1, #self.buttons do
        self.buttons[i]:update(dt)
    end
end

function skillTree:mousereleased(x, y, mouseButton)
    if mouseButton == 1 then
        for i, button in ipairs(self.buttons) do
            if button:checkInside(x, y) then
                button:click()
            end 
        end
    end
end

function skillTree:keypressed(key)
    
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})