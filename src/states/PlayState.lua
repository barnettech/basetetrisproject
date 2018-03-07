--[[

  GD-50
  Tetris remake for Project1

--]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.timer = 0

   -- add 1 to timer every second
    Timer.every(1, function()
        self.timer = self.timer + 1

    end)


end


function PlayState:enter(params)
  -- spawn a board and place it toward the right
  self.board = params.board or Board(self.level, VIRTUAL_WIDTH - 272, 16)


end

function PlayState:update(dt)
  
  Timer.update(dt)

end

function PlayState:havetilefall()
   local x = math.random(1,8)
   self.tiles[0][x]:render(self.x, self.y)


end

function PlayState:render()
  -- render board of tiles
  self.board:render()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')



end


