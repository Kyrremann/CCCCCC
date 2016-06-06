--[[
   LavamanSprite.lua - 2014
   
   Copyright Dejaime Antônio de Oliveira Neto, 2014
   
   Released under the MIT license.
   Visit for more information:
   http://opensource.org/licenses/MIT
]]
print("SimplePlayerSprite.lua loaded")

require "love.graphics"

local image_w = 917 -- This info can be accessed with a Löve2D call
local image_h = 203 -- after the image has been loaded. I'm creating these for readability.

return {
   serialization_version = 1.0, -- The version of this serialization process

   sprite_sheet = "images/roguelikeChar_transparent.png", -- The path to the spritesheet
   sprite_name = "simple players", -- The name of the sprite

   frame_duration = 0.10,
   
   
   --This will work as an array.
   --So, these names can be accessed with numeric indexes starting at 1.
   --If you use < #sprite.animations_names > it will return the total number
   --		of animations in in here.
   animations_names = {
      "idle",
      "walk"
   },

   --The list with all the frames mapped to their respective animations
   --	each one can be accessed like this:
   --	mySprite.animations["idle"][1], or even
   animations = {
      idle = {
	 --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
	 love.graphics.newQuad(   0, 170, 16, 16, image_w, image_h)
      },
      
      walk = {
	 love.graphics.newQuad( 156, 310, 45, 54, image_w, image_h),
	 love.graphics.newQuad( 156, 156, 45, 54, image_w, image_h),
	 love.graphics.newQuad( 115,  48, 45, 52, image_w, image_h)
      }
   } --animations

} --return (end of file)
