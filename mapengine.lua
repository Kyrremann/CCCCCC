local mapengine = {}
local mapBank = {}
local spritBank = {}
local spritesheet = ''
local protoMap

function mapengine:loadLevel(level, world)
   protoMap = loadfile(level)()
   spritesheet = love.graphics.newImage('images/roguelikeDungeon_transparent.png')

   for y=1, protoMap.height do
      mapBank[y] = {}
      for x=1, protoMap.width do
	 mapBank[y][x] = {}
      end
   end

   for index, tile in ipairs(protoMap.tiles) do
      local quad_x, quad_y
      if tile.quad ~= nil then
	 quad_x = tile.quad.x
	 quad_y = tile.quad.y
      else
	 quad_x = protoMap.default_quad.x
	 quad_y = protoMap.default_quad.y
      end
      if tile.x_range then
	 for x=tile.x_range[1], tile.x_range[2] do
	    local temp = {
	       title = 'simple ground',
	       quad = love.graphics.newQuad(
		  quad_x, quad_y,
		  16, 16, 492, 305)
	    }
	    mapBank[tile.y][x] = temp
	    world:add(temp, (x - 1) * 16, (tile.y - 1) * 16, 16, 16)
	 end
      elseif tile.y_range then
	 for y=tile.y_range[1], tile.y_range[2] do
	    local temp = {
	       quad = love.graphics.newQuad(
		  quad_x, quad_y,
		  16, 16, 492, 305)
	    }
	    mapBank[y][tile.x] = temp
	    world:add(temp, (tile.x - 1) * 16, (y - 1) * 16, 16, 16)
	 end
      elseif tile.x and tile.y then
	 local temp = {
	    quad = love.graphics.newQuad(
	       quad_x, quad_y,
	       16, 16, 492, 305)
	 }
	 print(tile.y, tile.x)
	 mapBank[tile.y][tile.x] = temp
	 world:add(temp, (tile.x - 1) * 16, (tile.y - 1) * 16, 16, 16)
      end
   end

   local goal = protoMap.goal
   local temp = {
      title = 'goal',
      quad = love.graphics.newQuad(
	 goal.quad.x, goal.quad.y,
	 16, 16, 492, 305)
   }
   mapBank[goal.y][goal.x] = temp
   world:add(temp, (goal.x - 1) * 16, (goal.y - 1) * 16, 16, 16)
end

function mapengine:draw()
   for y, vy in ipairs(mapBank) do
      for x, tile in ipairs(vy) do
	 if tile.quad then
	    love.graphics.draw(
	       spritesheet,
	       tile.quad,
	       (x - 1) * 16,
	       (y - 1) * 16
	    )
	 end
      end
   end
end

function mapengine:setStartZone(player)
   player.x = protoMap.start.x * 16
   player.y = protoMap.start.y * 16
end

return mapengine
