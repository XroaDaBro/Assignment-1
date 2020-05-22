PauseState = Class{__includes = BaseState}

Pauseicon = love.graphics.newImage('Pseed.png')


function PauseState:Init()

end

function PauseState:update(dt)
    if love.keyboard.wasPressed ('p') then
        gStateMachine:change('play')
        scrolling = true
        sounds['music']:play()
    end

end

function PauseState:render()
    love.graphics.setFont (flappyFont)
    love.graphics.printf ( ' Paused!!! ', 0, 50, VIRTUAL_WIDTH,'center')
    love.graphics.setFont (mediumFont)
    love.graphics.printf ( ' Press "p" to continue... ', 0, 100, VIRTUAL_WIDTH,'center')
    love.graphics.draw (Pauseicon, 210, 130)

end

