local field = {}
field.__index = field

local tileSize = 64

local function new()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.8)
    local tiles = {
        {-1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0},
        {-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, -1, -1, -1, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    }
    return setmetatable({tiles = tiles}, field)
end

function field:draw()
    local function chooseColor(tileId)
        if tileId == 0 then
            love.graphics.setColor(0.1, 0.8, 0.1)
        elseif tileId == -1 then
            love.graphics.setColor(0.1, 0.1, 0.8)
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
        return false
    else
        return self.tiles[tileY][tileX] == 0
    end
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})