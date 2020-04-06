local button = {}
button.__index = button

local function new(x, y, w, h, text, callback)
    return setmetatable({
        x = x,
        y = y,
        w = w,
        h = h,
        text = text,
        callback = callback
        }, button)
end

function button:draw()
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setNewFont(32)
    love.graphics.print(self.text, self.x, self.y)
end

function button:update(dt)

end

function button:click()
    self.callback()
end

function button:checkInside(x, y)
    return self.x <= x and self.x + self.w >= x and 
        self.y <= y and self.h + self.y >= y
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})