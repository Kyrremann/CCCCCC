local menuengine = {}
local fwt = 0 -- firework timer
local fw = nil

function menuengine:init()
   fw = require 'firework.FireworkEngine'()
   love.graphics.setBlendMode('add')
end

function menuengine:update(dt)
   fwt = fwt + dt
   fw:update(dt)
   if fwt > 0.2 then
      fwt = fwt - 0.2
      fw:addFirework(
	 16 + math.random(love.graphics.getWidth() - 16 * 2),
	 16 + math.random(love.graphics.getHeight() - 16 * 2)
      )
   end
end

function menuengine:draw()
   love.graphics.setColor(84, 3, 142)
   draw_c(0, 0)
   draw_c(150, 0)
   draw_c(300, 0)
   draw_c(450, 0)
   draw_c(600, 0)
   draw_c(750, 0)
   show_leaderboard()
   fw:draw()
end

function draw_c(mod_x, mod_y)
   love.graphics.polygon('fill', {
			    100 + mod_x, 100 + mod_y,
			    150 + mod_x,  50 + mod_y,
			    200 + mod_x,  50 + mod_y,
			    200 + mod_x, 100 + mod_y,
			    150 + mod_x, 100 + mod_y,
			    150 + mod_x, 150 + mod_y,
			    100 + mod_x, 150 + mod_y
   })
   love.graphics.polygon('fill', {
			    100 + mod_x, 150 + mod_y,
			    200 + mod_x, 150 + mod_y,
			    200 + mod_x, 200 + mod_y,
			    150 + mod_x, 200 + mod_y
   })
end


function show_leaderboard()
   love.graphics.setColor(255, 255, 255, 255)
   local y = 200
   local x = 100
   for i, score, name in highscore() do
      if name then
	 y = y + 40
	 love.graphics.print(
	    string.format("%02d:\t%s\t%.3f", i, name, score),
	    x, y)
      end
      if i == 20 then
	 x = 1050
	 y = 0
      end
      if i == 45 then return end
   end
end

return menuengine
