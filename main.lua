Camera = require "camera"
Player = require "player"
Field = require "field"

function love.load()
    width, height, flags = love.window.getMode( )
    camera = Camera()
    player = Player(100, 100)
    field = Field(s)
    timer = 0
end

function love.draw()
    local function drawWorld()
        field:draw()
        player:draw()
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
    keysPressed = {
        ["w"] = love.keyboard.isDown('w'),
        ["s"] = love.keyboard.isDown('s'), 
        ["d"] = love.keyboard.isDown('d'), 
        ["a"] = love.keyboard.isDown('a'), 
        }
    player:move(keysPressed, dt, field)
    
    timer = timer + dt

    if timer > 0.01 then
        timer = timer - 0.01
        -- camera:rotate(3.14/180)
       -- camera:zoom(1.001)
    end
end