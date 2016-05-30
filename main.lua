next_animation = 2
function love.load()
   local bump = require 'bump'
   world = bump.newWorld(45)

   as = require 'animatedsprite'
   
   simplePlayer = as:getInstance('simpleplayersprite.lua')
   simplePlayer.x = 100
   simplePlayer.y = 100

   world:add(simplePlayer, simplePlayer.x, simplePlayer.y, 45, 54)
   local A = {name='hello'}
   world:add(A, 500, 0, 500, 200)
end

function love.update(dt)
   if love.keyboard.isDown('right') then
      simplePlayer.x, simplePlayer.y = world:move(simplePlayer, simplePlayer.x + (dt * 200), simplePlayer.y)
   elseif love.keyboard.isDown('left') then
      simplePlayer.x = simplePlayer.x - (dt * 200)
   end
   as:updateInstance(simplePlayer, dt)
end

function love.draw()
   love.graphics.rectangle('line', 500, 0, 500, 200)
   as:drawInstance(simplePlayer)
end

function love.keypressed(key, scancode, isrepeat)
   if key == 'left' or key == 'right' then
      simplePlayer.curr_anim = simplePlayer.sprite.animations_names[2]
      simplePlayer.curr_frame = 1
      if key == 'left' then
	 if simplePlayer.flipped then
	    simplePlayer.dir = 1
	 else
	    simplePlayer.dir = -1
	 end
      elseif key == 'right' then
	 if simplePlayer.flipped then
	    simplePlayer.dir = -1
	 else
	    simplePlayer.dir = 1
	 end
      end
   elseif key == 'space' then
      simplePlayer.rotation = simplePlayer.rotation + math.pi
      simplePlayer.dir = simplePlayer.dir * -1
      simplePlayer.flipped = not simplePlayer.flipped
   elseif key == 'escape' then
      love.event.quit()
   end
end

function love.keyreleased(key, isrepeat)
   if key == 'left' or key == 'right' then
      simplePlayer.curr_anim = simplePlayer.sprite.animations_names[1]
      simplePlayer.curr_frame = 1
   end
end
