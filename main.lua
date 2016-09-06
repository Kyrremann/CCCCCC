function love.load()
   if not love.filesystem.exists('leaderboard.txt') then
      love.filesystem.write('leaderboard.txt', '')
   end

   ge = require 'gameengine'
   gs = require 'gamestate'
   
   fontSmall = love.graphics.newFont('fonts/kenpixel_future_square.ttf', 22)
   love.graphics.setFont(fontSmall)

   math.randomseed(os.time())
   gs:setMenu()
   leaderboard = {
      time = 0,
      text = '',
   }
end

function love.update(dt)
   if gs:isGame() then
      ge:update(dt)
   elseif gs:isEnd() then
      -- ask user to type name
      -- show time
   else
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
   local y = 300
   for line in love.filesystem.lines("leaderboard.txt") do
      love.graphics.print(line, 100, y, 0, 2, 2)
      y = y + 40
   end
end

function love.keypressed(key, scancode, isrepeat)
   if gs:isGame() then
      ge:keypressed(key, scancode, isrepeat)
   elseif gs:isEnd() then
      if key == 'return' then
	 success, errormsg = love.filesystem.append("leaderboard.txt",
						    string.format("%s - %.3f\n",
								  leaderboard.text,
								  leaderboard.time))
	 if not success then
	    print(errormsg)
	    leaderboard.text = errormsg
	 else
	    leaderboard.text = ""
	    leaderboard.time = 0    
	    gs:setMenu()
	 end
      elseif key == 'escape' then
	 leaderboard.text = ""
	 leaderboard.time = 0
	 gs:setMenu()
      end
   else
      if key == 'return' then
	 gs:setGame()
	 ge:init(gs)
	 ge:start('level_ciber.lua')
      elseif key == 'escape' then
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
