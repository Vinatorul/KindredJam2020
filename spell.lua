local spell = {}
spell.__index = spell

local maxSpeed = 350
local accSpeed = 500

local function new(x, y, r, time, minDmg, maxDmg, speed, angle)
    x = x or 0
    y = y or 0
    r = r or 30
    time = time or 1
    minDmg = minDmg or 20
    maxDmg = maxDmg or 50
    speed = speed or 0
    angle = angle or 0
    return setmetatable({
        x = x, 
        y = y, 
        speed = speed,
        angle = angle,
        time = time, 
        r = r,
        minDmg = minDmg,
        maxDmg = maxDmg}, spell)
end

function spell:draw()
    love.graphics.setColor(0.9, 0.5, 0.0, 0.7)
    love.graphics.circle(
        'fill',
        self.x,
        self.y,
        self.r)
end

function spell:update(dt)
    self.time = self.time - dt
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
end

function spell:alive()
    return self.time > 0
end

function spell:getDmg()
    return love.math.random(self.minDmg, self.maxDmg)
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})