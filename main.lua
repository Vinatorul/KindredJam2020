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
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.update(dt)
    player:update(dt, field)
    for i = 1, #enemies do
        enemies[i]:move(dt, field)
    end
    for i = #spells, 1, -1 do
        spells[i]:update(dt)
        if not spells[i]:alive() then
            table.remove(spells, i)
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