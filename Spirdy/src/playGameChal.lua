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
local myData = require("myData")

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

physics.start()
physics.setGravity(0,0)
physics.setContinuous(true)

local group = {}
local wall1, wall2, wall3, wall4, Text, gemCounter, coinCounter, coinFont, background, background2, background3, 
  stars1, stars2, stars3, pause, cloud1, cloud2, cloud3, gem, op1, op2, op3, op4, op4C,  op5, op6, op7, op8, 
  op9, op10, op11, op12, op13, op14, op15, light1, shadows, scoreText
  
local score = myData.lv1Score 
local prevScore = myData.lv1PrevScore
local highScore = myData.lv1HighScore
local random = math.random

-- Local variables for character handler
local char = mcx.new()
local charDies = mcx.new()
char:enableDebugging()
charDies:enableDebugging()

-- Set Walking Speed
local speed = 8 
local left, right, up, down, leftRed, upRed, downRed, rightRed


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

music.remove()

-- local forward references should go here
local function pause(event)
  local go = event.target.id
  if go == "pause" then
    composer.showOverlay(go, {isModal = true})
    char:pause()
    physics.pause()
    transition.pause()
    timer.pause(objTimer)
    timer.pause(gemTimer)
    --music.atroxOff()
    myData.bgScrollSpeed = 0
    myData.planetScrollSpeed = 0
    pause.alpha = 0
   end
end

function scene:resume()
   char:resume()
   physics.start()
   transition.resume()
   timer.resume(objTimer)
   timer.resume(gemTimer)
   --music.atroxOn()
   myData.bgScrollSpeed = 0.4
   myData.planetScrollSpeed = 0.8
   pause.alpha = 1
end

-- Deletes data when changing scene
function scene:remove()
  background:removeSelf()
  background = nil
  background2:removeSelf()
  background2 = nil
  background3:removeSelf()
  background3 = nil
  
  stars1:removeSelf()
  stars1 = nil
  stars2:removeSelf()
  stars2 = nil
  stars3:removeSelf()
  stars3 = nil
  
  cloud1:removeSelf()
  cloud1 = nil
  cloud2:removeSelf()
  cloud2 = nil
  cloud3:removeSelf()
  cloud3 = nil
  
  wall1:removeSelf()
  wall1 = nil
  wall2:removeSelf()
  wall2 = nil
  wall3:removeSelf()
  wall3 = nil
  wall4:removeSelf()
  wall4 = nil
end

local function highScore()
   if myData.lv1CScore > myData.lv1CHighScore then
     myData.lv1CHighScore = myData.lv1CScore
   end
end

local function resetScore()
  myData.lv1CScore = 0
end

local function setPrevScore()
  myData.lv1CPrevScore = myData.lv1CScore
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    --local group = display.newGroup()
    --group:insert(sceneGroup)
    
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
      wall1 = display.newRect(sceneGroup, 0, display.contentHeight/2, 2, display.contentHeight )
      wall2 = display.newRect(sceneGroup, display.contentWidth/2, 0, display.contentWidth, 2 )
      wall3 = display.newRect(sceneGroup, display.contentWidth, display.contentHeight/2, 0, display.contentHeight )
      wall4 = display.newRect(sceneGroup, display.contentWidth/2, display.contentHeight , display.contentWidth, 2 )

      -- Create bounding wall for the level
      physics.addBody( wall1, "kinematic", wallMaterial )
      physics.addBody( wall2, "kinematic", wallMaterial )
      physics.addBody( wall3, "kinematic", wallMaterial )
      physics.addBody( wall4, "kinematic", wallMaterial )
      
      ----------------------
      --    Background/UI    --
      ----------------------
