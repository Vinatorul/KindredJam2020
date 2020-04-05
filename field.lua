local field = {}
field.__index = field

local tileSize = 64

local function new()
    love.graphics.setBackgroundColor(0.2, 0.2, 0.7)
    local tiles = {
        {-1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0},
        {-2, -1, 0, 0, 0, 0, 0, 0, -2, -1, 0, 0, 0, 0, 0, 0, 0},
        {-2, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-2, -1, 0, -1, 0, 0, 0, 0, 0, 0, 0, -4, 0, 0, 0, 0, 1},
        {-1, -1, 0, -1, -1, 0, 0, 0, 0, 0, 0, -4, 0, 0, 0, 1, 1},
        {-2, -1, 0, -1, -1, 0, 0, 0, 0, -3, 0, 0, 0, 0, 0, -1, 1},
        {-1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1},
        {-1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 1, 1, 0, 0, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 1, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, -3, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, -3, 0, 0, 0, 0},
        {-1, -1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 1, 1, 1, 1, 1, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 1, 1, 1, -1, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    }
    return setmetatable({tiles = tiles}, field)
end

function field:draw()
    local function chooseColor(tileId)
        if tileId == 0 then
            love.graphics.setColor(0.2, 0.8, 0.2)
        elseif tileId == -2 then
            love.graphics.setColor(0.2, 0.2, 0.7)
        elseif tileId == -1 then
            love.graphics.setColor(0.2, 0.2, 0.9)
        elseif tileId == -3 then
            love.graphics.setColor(0.22, 0.83, 0.22)
        elseif tileId == -4 then
            love.graphics.setColor(0.7, 0.1, 0.1)
        elseif tileId == 1 then
            love.graphics.setColor(0.3, 0.3, 0.3)
        end
    end

    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            chooseColor(self.tiles[y][x])
            love.graphics.rectangle(
                'fill', 
                (x - 1) * tileSize,
                (y - 1) * tileSize,
                tileSize,
                tileSize
                )
        end
    end
end

function field:isWalkable(x, y)
    local tileX = math.ceil(x / tileSize)
    local tileY = math.ceil(y / tileSize)
    if tileY < 1 or tileY > #self.tiles or
       tileX < 1 or tileX > #self.tiles[tileY] then
        return -1
    else
        local tile = self.tiles[tileY][tileX]
        if tile == 0 then
            return 0
        elseif tile == -1 then
            return 1
        elseif tile == -3 then
            return 5
        elseif tile == -4 then
            return 80
        else
            return -1
        end
    end
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})