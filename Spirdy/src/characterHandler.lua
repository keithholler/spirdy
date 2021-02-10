local mcx = require("mcx")
local myData = require("myData")
local physics = require("physics")
local Analog = require("analogStick")

local W = display.contentWidth
local H = display.contentHeight

local char = mcx.new()
char:enableDebugging()

local charDies = mcx.new()
charDies:enableDebugging()

local physicsIdle, physicsBack, physicsUp, physicsDown, physicsForward

local character = {}
  character.analogStick = function(group)
    -- Set parameters for the Analog stick
    local group = display.newGroup()
    MyStick = Analog.NewStick({x = 55, y = 265, thumbSize = 25, borderSize = 45, 
          snapBackSpeed = .75, R = 255, G = 255, B = 255})
          group:insert(MyStick)
          
       function moveAnalog(e)
        if e.phase == "began" then
          MyStick.x = e.x
          MyStick.y = e.y
          e.target = MyStick.Thumb
          e.phase = "began"
          MyStick.onDrag(e)

        elseif e.phase == "moved" then
          analogTimer = timer.performWithDelay(0, transition.cancel(tapAnalog))
      end  
    end

    Runtime:addEventListener("touch", moveAnalog)
  end

  character.chooseCharacter = function(player, group) 
    local group = display.newGroup()
    
    if player == "Spirdy" or player == "Default" then
    
      physicsIdle = (require "playerSel.characters.spirdy.idleAnim.idle00").physicsData(1)
      physicsBack = (require "playerSel.characters.spirdy.backAnim.backwards00").physicsData(1)
      physicsUp = (require "playerSel.characters.spirdy.upAnim.up00").physicsData(1)
      physicsDown = (require "playerSel.characters.spirdy.downAnim.down00").physicsData(1)
      physicsForward = (require "playerSel.characters.spirdy.forwardAnim.forwards00").physicsData(1)
      
      char:newAnim("idle", 
          mcx.sequence({name = "playerSel/characters/spirdy/idleAnim/idle",
            extension = "png",
            endFrame = 10,
            zeros = 2}),
          57, 86,
          {speed = 2, loops = -1})
          
      char:newAnim("forward", 
          mcx.sequence({name = "playerSel/characters/spirdy/forwardAnim/fwd",
            extension = "png",
            endFrame = 8,
            zeros = 2}),
          62, 84,
          {speed = 2, loops = -1})
        
      char:newAnim("back", 
          mcx.sequence({name = "playerSel/characters/spirdy/backAnim/back",
            extension = "png",
            endFrame = 8,
            zeros = 2}),
          68, 84,
          {speed = 2, loops = -1})
          
      char:newAnim("up", 
          mcx.sequence({name = "playerSel/characters/spirdy/upAnim/up",
            extension = "png",
            endFrame = 8,
            zeros = 2}),
          55, 85,
          {speed = 2, loops = -1})
          
      char:newAnim("down", 
        mcx.sequence({name = "playerSel/characters/spirdy/downAnim/down",
          extension = "png",
          endFrame = 8,
          zeros = 2}),
        66, 85,
        {speed = 2, loops = -1})

    end
  
    if player == "Myme" then
      
      physicsIdle = (require "playerSel.characters.myme.idleAnim.idle00").physicsData(1)
      physicsBack = (require "playerSel.characters.myme.backAnim.backwards00").physicsData(1)
      physicsUp = (require "playerSel.characters.myme.upAnim.up00").physicsData(1)
      physicsDown = (require "playerSel.characters.myme.downAnim.down00").physicsData(1)
      physicsForward = (require "playerSel.characters.myme.forwardAnim.forwards00").physicsData(1)
      
      char:newAnim("idle", 
          mcx.sequence({name = "playerSel/characters/myme/idleAnim/idle",
            extension = "png",
            endFrame = 18,
            zeros = 2}),
          35, 90,
          {speed = 2, loops = -1})
          
      char:newAnim("forward", 
          mcx.sequence({name = "playerSel/characters/myme/forwardAnim/forward",
            extension = "png",
            endFrame = 8,
            zeros = 2}),
          46, 88,
          {speed = 2, loops = -1})
        
      char:newAnim("back", 
          mcx.sequence({name = "playerSel/characters/myme/backAnim/back",
            extension = "png",
            endFrame = 10,
            zeros = 2}),
          36, 90,
          {speed = 2, loops = -1})
          
      char:newAnim("up", 
          mcx.sequence({name = "playerSel/characters/myme/upAnim/up",
            extension = "png",
            endFrame = 8,
            zeros = 2}),
          43, 85,
          {speed = 2, loops = -1})
          
      char:newAnim("down", 
        mcx.sequence({name = "playerSel/characters/myme/downAnim/down",
          extension = "png",
          endFrame = 8,
          zeros = 2}),
        46, 88,
        {speed = 2, loops = -1})
    
    end
    
    char.type = "player"
    
    char.x = W*.5
    char.y = H*.5
    char.isFixedRotation = true
    
    charDies.x = W*.5
    charDies.y = H*.5
    charDies.isFixedRotation = true
    
    group:insert(char)
    group:insert(charDies)
    
  end
  
  -- Player dies animation
  character.playerDies = function(player)
    if char == "Spirdy" or char == "Default" then
     charDies:newAnim("dead", 
      mcx.sequence({name = "playerSel/characters/spirdy/gameOverAnim/dies",
       extension = "png",
       endFrame = 24,
       zeros = 2}),
      351, 330,
      {speed = 1, loops = 1})
    end
    
    if char == "Myme" then
      -- Temp place holder until myme death animation is complete
      charDies:newAnim("dead", 
      mcx.sequence({name = "playerSel/characters/spirdy/gameOverAnim/dies",
       extension = "png",
       endFrame = 24,
       zeros = 2}),
      351, 330,
      {speed = 1, loops = 1})
    end
    
  end
  
  character.playIdle = function()
    char:play({name = "idle"})
    physics.addBody(char, "dynamic", physicsIdle:get("idle00") )
    char.isFixedRotation = true
  end
  
  character.playFwd = function()
    physics.removeBody(char)
    char:play({name = "forward"})
    physics.addBody(char, "dynamic", physicsForward:get("forwards00") )
    char.isFixedRotation = true
  end
  
  character.playBack = function()
    physics.removeBody(char)
    char:play({name = "back"})
    physics.addBody(char, "dynamic", physicsBack:get("backwards00") )
    char.isFixedRotation = true
  end
  
  character.playUp = function()
    physics.removeBody(char)
    char:play({name = "up"})
    physics.addBody(char, "dynamic", physicsUp:get("up00") )
    char.isFixedRotation = true
  end
  
  character.playDown = function()
    physics.removeBody(char)
    char:play({name = "down"})
    physics.addBody(char, "dynamic", physicsDown:get("down00") )
    char.isFixedRotation = true
  end
  
  character.playDies = function()
    physics.removeBody(char)
    charDies:play({name = "dead"})
    charDies.isFixedRotation = true
  end
  
  -- Moves the character
  character.moveChar = function()
    function main( event )
        -- moves both the sprite sheet (bird1) and the physics image (spirdy)
        MyStick:move(char, 6.0, false)
        MyStick:move(charDies, 6.0, false)
        
        -- MOST IMPORTANT PART MAKES BIRD1 STICK TO SPIRDY EVEN IF THE PHYSICS HITS A WALL
        -- MAKING THE SPRITE SHEET NOT FLY OFF THE SCREEN
        -- Makes spirdy move forward depending on angle
          if MyStick:getAngle()>= 45 and MyStick:getAngle()<= 135 and char:currentAnimation() == "up" or MyStick:getAngle()>= 45 and MyStick:getAngle()<= 135 and char:currentAnimation() == "down" or
          MyStick:getAngle()>= 45 and MyStick:getAngle()<= 135 and char:currentAnimation() == "back" or MyStick:getAngle()>= 45 and MyStick:getAngle()<= 135 and char:currentAnimation() == "idle" then
            physics.removeBody(char)
            char:play({name = "forward"})

            physics.addBody(char, "dynamic", physicsForward:get("forwards00") )
            char.isFixedRotation = true
            
          -- Makes spirdy move backwards depending on angle       
          elseif MyStick:getAngle()>= 225 and MyStick:getAngle()<= 315 and char:currentAnimation() == "up" or MyStick:getAngle()>= 225 and MyStick:getAngle()<= 315 and char:currentAnimation() == "down" or
          MyStick:getAngle()>= 225 and MyStick:getAngle()<= 315 and char:currentAnimation() == "forward" or MyStick:getAngle()>= 225 and MyStick:getAngle()<= 315 and char:currentAnimation() == "idle" then
            physics.removeBody(char)
            char:play({name = "back"})

            physics.addBody(char, "dynamic", physicsBack:get("backwards00") )
            char.isFixedRotation = true
            
          -- Makes spirdy move upwards depending on angle
          elseif MyStick:getAngle()> 315 and MyStick:getAngle()<= 360 and char:currentAnimation() == "back" or MyStick:getAngle()> 0 and MyStick:getAngle()< 45 and char:currentAnimation() == "back" or
          MyStick:getAngle()> 315 and MyStick:getAngle()<= 360 and char:currentAnimation() == "forward" or MyStick:getAngle()> 0 and MyStick:getAngle()< 45 and char:currentAnimation() == "forward" or
          MyStick:getAngle()> 315 and MyStick:getAngle()<= 360 and char:currentAnimation() == "down" or MyStick:getAngle()> 0 and MyStick:getAngle()< 45 and char:currentAnimation() == "down" or 
          MyStick:getAngle()> 315 and MyStick:getAngle()<= 360 and char:currentAnimation() == "idle" or MyStick:getAngle()> 0 and MyStick:getAngle()< 45 and char:currentAnimation() == "idle" then
            physics.removeBody(char)
            char:play({name = "up"})

            physics.addBody(char, "dynamic", physicsUp:get("up00") )
            char.isFixedRotation = true
            
          -- Makes spirdy move downwards depending on angle
          elseif MyStick:getAngle()> 135 and MyStick:getAngle()< 225 and char:currentAnimation() == "back" or MyStick:getAngle()> 135 and MyStick:getAngle()< 225 and char:currentAnimation() == "forward" or
          MyStick:getAngle()> 135 and MyStick:getAngle()< 225 and char:currentAnimation() == "up" or MyStick:getAngle()> 135 and MyStick:getAngle()< 225 and char:currentAnimation() == "idle" then
            physics.removeBody(char)
            char:play({name = "down"})

            physics.addBody(char, "dynamic", physicsDown:get("down00") )
            char.isFixedRotation = true
      end
    end
 
    Runtime:addEventListener( "enterFrame", main )
  end
  
  character.charStop = function()
    char:stop()
  end
  
  character.charDiesStop = function()
    charDies:stop()
  end
  
  character.charPause = function()
    char:pause()
  end
  
  character.charResume = function()
    char:resume()
  end
  
  character.charDiesStop = function()
    charDies:stop()
  end
  
  character.remov = function(target)
    target:removeSelf()
    target = nil
  end
  
return character