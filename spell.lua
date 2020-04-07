local spell = {}
spell.__index = spell

local function new(x, y, r, time, minDmg, maxDmg, speed, angle)
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