local gameengine = {}
local bump = require 'bump'
local me = require 'mapengine'   
local as = require 'animatedsprite'
local gs = nil
local world = nil
local start_time = nil
local next_animation = 2

function gameengine:init(gamestate)
   world = bump.newWorld(16)
   gs = gamestate
end

function gameengine:start(level)
   me:loadLevel(level, world)
   
   simplePlayer = as:getInstance('simpleplayersprite.lua')
   me:setStartZone(simplePlayer)
   gravity = 600

   world:add(simplePlayer, simplePlayer.x, simplePlayer.y, 16, 16)

   start_time = love.timer.getTime()
end

function gameengine:update(dt)
   local cols = nil
   local len = nil

   simplePlayer.x, simplePlayer.y, cols, len = world:move(simplePlayer, simplePlayer.x, simplePlayer.y + (gravity * dt))
   isAtGoal(cols)
   
   if len == 1 then
      simplePlayer.grounded = true
   else
      simplePlayer.grounded = false
   end

   if love.keyboard.isDown('right') then
      simplePlayer.x, simplePlayer.y, cols, len  = world:move(simplePlayer, simplePlayer.x + (dt * 400), simplePlayer.y)
      isAtGoal(cols)
   elseif love.keyboard.isDown('left') then
      simplePlayer.x, simplePlayer.y, cols, len  = world:move(simplePlayer, simplePlayer.x - (dt * 400), simplePlayer.y)
      isAtGoal(cols)
   end
   as:updateInstance(simplePlayer, dt)
end

function isAtGoal(cols)
   if #cols > 0 and cols[1].other.title == 'goal' then
      -- TODO: Move this to another file
      leaderboard.time = 0
      leaderboard.text = ""
      leaderboard.time = love.timer.getTime() - start_time
      gs:setEnd()
      -- clean up?
   end
end

function gameengine:draw()
   me:draw()
   as:drawInstance(simplePlayer)
end

function gameengine:keypressed(key, scancode, isrepeat)
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
      gs.setMenu()
   end
end

function gameengine:keyreleased(key, isrepeat)
   if key == 'left' or key == 'right' then
      simplePlayer.curr_anim = simplePlayer.sprite.animations_names[1]
      simplePlayer.curr_frame = 1
   end
end

return gameengine
