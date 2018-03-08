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

--[[
    AABB collision that expects a anothertile, which will have an X and Y and reference
    global anothertile width and height values.
]]
function Tile:collides(anothertile)
    TILE_WIDTH = 8
    TILE_HEIGHT = 8
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if self.x > anothertile.x + TILE_WIDTH or anothertile.x > self.x + TILE_WIDTH then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > anothertile.y + TILE_HEIGHT or self.y < anothertile.y - TILE_HEIGHT then
        return false;
    end

    -- if the above aren't true, they're overlapping
    return true
    
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
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        x, y)

    end
      
      --print(':38 x is ' .. x) 
      --print(':38 ' .. self.x + x)
      --print(':39 ' .. self.y + y)
end
