--[[

  GD-50
  Tetris remake for Project1

--]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.timer = 0
  self.numberfallen = 0
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

end

function PlayState:update(dt)
  
  Timer.update(dt)
  -- update timer for tetris block spawning
  self.tilespawntimer = self.tilespawntimer + dt
  -- self.fallingtiles = self.havetilefall(self.fallingtiles)
   math.randomseed(os.time())
  if self.tilespawntimer >= 3 then
      self.numberfallen = self.numberfallen + 1
      local x = math.random(1,8)
      table.insert(self.fallingtiles, Tile(400, 100, math.random(18), math.random(1), 0))
      self.fallingtiles[self.numberfallen]:render(100, 0, false)
      print('reset timer')
      self.tilespawntimer = 0
  end
  local tilecollision = false
  for k, tilefalling in pairs(self.fallingtiles) do
    for y = 1, 8 do
      for x = 1, 8 do
        if tilefalling:collides(self.board.tiles[y][x]) then
          print('collision')
          tilecollision = true
        end
      end
    end
    if tilefalling.gridY < VIRTUAL_HEIGHT - 46 and tilecollision == false then
      tilefalling.gridY = tilefalling.gridY + 1
    end
  end
  -- print('tilespawntimer is ' .. self.tilespawntimer)

end


function PlayState:render()
  -- render board of tiles
  self.board:render()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')


  --love.graphics.rectangle("fill", VIRTUAL_WIDTH - 200, 50, 60, 120 )
  for k, tilefalling in pairs(self.fallingtiles) do
    tilefalling:render(tilefalling.gridX, tilefalling.gridY, false)
  end

end


