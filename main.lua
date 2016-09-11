function love.load()
   ge = require 'gameengine'
   gs = require 'gamestate'
   me = require 'menuengine'
   
   highscore = require 'sick'
   highscore.set('highscore.txt', 1000)

   fontSmall = love.graphics.newFont('fonts/kenpixel_future_square.ttf', 22)
   love.graphics.setFont(fontSmall)

   math.randomseed(os.time())
   gs:setMenu()
   me.init()
   leaderboard = {
      time = 0,
      text = '',
   }
end

function love.update(dt)
   if gs:isGame() then
      ge:update(dt)
   elseif gs:isEnd() then
      --
   else
      me:update(dt)
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
      me:draw()
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
      elseif key == 'backspace' then
	 leaderboard.text = leaderboard.text:sub(1, -2)
      end
   else
      if key == 'return' then
	 gs:setGame()
	 ge:init(gs)
	 ge:start('level_ciber3.lua')
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
