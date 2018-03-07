--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(level, x, y)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}

    self:initializeTiles()
    math.randomseed(os.time())
end

function Board:initializeTiles()
    self.tiles = {}
    self.tilescopy = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})
        --math.randomseed(os.time())
        for tileX = 1, 8 do
            if math.random(1,20) <= 10 then
              self.shiny = 1
            else
              self.shiny = 0
            end
            print('shiny is ' .. self.shiny)
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(self.level), self.shiny))
        end
    end

    while self:calculateMatches() do
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

function Board:checkIfMatchesPossible()   
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        
        local colorToMatch = self.tilescopy[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            -- if this is the same color as the one we're trying to match...
            if self.tilescopy[y][x].color == colorToMatch then
                matchNum = matchNum + 1
                if matchNum >= 3 then
                  print(':66 matchable at location ' .. x .. ', ' .. y)
                  return true
                end
            else
                -- set this as the new color we want to watch for
                colorToMatch = self.tilescopy[y][x].color

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end

                matchNum = 1
            end
        end

        -- account for the last row ending with a match
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tilescopy[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tilescopy[y][x].color == colorToMatch then
                matchNum = matchNum + 1
                if matchNum >= 3 then
                  print(':96 matchable at location ' .. x .. ', ' .. y)
                  return true
                end
            else
                colorToMatch = self.tilescopy[y][x].color

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

    end

    -- return matches table if > 0, else just return false
    return false
end

function Board:collides(mousex, mousey, target)
    target.width = 10 
    target.height = 10

    local locationX = 220 + (target.gridX * 32)
    local locationY = (target.gridY * 32)

    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if mousex > locationX + target.width or mousex < locationX - target.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if mousey > locationY + target.height or mousey < locationY - target.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches(shinyx, shinyy)
    if shinyx and shinyy then
      self.shinyx = shinyx + 1
      self.shinyy = shinyy + 1
    end
    self.horizontalshinymatch = false
    self.verticalshinymatch = false
    if self.shinyx and self.shinyy then
      -- print('at :122 shinyx is ' .. self.shinyx .. ' and shinyy is ' .. self.shinyy)  
    end

    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color
                
                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        if x2 == self.shinyx and y == self.shinyy then
                          self.horizontalshinymatch = true;
                        end
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end

                matchNum = 1
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
              if x == self.shinyx and y == self.shinyy then
                self.horizontalshinymatch = true
                if self.shinyx and self.shinyy then
                  -- print('at :113 shinyx is ' .. self.shinyx .. ' and shinyy is ' .. self.shinyy) 
                end
              end
              table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                      if x == self.shinyx and y == self.shinyy then
                        self.verticalshinymatch = true
                        if self.shinyx and self.shinyy then
                        end
                      end
                      table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum, -1 do
              if x == self.shinyx and y == self.shinyy then
                self.verticalshinymatch = true
                if self.shinyx and self.shinyy then
                  -- print('at :179 shinyx is ' .. self.shinyx .. ' and shinyy is ' .. self.shinyy) 
                end
              end
              table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    if self.horizontalshinymatch and self.shinyy then
      local match = {}
      for y = 1, 8 do
        table.insert(match, self.tiles[self.shinyy][y])
      end
      table.insert(matches, match)
    end
    if self.verticalshinymatch and self.shinyx then
      local match = {}
      for y = 1, 8 do
        table.insert(match, self.tiles[y][self.shinyx])
      end
      table.insert(matches, match)
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = Tile(x, y, math.random(18), math.random(6))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:getNewTiles()
    return {}
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
