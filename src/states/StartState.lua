--[[
    GD50
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Match-3" in large text, as well as a message to press
    Enter to begin.
]]

local positions = {}

StartState = Class{__includes = BaseState}

function StartState:init()
    -- currently selected menu item
    self.currentMenuItem = 1

    -- generate full table of tiles just for display
    for i = 1, 64 do
        table.insert(positions, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    -- used to animate our full-screen transition rect
    self.transitionAlpha = 0

    -- if we've selected an option, we need to pause input while we animate out
    self.pauseInput = false
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- as long as can still input, i.e., we're not in a transition...
    if not self.pauseInput then
        -- change menu selection
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            gSounds['select']:play()
        end

        -- switch to another state via one of the menu options
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 1 then
                -- tween, using Timer, the transition rect's alpha to 255, then
                -- transition to the BeginGame state after the animation is over
                Timer.tween(1, {
                    [self] = {transitionAlpha = 255}
                }):finish(function()
                    gStateMachine:change('begin-game', {
                        level = 1
                    })

                end)
            else
                love.event.quit()
            end

            -- turn off input during transition
            self.pauseInput = true
        end
    end

    -- update our Timer, which will be used for our fade transitions
    Timer.update(dt)
end

function StartState:render()
    -- render all tiles and their drop shadows
    --[[for y = 1, 8 do
        for x = 1, 8 do
            -- render shadow first
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.draw(gTextures['main'], positions[(y - 1) * x + x], 
                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            -- render tile
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.draw(gTextures['main'], positions[(y - 1) * x + x], 
                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end--]]
    love.graphics.draw(gTextures['main1'], VIRTUAL_WIDTH / 3, 0)

    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawOptions(12)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

--[[
    Draws "Start" and "Quit Game" text over semi-transparent rectangles.
]]
function StartState:drawOptions(y)
    -- draw rect behind start and quit game text
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 58, 6)

    -- draw Start text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8)
    
    if self.currentMenuItem == 1 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end
    
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')

    -- draw Quit Game text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Quit Game', VIRTUAL_HEIGHT / 2 + y + 33)
    
    if self.currentMenuItem == 2 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end
    
    love.graphics.printf('Quit Game', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end

--[[
    Helper function for drawing just text backgrounds; draws several layers of the same text, in
    black, over top of one another for a thicker shadow.
]]
function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end
