system.getInfo("model")
display.setStatusBar(display.HiddenStatusBar)

local composer = require( "composer" )
local scene = composer.newScene()

local function onRequireWidgetLibrary(name)
  return require("widgets." .. name)
end
package.preload.widget = onRequireWidgetLibrary
package.preload.widget_slider = onRequireWidgetLibrary
package.preload.widget_switch = onRequireWidgetLibrary

local widget = require( "widget" )
local score = require( "score" )
local music = require("sounds")
local physics = require("physics")
local time = require("timer")
system.activate( "multitouch" ) -- enable multitouch functionality

local centerY = display.contentCenterY
local centerX = display.contentCenterX
local W = display.contentWidth
local H = display.contentHeight
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight
local screenTopSB = screenTop + display.topStatusBarContentHeight
local screenHeightSB = display.viewableContentHeight - screenTopSB
local screenBottomSB = screenTopSB + screenHeightSB

local wall1 = display.newRect( 0, display.contentHeight/2, 2, display.contentHeight )
local wall2 = display.newRect( display.contentWidth/2, 0, display.contentWidth, 2 )
local wall3 = display.newRect( display.contentWidth, display.contentHeight/2, 0, display.contentHeight )
local wall4 = display.newRect( display.contentWidth/2, display.contentHeight , display.contentWidth, 2 )

local myAnimation, myAnimation2
local scrollSpeed = 0.4
local scrollSpeed2 = 0.8
local gemMove2, gemMove1
local Text
local background
local background2
local background3
local planet1
local planet2
local planet3
local motionx = 0 -- Variable used to move character along x axis
local motiony = 0
local speed = 8 -- Set Walking Speed
local left, right, up, down, leftRed, upRed, downRed, rightRed

-- Variables for the in-game displays
local gemCounter
local coinCounter
local coinFont

-- In your sequences, add the parameter 'sheet=', referencing which image sheet the sequence should use
-- local variables for th Gems
local sequenceData = {{ name="Gem1", start=1, count=5, time=800, loopCount=0 }}
local SheetInfo = { width = 40, height = 60, numFrames = 5, sheetContentWidth = 200, sheetContentHeight = 60}
local redSheet = graphics.newImageSheet("redGemsSprites.png", SheetInfo)
local greenSheet = graphics.newImageSheet("greenGemsSprites.png", SheetInfo)

local myGroup = display.newGroup()
local group = {}
local tran, resumeBtn, Player, player1

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

      --------------------------
      --    Timer Functions   --
      --------------------------
-------------------------------------------------------------------------------------------------------
      function timer:createTimer(delay, listener, iterations)
        local id = null
        id = timer.performWithDelay( delay, listener, iterations )
        table.insert(group,id)
      
        -- Garbage Collection
        if iterations ~= nil and iterations ~= 0 then
          timer.performWithDelay( delay*iterations+100, function(self)
            timer:destroyTimer(id)
          end, 1 )
        end
        return id
      end
      
      -- Find ID of timer in table and destroy it
      function timer:destroyTimer(id)
        for i=1, table.maxn(group), 1 do
          if group[i] == id then
            timer.cancel(id)
            table.remove(group,i)
            return true
          end
        end
          return false
      end
      
      function timer:flushAllTimers()
        for i=table.maxn(group), 1, -1 do
          timer.cancel(group[i])
          table.remove(group,i)
        end
      end
      
      function timer:pauseAllTimers()
        for i=1, table.maxn(group), 1 do
          timer.pause(group[i])
        end
      end
      
      function timer:resumeAllTimers()
        for i=1, table.maxn(group), 1 do
          timer.resume(group[i])
        end
      end 
-------------------------------------------------------------------------------------------------------

local function pause(event)
  local go = event.target.id
  if go == "pause" then
    composer.showOverlay(go, {isModal = true})
    physics.pause()
    transition.pause()
    timer:pauseAllTimers()
    music.atroxOff()
    scrollSpeed = 0
    scrollSpeed2 = 0
   end
end

function scene:resume()
   physics.start()
   transition.resume()
   timer:resumeAllTimers()
   music.atroxOn()
   scrollSpeed = .4
   scrollSpeed2 = .8
end

