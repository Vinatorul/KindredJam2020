local enemy = {}
enemy.__index = enemy

local maxSpeed = 350
local accSpeed = 500

local function new(x, y)
    x = x or 0
    y = y or 0
    return setmetatable({
        x = x, 
        y = y, 
        r = 10,
        dx = 0, 
        dy = 0, 
        timer = 0, 
        keys = {},
        hp = 100,
        hpRegen = 1,
        minDmg = 5,
        maxDmg = 10,
        invTimer = 0}, enemy)
end

function enemy:draw()
    love.graphics.setColor(0.7, 0.1, 0.1)
    love.graphics.circle(
        'fill',
        self.x,
        self.y,
        self.r)
    love.graphics.print(math.floor(self.hp), self.x, self.y)
end

function enemy:update(dt, field)
    self.timer = self.timer - dt
    self.invTimer = self.invTimer - dt
    self.hp = math.min(self.hp + self.hpRegen * dt, 100)
    if self.timer < 0 then
        self.timer = 0.2
        self.keys = {
            ["w"] = love.math.random(0, 1) == 1,
            ["s"] = love.math.random(0, 1) == 1, 
            ["d"] = love.math.random(0, 1) == 1, 
            ["a"] = love.math.random(0, 1) == 1, 
        }
    end
    if self.keys['w'] then
        self.dy = self.dy - accSpeed * dt
    end
    if self.keys['s'] then
        self.dy = self.dy + accSpeed * dt
    end
    if self.keys['a'] then
        self.dx = self.dx - accSpeed * dt
    end
    if self.keys['d'] then
        self.dx = self.dx + accSpeed * dt
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
end

function enemy:getDmg()
    return love.math.random(self.minDmg, self.maxDmg)
end

function enemy:hit(dmg)
    if self.invTimer <= 0 then
        self.hp = self.hp - dmg
        self.invTimer = 0.1
    end
end

function enemy:alive()
    return self.hp > 0
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})