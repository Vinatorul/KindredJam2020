Camera = require "camera"
Player = require "player"
Field = require "field"
Enemy = require "enemy"
SkillTree = require "ui.skillTree"

local game = {}
game.__index = game

local function new()
    local camera = Camera()
    local player = Player(100, 100)
    local field = Field(s)
    local enemies = {}
    for i = 1, 10 do
        enemies[i] = Enemy(love.math.random(1000), love.math.random(1000))
    end
    local spells = {}
    return setmetatable({
        camera = camera, 
        player = player, 
        field = field,
        enemies = enemies,
        spells = spells,
        skillTreeOpened = false,
        skillTree = SkillTree()}, game)
end

function game:draw()
    local function drawWorld()
        self.field:draw()
        for i = 1, #self.enemies do
            self.enemies[i]:draw()
        end
        for i = 1, #self.spells do
            self.spells[i]:draw()
        end
        local mouseX, mouseY = self.camera:mousePosition()
        self.player:draw(mouseX, mouseY)
    end
    local lockX, lockY = self.player.x, self.player.y
    if self.skillTreeOpened then
        lockX = lockX - self.skillTree.w / 2
    end
    self.camera:lockWindow(lockX, lockY, 390, 410, 290, 310)
    self.camera:zoomTo(1)
    self.camera:attach()
    drawWorld()
    self.camera:detach()
    if self.skillTreeOpened then
        self.skillTree:draw()
    end
end

function game:update(dt)

    function checkCollision(first, second)
        return (first.x - second.x) ^ 2 + (first.y - second.y) ^ 2 <= 
            (first.r + second.r) ^ 2
    end
    
    self.player:update(dt, self.field)
    for i = 1, #self.enemies do
        self.enemies[i]:update(dt, self.field)
    end
    for i = #self.spells, 1, -1 do
        self.spells[i]:update(dt)
        if not self.spells[i]:alive() then
            table.remove(self.spells, i)
        end
    end
    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        if checkCollision(enemy, self.player) then
            self.player:hit(enemy:getDmg())
        end
        for j, spell in ipairs(self.spells) do
            if checkCollision(enemy, spell) then
                local dmg = enemy:hit(spell:getDmg())     
                self.player:hit(dmg)
            end
        end
        if not enemy:alive() then
            table.remove(self.enemies, i)
        end
    end
end

function game:over()
    return not self.player:alive()
end

function game:mousereleased(button)
    if button == 1 then
        local mouseX, mouseY = self.camera:mousePosition()
        local spell = self.player:castSpell(mouseX, mouseY)     
        table.insert(self.spells, spell)
    end
end

function game:keypressed(key)
    if key == "1" then
        self.player:setSpell(1)
    elseif key == "2" then
        self.player:setSpell(2)
    elseif key == "3" then
        self.player:setSpell(3)
    elseif key == "f" then
        self.skillTreeOpened = not self.skillTreeOpened
    end
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})