scene:addEventListener( "resume", scene )

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    --local group = display.newGroup()
    --group:insert(sceneGroup)
    
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
      sceneGroup:insert(wall1)
      sceneGroup:insert(wall2)
      sceneGroup:insert(wall3)
      sceneGroup:insert(wall4)
      
      physics.start()
      physics.setGravity(0,0)
      music.Atrox()

      -- Create bounding wall for the level
      physics.addBody( wall1, "kinematic", wallMaterial )
      physics.addBody( wall2, "kinematic", wallMaterial )
      physics.addBody( wall3, "kinematic", wallMaterial )
      physics.addBody( wall4, "kinematic", wallMaterial )
        
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    local group = display.newGroup()
    group:insert(sceneGroup)

    if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      
      ----------------------
      --    Background    --
      ----------------------
-------------------------------------------------------------------------------------------------------
      composer.removeScene("levelSelChal")
      Text = display.newText( " ", W*.6, H-20, native.systemFont, 15 )
      background =  display.newImageRect("level1_p1.png", 712.5, 450)
      background2 =  display.newImageRect("level1_p2.png", 712.5, 450)
      background3 =  display.newImageRect("level1_p3.png", 712.5, 450)
      planet1 =  display.newImageRect("planet1.png", 712.5, 450)
      planet2 =  display.newImageRect("planet2.png", 712.5, 450)
      planet3 =  display.newImageRect("planet3.png", 712.5, 450)

      -- Variables for the in-game displays
      gemCounter = display.newImageRect("gameUI/counter_gem.png", 140, 60)
      coinCounter = display.newImageRect("gameUI/counter_coin.png", 140, 60)
      coinFont = display.newText("1", 0, 0, "Soup Of Justice", 24)
      
      -- Directional controls 
      left = widget.newButton
      {
        width = 84, 
        height = 56, 
        defaultFile = "arrows/arrowLeft.png",
        overFile = "arrows/arrowLeftRed.png"
      }
      
      right = widget.newButton
      {
        width = 84, 
        height = 56, 
        defaultFile = "arrows/arrowRight.png", 
        overFile = "arrows/arrowRightRed.png"
      }
        
      up = widget.newButton
      {
        width = 56, 
        height = 84, 
        defaultFile = "arrows/arrowUp.png", 
        overFile = "arrows/arrowUpRed.png"
      }
      
      down = widget.newButton
      {
        width = 56, 
        height = 84, 
        defaultFile = "arrows/arrowDown.png", 
        overFile = "arrows/arrowDownRed.png"
      }
      --[[left = display.newImageRect("arrows/arrowLeft.png", 84, 56)
      right = display.newImageRect("arrows/arrowRight.png", 84, 56)
      up = display.newImageRect("arrows/arrowUp.png", 56, 84)
      down = display.newImageRect("arrows/arrowDown.png", 56, 84)]]--
      
      background:scale(1, 1)
      background.anchorX = 0;
      background.anchorY = .5;
      background.x = 0; background.y = H/2;
  
      background2:scale(1, 1)
      background2.anchorX = 0;
      background2.anchorY = 0.5;
      background2.x = 712.5; background2.y = H/2;
  
      background3:scale(1, 1)
      background3.anchorX = 0;
      background3.anchorY = 0.5;
      background3.x = 1425; background3.y = H/2;
  
      planet1:scale(1, 1)
      planet1.anchorX = 0;
      planet1.anchorY = .5;
      planet1.x = 0; planet1.y = H/2;
  
      planet2:scale(1, 1)
      planet2.anchorX = 0;
      planet2.anchorY = 0.5;
      planet2.x = 712.5; planet2.y = H/2;
  
      planet3:scale(1, 1)
      planet3.anchorX = 0;
      planet3.anchorY = 0.5;
      planet3.x = 1425; planet3.y = H/2;

      sceneGroup:insert(background)
      sceneGroup:insert(background2)
      sceneGroup:insert(background3)
      sceneGroup:insert(planet1)
      sceneGroup:insert(planet2)
      sceneGroup:insert(planet3)
  
      coinCounter.x = 210
      coinCounter.y = 29
      coinCounter.alpha = 1
  
      gemCounter.x = 65
      gemCounter.y = 30
      gemCounter.alpha = 1
  
      coinFont:setFillColor( 0, 0, 0 )
      coinFont.anchorX = 0
      coinFont.x = 245
      coinFont.y = 32
      
      left.x = 560
      left.y = 365
      left.alpha = 1
      
      right.x = 650
      right.y = 365.5
      right.alpha = 1
      
      up.x = 40
      up.y = 140
      up.alpha = 1
      
      down.x = 39.5
      down.y = 230
      down.alpha = 1
      
      sceneGroup:insert(Text)
      sceneGroup:insert(coinCounter)
      sceneGroup:insert(gemCounter)
      sceneGroup:insert(coinFont)
      sceneGroup:insert(left)
      sceneGroup:insert(right)
      sceneGroup:insert(up)
      sceneGroup:insert(down)

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        local function move(event)
  
          background.x = background.x - scrollSpeed
          background2.x = background2.x - scrollSpeed
          background3.x = background3.x - scrollSpeed
        
          if(background.x + background.contentWidth) < -712.5 then
            background:translate(712.5*3, 0)
          end
        
          if(background2.x + background2.contentWidth) < -712.5 then
            background2:translate(712.5*3, 0)
          end
        
          if(background3.x + background3.contentWidth) < -712.5 then
            background3:translate(712.5*3, 0)
          end
        end
  
      Runtime:addEventListener("enterFrame", move)
  
      local function move2(event)
  
        planet1.x = planet1.x - scrollSpeed2
        planet2.x = planet2.x - scrollSpeed2
        planet3.x = planet3.x - scrollSpeed2
          
        if(planet1.x + planet1.contentWidth) < -712.5 then
          planet1:translate(712.5*3, 0)
        end
          
        if(planet2.x + planet2.contentWidth) < -712.5 then
          planet2:translate(712.5*3, 0)
        end
          
        if(planet3.x + planet3.contentWidth) < -712.5 then
          planet3:translate(712.5*3, 0)
        end
      end
  
      Runtime:addEventListener("enterFrame", move2)

      local scoreText = score.init({fontSize = 20, font = "Soup Of Justice", x = 90, y = 32, maxDigits = 5, leadingZeros = false, filename = "scorefile.txt",})
        scoreText:setFillColor(0, 0, 0)
        sceneGroup:insert(scoreText)
      
