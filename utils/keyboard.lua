function isKeyDown(key)
    if state == 2 or state == 4 then 
        return love.keyboard.isDown(key)
    else
        return false
    end
end