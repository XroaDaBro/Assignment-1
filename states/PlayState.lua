--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

TIMER_RANDOM = math.random(-1,3) + 1

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24
--which are located here...
goldcoins0 = love.graphics.newImage('33miss.png')
goldcoins1 = love.graphics.newImage('32miss.png')
goldcoins2 = love.graphics.newImage('31miss.png')
goldcoins3 = love.graphics.newImage('30miss.png')

function PlayState:init()
    self.medal = 0
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 2
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    if counting == 1 then
    self.timer = self.timer + dt

    -- spawn a new pipe pair every second and a half
    if self.timer > TIMER_RANDOM then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-50, -40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))

        -- reset timer
        self.timer = math.random(-1,0.5)
    end
    else
        self.timer = 0
    end 
    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        --here, i made a little piece of code with my own variable in it called self.medal.   
        if self.score == 5 then
            sounds['Medal']:play()
            self.medal = 1
        end
        if self.score == 10 then
            sounds['Medal']:play()
            self.medal = 2
        end
        if self.score == 15 then
            sounds['Medal']:play()
            self.medal = 3
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score, medal = self.medal})
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 36 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score, medal = self.medal})
    end
    -- what i did to make the pause was set the variables running in playstate all 0(zero) so that it would have a pause effect
    if love.keyboard.wasPressed('p') then
        
        pause = 2
        PIPE_SPEED = 0
        scrolling = false
        counting = 2

    end
    if love.mouse.wasPressed(1) then

        pause = 1
        PIPE_SPEED = 60
        scrolling = true
        counting = 1

    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    love.graphics.print('Coins: ' .. tostring(self.medal), 8, 40)
    
    --This is the part of the code where love2d would render the pictures of the gold coins 
    if self.medal == 0 then
        love.graphics.draw( goldcoins0, 8, 80)
    end
    if self.medal == 1 then
        love.graphics.draw( goldcoins1, 8, 80)
    end
    if self.medal == 2 then
        love.graphics.draw( goldcoins2, 8, 80)
    end
    if self.medal == 3 then
        love.graphics.draw( goldcoins3, 8, 80)
    end

    self.bird:render()
    if pause == 2 then
        love.graphics.setFont (flappyFont)
    love.graphics.printf ( ' Paused!!! ', 0, 50, VIRTUAL_WIDTH,'center')
    love.graphics.setFont (mediumFont)
    love.graphics.printf ( ' Tap the screen to continue... ', 0, 100, VIRTUAL_WIDTH,'center')
    love.graphics.draw (Pauseicon, 210, 130)
    end
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