-------------------------------------------------------------------------------------------------------

    ----------------
    --    Gems    --
    ----------------
-------------------------------------------------------------------------------------------------------
    local gemMove1 = function()
      local function handleOnComplete(target)
           target:removeSelf()
           target = nil
      end

    myAnimation = display.newSprite( redSheet, sequenceData )
        myAnimation.y = 1 + math.random( 450 ); myAnimation.x = 800
        physics.addBody(myAnimation, "kinematic", {isSensor = true})
        transition.to(myAnimation,{time = math.random(6000,25000),x=(W-2000), onComplete = handleOnComplete})
        myAnimation:setSequence( "Gem1" )
        myAnimation:play()
        myAnimation.type = "gems1"
        myAnimation.value = 1
        sceneGroup:insert(myAnimation)
    end

    local gemMove2 = function()
      local function handleOnComplete(target)
           target:removeSelf()
           target = nil
      end

    myAnimation2 = display.newSprite( greenSheet, sequenceData )
        myAnimation2.y = 1 + math.random( 450 ); myAnimation2.x = 800
        physics.addBody(myAnimation2, "kinematic", {isSensor = true})
        transition.to(myAnimation2,{time = math.random(6000,25000),x=(W-2000), onComplete = handleOnComplete})
        myAnimation2:setSequence( "Gem1" )
        myAnimation2:play()
        myAnimation2.type = "gems2"
        myAnimation2.value = 1
        sceneGroup:insert(myAnimation2)
    end

    -- After a short time, swap the sequence to 'seq2' which uses the second image sheet
    local function swapSheet()
           myAnimation:setSequence( "Gem1" )
           myAnimation:play()
    end
-------------------------------------------------------------------------------------------------------

    --------------------
    --    Obstacles   --
    --------------------
