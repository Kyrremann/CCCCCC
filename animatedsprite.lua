--[[
   AnimatedSprite.lua - 2014
   
   Copyright Dejaime Antônio de Oliveira Neto, 2014
   
   Released under the MIT license.
   Visit for more information:
   http://opensource.org/licenses/MIT
]]
print("AnimatedSprite.lua loaded")

local animatedSprite = {}
local ManagerVersion = 1.0

local sprite_bank = {} --Map with all the sprite definitions
local image_bank = {} --Contains all images that were already loaded

function animatedSprite:loadSprite(sprite_def)
   if sprite_def == nil then return nil end
   
   --Load the sprite inition file to ensure it exists
   local definition_file = loadfile(sprite_def)

   --If the file doesn't exist or has syntax errors, it'll be nil.
   if definition_file == nil then
      --Spit out a warning and return nil.
      print("Attempt to load an invalid file (inexistent or syntax errors?): "..sprite_def)
      return nil
   end

   --[[Loading the sprite definition as an entry in our table.

      We can execute the file by calling it as a function
      with these () as we loaded with loadfile previously.
      If we used dofile with an invalid file path our program
      would crash. 
      At this point, executing the file will load all the necessary
      information in a single call. There's no need to parse
      this of serialization.
   ]]
   local old_sprite = sprite_bank[sprite_def]
   sprite_bank[sprite_def] = definition_file()
   
   --Check the version to verify if it is compatible with this one.
   if sprite_bank[sprite_def].serialization_version ~= ManagerVersion then
      print("Attempt to load file with incompatible versions: "..sprite_def)
      print("Expected version "..ManagerVersion..", got version "
	       ..sprite_bank[sprite_def].serialization_version.." .")
      sprite_bank[sprite_def] = old_sprite -- Undo the changes due to error
      -- Return old value (nil if not previously loaded)
      return sprite_bank[sprite_def]
   end
   
   
   --All we need to do now is check if the image exist
   --	and load it.
   
   --Storing the path to the image in a variable (to add readability)
   local sprite_sheet = sprite_bank[sprite_def].sprite_sheet

   --Load the image.
   local old_image = image_bank[sprite_sheet]
   image_bank[sprite_sheet] = love.graphics.newImage(sprite_sheet)
   
   --Check if the loaded image is valid.
   if image_bank[sprite_sheet] == nil then
      -- Invalid image, reverting all changes
      image_bank [sprite_sheet] = old_image	-- Revert image
      sprite_bank[sprite_def] = old_sprite	-- Revert sprite
      
      print("Failed loading sprite "..sprite_def..", invalid image path ( "..sprite_sheet.." ).")
   end
   
   return sprite_bank[sprite_def]
end

function animatedSprite:getInstance(sprite_def)
   if sprite_def == nil then return nil end -- invalid use
   
   if sprite_bank[sprite_def] == nil then
      --Sprite not loaded attempting to load; abort on failure.
      if animatedSprite:loadSprite(sprite_def) == nil then return nil end
   end
   
   --All set, return the default table.
   return {
      sprite = sprite_bank[sprite_def], --Sprite reference
      --Sets the animation as the first one in the list.
      curr_anim = sprite_bank[sprite_def].animations_names[1],
      curr_frame = 1,
      elapsed_time = 0,
      size_scale = 1,
      time_scale = 1,
      x = 0,
      y = 0,
      rotation = 0,
      dir = 1,
      offset_x = 0,--22.5,
      offset_y = 0,--27,
      flipped = false
   }
end

function animatedSprite:updateInstance(spr, dt)
   -- Increment the internal counter.
   spr.elapsed_time = spr.elapsed_time + dt

   --We check we need to change the current frame.
   if spr.elapsed_time > spr.sprite.frame_duration * spr.time_scale then
      -- Check if we are at the last frame.
      -- # returns the total entries of an array.
      if spr.curr_frame < #spr.sprite.animations[spr.curr_anim] then
	 -- Not on last frame, increment.
	 spr.curr_frame = spr.curr_frame + 1
      else
	 -- Last frame, loop back to 1.
	 spr.curr_frame = 1
      end
      -- Reset internal counter on frame change.
      spr.elapsed_time = 0
   end
end

function animatedSprite:drawInstance(spr)
   love.graphics.push()
   love.graphics.translate(spr.x, spr.y)
   -- love.graphics.rotate(spr.rotation)
   -- love.graphics.rectangle('line', -22.5, -27, 45, 54)
   if spr.dir == -1 then
      spr.offset_x = 45
   else
      spr.offset_x = 0
   end
 
   -- love.graphics.rectangle('line', 0, 0, 16, 16)
   love.graphics.draw(
      image_bank[spr.sprite.sprite_sheet], --The image
      spr.sprite.animations[spr.curr_anim][spr.curr_frame], --Current frame of the current animation
      0,
      0
   )
   love.graphics.pop()
end

return animatedSprite
