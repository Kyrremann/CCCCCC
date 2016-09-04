function love.load()
   ge = require 'gameengine'
   gs = require 'gamestate'
   
   gs:setMenu()
   leaderboard_time = 0
   leaderboard_text = ""
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

function love.draw()
   if gs:isGame() then
      ge:draw()
   elseif gs:isEnd() then
      love.graphics.printf(
	 string.format("You time was %.3f! Type you name, please! -- %q",
	    leaderboard_time, leaderboard_text),
	 0, 0, love.graphics.getWidth())
   else
      --
   end
end

function love.keypressed(key, scancode, isrepeat)
   if gs:isGame() then
      ge:keypressed(key, scancode, isrepeat)
   elseif gs:isEnd() then
      if key == 'return' then
	 success, errormsg = love.filesystem.append("leaderboard.txt", string.format("%s - %.3f", leaderboard_text, leaderboard_time))
	 if not success then
	    print(errormsg)
	    leaderboard_text = errormsg
	 else
	    leaderboard_text = ""
	    leaderboard_time = 0    
	    gs:setMenu()
	 end
      elseif key == 'escape' then
	 leaderboard_text = ""
	 leaderboard_time = 0
	 gs:setMenu()
      end
   else
      if key == 'return' then
	 gs:setGame()
	 ge:init(gs)
	 ge:start('level_1.lua')
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
      leaderboard_text = leaderboard_text .. t
   else
      --
   end
end
