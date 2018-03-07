--[[

  GD-50
  Tetris remake for Project1

--]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.timer = 0
  self.tilespawntimer = 0
  self.fallentiles = {}
  self.fallingtiles =  {}

   -- add 1 to timer every second
   Timer.every(1, function()
     self.timer = self.timer + 1
   end)

end


function PlayState:enter(params)
  -- spawn a board and place it toward the right
  self.board = params.board or Board(self.level, VIRTUAL_WIDTH - 272, 16)
  print('in enter code')

end

function PlayState:update(dt)
  
  Timer.update(dt)
  -- update timer for tetris block spawning
  self.tilespawntimer = self.tilespawntimer + dt
  -- self.fallingtiles = self.havetilefall(self.fallingtiles)
   math.randomseed(os.time())
  if self.tilespawntimer > math.random(2, 5) then
      local x = math.random(1,8)
      table.insert(self.fallingtiles, Tile(x, 0, math.random(18), math.random(1), 0))
      self.fallingtiles[1]:render(x, 0, false)
      self.tilespawntimer = 0
  end

end

function PlayState:havetilefall(fallingtiles)
   local x = math.random(1,8)
   table.insert(fallingtiles[1], Tile(x, 0, math.random(18), math.random(1), 0))

   fallingtiles[1]:render(x, 0)

   return fallingtiles

end

function PlayState:render()
  -- render board of tiles
  self.board:render()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')



end


