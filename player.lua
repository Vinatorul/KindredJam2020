Spell = require "spell"
require "utils.keyboard"
Set = require "utils.set"

local player = {}
player.__index = player

local maxSpeed = 150
local accSpeed = 500
local slowdownSpeed = 250
local playerRadius = 30
local spells = {
    [1] = {
        maxDistance = 100,
        r = 30, 
        time = 0.1, 
        minDmg = 15, 
        maxDmg = 30, 
        speed = 0,
        manaCost = 15, 
    },
    [2] = {
        maxDistance = playerRadius,
        r = 40, 
        time = 0.1, 
        minDmg = 20, 
        maxDmg = 50, 
        speed = 0, 
        manaCost = 10,
    },
    [3] = {
        maxDistance = playerRadius,
        r = 20, 
        time = 2, 
        minDmg = 15, 
        maxDmg = 20, 
        speed = 700,
        manaCost = 15, 
    },
}

local allSkills = {
    spells = Set({1, 2, 3})
}

local function new(x, y)
    x = x or 0
    y = y or 0
    return setmetatable({
        x = x, 
        y = y, 
        dx = 0, 
        dy = 0,
        r = playerRadius,
        hp = 100,
        invTimer = 0,
        currentSpell = 1,
        mana = 100,
        manaRegen = 5,
        skills = Set({1})}, player)
end

function player:update(dt, field)
    self.invTimer = self.invTimer - dt 
    self.mana = math.min(self.mana + self.manaRegen * dt, 100)
    if isKeyDown('w') then
        self.dy = self.dy - accSpeed * dt
    elseif isKeyDown('s') then
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
    if isKeyDown('a') then
        self.dx = self.dx - accSpeed * dt
    elseif isKeyDown('d') then
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
        self:hit(-t)
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

local function castSpell(spellId, x, y, angle, mouseDistance)
    local spellInfo = spells[spellId]
    local distance = math.min(mouseDistance, spellInfo.maxDistance)
    return Spell(
        x + math.cos(angle) * distance, 
        y + math.sin(angle) * distance, 
        spellInfo.r, 
        spellInfo.time, 
        spellInfo.minDmg, 
        spellInfo.maxDmg, 
        spellInfo.speed, 
        angle
    )
end

function player:canCastSpell()
    return self.mana >= spells[self.currentSpell].manaCost
end

function player:castSpell(mouseX, mouseY)
    local distanceX = mouseX - self.x
    local distanceY = mouseY - self.y
    local distance = math.sqrt(distanceX^2 + distanceY^2)
    local angle = math.atan2(distanceY, distanceX)
    if self:canCastSpell() then
        self.mana = self.mana - spells[self.currentSpell].manaCost
        return castSpell(self.currentSpell, self.x, self.y, angle, distance)
    end
end

function player:setSpell(spellId)
    if self.skills:contains(spellId) then
        self.currentSpell = spellId
        return
    end
end

function player:hit(dmg)
    if self.invTimer <= 0 then
        self.hp = self.hp - dmg
        self.invTimer = 0.1
    end
end

function player:alive()
    return self.hp > 0 and self.hp < 200
end

function player:addSkill(skillID)
    self.skills:add(skillID)
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})