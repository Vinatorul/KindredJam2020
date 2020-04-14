Game = require "game"
MainMenu = require "ui.mainMenu"

function love.load()
    width, height, flags = love.window.getMode( )
    state = 1
    mainMenu = MainMenu()
end

function newGame()
    game = Game()
    state = 2
    love.mouse.setGrabbed(true)
end

function continueGame()
    if game and not game:over() then
        state = 2
        love.mouse.setGrabbed(true)
    end
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
        game:update(dt)
        if game:over() then
            state = 1
            love.mouse.setGrabbed(false)
        end
    elseif state == 3 then
        game:update(dt)
        mainMenu:update(dt)
        if game:over() then
            state = 1
            love.mouse.setGrabbed(false)
        end
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
            love.mouse.setGrabbed(false)
        elseif state == 3 then
            state = 2
            love.mouse.setGrabbed(true)
        end
    else
        if state == 1 or state == 3 then
            mainMenu:keypressed(key)
        elseif state == 2 then
            game:keypressed(key)
        end
    end
end