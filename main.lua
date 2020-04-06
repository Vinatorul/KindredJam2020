Game = require "game"
MainMenu = require "ui.mainMenu"

function love.load()
    width, height, flags = love.window.getMode( )
    state = 1
    game = Game()
    mainMenu = MainMenu()
end

function love.draw()
    if state == 1 then
        mainMenu:draw()
    elseif state == 2 then
        game:draw()
    elseif state == 3 then
        game:draw()
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, width, height)
        mainMenu:draw()
    end
    love.graphics.setNewFont(32)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.update(dt)
    if state == 1 then
        mainMenu:update(dt)
    elseif state == 2 then
        if not game:update(dt) then
            state = 1
        end 
    elseif state == 3 then
        if not game:update(dt) then
            state = 1
        end
        mainMenu:update(dt)
    end
end

function love.mousereleased(x, y, button)   
    if state == 1 or state == 3 then
        mainMenu:mousereleased(x, y, button)
    elseif state == 2 then
        game:mousereleased(button)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        if state == 1 then
            love.event.quit()
        elseif state == 2 then
            state = 3
        elseif state == 3 then
            state = 2
        end
    else
        if state == 1 or state == 3 then
            mainMenu:keypressed(key)
        elseif state == 2 then
            game:keypressed(key)
        end
    end
end