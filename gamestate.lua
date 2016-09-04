local gamestate = {}
local MENU = 'menu'
local GAME = 'game'
local END = 'end'

local state = MENU

function gamestate:setMenu()
   state = MENU
end

function gamestate:setGame()
   state = GAME
end

function gamestate:setEnd()
   state = END
end

function gamestate:isMenu()
   return state == MENU
end

function gamestate:isGame()
   return state == GAME
end

function gamestate:isEnd()
   return state == END
end

function gamestate:getGamestate()
   return state
end

return gamestate
