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
    return setmetatable({x = x, y = y, dx = dx, dy = dy}, player)
end

function player:move(keys, dt, field)
    if keys['w'] then
        self.dy = self.dy - accSpeed * dt
    elseif keys['s'] then
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
    if keys['a'] then
        self.dx = self.dx - accSpeed * dt
    elseif keys['d'] then
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

function player:draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.circle(
        'fill',
        self.x,
        self.y,
        30)
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})