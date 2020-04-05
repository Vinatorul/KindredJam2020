Camera = require "camera"
Player = require "player"
Field = require "field"
Enemy = require "enemy"

function love.load()
    width, height, flags = love.window.getMode( )
    camera = Camera()
    player = Player(100, 100)
    field = Field(s)
    enemies = {}
    for i = 1, 10 do
        enemies[i] = Enemy(love.math.random(1000), love.math.random(1000))
    end
    spells = {}
    timer = 0
end

function love.draw()
    local function drawWorld()
        field:draw()
        for i = 1, #enemies do
            enemies[i]:draw()
        end
        for i = 1, #spells do
            spells[i]:draw()
        end
        local mouseX, mouseY = camera:mousePosition()
        player:draw(mouseX, mouseY)
    end

    camera:lockWindow(player.x, player.y, 390, 410, 290, 310)
    camera:zoomTo(1)
    camera:attach()
    drawWorld()
    camera:detach()
    love.graphics.setNewFont(32)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.update(dt)

    function checkCollision(first, second)
        return (first.x - second.x) ^ 2 + (first.y - second.y) ^ 2 <= 
            (first.r + second.r) ^ 2
    end

    player:update(dt, field)
    for i = 1, #enemies do
        enemies[i]:update(dt, field)
    end
    for i = #spells, 1, -1 do
        spells[i]:update(dt)
        if not spells[i]:alive() then
            table.remove(spells, i)
        end
    end
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        if checkCollision(enemy, player) then
            player:hit(enemy:getDmg())
            if not player:alive() then
                love.load()
            end
        end
        for j, spell in ipairs(spells) do
            if checkCollision(enemy, spell) then
                enemy:hit(spell:getDmg())
                if not enemy:alive() then
                    table.remove(enemies, i)
                    break
                end
            end
        end
    end
    
    timer = timer + dt

    if timer > 0.01 then
        timer = timer - 0.01
        --camera:rotate(3.14/180)
       -- camera:zoom(1.001)
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        local mouseX, mouseY = camera:mousePosition()
        local spell = player:castSpell(mouseX, mouseY)     
        table.insert(spells, spell)
    end
end

function love.keypressed(key)
    if key == "1" then
        player:setSpell(1)
    elseif key == "2" then
        player:setSpell(2)
    elseif key == "3" then
        player:setSpell(3)
    elseif key == "4" then
        player:setSpell(4)
    end
end