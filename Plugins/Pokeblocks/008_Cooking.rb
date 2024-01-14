class CookingStage1
	def initialize
		@sprites = {}
		@viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
		@viewport.z = 99999
	
		#Graphics
		@sprites["pot_upper"] = IconSprite.new(0, 0, @viewport)
		@sprites["pot_upper"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/stewpot_base_upper - large")
		@sprites["pot_upper"].x = Graphics.width/2 - @sprites["pot_upper"].width/2
		@sprites["pot_upper"].y = 70
		@sprites["pot_upper"].z = 99999
		
		@sprites["pot_lower"] = IconSprite.new(0, 0, @viewport)
		@sprites["pot_lower"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/stewpot_base_lower - large")
		@sprites["pot_lower"].x = Graphics.width/2 - @sprites["pot_lower"].width/2
		@sprites["pot_lower"].y = 70
		#always on top of the spoon when submerged
		@sprites["pot_lower"].z = 999999
		
		@sprites["stove"] = IconSprite.new(0, 0, @viewport)
		@sprites["stove"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/stove - large")
		@sprites["stove"].x = Graphics.width/2 - @sprites["stove"].width/2
		@sprites["stove"].y = @sprites["pot_upper"].y + 160
		@sprites["stove"].z = 99998
		
		@sprites["candy_base"] = IconSprite.new(0, 0, @viewport)
		@sprites["candy_base"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/candy_base_in_pot")
		@sprites["candy_base"].x = Graphics.width/2 - @sprites["candy_base"].width/2
		@sprites["candy_base"].y = 70
		@sprites["candy_base"].z = 99999
		@sprites["candy_base"].visible = false
		
		@sprites["spoon"] = IconSprite.new(0, 0, @viewport)
		@sprites["spoon"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/spoon")
		@sprites["spoon"].x = Graphics.width/2 - @sprites["spoon"].width/2
		@sprites["spoon"].y = 0
		@sprites["spoon"].z = 999999
		@lastX = Graphics.width/2 - @sprites["spoon"].width/2
		@lastY = 0
		
		@edgeOfPotLeft = @sprites["pot_lower"].x + (83+@sprites["spoon"].width/2)
		@edgeOfPotRight = @sprites["pot_lower"].x + @sprites["pot_lower"].width - (83+@sprites["spoon"].width/2)
		@edgeOfPotTop = @sprites["pot_lower"].y + 50
		@edgeOfPotBottom = @sprites["pot_lower"].y + 270
		
		@sprites["boundaries"] = IconSprite.new(0, 0, @viewport)
		@sprites["boundaries"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/stewpot_stirring_boundaries")
		@sprites["boundaries"].x = @sprites["pot_upper"].x
		@sprites["boundaries"].y = @sprites["pot_upper"].y
		@sprites["boundaries"].z = 99999999
		
		pbmain
	end #def initialize
	
	def outOfBounds?
		return true if !Mouse.over_pixel?(@sprites["boundaries"]) #if Mouse.x < @edgeOfPotLeft || Mouse.x > @edgeOfPotRight || Mouse.y < @edgeOfPotTop || Mouse.y > @edgeOfPotBottom
		return false
	end
	
	def updateCursorPos
		@lastX = @sprites["spoon"].x
		@lastY = @sprites["spoon"].y
		
		#if the mouse leaves the game window, put the spoon at its last X and Y rather than in the top left of the screen
		if !System.mouse_in_window
			@sprites["spoon"].x = @lastX
			@sprites["spoon"].y = @lastY
		elsif outOfBounds? && @spoonSubmerged #if the cursor goes outside of what's allowed for stirring and they are currently stirring, don't follow the cursor
			@sprites["spoon"].x = @lastX
			@sprites["spoon"].y = @lastY
		else
			@sprites["spoon"].x=Mouse.x-@sprites["spoon"].width/2 if defined?(Mouse.x)
			@sprites["spoon"].y=Mouse.y-@sprites["spoon"].height+40 if defined?(Mouse.y)
		end
	end #updateCursorPos
	
	def submergeSpoon
		@spoonSubmerged = true
		@sprites["spoon"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/spoon_ submerged")
		@sprites["spoon"].z = 99999
	end #def submergeSpoon
	
	def pullSpoon
		@spoonSubmerged = false
		@sprites["spoon"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/spoon")
		@sprites["spoon"].z = 999999
	end #def pullSpoon
	
	def detectInput
		if Mouse.press? && !outOfBounds?
			submergeSpoon
		end #if Mouse.press?
		if Input.release?(Input::MOUSELEFT)
			pullSpoon
		end #Input.release?(Input::MOUSELEFT)
	end #detectInput
	
	def pbmain
		#pbMessage(_INTL("Adding candy base"))
		@sprites["candy_base"].visible = true
		
		loop do
			Graphics.update
			Input.update
			updateCursorPos
			pbUpdateSpriteHash(@sprites)
			detectInput
		end #loop do
	end
end #class CookingStage1

class CookingStage2
	def initialize
		@sprites = {}
		@viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
		@viewport.z = 99999
	
		#Graphics
		@sprites["firewood"] = IconSprite.new(0, 0, @viewport)
		@sprites["firewood"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/firewood")
		@sprites["firewood"].x = Graphics.width/2 - @sprites["firewood"].width/2
		@sprites["firewood"].y = Graphics.height/2
		@sprites["firewood"].z = 99999
		
		#animname, framecount, framewidth, frameheight, frameskip
		@sprites["fire"] = AnimatedSprite.new("Graphics/Pictures/Pokeblock/Candy Making/fire_anim",3,274,201,4,@viewport)
		@sprites["fire"].x = @sprites["firewood"].x + @sprites["firewood"].width/2 - @sprites["fire"].width/4
		@sprites["fire"].y = @sprites["firewood"].y + @sprites["firewood"].height/2 - @sprites["fire"].height/3
		@sprites["fire"].z = 99999
		@sprites["fire"].zoom_x = 0.5
		@sprites["fire"].zoom_y = 0.5
		@sprites["fire"].play
		
		@sprites["stove"] = IconSprite.new(0, 0, @viewport)
		@sprites["stove"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/stove")
		@sprites["stove"].x = Graphics.width/2 - @sprites["stove"].width/2
		@sprites["stove"].y = @sprites["firewood"].y - @sprites["stove"].height/3
		@sprites["stove"].z = 99999
		
		@sprites["pot"] = IconSprite.new(0, 0, @viewport)
		@sprites["pot"].setBitmap("Graphics/Pictures/Pokeblock/Candy Making/stewpot_base")
		@sprites["pot"].x = Graphics.width/2 - @sprites["pot"].width/2
		@sprites["pot"].y = @sprites["stove"].y - 80
		@sprites["pot"].z = 99999
		
		pbmain
	end #def initialize
	
	def pbmain
		loop do
			Graphics.update
			pbUpdateSpriteHash(@sprites)
		end #loop do
	end
end #class CookingStage2