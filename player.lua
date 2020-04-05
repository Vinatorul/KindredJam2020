Spell = require "spell"

local player = {}
player.__index = player

local maxSpeed = 150
local accSpeed = 500
local slowdownSpeed = 250

local function new(x, y)
    x = x or 0
    y = y or 0
    return setmetatable({
        x = x, 
        y = y, 
        dx = 0, 
        dy = 0,
        r = 30,
        hp = 100,
        invTimer = 0,
        currentSpell = 1,
        mana = 100,
        manaRegen = 5}, player)
end

function player:update(dt, field)
    self.invTimer = self.invTimer - dt 
    self.mana = math.min(self.mana + self.manaRegen * dt, 100)
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
    if field:isWalkable(newX, newY) >= 0 then
        self.x = newX
        self.y = newY
    elseif field:isWalkable(self.x, newY) >= 0 then       
        self.y = newY
        self.dx = 0
    elseif field:isWalkable(newX, self.y) >= 0 then 
        self.x = newX
        self.dy = 0
    end 
    local t = field:isWalkable(self.x, self.y) 
    if t > 0 then
        self:hit(t)
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
    love.graphics.print(math.floor(self.hp), self.x, self.y)
    love.graphics.print(math.floor(self.mana), self.x, self.y + 25)
    love.graphics.print(self.currentSpell, self.x, self.y + 50)
end

function player:castSpell(mouseX, mouseY)
    local distanceX = mouseX - self.x
    local distanceY = mouseY - self.y
    local distance = math.min(math.sqrt(distanceX^2 + distanceY^2), 100)
    local angle = math.atan2(distanceY, distanceX)
    if self.currentSpell == 1 and self.mana >= 10 then
        self.mana = self.mana - 10
        return Spell(self.x + math.cos(angle) * self.r,
            self.y + math.sin(angle) * self.r,
            40,
            0.1,
            20,
            50)
    elseif self.currentSpell == 2 and self.mana >= 15 then
        self.mana = self.mana - 15
        return Spell(self.x + math.cos(angle) * distance,
            self.y + math.sin(angle) * distance,
            30,
            0.1,
            15,
            30)
    elseif self.currentSpell == 3 and self.mana >= 15 then
        self.mana = self.mana - 15
        return Spell(self.x + math.cos(angle) * distance,
            self.y + math.sin(angle) * distance,
            20,
            2,
            15,
            20,
            700,
            angle)
    elseif self.currentSpell == 4 and self.mana >= 50 then
        self.mana = self.mana - 50
        self.hp = self.hp + 10
    end
end

function player:setSpell(spellId)
    self.currentSpell = spellId
end

function player:hit(dmg)
    if self.invTimer <= 0 then
        self.hp = self.hp - dmg
        self.invTimer = 0.1
    end
end

function player:alive()
    return self.hp > 0
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})