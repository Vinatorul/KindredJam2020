Spell = require "spell"

local player = {}
player.__index = player

local maxSpeed = 150
local accSpeed = 500
local slowdownSpeed = 250

local function new(x, y)
    x = x or 0
    y = y or 0
    local dx = 0
    local dy = 0
    return setmetatable({
        x = x, 
        y = y, 
        dx = dx, 
        dy = dy,
        r = 30}, player)
end

function player:update(dt, field)
    if love.keyboard.isDown('w') then
        self.dy = self.dy - accSpeed * dt
    elseif love.keyboard.isDown('s') then
        self.dy = self.dy + accSpeed * dt
    elseif self.dy > 0 then
        self.dy = self.dy - slowdownSpeed * dt
        if self.dy < 0 then
            self.dy = 0
        end
    elseif self.dy < 0 then
        self.dy = self.dy + slowdownSpeed * dt
        if self.dy > 0 then
            self.dy = 0
        end
    end
    if love.keyboard.isDown('a') then
        self.dx = self.dx - accSpeed * dt
    elseif love.keyboard.isDown('d') then
        self.dx = self.dx + accSpeed * dt
    elseif self.dx > 0 then
        self.dx = self.dx - slowdownSpeed * dt
        if self.dx < 0 then
            self.dx = 0
        end
    elseif self.dx < 0 then
        self.dx = self.dx + slowdownSpeed * dt
        if self.dx > 0 then
            self.dx = 0
        end
    end 
    if self.dx > maxSpeed then
        self.dx = maxSpeed
    elseif self.dx < -maxSpeed then
        self.dx = -maxSpeed
    end
    if self.dy > maxSpeed then
        self.dy = maxSpeed
    elseif self.dy < -maxSpeed then
        self.dy = -maxSpeed
    end
    local newX = self.x + self.dx * dt
    local newY = self.y + self.dy * dt
    if field:isWalkable(newX, newY) then
        self.x = newX
        self.y = newY
    elseif field:isWalkable(self.x, newY) then       
        self.y = newY
        self.dx = 0
    elseif field:isWalkable(newX, self.y) then 
        self.x = newX
        self.dy = 0
    end 
end

function player:draw(mouseX, mouseY)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.circle(
        'fill',
        self.x,
        self.y,
        self.r)
    local distanceX = mouseX - self.x
    local distanceY = mouseY - self.y
    local distance = math.sqrt(distanceX^2 + distanceY^2)
    local angle = math.atan2(distanceY, distanceX)
    local eyeBallX = self.x + math.cos(angle) * math.min(distance, self.r - 5)
    local eyeBallY = self.y + math.sin(angle) * math.min(distance, self.r - 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', eyeBallX, eyeBallY, 5)
end

function player:castSpell(mouseX, mouseY)
    local distanceX = mouseX - self.x
    local distanceY = mouseY - self.y
    local angle = math.atan2(distanceY, distanceX)  
    return Spell(self.x + math.cos(angle) * self.r,
        self.y + math.sin(angle) * self.r,
        40,
        0.1)
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})