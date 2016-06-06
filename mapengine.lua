local mapengine = {}
local mapBank = {}
local spritBank = {}
local spritesheet = ''

function mapengine:loadLevel(level, world)
   local protoMap = loadfile(level)()
   spritesheet = love.graphics.newImage('images/roguelikeDungeon_transparent.png')

   for y=1, protoMap.height do
      mapBank[y] = {}
      for x=1, protoMap.width do
	 mapBank[y][x] = {}
      end
   end

   for index, tile in ipairs(protoMap.tiles) do
      if tile.x_range then
	 for x=tile.x_range[1], tile.x_range[2] do
	    local temp = {
	       quad = love.graphics.newQuad(
		  tile.tile_x, tile.tile_y,
		  16, 16, 492, 305)
	    }
	    mapBank[tile.y][x] = temp
	    world:add(temp, (x - 1) * 16, (tile.y - 1) * 16, 16, 16)
	 end
      end
      if tile.y_range then
	 for y=tile.y_range[1], tile.y_range[2] do
	    local temp = {
	       quad = love.graphics.newQuad(
		  tile.tile_x, tile.tile_y,
		  16, 16, 492, 305)
	    }
	    mapBank[y][tile.x] = temp
	    world:add(temp, (tile.x - 1) * 16, (y - 1) * 16, 16, 16)
	 end
      end
   end
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

return mapengine
