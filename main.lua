next_animation = 2
function love.load()
   local bump = require 'bump'
   world = bump.newWorld(16)

   as = require 'animatedsprite'
   me = require 'mapengine'

   me:loadLevel('level_1.lua', world)
   
   simplePlayer = as:getInstance('simpleplayersprite.lua')
   me:setStartZone(simplePlayer)
   gravity = 600

   world:add(simplePlayer, simplePlayer.x, simplePlayer.y, 16, 16)
end

function love.update(dt)
   local cols = nil
   local len = nil

   simplePlayer.x, simplePlayer.y, cols, len = world:move(simplePlayer, simplePlayer.x, simplePlayer.y + (gravity * dt))
   if #cols > 0 then
      -- check if user is at goal
      if cols[1].other.title == 'goal' then
	 love.event.quit()	 
      end
   end
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
   me:draw()
   as:drawInstance(simplePlayer)
end

function love.keypressed(key, scancode, isrepeat)
   if key == 'left' or key == 'right' then
      simplePlayer.curr_anim = simplePlayer.sprite.animations_names[1]
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
