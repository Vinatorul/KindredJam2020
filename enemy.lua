local enemy = {}
enemy.__index = enemy

local maxSpeed = 350
local accSpeed = 500

local function new(x, y)
    x = x or 0
    y = y or 0
    local dx = 0
    local dy = 0
    local timer = 0
    return setmetatable({x = x, y = y, dx = dx, dy = dy, timer = timer, keys = {}}, enemy)
end

function enemy:draw()
    love.graphics.setColor(0.7, 0.1, 0.1)
    love.graphics.circle(
        'fill',
        self.x,
        self.y,
        10)
end

function enemy:move(dt, field)
    timer = timer - dt
    if timer < 0 then
        timer = 0.2
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

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})