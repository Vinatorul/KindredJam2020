local spell = {}
spell.__index = spell

local maxSpeed = 350
local accSpeed = 500

local function new(x, y, r, time)
    x = x or 0
    y = y or 0
    r = r or 30
    time = time or 1
    return setmetatable({x = x, y = y, time = time, r = r}, spell)
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
end

function spell:alive()
    return self.time > 0
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})