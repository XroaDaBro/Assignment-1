--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}
--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

reward0 =love.graphics.newImage('33miss.png')
reward1 = love.graphics.newImage('32miss.png')
reward2 = love.graphics.newImage('31miss.png')
reward3 = love.graphics.newImage('30miss.png')

function ScoreState:enter(params)
    self.score = params.score
    self.medal = params.medal
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oh no! Fifty crashed!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf(' Final Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf(' Gold  Coins: ' .. tostring(self.medal), 0, 120, VIRTUAL_WIDTH, 'center')

    if self.medal == 0 then
        love.graphics.draw(reward0, 220, 160)
    end
    if self.medal == 1 then 
        love.graphics.draw(reward1, 220, 160)
    end
    if self.medal == 2 then 
        love.graphics.draw(reward2, 220, 160)
    end
    if self.medal == 3 then 
        love.graphics.draw(goldcoins3, 220, 160)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 210, VIRTUAL_WIDTH, 'center')
end