-------------------------------------------------------------------------------------------------------
      Text = display.newText(sceneGroup, " ", W*.6, H-20, native.systemFont, 15 )
      background = display.newImageRect(sceneGroup, "bg/bg1Part1.png", 712.5, 450)
      background2 = display.newImageRect(sceneGroup, "bg/bg1Part2.png", 712.5, 450)
      background3 = display.newImageRect(sceneGroup, "bg/bg1Part3.png", 712.5, 450)
      stars1 =  display.newImageRect(sceneGroup, "bg/stars1.png", 712.5, 450)
      stars2 =  display.newImageRect(sceneGroup, "bg/stars2.png", 712.5, 450)
      stars3 =  display.newImageRect(sceneGroup, "bg/stars3.png", 712.5, 450)
      cloud1 =  display.newImageRect(sceneGroup, "bg/clouds1.png", 712.5, 450)
      cloud2 =  display.newImageRect(sceneGroup, "bg/clouds2.png", 712.5, 450)
      cloud3 =  display.newImageRect(sceneGroup, "bg/clouds3.png", 712.5, 450)
      
      --[[shadows = Shadows:new( 0.8, {0.5,0,0.5} )
      shadows:SetRealAttenuation( true )
      shadows.x = -10
      shadows.y = -10
      sceneGroup:insert(shadows)
      
      light1 = shadows:AddLight(2, {1,0,1}, .04, 2)
      light1:SetDraggable(false)
      sceneGroup:insert(light1)]]--
      
      -- Variables for the in-game displays
      gemCounter = display.newImageRect(sceneGroup, "gameUI/counter_gem.png", 140, 60)
      coinCounter = display.newImageRect(sceneGroup, "gameUI/counter_coin.png", 140, 60)
      
      coinFont = display.newText(sceneGroup, myData.coins, 245, 32, "Soup Of Justice", 24)
      coinFont:setFillColor( 0, 0, 0 )
      coinFont.anchorX = 0
      
      scoreText = display.newText(sceneGroup, myData.lv1Score, 90, 32, "Soup Of Justice", 24)
      scoreText:setFillColor(0, 0, 0)
      scoreText.anchorX = 0
      
      -- Background
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
  
      stars1:scale(1, 1)
      stars1.anchorX = 0;
      stars1.anchorY = .5;
      stars1.x = 0; stars1.y = H/2;
  
      stars2:scale(1, 1)
      stars2.anchorX = 0;
      stars2.anchorY = 0.5;
      stars2.x = 712.5; stars2.y = H/2;
  
      stars3:scale(1, 1)
      stars3.anchorX = 0;
      stars3.anchorY = 0.5;
      stars3.x = 1425; stars3.y = H/2;
      
      cloud1:scale(1, 1)
      cloud1.anchorX = 0;
      cloud1.anchorY = 0.5;
      cloud1.x = 0; cloud1.y = H/2;
  
      cloud2:scale(1, 1)
      cloud2.anchorX = 0;
      cloud2.anchorY = 0.5;
      cloud2.x = 712.5; cloud2.y = H/2;
  
      cloud3:scale(1, 1)
      cloud3.anchorX = 0;
      cloud3.anchorY = 0.5;
      cloud3.x = 1425; cloud3.y = H/2;
      
      -- Obstacles
      op1 = display.newImageRect(sceneGroup, "levels/normalMode/level1/obstacle1.png", 491, 450)
      op1.isVisible = false
      op1.isBodyActive = false
      sceneGroup:insert(op1)
      
      op2 = display.newImageRect(sceneGroup, "levels/normalMode/level1/obstacle2.png", 478, 450)
      op2.isVisible = false
      op2.isBodyActive = false
      sceneGroup:insert(op2)
      
      op3 = display.newImageRect(sceneGroup, "levels/normalMode/level1/obstacle6.png", 379, 396)
      op3.isVisible = false
      op3.isBodyActive = false
      sceneGroup:insert(op3)
      
      op4 = display.newImageRect(sceneGroup, "levels/normalMode/level1/obstacle3.png", 663, 450)
      op4.isVisible = false
      op4.isBodyActive = false
      sceneGroup:insert(op4)
      
      op4C = display.newImageRect(sceneGroup, "levels/normalMode/level1/obstacle6.png", 379, 396)
      op4C.isVisible = false
      op4C.isBodyActive = false
      sceneGroup:insert(op4C)
      
      op5 = display.newImageRect(sceneGroup, "levels/normalMode/level1/obstacle5.png", 598, 450)
      op5.isVisible = false
      op5.isBodyActive = false
      sceneGroup:insert(op5)
      
      op6 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_1.png", 490, 450)
      op6.isVisible = false
      op6.isBodyActive = false
      sceneGroup:insert(op6)
      
      op7 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_2.png", 691, 441)
      op7.isVisible = false
      op7.isBodyActive = false
      sceneGroup:insert(op7)
      
      op8 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_3.png", 547, 436)
      op8.isVisible = false
      op8.isBodyActive = false
      sceneGroup:insert(op8)
      
      op9 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_5.png", 595, 450)
      op9.isVisible = false
      op9.isBodyActive = false
      sceneGroup:insert(op9)
      
      op10 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_6.png", 412, 450)
      op10.isVisible = false
      op10.isBodyActive = false
      sceneGroup:insert(op10)
      
      op11 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_7.png", 380, 450)
      op11.isVisible = false
      op11.isBodyActive = false
      sceneGroup:insert(op11)
      
      op12 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_9.png", 262, 450)
      op12.isVisible = false
      op12.isBodyActive = false
      sceneGroup:insert(op12)
      
      op13 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_10.png", 374, 450)
      op13.isVisible = false
      op13.isBodyActive = false
      sceneGroup:insert(op13)
      
      op14 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_11.png", 414, 450)
      op14.isVisible = false
      op14.isBodyActive = false
      sceneGroup:insert(op14)
      
      op15 = display.newImageRect(sceneGroup, "levels/normalMode/level1/ob_12.png", 266, 450)
      op15.isVisible = false
      op15.isBodyActive = false
      sceneGroup:insert(op15)
  
      gemCounter.x = 65
      gemCounter.y = 30
      gemCounter.alpha = 1
        
      coinCounter.x = 210
      coinCounter.y = 29
      coinCounter.alpha = 1
      
      pause = widget.newButton
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
      
      sceneGroup:insert(left)
      sceneGroup:insert(right)
      sceneGroup:insert(up)
      sceneGroup:insert(down)
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
      function move(event)
  
          background.x = background.x - myData.bgScrollSpeed
          background2.x = background2.x - myData.bgScrollSpeed
          background3.x = background3.x - myData.bgScrollSpeed
        
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
  
      function move2(event)
  
        stars1.x = stars1.x - myData.starScrollSpeed
        stars2.x = stars2.x - myData.starScrollSpeed
        stars3.x = stars3.x - myData.starScrollSpeed
          
        if(stars1.x + stars1.contentWidth) < -712.5 then
          stars1:translate(712.5*3, 0)
        end
          
        if(stars2.x + stars2.contentWidth) < -712.5 then
          stars2:translate(712.5*3, 0)
        end
          
        if(stars3.x + stars3.contentWidth) < -712.5 then
          stars3:translate(712.5*3, 0)
        end
      end
  
      Runtime:addEventListener("enterFrame", move2)
      
      function move3(event)
  
        cloud1.x = cloud1.x - myData.planetScrollSpeed
        cloud2.x = cloud2.x - myData.planetScrollSpeed
        cloud3.x = cloud3.x - myData.planetScrollSpeed
          
        if(cloud1.x + cloud1.contentWidth) < -712.5 then
          cloud1:translate(712.5*3, 0)
        end
          
        if(cloud2.x + cloud2.contentWidth) < -712.5 then
          cloud2:translate(712.5*3, 0)
        end
          
        if(cloud3.x + cloud3.contentWidth) < -712.5 then
          cloud3:translate(712.5*3, 0)
        end
      end
  
      Runtime:addEventListener("enterFrame", move3)

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        -- In your sequences, add the parameter 'sheet =', referencing which image sheet the sequence should be used
    -- local variables for the Gems
    local sequenceData = {{ name="Gem1", start  =1, count = 5, time = 800, loopCount = 0 }}
    local SheetInfo = { width = 40, height = 60, numFrames = 5, sheetContentWidth = 200, sheetContentHeight = 60}
    local redSheet = graphics.newImageSheet("redGemsSprites.png", SheetInfo)
    local greenSheet = graphics.newImageSheet("greenGemsSprites.png", SheetInfo)
      
    local function genGems()
      local gems = {redSheet, greenSheet}
      local gemRan = gems[math.random(#gems)];
      local gemPhysData = (require "blueGem01").physicsData(1.0)
      
      gem = display.newSprite(sceneGroup, gemRan, sequenceData);
    
      gem.Gems = gemRan
        
      physics.addBody( gem, "kinematic", gemPhysData:get("blueGem01"))
      
      gem.y = 1 + math.random( 450 ) 
      gem.x = 800
      gem:setSequence( "Gem1" )
      
      gem.type = "gems"
      gem.value = 1
      gem:play()
      
      local function gemsRemove(target)
        physics.removeBody(target)
        target:removeSelf()
        target = nil
      end
      
        transition.to(gem, {time = 4500,x=(W-900), onComplete = gemsRemove, tag = "transTag"})
        
        -- After a short time, swap the sequence to 'seq2' which uses the second image sheet
        local function swapSheet()
               gem:setSequence( "Gem1" )
               gem:play()
        end
    end
      
-------------------------------------------------------------------------------------------------------

    --------------------
    --    Obstacles   --
    --------------------
-------------------------------------------------------------------------------------------------------
    local physicsData = (require "levels.normalMode.level1.level1Physics").physicsData(1.0)
    
    local opMove5 = function()
        
        physics.addBody(op5, "kinematic", physicsData:get("obstacle5") )
        op5.x = 1000
        op5.y = 200
        op5.isVisible = true
        op5.isBodyActive = true
        op5.type = "obstacle"
        
        local function op5Remove(target)
          op5.isVisible = false
          op5.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op5, {time = 12500, x=(W-2500), onComplete = op5Remove, tag = "transTag"})
    end

    local opMove3 = function()
        
        physics.addBody(op3, "kinematic", physicsData:get("obstacle6") )
        op3.rotation = 400
        op3.x = 1000
        op3.y = 175
        op3.isVisible = true
        op3.isBodyActive = true
        op3.type = "obstacle"
        
        local function op3Remove(target)
          op3.isVisible = false
          op3.isBodyActive = false
          physics.removeBody(target)
        end
        
        transition.to(op3, {time = 12500, x=(W-2500), onComplete = op3Remove, tag = "transTag"})
        
        local function Lshaperotate()
          transition.to(op3, {time = 2500,rotation = op3.rotation-360, onComplete = Lshaperotate, tag = "transTag"})
        end
        
        Lshaperotate()
    end

    local opMove2 = function()
        
        physics.addBody(op2, "kinematic", physicsData:get("obstacle2") )
        op2.x = 1000
        op2.y = 200
        op2.isVisible = true
        op2.isBodyActive = true
        op2.type = "obstacle"
        
        local function op2Remove(target)
          op2.isVisible = false
          op2.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op2, {time = 12500, x=(W-2500), onComplete = op2Remove, tag = "transTag"})
    end

    local opMove1 = function()
        
        physics.addBody(op1, "kinematic", physicsData:get("obstacle1") )
        op1.x = 1000
        op1.y = 200
        op1.isVisible = true
        op1.isBodyActive = true
        op1.type = "obstacle"
        
        local function op1Remove(target)
          op1.isVisible = false
          op1.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op1, {time = 12500, x=(W-2500), onComplete = op1Remove, tag = "transTag"})
    end
    
    local opMove4 = function() 
        
        physics.addBody(op4, "kinematic", physicsData:get("obstacle3") )
        op4.x = 1000
        op4.y = 200
        op4.isVisible = true
        op4.isBodyActive = true
        op4.type = "obstacle"
        
        physics.addBody(op4C, "kinematic", physicsData:get("obstacle6") )
        op4C.x = 1000
        op4C.y = 200
        op4C.isVisible = true
        op4C.isBodyActive = true
        op4C.type = "obstacle"
        
        local function op4Remove(target)
          op4.isVisible = false
          op4.isBodyActive = false
          
          op4C.isVisible = false
          op4C.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op4C, {time = 12500, x=(W-2500), onComplete = op4Remove, tag = "transTag"})
      
        transition.to(op4, {time = 12500, x=(W-2500), onComplete = op4Remove, tag = "transTag"})
        
        local function cRotate()
          transition.to(op4C, {time = 2500, rotation = op4C.rotation-360, onComplete = cRotate, tag = "transTag"})
        end
        
        cRotate()
    end
    
    local opMove6 = function()
        
        physics.addBody(op6, "kinematic", physicsData:get("ob_1") )
        op6.x = 1000
        op6.y = 200
        op6.isVisible = true
        op6.isBodyActive = true
        op6.type = "obstacle"
        
        local function op6Remove(target)
          op6.isVisible = false
          op6.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op6, {time = 12500, x=(W-2500), onComplete = op6Remove, tag = "transTag"})
    end
    
    local opMove7 = function()

        physics.addBody(op7, "kinematic", physicsData:get("ob_2") )
        op7.x = 1000
        op7.y = 200
        op7.isVisible = true
        op7.isBodyActive = true
        op7.type = "obstacle"
        
        local function op7Remove(target)
          op7.isVisible = false
          op7.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op7, {time = 12500, x=(W-2500), onComplete = op7Remove, tag = "transTag"})
    end
    
    local opMove8 = function()

        physics.addBody(op8, "kinematic", physicsData:get("ob_3") )
        op8.x = 1000
        op8.y = 200
        op8.isVisible = true
        op8.isBodyActive = true
        op8.type = "obstacle"
        
        local function op8Remove(target)
          op8.isVisible = false
          op8.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op8, {time = 12500, x=(W-2500), onComplete = op8Remove, tag = "transTag"})
    end
    
    local opMove9 = function()

        physics.addBody(op9, "kinematic", physicsData:get("ob_5") )
        op9.x = 1000
        op9.y = 200
        op9.isVisible = true
        op9.isBodyActive = true
        op9.type = "obstacle"
        
        local function op9Remove(target)
          op9.isVisible = false
          op9.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op9, {time = 12500, x=(W-2500), onComplete = op9Remove, tag = "transTag"})
    end
    
    local opMove10 = function()

        physics.addBody(op10, "kinematic", physicsData:get("ob_6") )
        op10.x = 1000
        op10.y = 200
        op10.isVisible = true
        op10.isBodyActive = true
        op10.type = "obstacle"
        
        local function op10Remove(target)
          op10.isVisible = false
          op10.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op10, {time = 12500, x=(W-2500), onComplete = op10Remove, tag = "transTag"})
    end
    
    local opMove11 = function()

        physics.addBody(op11, "kinematic", physicsData:get("ob_7") )
        op11.x = 1000
        op11.y = 200
        op11.isVisible = true
        op11.isBodyActive = true
        op11.type = "obstacle"
        
        local function op11Remove(target)
          op11.isVisible = false
          op11.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op11, {time = 12500, x=(W-2500), onComplete = op11Remove, tag = "transTag"})
    end
    
    local opMove12 = function()

        physics.addBody(op12, "kinematic", physicsData:get("ob_9") )
        op12.x = 1000
        op12.y = 200
        op12.isVisible = true
        op12.isBodyActive = true
        op12.type = "obstacle"
        
        local function op12Remove(target)
          op12.isVisible = false
          op12.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op12, {time = 12500, x=(W-2500), onComplete = op12Remove, tag = "transTag"})
    end
    
    local opMove13 = function()

        physics.addBody(op13, "kinematic", physicsData:get("ob_10") )
        op13.x = 1000
        op13.y = 200
        op13.isVisible = true
        op13.isBodyActive = true
        op13.type = "obstacle"
        
        local function op13Remove(target)
          op13.isVisible = false
          op13.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op13, {time = 12500, x=(W-2500), onComplete = op13Remove, tag = "transTag"})
    end
    
    local opMove14 = function()

        physics.addBody(op14, "kinematic", physicsData:get("ob_11") )
        op14.x = 1000
        op14.y = 200
        op14.isVisible = true
        op14.isBodyActive = true
        op14.type = "obstacle"
        
        local function op14Remove(target)
          op14.isVisible = false
          op14.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op14, {time = 12500, x=(W-2500), onComplete = op14Remove, tag = "transTag"})
    end
    
    local opMove15 = function()

        physics.addBody(op15, "kinematic", physicsData:get("ob_12") )
        op15.x = 1000
        op15.y = 200
        op15.isVisible = true
        op15.isBodyActive = true
        op15.type = "obstacle"
        
        local function op15Remove(target)
          op15.isVisible = false
          op15.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op15, {time = 12500, x=(W-2500), onComplete = op15Remove, tag = "transTag"})
    end
    
    local function ranGen()
      local obs = {}
      
        if op1.isVisible == false then 
          obs[#obs + 1] = 1
        end
        
        if op2.isVisible == false then 
          obs[#obs + 1] = 2
        end
        
        if op3.isVisible == false then 
          obs[#obs + 1] = 3
        end
        
        if op4.isVisible == false then 
          obs[#obs + 1] = 4
        end
        
        if op5.isVisible == false then 
          obs[#obs + 1] = 5
        end
        
        if op6.isVisible == false then 
          obs[#obs + 1] = 6
        end
        
        if op7.isVisible == false then 
          obs[#obs + 1] = 7
        end
        
        if op8.isVisible == false then 
          obs[#obs + 1] = 8
        end
        
        if op9.isVisible == false then 
          obs[#obs + 1] = 9
        end
        
        if op10.isVisible == false then 
          obs[#obs + 1] = 10
        end
        
        if op11.isVisible == false then 
          obs[#obs + 1] = 11
        end
        
        if op12.isVisible == false then 
          obs[#obs + 1] = 12
        end
        
        if op13.isVisible == false then 
          obs[#obs + 1] = 13
        end
        
        if op14.isVisible == false then 
          obs[#obs + 1] = 14
        end
        
        if op15.isVisible == false then 
          obs[#obs + 1] = 15
        end
  
        --local random = obs[math.random(#obs)];
        local index = math.random(#obs)
        local obstacle = obs[index]
      
        if obstacle == 1 then opMove1()
        elseif obstacle == 2 then opMove2()
        elseif obstacle == 3 then opMove3()
        elseif obstacle == 4 then opMove4()
        elseif obstacle == 5 then opMove5()
        elseif obstacle == 6 then opMove6()
        elseif obstacle == 7 then opMove7()
        elseif obstacle == 8 then opMove8()
        elseif obstacle == 9 then opMove9()
        elseif obstacle == 10 then opMove10()
        elseif obstacle == 11 then opMove11()
        elseif obstacle == 12 then opMove12()
        elseif obstacle == 13 then opMove13()
        elseif obstacle == 14 then opMove14()
        elseif obstacle == 15 then opMove15()
        end
    end

    objTimer = timer.performWithDelay(2500, ranGen, -1)
    gemTimer = timer.performWithDelay( math.random(1000,4000), genGems, 99999)
------------------------------------------------------------------------------------------------------
    
     -- Spirdy collision function can add more to function if needed
     function collision(self, event)
      if event.phase == "began" then 
        --Collision with asteroids
        if self.type == "player"  and event.other.type == "obstacle" then
        
          local function trans()
            charDies:stop()
            Text:removeSelf()
            Text = nil
            pause:removeSelf()
            pause = nil
            scoreText:removeSelf()
            scoreText = nil
            gemCounter:removeSelf()
            gemCounter = nil
            coinCounter:removeSelf()
            coinCounter = nil
            coinFont:removeSelf()
            coinFont = nil
            gem:removeSelf()
            gem = nil
            
            resetScore()
            --shadows:Remove()
            transition.cancel()
            timer.cancel(objTimer)
            timer.cancel(gemTimer)
            --char:remove()
            --charDies:remove()
            
            composer.showOverlay("gameOver")
          end
          
          --highsaveScore()
          
          if char:currentAnimation() == "back" or char:currentAnimation() == "up" or char:currentAnimation() == "down" or
          char:currentAnimation() == "forward" or char:currentAnimation() == "idle" then
            Runtime:removeEventListener("enterFrame", move)
            Runtime:removeEventListener("enterFrame", move2)
            Runtime:removeEventListener("enterFrame", move3)
            char:removeEventListener("collision", char)
            
            transition.cancel("transTag")
            timer.pause(objTimer)
            timer.pause(gemTimer)
            gem:pause()
            setPrevScore()
            highScore()

            charDies:newAnim("dead", 
              mcx.sequence({name = "playerSel/characters/spirdy/gameOverAnim/dies",
              extension = "png",
              endFrame = 24,
              zeros = 2}),
            351, 330,
            {speed = 1, loops = 1})
            
            physics.removeBody(char)
            char:stop()
            
            music.spirdyDies()
            charDies:play({name = "dead"})
            transition.to(charDies, {delay = 1000, onComplete = trans})
            
           end
           
        -- Collision with gems 
        elseif self.type == "player" and event.other.type == "gems" then
          --score.add(event.other.value)
          
          music.gemSound()
          myData.lv1CScore = myData.lv1CScore + 1
          scoreText.text = myData.lv1CScore
          myData.totalGems = myData.lv1CScore + 1
          
          transition.to(event.other, {time = 500, x = 10, y = 30, width = 10, height = 10, alpha = 0})
          
          --Makes the type not equal so the collision is not dected this is to keep the collision at 1
          if event.other.type =="gems" then
            event.other.type = "none"
            
          end
        end
      end
    end

    local physicsIdle, physicsBack, physicsUp, physicsDown, physicsForward
    
    -- Checks to see what character is selected. Spirdy is default. 
      if myData.myCharacter == "Default" or myData.myCharacter == "Spirdy" then
        -- Physics for character movement
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
      
      if myData.myCharacter == "Myme" then
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
            {speed = 1, loops = -1})
            
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
      
      char.x = W*.5
      char.y = H*.5
      charDies.x = W*.5
      charDies.y = H*.5
    
      -- Sets player to a type object for collision listener
      char.type = "player"
      char.collision = collision 
      char:addEventListener("collision", char)
      physics.addBody(char, "dynamic", physicsIdle:get("idle00") )
    
      char:play({name = "idle"})
    
      char.isFixedRotation = true
      charDies.isFixedRotation = true
    
      sceneGroup:insert(char)
      sceneGroup:insert(charDies) 
    
    local function stop (event)
      if event.phase =="ended" then
        motionx = 0
        motiony = 0
      end
    end
    Runtime:addEventListener("touch", stop )
    -- When no arrow is pushed, this will stop me from moving.
    
   local function movePlayer (event)
    char.x = char.x + motionx
    char.y = char.y + motiony
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
    physics.stop()
    --transition.cancel()
    Runtime:removeEventListener("enterFrame", move)
    Runtime:removeEventListener("enterFrame", move2)
    Runtime:removeEventListener("enterFrame", move3)
    collectgarbage("collect")
                
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene