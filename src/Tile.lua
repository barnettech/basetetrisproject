--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety, shiny)
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.shiny = shiny
end

function Tile:render(x, y, opacity)
    -- draw tile itself
    if opacity then
       -- print('opacity is ' .. opacity)
       -- draw shadow
       love.graphics.setColor(34, 32, 52, 255)
       love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
         self.x + x + 2, self.y + y + 2)

      --[[love.graphics.setColor(255, 255, 255, 20)
      love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)]]
    else
      print('x is ' .. x .. ', y is ' .. y)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        x, y)

    end
      
      --print(':38 x is ' .. x) 
      --print(':38 ' .. self.x + x)
      --print(':39 ' .. self.y + y)
end
