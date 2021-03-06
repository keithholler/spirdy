--------------------------------------------------------------------------------
--  Changes:
--    Version 1.1:
--      Added perspective view/camera view 
--      Changed config settings to 1200x800
--      Increased native height to allow use of perspective view
--      Reduced needed images to two each
--      Grouped single asteroids together to form obstacles
--      Removed old obstacles images
--      Can now be viewed on all devices
--      Added particle effects
--      Added sound effects
--      Inceased thickness of physics walls from 2 to 20
--
--
--
--------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time()) 

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local physics = require("physics")
local pd = require("particleDesigner")
local Analog = require("analogStick")
local myData = require ("myData")
local mcx = require("mcx")
local sound = require("sounds")
local perspective = require("perspective")

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

physics.start()
physics.setGravity(0,0)
physics.setContinuous(true)
physics.setReportCollisionsInContentCoordinates(true)
--physics.setDrawMode( "hybrid" )

local table = {}
local wall1, wall2, wall3, wall4, gemCounter, coinCounter, coinFont, bg1Pt1, bg1Pt2, bg1Pt3, 
  cloud2Pt1, cloud2Pt2, cloud2Pt3, pause, cloud1Pt1, cloud1Pt2, cloud1Pt3, gem, scoreText, camera 
  
local score = myData.lv1Score 
local prevScore = myData.lv1PrevScore
local highScore = myData.lv1HighScore
local random = math.random

local objGen = 4000
local objSpeed = 7000

local y

local prevTime, currentTime
local songTime = 0
local totalTime = 0
local num = 0

-- Local variables for character handler
local char = mcx.new()
local charDies = mcx.new()
char:enableDebugging()
charDies:enableDebugging()

local physicsIdle, physicsBack, physicsUp, physicsDown, physicsForward

-- Tables for each asteroid. Every asteroid has its own table to be produced multiple times throughout  the obstacle functions. 
local ast1 = {}
local ast2 = {}
local ast3 = {}
local ast4 = {}
local ast5 = {}
local ast6 = {}
local ast7 = {}
local ast8 = {}
local ast9 = {}
local ast10 = {}
local ast11 = {}
local ast12 = {}
local ast13 = {}
local ast14 = {}
local ast14Rev = {} -- Rev = Reverse, goes the other way vs. ast14
local obstacles = {}

-- Values for each asteroid table
local a = 1
local b = 1
local c = 1
local d = 1
local e = 1
local f = 1
local g = 1
local h = 1
local i = 1
local j = 1
local k = 1
local l = 1
local m = 1
local n = 1
local o = 1
local obst = 1

local objectCount = 10
local obstacleCount = 30


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- Stops the main menu music
sound.remove()

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

  bg1Pt1:removeSelf()
  bg1Pt1 = nil
  bg1Pt2:removeSelf()
  bg1Pt2 = nil
  bg1Pt3:removeSelf()
  bg1Pt3 = nil
  
  cloud1Pt1:removeSelf()
  cloud1Pt1 = nil
  cloud1Pt2:removeSelf()
  cloud1Pt2 = nil
  cloud1Pt3:removeSelf()
  cloud1Pt3 = nil
  
  cloud2Pt1:removeSelf()
  cloud2Pt1 = nil
  cloud2Pt2:removeSelf()
  cloud2Pt2 = nil
  cloud2Pt3:removeSelf()
  cloud2Pt3 = nil
  
  wall1:removeSelf()
  wall1 = nil
  wall2:removeSelf()
  wall2 = nil
  wall3:removeSelf()
  wall3 = nil
  wall4:removeSelf()
  wall4 = nil
  
  gemCounter = nil
  coinCounter = nil
  coinFont = nil
  scoreText = nil
  pause = nil
  
end

local function highScore()
   if myData.lv1Score > myData.lv1HighScore then
     myData.lv1HighScore = myData.lv1Score
   end
end

local function resetScore()
  myData.lv1Score = 0
end

local function setPrevScore()
  myData.lv1PrevScore = myData.lv1Score
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    camera = perspective.createView()
    
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    --wall1 = display.newRect(sceneGroup, 0, display.contentHeight/2, 2, display.contentHeight )
    --wall2 = display.newRect(sceneGroup, display.contentWidth/2, 0, display.contentWidth, 2 )
    --wall3 = display.newRect(sceneGroup, display.contentWidth, display.contentHeight/2, 0, display.contentHeight )
    --wall4 = display.newRect(sceneGroup, display.contentWidth/2, display.contentHeight , display.contentWidth, 2 )
    
      local wallMaterial = { density = 1.0, friction = 0.3, bounce = 0.0 }
      
      wall1 = display.newRect(sceneGroup, -150, H/2, 30, H + 300)
      wall1.alpha = 0
      camera:add(wall1, 8)

      wall2 = display.newRect(sceneGroup, W/2, -150, W+300, 30)
      wall2.alpha = 0
      camera:add(wall2, 8)

      wall3 = display.newRect(sceneGroup, W+150, H/2, 30, H+300)
      wall3.alpha = 0
      camera:add(wall3, 8)

      wall4 = display.newRect(sceneGroup, W/2, H + 150, W+300, 30)
      wall4.alpha = 0
      camera:add(wall4, 8)

      -- Create bounding wall for the level
      physics.addBody( wall1, "kinematic", wallMaterial )
      physics.addBody( wall2, "kinematic", wallMaterial )
      physics.addBody( wall3, "kinematic", wallMaterial )
      physics.addBody( wall4, "kinematic", wallMaterial )
      
      ----------------------
      --    Background/UI    --
      ----------------------
