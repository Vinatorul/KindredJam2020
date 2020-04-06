Button = require "ui.button"

local mainMenu = {}
mainMenu.__index = mainMenu

local function newGame()
    state = 2
end

local function openSettings()
    
end

local function new()
    local buttons = {}
    local newGame = Button(100, 100, 200, 40, "New game", newGame)
    table.insert(buttons, newGame)
    local openSettings = Button(100, 200, 200, 40, "Settings", openSettings)
    table.insert(buttons, openSettings)
    local exitGame = Button(100, 300, 200, 40, "Exit game", love.event.quit)
    table.insert(buttons, exitGame)
    return setmetatable({
        buttons = buttons
        }, mainMenu)
end

function mainMenu:draw()
    for i = 1, #self.buttons do
        self.buttons[i]:draw()
    end
end

function mainMenu:update(dt)
    for i = 1, #self.buttons do
        self.buttons[i]:update(dt)
    end
end

function mainMenu:mousereleased(x, y, mouseButton)
    if mouseButton == 1 then
        for i, button in ipairs(self.buttons) do
            if button:checkInside(x, y) then
                button:click()
            end 
        end
    end
end

function mainMenu:keypressed(key)
    
end

return setmetatable({new = new},
    {__call = function(_, ...) return new(...) end})