-------------------------------------------------------------------------------------------------------
    local opMove5 = function()
        local function handleOnComplete(target)
           target:removeSelf()
           target = nil
        end
      
        local physicsData = (require "obstacle_5").physicsData(1)
        local op5 = display.newImageRect("obstacle_5.png",680,450)

        physics.addBody(op5, "kinematic", physicsData:get("obstacle_5") )
        op5.x = 1000
        op5.y = 200
        op5.type = "op5"
        sceneGroup:insert(op5)
      
        transition.to(op5,{time = 10000,x=(W-2000), onComplete = handleOnComplete})
    end

    local opMove4 = function()
      local function handleOnComplete(target)
           target:removeSelf()
           target = nil
      end
      
      local physicsData = (require "obstacle_4").physicsData(1)
      local op4 = display.newImageRect("obstacle_4.png",713,450)

      physics.addBody(op4, "kinematic", physicsData:get("obstacle_4") )
      op4.x = 1000
      op4.y = 200
      op4.type = "op4"
      sceneGroup:insert(op4)
      
      transition.to(op4,{time = 10000,x=(W-2000), onComplete = handleOnComplete})
    end

    local opMove3 = function()
        local function handleOnComplete(target)
           target:removeSelf()
           target = nil
        end
      
        local physicsData = (require "L1_Cshape_crop").physicsData(1)
        local op3 = display.newImageRect("L1_Cshape_crop.png",486,435)
      
        physics.addBody(op3, "kinematic", physicsData:get("L1_Cshape_crop") )
        op3.rotation = 400
        op3.x = 1000
        op3.y = 200
        op3.type = "op3"
        sceneGroup:insert(op3)
        
        transition.to(op3,{time = 10000,x=(W-2000), onComplete = handleOnComplete})
        
        local function Lshaperotate()
          transition.to(op3,{time = 2500,rotation = op3.rotation-360, onComplete = Lshaperotate})
        end
        
        Lshaperotate()
    end

    local opMove2 = function()
        local function handleOnComplete(target)
           target:removeSelf()
           target = nil
        end

        local physicsData = (require "obstacle_2").physicsData(1)
        local op2 = display.newImageRect("obstacle_2.png",713,450)

        physics.addBody(op2, "kinematic", physicsData:get("obstacle_2") )
        op2.x = 1000
        op2.y = 175
        op2.type = "op2"
        sceneGroup:insert(op2)
      
        transition.to(op2,{time = 10000,x=(W-2000), onComplete = handleOnComplete})
    end

    local opMove1 = function()
        local function handleOnComplete(target)
           target:removeSelf()
           target = nil
        end

        local physicsData = (require "obstacle_1").physicsData(1)
        local op1 = display.newImageRect("obstacle_1.png",713,450)
      
        physics.addBody(op1, "kinematic", physicsData:get("obstacle_1") )
        op1.x = 1000
        op1.y = 200
        op1.type = "op1"
        sceneGroup:insert(op1)
      
        transition.to(op1,{time = 10000,x=(W-2000), onComplete = handleOnComplete})
    end

    local pick = function()
      Object = math.ceil(math.random(1,5))
      if Object == 1 then opMove1()  
      elseif Object == 2 then opMove2()
      elseif Object == 3 then opMove3()
      elseif Object == 4 then opMove4()  
      elseif Object == 5 then opMove5() 
      end
    end

    timer:createTimer(2500, pick, 99999)
    timer:createTimer( math.random(1000,4000), gemMove1, 99999)
    timer:createTimer( math.random(1000,4000), gemMove2, 99999)