-------------------------------------------------------------------------------------------------------
      
      bg1Pt1 = display.newImageRect(sceneGroup, "levels/backgrounds/level1/bg1Pt1.png", 1425, 900)
      camera:add(bg1Pt1, 8)
      bg1Pt2 = display.newImageRect(sceneGroup, "levels/backgrounds/level1/bg1Pt2.png", 1425, 900)
      camera:add(bg1Pt2, 8)
      bg1Pt3 = display.newImageRect(sceneGroup, "levels/backgrounds/level1/bg1Pt3.png", 1425, 900)
      camera:add(bg1Pt3, 8)
      
      cloud1Pt1 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds1Pt1.png", 1425, 900)
      camera:add(cloud1Pt1, 7)
      cloud1Pt2 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds1Pt2.png", 1425, 900)
      camera:add(cloud1Pt2, 7)
      cloud1Pt3 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds1Pt3.png", 1425, 900)
      camera:add(cloud1Pt3, 7)
      
      cloud2Pt1 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds2Pt1.png", 1425, 900)
      camera:add(cloud2Pt1, 6)
      cloud2Pt2 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds2Pt2.png", 1425, 900)
      camera:add(cloud2Pt2, 6)
      cloud2Pt3 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds2Pt3.png", 1425, 900)
      camera:add(cloud2Pt3, 6)
      
      -- Background
      bg1Pt1:scale(1, 1)
      bg1Pt1.anchorX = 0;
      bg1Pt1.anchorY = 0.5;
      bg1Pt1.x = 0; bg1Pt1.y = H/2;
  
      bg1Pt2:scale(1, 1)
      bg1Pt2.anchorX = 0;
      bg1Pt2.anchorY = 0.5;
      bg1Pt2.x = 1425; bg1Pt2.y = H/2;
  
      bg1Pt3:scale(1, 1)
      bg1Pt3.anchorX = 0;
      bg1Pt3.anchorY = 0.5;
      bg1Pt3.x = 2850; bg1Pt3.y = H/2;
      
      -- Small stars
      --[[local emitter1 = pd.newEmitter("starFieldSmall.json")
      emitter1.x = centerX
      emitter1.y = centerY
      emitter1.sourcePositionVariancex = W/2
      emitter1.sourcePositionVariancey = H/2

      local original_rate1 = emitter1.emissionRateInParticlesPerSeconds

      emitter1.emissionRateInParticlesPerSeconds = original_rate1 * 3
      sceneGroup:insert(emitter1)
      camera:add(emitter1, 8)
      
      -- Large Stars
      local emitter2 = pd.newEmitter("starFieldLarge.json")
      emitter2.x = centerX
      emitter2.y = centerY
      emitter2.sourcePositionVariancex = W/2
      emitter2.sourcePositionVariancey = H/2

      local original_rate2 = emitter2.emissionRateInParticlesPerSeconds

      emitter2.emissionRateInParticlesPerSeconds = original_rate2 * 2
      sceneGroup:insert(emitter2)
      camera:add(emitter2, 8)

      -- Blue stars
      local emitter3 = pd.newEmitter("starFieldBlue.json")
      emitter3.x = centerX
      emitter3.y = centerY
      emitter3.sourcePositionVariancex = W/2
      emitter3.sourcePositionVariancey = H/2

      local original_rate3 = emitter3.emissionRateInParticlesPerSeconds

      emitter3.emissionRateInParticlesPerSeconds = original_rate3 * 2
      sceneGroup:insert(emitter3)
      camera:add(emitter3, 8)]]--
      
      -- Clouds Layer 1
      cloud1Pt1:scale(1, 1)
      cloud1Pt1.anchorX = 0;
      cloud1Pt1.anchorY = 0.5;
      cloud1Pt1.x = 0; cloud1Pt1.y = H/2;
  
      cloud1Pt2:scale(1, 1)
      cloud1Pt2.anchorX = 0;
      cloud1Pt2.anchorY = 0.5;
      cloud1Pt2.x = 1425; cloud1Pt2.y = H/2;
  
      cloud1Pt3:scale(1, 1)
      cloud1Pt3.anchorX = 0;
      cloud1Pt3.anchorY = 0.5;
      cloud1Pt3.x = 2850; cloud1Pt3.y = H/2;
      
      -- Clouds Layer 2
      cloud2Pt1:scale(1, 1)
      cloud2Pt1.anchorX = 0;
      cloud2Pt1.anchorY = 0.5;
      cloud2Pt1.x = 0; cloud1Pt1.y = H/2;
  
      cloud2Pt2:scale(1, 1)
      cloud2Pt2.anchorX = 0;
      cloud2Pt2.anchorY = 0.5;
      cloud2Pt2.x = 1425; cloud1Pt2.y = H/2;
  
      cloud2Pt3:scale(1, 1)
      cloud2Pt3.anchorX = 0;
      cloud2Pt3.anchorY = 0.5;
      cloud2Pt3.x = 2850; cloud1Pt3.y = H/2;
      
      for obst = 1, obstacleCount do
      
      end
      
      -- Asteroids
      for a = 1, objectCount do
        ast1[a] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast1.png", 528, 679)
        ast1[a].isVisible = false
        ast1[a].isBodyActive = false
        camera:add(ast1[a], 2)
      end
      
      for b = 1, objectCount do
        ast2[b] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast2.png", 569, 737)
        ast2[b].isVisible = false
        ast2[b].isBodyActive = false
        camera:add(ast2[b], 4)
      end
      
      for c = 1, objectCount do
        ast3[c] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast3.png", 618, 484)
        ast3[c].isVisible = false
        ast3[c].isBodyActive = false
        camera:add(ast3[c], 5)
      end
      
      for d = 1, objectCount do
        ast4[d] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast4.png", 385, 539)
        ast4[d].isVisible = false
        ast4[d].isBodyActive = false
        camera:add(ast4[d], 3)
      end
      
      for e = 1, objectCount do
        ast5[e] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast5.png", 385, 416)
        ast5[e].isVisible = false
        ast5[e].isBodyActive = false
        camera:add(ast5[e], 4)
      end
      
      for f = 1, objectCount do
        ast6[f] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast6.png", 340, 335)
        ast6[f].isVisible = false
        ast6[f].isBodyActive = false
        camera:add(ast6[f], 3)
      end
      
      for g = 1, objectCount do
        ast7[g] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast7.png", 558, 377)
        ast7[g].isVisible = false
        ast7[g].isBodyActive = false
        camera:add(ast7[g], 2)
      end
      
      for h = 1, objectCount do
        ast8[h] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast8.png", 409, 338)
        ast8[h].isVisible = false
        ast8[h].isBodyActive = false
        camera:add(ast8[h], 2)
      end
      
      for i = 1, objectCount do
        ast9[i] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast9.png", 377, 437)
        ast9[i].isVisible = false
        ast9[i].isBodyActive = false
        camera:add(ast9[i], 1)
      end
      
      for j = 1, objectCount do
        ast10[j] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast10.png", 399, 426)
        ast10[j].isVisible = false
        ast10[j].isBodyActive = false
        camera:add(ast10[j], 3)
      end
      
      for k = 1, objectCount do
        ast11[k] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast11.png", 426, 384)
        ast11[k].isVisible = false
        ast11[k].isBodyActive = false
        camera:add(ast11[k], 4)
      end
      
      for l = 1, objectCount do
        ast12[l] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast12.png", 399, 437)
        ast12[l].isVisible = false
        ast12[l].isBodyActive = false
        camera:add(ast12[l], 1)
      end
      
      for m = 1, objectCount do
        ast13[m] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast13.png", 784, 848)
        ast13[m].isVisible = false
        ast13[m].isBodyActive = false
        camera:add(ast13[m], 2)
      end
      
      for n = 1, objectCount do
        ast14[n] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast14.png", 604, 653)
        ast14[n].isVisible = false
        ast14[n].isBodyActive = false
        camera:add(ast14[n], 1)
        
        local function rotate()
          transition.to(ast14[n], {time = 2000, rotation = ast14[n].rotation+360, onComplete = rotate, tag = "transTag"})
        end
        
        rotate()
      end
      
      for o = 1, objectCount do
        ast14Rev[o] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast14.png", 604, 653)
        ast14Rev[o].isVisible = false
        ast14Rev[o].isBodyActive = false
        camera:add(ast14Rev[o], 1)
        
        local function rotate()
          transition.to(ast14Rev[o], {time = 2000, rotation = ast14Rev[o].rotation-360, onComplete = rotate, tag = "transTag"})
        end
        
        rotate()
      end
      
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
            112, 171,
            {speed = 1, loops = -1})
            
        char:newAnim("forward", 
            mcx.sequence({name = "playerSel/characters/spirdy/forwardAnim/fwd",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            124, 168,
            {speed = 1, loops = -1})
            
        char:newAnim("back", 
            mcx.sequence({name = "playerSel/characters/spirdy/backAnim/back",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            136, 169,
            {speed = 1, loops = -1})
            
        char:newAnim("up", 
            mcx.sequence({name = "playerSel/characters/spirdy/upAnim/up",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            110, 171,
            {speed = 1, loops = -1})
            
        char:newAnim("down", 
            mcx.sequence({name = "playerSel/characters/spirdy/downAnim/down",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            132, 171,
            {speed = 1, loops = -1})
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
            {speed = 1, loops = -1})
          
        char:newAnim("back", 
            mcx.sequence({name = "playerSel/characters/myme/backAnim/back",
              extension = "png",
              endFrame = 10,
              zeros = 2}),
            36, 90,
            {speed = 1, loops = -1})
            
        char:newAnim("up", 
            mcx.sequence({name = "playerSel/characters/myme/upAnim/up",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            43, 85,
            {speed = 1, loops = -1})
            
        char:newAnim("down", 
          mcx.sequence({name = "playerSel/characters/myme/downAnim/down",
            extension = "png",
            endFrame = 8,
            zeros = 2}),
          46, 88,
          {speed = 1, loops = -1})
      end
      
      char.x = W*.5
      char.y = H*.5
      
      sceneGroup:insert(char)
      camera:add(char, 1)
      sceneGroup:insert(charDies)
      camera:add(charDies, 1)
      
      -- Moving stars
      local emitter6 = pd.newEmitter("movingStars.json")
      emitter6.x = centerX + 600
      emitter6.y = centerY
      emitter6.startColorBlue = 1
      emitter6.startColorRed = 1
      emitter6.startColorGreen = 0
      sceneGroup:insert(emitter6)
      camera:add(emitter6, 1)
      
      -- Variables for the in-game displays
      gemCounter = display.newImageRect(sceneGroup, "gameUI/counter_gem.png", 271, 128)
      coinCounter = display.newImageRect(sceneGroup, "gameUI/counter_coin.png", 271, 128)
      
      gemCounter.x = W/2 - 500
      gemCounter.y = H/2 - 330
      gemCounter.alpha = 1
      camera:add(gemCounter, 1)
        
      coinCounter.x = W/2 - 220
      coinCounter.y = H/2 - 330
      coinCounter.alpha = 1
      camera:add(coinCounter, 1)
      
      coinFont = display.newText(sceneGroup, myData.coins, W/2-170, H/2-325, "Soup Of Justice", 42)
      coinFont:setFillColor( 0, 0, 0 )
      coinFont.anchorX = 0
      camera:add(coinFont, 1)
      
      scoreText = display.newText(sceneGroup, myData.lv1Score, W/2-450, H/2-325, "Soup Of Justice", 42)
      scoreText:setFillColor(0, 0, 0)
      scoreText.anchorX = 0
      camera:add(scoreText, 1)
      
      pause = widget.newButton
      {
        width = 75,
        height = 75,
        defaultFile = "pause.png",
        id = "pause",
        onRelease = pause
      }
    
      pause.x = W/2 + 600
      pause.y = H/2 - 330
      pause.alpha = 0.7
      sceneGroup:insert(pause)
      camera:add(pause, 1)
      
      -- Set parameters for the Analog stick
      MyStick = Analog.NewStick({x = 0, y = 0, thumbSize = 45, borderSize = 65, 
            snapBackSpeed = .75, R = 255, G = 255, B = 255})
      --sceneGroup:insert(MyStick)
      --camera:add(MyStick, 1)
      
      camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3)
      camera:setBounds(W/2 - 150, W/2 + 150, H/2 - 150, H/2 + 150)
      
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      --composer.removeScene("loadIntro")
      --composer.removeScene("levelSelNorm")
      --composer.removeScene("retry")
      --score.reset()
      
        --music.Atrox()
        function move(event)
  
          bg1Pt1.x = bg1Pt1.x - myData.bgScrollSpeed
          bg1Pt2.x = bg1Pt2.x - myData.bgScrollSpeed
          bg1Pt3.x = bg1Pt3.x - myData.bgScrollSpeed
        
          if(bg1Pt1.x + bg1Pt1.contentWidth) < -1425 then
            bg1Pt1:translate(1425*3, 0)
          end
        
          if(bg1Pt2.x + bg1Pt2.contentWidth) < -1425 then
            bg1Pt2:translate(1425*3, 0)
          end
        
          if(bg1Pt3.x + bg1Pt3.contentWidth) < -1425 then
            bg1Pt3:translate(1425*3, 0)
          end
        end
  
      Runtime:addEventListener("enterFrame", move)
      
      function move2(event)
  
        cloud1Pt1.x = cloud1Pt1.x - myData.bgScrollSpeed
        cloud1Pt2.x = cloud1Pt2.x - myData.bgScrollSpeed
        cloud1Pt3.x = cloud1Pt3.x - myData.bgScrollSpeed
          
        if(cloud1Pt1.x + cloud1Pt1.contentWidth) < -1425 then
          cloud1Pt1:translate(1425*3, 0)
        end
          
        if(cloud1Pt2.x + cloud1Pt2.contentWidth) < -712.5 then
          cloud1Pt2:translate(1425*3, 0)
        end
          
        if(cloud1Pt3.x + cloud1Pt3.contentWidth) < -712.5 then
          cloud1Pt3:translate(1425*3, 0)
        end
      end
  
      Runtime:addEventListener("enterFrame", move2)
      
      function move3(event)
  
        cloud2Pt1.x = cloud2Pt1.x - myData.bgScrollSpeed
        cloud2Pt2.x = cloud2Pt2.x - myData.bgScrollSpeed
        cloud2Pt3.x = cloud2Pt3.x - myData.bgScrollSpeed
          
        if(cloud2Pt1.x + cloud2Pt1.contentWidth) < -1425 then
          cloud2Pt1:translate(1425*3, 0)
        end
          
        if(cloud2Pt2.x + cloud2Pt2.contentWidth) < -1425 then
          cloud2Pt2:translate(1425*3, 0)
        end
          
        if(cloud2Pt3.x + cloud2Pt3.contentWidth) < -1425 then
          cloud2Pt3:translate(1425*3, 0)
        end
      end
  
      Runtime:addEventListener("enterFrame", move3)
      
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
      sound.Atrox()
      
    -- Listens for the Analog stick
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
     
-------------------------------------------------------------------------------------------------------

    ----------------
    --    Gems    --
    ----------------
-------------------------------------------------------------------------------------------------------
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
      
      gem.x = W/2 + 1000
      gem.y = 1 + math.random( H ) 
      gem:setSequence( "Gem1" )
      
      gem.type = "gems"
      gem.value = 1
      gem:play()
      camera:add(gem, 3)
      
      local function gemsRemove(target)
        physics.removeBody(target)
        target:removeSelf()
        target = nil
      end
      
        transition.to(gem, {time = 4500,x=(W/2 - 1000), onComplete = gemsRemove, tag = "transTag"})
        
        -- After a short time, swap the sequence to 'seq2' which uses the second image sheet
        local function swapSheet()
               gem:setSequence( "Gem1" )
               gem:play()
        end
    end
    
    --[[local function timerGen()
      y = math.random(50,350)
    end
    
    timer.performWithDelay(498, timerGen, 0)]]--
    
    local physicsData = (require "levels.normalMode.level1.asteroids").physicsData(1.0)
    
    -- Obstacles 1 through 30
-- ----------------------------------------------------------------------------------------------------    
    local function targetRemove(target)
      target.isVisible = false
      target.isBodyActive = false
      physics.removeBody(target)
    end
    
    -- Obstacle 1 
    local opMove1 = function()
        physics.addBody(ast8[1], "kinematic", physicsData:get("ast8") )
        physics.addBody(ast10[1], "kinematic", physicsData:get("ast10") )
        physics.addBody(ast11[1], "kinematic", physicsData:get("ast11") )
        physics.addBody(ast6[1], "kinematic", physicsData:get("ast6") )
        
        ast8[1].x = W/2 + 1450
        ast8[1].y = H/2 + 360
        ast8[1].isVisible = true
        ast8[1].isBodyActive = true
        ast8[1].type = "obstacle"

        ast10[1].x = W/2 + 1700
        ast10[1].y = H/2 - 320
        ast10[1].isVisible = true
        ast10[1].isBodyActive = true
        ast10[1].type = "obstacle"
        
        ast11[1].x = W/2 + 1200
        ast11[1].y = H/2
        ast11[1].isVisible = true
        ast11[1].isBodyActive = true
        ast11[1].type = "obstacle"

        ast6[1].x = W/2 + 2050
        ast6[1].y = H/2 + 50
        ast6[1].isVisible = true
        ast6[1].isBodyActive = true
        ast6[1].type = "obstacle"
      
        transition.to(ast11[1], {time = myData.obstacleSpeed, x = W/2 - 1850, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast8[1], {time = myData.obstacleSpeed, x = W/2 - 1650, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast10[1], {time = myData.obstacleSpeed, x = W/2 - 1400, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[1], {time = myData.obstacleSpeed, x = W/2 - 1000, onComplete = targetRemove, tag = "transTag"})
    end
    
    -- Obstacle 2
    local opMove2 = function()
        physics.addBody(ast8[2], "kinematic", physicsData:get("ast8") )
        physics.addBody(ast10[2], "kinematic", physicsData:get("ast10") )
        physics.addBody(ast11[2], "kinematic", physicsData:get("ast11") )
        physics.addBody(ast6[2], "kinematic", physicsData:get("ast6") )
        physics.addBody(ast7[1], "kinematic", physicsData:get("ast7") )
        
        ast8[2].x = W/2 + 1200
        ast8[2].y = H/2 + 200
        ast8[2].isVisible = true
        ast8[2].isBodyActive = true
        ast8[2].type = "obstacle"
        
        ast10[2].x = W/2 + 1650
        ast10[2].y = H/2 
        ast10[2].isVisible = true
        ast10[2].isBodyActive = true
        ast10[2].type = "obstacle"
        
        ast11[2].x = W/2 + 1200
        ast11[2].y = H/2 - 170
        ast11[2].isVisible = true
        ast11[2].isBodyActive = true
        ast11[2].type = "obstacle"
        
        ast6[2].x = W/2 + 2050
        ast6[2].y = H/2 + 100
        ast6[2].isVisible = true
        ast6[2].isBodyActive = true
        ast6[2].type = "obstacle"

        ast7[1].x = W/2 + 2450
        ast7[1].y = H/2 + 400
        ast7[1].isVisible = true
        ast7[1].isBodyActive = true
        ast7[1].type = "obstacle"
      
        transition.to(ast11[2], {time = myData.obstacleSpeed, x = W/2 - 2050, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast8[2], {time = myData.obstacleSpeed, x = W/2 - 2050, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast10[2], {time = myData.obstacleSpeed, x = W/2 - 1600, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[2], {time = myData.obstacleSpeed, x = W/2 - 1200, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast7[1], {time = myData.obstacleSpeed, x = W/2 - 1000, onComplete = targetRemove, tag = "transTag"})
    end
    
    -- Obstacle 3
    local opMove3 = function()
        physics.addBody(ast4[1], "kinematic", physicsData:get("ast4") )
        physics.addBody(ast6[3], "kinematic", physicsData:get("ast6") )
        physics.addBody(ast9[1], "kinematic", physicsData:get("ast9") )
        physics.addBody(ast11[3], "kinematic", physicsData:get("ast11") )
        
        ast4[1].x = W/2 + 1200
        ast4[1].y = H/2 - 350
        ast4[1].isVisible = true
        ast4[1].isBodyActive = true
        ast4[1].type = "obstacle"

        ast6[3].x = W/2 + 1300
        ast6[3].y = H/2
        ast6[3].isVisible = true
        ast6[3].isBodyActive = true
        ast6[3].type = "obstacle"

        ast9[1].x = W/2 + 1470
        ast9[1].y = H/2 + 160
        ast9[1].isVisible = true
        ast9[1].isBodyActive = true
        ast9[1].type = "obstacle"

        ast11[3].x = W/2 + 1650
        ast11[3].y = H/2 + 500
        ast11[3].isVisible = true
        ast11[3].isBodyActive = true
        ast11[3].type = "obstacle"
      
        transition.to(ast4[1], {time = myData.obstacleSpeed, x = W/2 - 2250, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[3], {time = myData.obstacleSpeed, x = W/2 - 2050, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast9[1], {time = myData.obstacleSpeed, x = W/2 - 1800, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast11[3], {time = myData.obstacleSpeed - 2000, x = W/2 - 1600, onComplete = targetRemove, tag = "transTag"})
    end
    
    -- Obstacle 4
    local opMove4 = function()
        physics.addBody(ast4[2], "kinematic", physicsData:get("ast4") )
        physics.addBody(ast6[4], "kinematic", physicsData:get("ast6") )
        physics.addBody(ast14[1], "kinematic", physicsData:get("ast14") )
        
        ast4[2].x = W/2 + 1200
        ast4[2].y = H/2 + 450
        ast4[2].isVisible = true
        ast4[2].isBodyActive = true
        ast4[2].type = "obstacle"

        ast6[4].x = W/2 + 1750
        ast6[4].y = H/2 - 420
        ast6[4].isVisible = true
        ast6[4].isBodyActive = true
        ast6[4].type = "obstacle"

        ast14[1].x = W/2 + 1400
        ast14[1].y = H/2 - 50
        ast14[1].isVisible = true
        ast14[1].isBodyActive = true
        ast14[1].type = "obstacle"
      
        transition.to(ast4[2], {time = myData.obstacleSpeed, x = W/2 - 2250, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[4], {time = myData.obstacleSpeed, x = W/2 - 1700, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast14[1], {time = myData.obstacleSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
    end
    
    -- Obstacle 5
    local opMove5 = function()
        physics.addBody(ast4[3], "kinematic", physicsData:get("ast4") )
        physics.addBody(ast6[5], "kinematic", physicsData:get("ast6") )
        physics.addBody(ast14[2], "kinematic", physicsData:get("ast14") )
        
        ast4[3].x = W/2 + 1200
        ast4[3].y = H/2 -200
        ast4[3].isVisible = true
        ast4[3].isBodyActive = true
        ast4[3].type = "obstacle"

        ast6[5].x = W/2 + 1750
        ast6[5].y = H/2 - 420
        ast6[5].isVisible = true
        ast6[5].isBodyActive = true
        ast6[5].type = "obstacle"

        ast14[2].x = W/2 + 1400
        ast14[2].y = H/2 + 300
        ast14[2].isVisible = true
        ast14[2].isBodyActive = true
        ast14[2].type = "obstacle"
      
        transition.to(ast4[3], {time = myData.obstacleSpeed, x = W/2 - 2250, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[5], {time = myData.obstacleSpeed, x = W/2 - 1700, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast14[2], {time = myData.obstacleSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
    end
    
    -- Obstacle 6
    local opMove6 = function()
        
        physics.addBody(ast7[2], "kinematic", physicsData:get("ast7") )
        physics.addBody(ast8[3], "kinematic", physicsData:get("ast8") )
        physics.addBody(ast10[3], "kinematic", physicsData:get("ast10") )
        physics.addBody(ast11[4], "kinematic", physicsData:get("ast11") )
        physics.addBody(ast3[1], "kinematic", physicsData:get("ast3") )
        
        ast7[2].x = W/2 + 1700
        ast7[2].y = H/2
        ast7[2].isVisible = true
        ast7[2].isBodyActive = true
        ast7[2].type = "obstacle"

        ast8[3].x = W/2 + 1200
        ast8[3].y = H/2 + 300
        ast8[3].isVisible = true
        ast8[3].isBodyActive = true
        ast8[3].type = "obstacle"

        ast10[3].x = W/2 + 1200
        ast10[3].y = H/2 - 100
        ast10[3].isVisible = true
        ast10[3].isBodyActive = true
        ast10[3].type = "obstacle"

        ast11[4].x = W/2 + 1800
        ast11[4].y = H/2 - 300
        ast11[4].isVisible = true
        ast11[4].isBodyActive = true
        ast11[4].type = "obstacle"

        ast3[1].x = W/2 + 2000
        ast3[1].y = H/2 + 600
        ast3[1].isVisible = true
        ast3[1].isBodyActive = true
        ast3[1].type = "obstacle"
      
        transition.to(ast7[2], {time = myData.obstacleSpeed, x = W/2 - 1200, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast8[3], {time = myData.obstacleSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast10[3], {time = myData.obstacleSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast11[4], {time = myData.obstacleSpeed, x = W/2 - 1100, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast3[1], {time = myData.obstacleSpeed, x = W/2 - 1000, onComplete = targetRemove, tag = "transTag"})
    end
    
    local opMove7 = function()

        physics.addBody(ast14[3], "kinematic", physicsData:get("ast14"))
        physics.addBody(ast14Rev[1], "kinematic", physicsData:get("ast14"))

        ast14[3].x = W/2 + 1400
        ast14[3].y = H/2 - 150
        ast14[3].isVisible = true
        ast14[3].isBodyActive = true
        ast14[3].type = "obstacle"

        ast14Rev[1].x = W/2 + 1800
        ast14Rev[1].y = H/2 + 150
        --ast14[4].xScale = -1
        ast14Rev[1].isVisible = true
        ast14Rev[1].isBodyActive = true
        ast14Rev[1].type = "obstacle"
      
        transition.to(ast14[3], {time = objSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast14Rev[1], {time = objSpeed, x = W/2 - 1800, onComplete = targetRemove, tag = "transTag"})
    end
    
    
    
    local opMove8 = function()
    
        local function remove(target)
          target.isVisible = false
          target.isBodyActive = false
          transition.cancel("obst8Rotation")
          transition.cancel("obst8")
        end
    
        physics.addBody(ast8[4], "kinematic", physicsData:get("ast8") )
        physics.addBody(ast6[6], "kinematic", physicsData:get("ast6") )
        physics.addBody(ast5[1], "kinematic", physicsData:get("ast5") )
        physics.addBody(ast8[5], "kinematic", physicsData:get("ast8") )
        physics.addBody(ast6[7], "kinematic", physicsData:get("ast6") )
        physics.addBody(ast5[2], "kinematic", physicsData:get("ast5") )
        
        ast8[4].x = W/2 + 1400
        ast8[4].y = H/2 - 400
        ast8[4].isVisible = true
        ast8[4].isBodyActive = true
        ast8[4].type = "obstacle"

        ast6[6].x = W/2 + 1400
        ast6[6].y = H/2
        ast6[6].isVisible = true
        ast6[6].isBodyActive = true
        ast6[6].type = "obstacle"

        ast5[1].x = W/2 + 1400
        ast5[1].y = H/2 + 500
        ast5[1].isVisible = true
        ast5[1].isBodyActive = true
        ast5[1].type = "obstacle"

        local function collision()
          if ast6[6].y == H/2 - 180 then
            local function equalize()
              local function normalize()
                local function normRotation()
                  transition.to(ast8[4], {time = 400, rotation = ast8[4].rotation - 10, tag = "obst8Rotation"})
                end
                transition.to(ast8[4], {time = 400, rotation = ast8[4].rotation + 10, onComplete = normRotation, tag = "obst8Rotation"})
                transition.to(ast8[4], {time = 400, y = H/2 - 400, tag = "obst8"})
              end
              transition.to(ast6[6], {time = 400, rotation = ast6[6].rotation - 8, tag = "obst8Rotation"})
              transition.to(ast8[4], {time = 400, rotation = ast8[4].rotation - 10, tag = "obst8Rotation"})
              transition.to(ast8[4], {time = 400, y = H/2 - 390, onComplete = normalize, tag = "obst8"})
            end
            transition.to(ast8[4], {time = 400, rotation = ast8[4].rotation + 10, tag = "obst8Rotation"})
            transition.to(ast8[4], {time = 400, y = H/2 - 440, onComplete = equalize, tag = "obst8"})
            transition.to(ast6[6], {time = 400, rotation = ast6[6].rotation + 8, tag = "obst8Rotation"})
            transition.to(ast6[6], {time = 1700, y = H/2 + 230, onComplete = collision, tag = "obst8"})
          end

          if ast6[6].y == H/2 + 230 then
            local function equalize()
              local function  normalize()
                local function normRotation()
                  transition.to(ast5[1], {time = 400, rotation = ast5[1].rotation + 10, tag = "obst8Rotation"})
                end
                transition.to(ast5[1], {time = 400, rotation = ast5[1].rotation - 10, onComplete = normRotation, tag = "obst8Rotation"})
                transition.to(ast5[1], {time = 400, y = H/2 + 500, tag = "obst8"})
              end
              transition.to(ast6[6], {time = 400, rotation = ast6[6].rotation + 8, tag = "obst8Rotation"})
              transition.to(ast5[1], {time = 400, rotation = ast5[1].rotation + 10, tag = "obst8Rotation"})
              transition.to(ast5[1], {time = 400, y = H/2 + 490, onComplete = normalize, tag = "obst8"})
            end
            transition.to(ast5[1], {time = 400, rotation = ast5[1].rotation - 10, tag = "obst8Rotation"})
            transition.to(ast5[1], {time = 400, y = H/2 + 540, onComplete = equalize, tag = "obst8"})
            transition.to(ast6[6], {time = 400, rotation = ast6[6].rotation - 8, tag = "obst8Rotation"})
            transition.to(ast6[6], {time = 1700, y = H/2 - 180, onComplete = collision, tag = "obst8"})
          end
        end

        transition.to(ast8[4], {time = myData.obstacleSpeed, x = W/2 - 2300, onComplete = remove})
        transition.to(ast6[6], {time = myData.obstacleSpeed, x = W/2 - 2300, onComplete = remove})
        transition.to(ast5[1], {time = myData.obstacleSpeed, x = W/2 - 2300, onComplete = remove})
        transition.to(ast6[6], {time = 1700, y = H/2 - 180, onComplete = collision, tag = "obst8"})
        
        ast8[5].x = W/2 + 2200
        ast8[5].y = H/2 - 400
        ast8[5].isVisible = true
        ast8[5].isBodyActive = true
        ast8[5].type = "obstacle"

        ast6[7].x = W/2 + 2200
        ast6[7].y = H/2
        ast6[7].isVisible = true
        ast6[7].isBodyActive = true
        ast6[7].type = "obstacle"

        ast5[2].x = W/2 + 2200
        ast5[2].y = H/2 + 500
        ast5[2].isVisible = true
        ast5[2].isBodyActive = true
        ast5[2].type = "obstacle"

        local function collision2()
          if ast6[7].y == H/2 - 180 then
            local function equalize()
              local function normalize()
                local function normRotation()
                  transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation - 8, tag = "obst8Rotation"})
                  transition.to(ast8[5], {time = 400, rotation = ast8[5].rotation - 10, tag = "obst8Rotation"})
                end
                transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation + 8, tag = "obst8Rotation"})
                transition.to(ast8[5], {time = 400, rotation = ast8[5].rotation + 10, tag = "obst8Rotation"})
                transition.to(ast8[5], {time = 400, y = H/2 - 400, onComplete = normRotation, tag = "obst8"})
              end
              transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation - 8, tag = "obst8Rotation"})
              transition.to(ast8[5], {time = 400, rotation = ast8[5].rotation - 10, tag = "obst8Rotation"})
              transition.to(ast8[5], {time = 400, y = H/2 - 390, onComplete = normalize, tag = "obst8"})
            end

            transition.to(ast8[5], {time = 400, rotation = ast8[5].rotation + 10, tag = "obst8Rotation"})
            transition.to(ast8[5], {time = 400, y = H/2 - 440, onComplete = equalize, tag = "obst8"})
            transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation + 8, tag = "obst8Rotation"})
            transition.to(ast6[7], {time = 1700, y = H/2 + 230, onComplete = collision, tag = "obst8"})
          end

          if ast6[7].y == H/2 + 230 then
            local function equalize()
              local function  normalize()
                local function normRotation()
                  transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation + 8, tag = "obst8Rotation"})
                  transition.to(ast5[2], {time = 400, rotation = ast5[2].rotation + 10, tag = "obst8Rotation"})
                end
                transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation - 8, tag = "obst8Rotation"})
                transition.to(ast5[2], {time = 400, rotation = ast5[2].rotation - 10, tag = "obst8Rotation"})
                transition.to(ast5[2], {time = 400, y = H/2 + 500, onComplete = normRotation, tag = "obst8"})
              end
              transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation + 8, tag = "obst8Rotation"})
              transition.to(ast5[2], {time = 400, rotation = ast5[2].rotation + 10, tag = "obst8Rotation"})
              transition.to(ast5[2], {time = 400, y = H/2 + 490, onComplete = normalize, tag = "obst8"})
            end
            transition.to(ast5[2], {time = 400, rotation = ast5[2].rotation - 10, tag = "obst8Rotation"})
            transition.to(ast5[2], {time = 400, y = H/2 + 540, onComplete = equalize, tag = "obst8"})
            transition.to(ast6[7], {time = 400, rotation = ast6[7].rotation - 8, tag = "obst8Rotation"})
            transition.to(ast6[7], {time = 1700, y = H/2 - 180, onComplete = collision2, tag = "obst8"})
          end
        end

        transition.to(ast8[5], {time = myData.obstacleSpeed, x = W/2 - 1800, onComplete = remove})
        transition.to(ast6[7], {time = myData.obstacleSpeed, x = W/2 - 1800, onComplete = remove})
        transition.to(ast5[2], {time = myData.obstacleSpeed, x = W/2 - 1800, onComplete = remove})
        transition.to(ast6[7], {time = 1700, y = H/2 + 230, onComplete = collision2, tag = "obst8"})
    end
    
    local opMove9 = function()

        ast9[2].x = W/2 + 1700
        ast9[2].y = H/2 - 300
        ast9[2].isVisible = true
        ast9[2].isBodyActive = true
        ast9[2].type = "obstacle"

        ast3[2].x = W/2 + 2300
        ast3[2].y = H/2 - 400
        ast3[2].isVisible = true
        ast3[2].isBodyActive = true
        ast3[2].type = "obstacle"

        ast11[5].x = W/2 + 2100
        ast11[5].y = H/2 + 150
        ast11[5].isVisible = true
        ast11[5].isBodyActive = true
        ast11[5].type = "obstacle"

        ast10[4].x = W/2 + 1800
        ast10[4].y = H/2 + 450
        ast10[4].isVisible = true
        ast10[4].isBodyActive = true
        ast10[4].type = "obstacle"

        ast8[6].x = W/2 + 1400
        ast8[6].y = H/2
        ast8[6].isVisible = true
        ast8[6].isBodyActive = true
        ast8[6].type = "obstacle"

        transition.to(ast9[2], {time = 8000, x = W/2 - 2200, tag = "transTag", onComplete = targetRemove})
        transition.to(ast3[2], {time = 8000, x = W/2 - 1400, tag = "transTag", onComplete = targetRemove})
        transition.to(ast11[5], {time = 8000, x = W/2 - 1600, tag = "transTag", onComplete = targetRemove})
        transition.to(ast10[4], {time = 8000, x = W/2 - 2000, tag = "transTag", onComplete = targetRemove})
        transition.to(ast8[6], {time = 8000, x = W/2 - 2400, tag = "transTag", onComplete = targetRemove})
    end
    
    --[[local opMove10 = function()

        physics.addBody(op10, "kinematic", physicsData:get("asteroid9") )
        op10.x = 1000
        op10.y = y
        op10.isVisible = true
        op10.isBodyActive = true
        op10.type = "obstacle"
        
        local function op10Remove(target)
          op10.isVisible = false
          op10.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op10, {time = objSpeed, x=(W-2500), onComplete = op10Remove, tag = "transTag"})
    end
    
    local opMove11 = function()

        physics.addBody(op11, "kinematic", physicsData:get("asteroid10") )
        op11.x = 1000
        op11.y = y
        op11.isVisible = true
        op11.isBodyActive = true
        op11.type = "obstacle"
        
        local function op11Remove(target)
          op11.isVisible = false
          op11.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op11, {time = objSpeed, x=(W-2500), onComplete = op11Remove, tag = "transTag"})
    end
    
    local opMove12 = function()

        physics.addBody(op12, "kinematic", physicsData:get("asteroid11") )
        op12.x = 1000
        op12.y = y
        op12.isVisible = true
        op12.isBodyActive = true
        op12.type = "obstacle"
        
        local function op12Remove(target)
          op12.isVisible = false
          op12.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op12, {time = objSpeed, x=(W-2500), onComplete = op12Remove, tag = "transTag"})
    end
    
    local opMove13 = function()

        physics.addBody(op13, "kinematic", physicsData:get("asteroid12") )
        op13.x = 1000
        op13.y = y
        op13.isVisible = true
        op13.isBodyActive = true
        op13.type = "obstacle"
        
        local function op13Remove(target)
          op13.isVisible = false
          op13.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op13, {time = objSpeed, x=(W-2500), onComplete = op13Remove, tag = "transTag"})
    end
    
    local opMove14 = function()

        physics.addBody(op14, "kinematic", physicsData:get("asteroid13") )
        op14.x = 1000
        op14.y = y
        op14.isVisible = true
        op14.isBodyActive = true
        op14.type = "obstacle"
        
        local function op14Remove(target)
          op14.isVisible = false
          op14.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op14, {time = objSpeed, x=(W-2500), onComplete = op14Remove, tag = "transTag"})
    end
    
    local opMove15 = function()

        physics.addBody(op15, "kinematic", physicsData:get("asteroid14") )
        op15.x = 1000
        op15.y = y
        op15.isVisible = true
        op15.isBodyActive = true
        op15.type = "obstacle"
        
        local function op15Remove(target)
          op15.isVisible = false
          op15.isBodyActive = false
          physics.removeBody(target)
        end
      
        transition.to(op15, {time = objSpeed, x=(W-2500), onComplete = op15Remove, tag = "transTag"})
    end]]--
    
    local function ranGen()
      --[[local obs = {}
      
        if ast1[a].isVisible == false then 
          obs[#obs + 1] = 1
        end
        
        if ast2[b].isVisible == false then 
          obs[#obs + 1] = 2
        end
        
        if ast3[c].isVisible == false then 
          obs[#obs + 1] = 3
        end
        
        if ast4[d].isVisible == false then 
          obs[#obs + 1] = 4
        end
        
        if ast5[e].isVisible == false then 
          obs[#obs + 1] = 5
        end
        
        if ast6[f].isVisible == false then 
          obs[#obs + 1] = 6
        end
        
        if ast7[g].isVisible == false then 
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
        end]]--
        
      --local function random()
        --local random = obs[math.random(#obs)];
        --local index = math.random(#obs)
        --local obstacle = obs[index]
        local obstacle = math.random(1, 9)
        print(obstacle)
      
        if obstacle == 1 and ast6[1].isVisible == false and ast8[1].isVisible == false and ast10[1].isVisible == false 
          and ast11[1].isVisible == false then
            opMove1()
            myData.spawnGen = 3500
            
        elseif obstacle == 2 and ast6[2].isVisible == false and ast8[2].isVisible == false and ast10[2].isVisible == false 
          and ast11[2].isVisible == false and ast7[1].isVisible == false then 
            opMove2()
            myData.spawnGen = 4000
          
        elseif obstacle == 3 and ast6[3].isVisible == false and ast4[1].isVisible == false and ast9[1].isVisible == false 
          and ast11[3].isVisible == false then 
            opMove3()
            myData.spawnGen = 3000
        
        elseif obstacle == 4 and ast6[4].isVisible == false and ast4[2].isVisible == false 
          and ast14[1].isVisible == false then 
            opMove4()
            myData.spawnGen = 3000
            
        elseif obstacle == 5 and ast6[5].isVisible == false and ast4[3].isVisible == false 
          and ast14[2].isVisible == false then
            opMove5()
            myData.spawnGen = 3000
            
        elseif obstacle == 6 and ast8[3].isVisible == false and ast10[3].isVisible == false and ast11[4].isVisible == false 
          and ast7[2].isVisible == false and ast3[1].isVisible == false then 
            opMove6()
            myData.spawnGen = 3000
        
        elseif obstacle == 7 and ast14[3].isVisible == false and ast14Rev[1].isVisible == false then 
          opMove7()
          myData.spawnGen = 3000
          
        elseif obstacle == 8 and ast8[4].isVisible == false and ast8[5].isVisible == false and ast6[6].isVisible == false 
          and ast6[7].isVisible == false and ast5[1].isVisible == false and ast5[2].isVisible == false then 
          opMove8()
          myData.spawnGen = 3000
          
        elseif obstacle == 9 and ast10[4].isVisible == false and ast11[5].isVisible == false and ast3[2].isVisible == false 
          and ast9[2].isVisible == false and ast8[6].isVisible == false then 
          opMove9()
          myData.spawnGen = 3000
        --[[elseif obstacle == 10 then opMove10()
        elseif obstacle == 11 then opMove11()
        elseif obstacle == 12 then opMove12()
        elseif obstacle == 13 then opMove13()
        elseif obstacle == 14 then opMove14()
        elseif obstacle == 15 then opMove15()]]--
        else
          ranGen()
          myData.spawnGen = 3500
        end
    --end
      --random()
    end
    
    --ranGen()
    
    -- Each asteroid in this function represents the last asteroid in a given object. This checker checks to see if the asteroid is at
    --  a certain location so it can spawn the next obstacle
    --[[local function checker()
      local ast6X, ast6Y
      
      if ast6[1].isVisible == true then
        ast6[1]:localToContent( 0, 0 )
      elseif ast6[2].isVisible == true then
        ast6[2]:localToContent( 0, 0 )
      elseif ast11[3].isVisivle == true then
        ast11[3]:localToContent( 0, 0 )
      elseif ast6[4].isVisivle == true then
        ast6[4]:localToContent( 0, 0 )
      elseif ast6[5].isVisivle == true then
        ast6[5]:localToContent( 0, 0 )
      elseif ast3[1].isVisivle == true then
        ast3[1]:localToContent( 0, 0 )
      elseif ast14Rev[1].isVisivle == true then
        ast14Rev[1]:localToContent( 0, 0 )
        
      elseif ast6[1].x == 1000 then
        ranGen()
      elseif ast6[2].x == 1000 then
        ranGen()
      elseif ast11[3].x == 1000 then
        ranGen()
      elseif ast6[4].x == 1000 then
        ranGen()
      elseif ast6[5].x == 1000 then
        ranGen()
      elseif ast3[1].x == 1000 then
        ranGen()
      elseif ast14Rev[1].x == 1000 then
        ranGen()
      end
    end]]--
    --ranGen()
    
    objTimer = timer.performWithDelay(myData.spawnGen, ranGen, -1)
    --checkTimer = timer.performWithDelay(10, checker, -1)
    gemTimer = timer.performWithDelay(math.random(1000,4000), genGems, 99999)
-- ----------------------------------------------------------------------------------------------------
    
     -- Spirdy collision function can add more to function if needed
     function collision(self, event)
      if event.phase == "began" then 
        --Collision with asteroids
        if self.type == "player"  and event.other.type == "obstacle" then
        
          local function trans()

            charDies:stop()
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
            
            --particles.remove()
            
            resetScore()
            --shadows:Remove()
            transition.cancel()
            timer.cancel(objTimer)
            --timer.cancel(objTimer2)
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
            Runtime:removeEventListener( "enterFrame", main )
            Runtime:removeEventListener("touch", moveAnalog)
            char:removeEventListener("collision", char)
            
            transition.cancel("transTag")
            transition.cancel("obst8Rotation")
            transition.cancel("obst8")
            timer.pause(objTimer)
            --timer.cancel(objTimer2)
            timer.pause(gemTimer)
            gem:pause()
            setPrevScore()
            highScore()
            
            print( event.x,event.y )
            charDies.x = event.x
            charDies.y = event.y

            sound.atroxRemove()
            charDies:newAnim("dead", 
              mcx.sequence({name = "playerSel/characters/spirdy/gameOverAnim/dies",
              extension = "png",
              endFrame = 24,
              zeros = 2}),
            703, 660,
            {speed = 1, loops = 1})
            
            physics.removeBody(char)
            char:stop()
            
            sound.spirdyDies()
            charDies:play({name = "dead"})
            transition.to(charDies, {delay = 1000, onComplete = trans})
            
           end
           
        -- Collision with gems 
        elseif self.type == "player" and event.other.type == "gems" then
          --score.add(event.other.value)
          
          sound.gemSound()
          myData.lv1Score = myData.lv1Score + 1
          scoreText.text = myData.lv1Score
          myData.totalGems = myData.lv1Score + 1
          
          transition.to(event.other, {time = 500, x = 10, y = 30, width = 10, height = 10, alpha = 0})
          
          --Makes the type not equal so the collision is not dected this is to keep the collision at 1
          if event.other.type =="gems" then
            event.other.type = "none"
            
          end
        end
      end
    end
    
    -- Begin character animation and player movement
    -- --------------------------------------------------------------------
      -- Sets player to a type object for collision listener
      
      --char.type = "player"
      char.collision = collision 
      char:addEventListener("collision", char)
      physics.addBody(char, "dynamic", physicsIdle:get("idle00") )
    
      char:play({name = "idle"})
      
      char.isFixedRotation = true
      charDies.isFixedRotation = true
    
    -- Moves Spirdy around the level
    function main( event )
        -- moves both the sprite sheet (bird1) and the physics image (spirdy)
        MyStick:move(char, 25.0, false)
        MyStick:move(charDies, 25.0, false)
        
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
    
    local function counters()
        local group = display.newGroup()
       
        group:insert(gemCounter)
        group:insert(coinCounter)
        group:insert(coinFont)
        group:insert(scoreText)
        group:insert(pause)
        
      end
      
    counters()
    
    camera.damping = 10 -- A bit more fluid tracking
    camera:setFocus(char) -- Set the focus to the player
    camera:track() -- Begin auto-tracking 
   
  end
end
-- --------------------------------------------------------------------


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
    Runtime:removeEventListener( "enterFrame", main )
    Runtime:removeEventListener("touch", moveAnalog)
    camera:destroy()
  
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