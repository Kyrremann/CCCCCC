next_animation = 2
function love.load()
   local bump = require 'bump'
   world = bump.newWorld(45)

   as = require 'animatedsprite'
   
   simplePlayer = as:getInstance('simpleplayersprite.lua')
   simplePlayer.x = 100
   simplePlayer.y = 100
   gravity = 600

   world:add(simplePlayer, simplePlayer.x, simplePlayer.y, 4, 6)
   local top = {name='top'}
   local bottom = {name='bottom'}
   local middle = {name='middle'}
   world:add(top, 0, 0, love.graphics.getWidth(), 2)
   world:add(bottom, 0, love.graphics.getHeight() - 2, love.graphics.getWidth(), 2)
   world:add(middle, love.graphics.getWidth() / 4, love.graphics.getHeight() / 4, 500, 5)
end

function love.update(dt)
   local cols = nil
   local len = nil
   simplePlayer.x, simplePlayer.y, cols, len = world:move(simplePlayer, simplePlayer.x, simplePlayer.y + (gravity * dt))
   if len == 1 then
      simplePlayer.grounded = true
   else
      simplePlayer.grounded = false
   end
   if love.keyboard.isDown('right') then
      simplePlayer.x, simplePlayer.y = world:move(simplePlayer, simplePlayer.x + (dt * 400), simplePlayer.y)
   elseif love.keyboard.isDown('left') then
      simplePlayer.x, simplePlayer.y = world:move(simplePlayer, simplePlayer.x - (dt * 400), simplePlayer.y)
   end
   as:updateInstance(simplePlayer, dt)
end

function love.draw()
   love.graphics.rectangle('line', 0, 0, love.graphics.getWidth(), 2)
   love.graphics.rectangle('line', 0, love.graphics.getHeight() - 2, love.graphics.getWidth(), 2)
   love.graphics.rectangle('line', love.graphics.getWidth() / 4, love.graphics.getHeight() / 4, 500, 5)
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
      --simplePlayer.rotation = simplePlayer.rotation + math.pi
      --simplePlayer.dir = simplePlayer.dir * -1
      -- simplePlayer.flipped = not simplePlayer.flipped
      if simplePlayer.grounded then
	 gravity = gravity * -1
      end
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