-------------------------------------------------------------------------------------------------------

    local pause = widget.newButton
    {
       width = 40,
       height = 40,
       defaultFile = "pause.png",
       id = "pause",
       onRelease = pause
    }
    pause.x = 650
    pause.y = 30
    pause.alpha = 0.7
    sceneGroup:insert(pause)

    -- Creates the player Spirdy
    Player = display.newGroup()
    Player.x = W * .5
    Player.y = H * .5
    
    -- Sets player to a type object for collision listener
    Player.type = "player"
    
    player1 = display.newImageRect("spirdyDown.png", 66, 85)
    Player:insert (player1)
    physics.addBody( Player, "dynamic", { density=0, friction=0.0, bounce=0.0 } )
    sceneGroup:insert(Player)
    
    local function stop (event)
      if event.phase =="ended" then
        motionx = 0
        motiony = 0
      end
    end
    Runtime:addEventListener("touch", stop )
    -- When no arrow is pushed, this will stop me from moving.
    
   local function movePlayer (event)
    Player.x = Player.x + motionx
    Player.y = Player.y + motiony
   end

  Runtime:addEventListener("enterFrame", movePlayer)
  -- When an arrow is pushed, this will make me move.
  
  function up:touch(event)
    motiony = -speed
  end
  up:addEventListener("touch", up)

  function down:touch(event)
    motiony = speed
  end
  down:addEventListener("touch", down)

  function left:touch(event)
    motionx = -speed
  end
  left:addEventListener("touch",left)

  function right:touch(event)
    motionx = speed
  end
  right:addEventListener("touch",right)

    -- Collides with the Red gem and adds to the counter
    local function onCollision(event)
      if event.phase == "began" then
       local player = event.object1
       local gem1 = event.object2
         
        if player.type == "player" and gem1.type == "gems1" then
          score.add(event.object2.value)
          event.object2.alpha = 0
        end
      end
    end

    Runtime:addEventListener("collision", onCollision)

    -- Collides with the Gree gem and adds to the counter
    local function onCollision2(event)
      if event.phase == "began" then
       local player = event.object1
       local gem2 = event.object2
         
        if player.type == "player" and gem2.type == "gems2" then
          score.add(event.object2.value)
          event.object2.alpha = 0
        end
      end
    end
         
    Runtime:addEventListener("collision", onCollision2)
    
    -- Collision for obstacle3
     local function onCollision3(event)
      if event.phase == "began" then
       local player = event.object1
       local op3 = event.object2
       local op5 = event.object3
        if player.type == "player" and op3.type == "op3" then
           
           Runtime:removeEventListener("enterFrame", move)
           Runtime:removeEventListener("enterFrame", move2)
           Runtime:removeEventListener("enterFrame", movePlayer)
           physics.stop()
           transition.cancel()
           timer:pauseAllTimers()
           music.remove()
           composer.gotoScene("gameOverChal")

        end
      end
    end
    
    Runtime:addEventListener("collision", onCollision3)
    
     -- Collision for obstacle 5
     local function onCollision4(event)
      if event.phase == "began" then
       local player = event.object1
       local op5 = event.object2
        if player.type == "player" and op5.type == "op5" then
           
           Runtime:removeEventListener("enterFrame", move)
           Runtime:removeEventListener("enterFrame", move2)
           Runtime:removeEventListener("enterFrame", movePlayer)
           physics.stop()
           transition.cancel()
           timer:pauseAllTimers()
           music.remove()
           composer.gotoScene("gameOverChal")
        end
      end
    end
    
    Runtime:addEventListener("collision", onCollision4)
    
     -- Collision for obstacle 4
     local function onCollision5(event)
      if event.phase == "began" then
       local player = event.object1
       local op4 = event.object2
        if player.type == "player" and op4.type == "op4" then
           
           Runtime:removeEventListener("enterFrame", move)
           Runtime:removeEventListener("enterFrame", move2)
           Runtime:removeEventListener("enterFrame", movePlayer)
           physics.stop()
           transition.cancel()
           timer:pauseAllTimers()
           music.remove()
           composer.gotoScene("gameOverChal")
        end
      end
    end
    
    Runtime:addEventListener("collision", onCollision5)
    
     -- Collision for obstacle 5
     local function onCollision6(event)
      if event.phase == "began" then
       local player = event.object1
       local op2 = event.object2
        if player.type == "player" and op2.type == "op2" then
           
           Runtime:removeEventListener("enterFrame", move)
           Runtime:removeEventListener("enterFrame", move2)
           Runtime:removeEventListener("enterFrame", movePlayer)
           physics.stop()
           transition.cancel()
           timer:pauseAllTimers()
           music.remove()
           composer.gotoScene("gameOverChal")
        end
      end
    end
    
    Runtime:addEventListener("collision", onCollision6)
    
     -- Collision for obstacle 5
     local function onCollision7(event)
      if event.phase == "began" then
       local player = event.object1
       local op1 = event.object2
        if player.type == "player" and op1.type == "op1" then

           Runtime:removeEventListener("enterFrame", move)
           Runtime:removeEventListener("enterFrame", move2)
           Runtime:removeEventListener("enterFrame", movePlayer)
           physics.stop()
           transition.cancel()
           timer:pauseAllTimers()
           music.remove()
           composer.gotoScene("gameOverChal")
           
        end
      end
    end
    
    Runtime:addEventListener("collision", onCollision7)
        
     local function saveScore( event )
      if event.phase == "ended" then
        score.save()
      end
      return true
    end
  
    local function loadScore( event )
      if event.phase == "ended" then
        local prevScore = score.load()
        if prevScore then
          score.set(prevScore)
        end
      end
      return true
    end
    
    local saveButton = widget.newButton({width = 200, height = 64, x = display.contentCenterX, y = display.contentHeight - 32,
      label = "Save Score", labelColor = { default = { 1, 1, 1 }, over = { 0, 0, 0 } },
      fontSize = 32, onEvent = saveScore})
      sceneGroup:insert(saveButton)

    local loadButton = widget.newButton({ width = 200, height = 64, x = display.contentCenterX, y = display.contentHeight - 64,
      label = "Load Score", labelColor = { default = { 1, 1, 1 }, over = { 0, 0, 0 } },
      fontSize = 32, onEvent = loadScore})
      sceneGroup:insert(loadButton)
         
    end
end

-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
                
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene