function love.load()
   if not love.filesystem.exists('leaderboard.txt') then
      love.filesystem.write('leaderboard.txt', '')
   end

   ge = require 'gameengine'
   gs = require 'gamestate'
   fw = require 'firework.FireworkEngine'()
   love.graphics.setBlendMode('add')
   highscore = require 'sick'
   highscore.set('highscore.txt', 1000)
   
   fontSmall = love.graphics.newFont('fonts/kenpixel_future_square.ttf', 22)
   love.graphics.setFont(fontSmall)

   math.randomseed(os.time())
   gs:setMenu()
   leaderboard = {
      time = 0,
      text = '',
   }
   fwt = 0 -- firework timer
end

function love.update(dt)
   if gs:isGame() then
      ge:update(dt)
   elseif gs:isEnd() then
      -- ask user to type name
      -- show time
   else
      fwt = fwt + dt
      fw:update(dt)
      if fwt > 0.2 then
	 fwt = fwt - 0.2
	 fw:addFirework(
	    16 + math.random(love.graphics.getWidth() - 16 * 2),
	    16 + math.random(love.graphics.getHeight() - 16 * 2)
	 )
      end
      -- menu
      -- show name of game
      -- show leaderboard
      -- show start
   end
end

function new_color(old, mod)
   old = old + mod
   if old > 255 then
      return 1
   else
      return old
   end
end

function love.draw()
   if gs:isGame() then
      love.graphics.setColor(255, 255, 255, 255)
      ge:draw()
   elseif gs:isEnd() then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf(
	 string.format("You time was %.3f! Type you name, please! -- %q",
	    leaderboard.time, leaderboard.text),
	 0, 0, love.graphics.getWidth())
   else
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

function love.keypressed(key, scancode, isrepeat)
   if gs:isGame() then
      ge:keypressed(key, scancode, isrepeat)
   elseif gs:isEnd() then
      if key == 'return' then
	 highscore.add(leaderboard.text, leaderboard.time)
	 leaderboard.text = ""
	 leaderboard.time = 0
	 gs:setMenu()
      elseif key == 'escape' then
	 leaderboard.text = ""
	 leaderboard.time = 0
	 gs:setMenu()
      end
   else
      if key == 'return' then
	 gs:setGame()
	 ge:init(gs)
	 ge:start('level_ciber2.lua')
      elseif key == 'escape' then
	 highscore.save()
	 love.event.quit()
      end
   end
end

function love.keyreleased(key, isrepeat)
   if gs:isGame() then
      ge:keyreleased(key, isrepeat)
   elseif gs:isEnd() then
      --
   else
   end
end

function love.textinput(t)
   if gs:isGame() then
      --
   elseif gs:isEnd() then
      leaderboard.text = leaderboard.text .. t
   else
      --
   end
end
