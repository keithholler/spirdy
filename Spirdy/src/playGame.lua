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

--local table = {}
--[[local wall1, wall2, wall3, wall4, gemCounter, coinCounter, coinFont, bg1Pt1, bg1Pt2, bg1Pt3, 
      cloud2Pt1, cloud2Pt2, cloud2Pt3, pause, cloud1Pt1, cloud1Pt2, cloud1Pt3,
      gem, scoreText, camera, debugBtn, gemTimer, obstTimer, ranTimer, secondsTimer]]--
      
local wall1, wall2, wall3, wall4, gemCounter, coinCounter, coinFont, pause, gem, scoreText, camera, debugBtn, gemTimer, obstTimer, 
  ranTimer, secondsTimer, bg1Pt1, cloud1Pt1
  
local score = myData.lv1Score 
local prevScore = myData.lv1PrevScore
local highScore = myData.lv1HighScore
local random = math.random

--local objGen = 4000
--local objSpeed = 7000

local musicTimer = 0 
local waveLengthTimer = 0

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
local ast15 = {}
local astField = {}
local scCrak = {}
--local obstacles = {}

-- Values for each asteroid table
local a = 0
local b = 0
local c = 0
local d = 0
local e = 0
local f = 0
local g = 0
local h = 0
local i = 0
local j = 0
local k = 0
local l = 0
local m = 0
local n = 0
local o = 0
local p = 0
local q = 0
--local obst = 1

local objectCount = 40
--local objectCount2 = 40
--local obstacleCount = 30
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
    char:togglePause()
    physics.pause()
    transition.pause()
    timer.pause(obstTimer)
    --timer.pause(waveLengthChecker)
    --timer.pause(secondsTimer)
    timer.pause(gemTimer)
    sound.lv1Pause()
    myData.bgScrollSpeed = 0
    myData.planetScrollSpeed = 0
    pause.alpha = 0
   end
end

function scene:resumeGame()
   char:togglePause()
   physics.start()
   transition.resume()
   timer.resume(obstTimer)
   --timer.resume(waveLengthChecker)
   timer.resume(gemTimer)
   sound.lv1Resume()
   myData.bgScrollSpeed = 0.4
   myData.planetScrollSpeed = 0.8
   pause.alpha = 1
end

-- Deletes data when changing scene
function scene:remove()

  --bg1Pt1:removeSelf()
  --bg1Pt1 = nil
  --bg1Pt2:removeSelf()
  --bg1Pt2 = nil
  --bg1Pt3:removeSelf()
  --bg1Pt3 = nil
  
  --cloud1Pt1:removeSelf()
  --cloud1Pt1 = nil
  --cloud1Pt2:removeSelf()
  --cloud1Pt2 = nil
  --cloud1Pt3:removeSelf()
  --cloud1Pt3 = nil
  
  --cloud2Pt1:removeSelf()
  --cloud2Pt1 = nil
  --cloud2Pt2:removeSelf()
  --cloud2Pt2 = nil
  --cloud2Pt3:removeSelf()
  --cloud2Pt3 = nil]]--
  
  wall1:removeSelf()
  wall1 = nil
  wall2:removeSelf()
  wall2 = nil
  wall3:removeSelf()
  wall3 = nil
  wall4:removeSelf()
  wall4 = nil
  
  gemCounter:removeSelf()
  gemCounter = nil
  
  coinCounter:removeSelf()
  coinCounter = nil
  
  coinFont:removeSelf()
  coinFont = nil
  
  scoreText:removeSelf()
  scoreText = nil
  
  pause:removeSelf()
  pause = nil
  
  debugBtn:removeSelf()
  debugBtn = nil
  
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

local getPrev = composer.getPrevious()
if getPrev ~= nil then
  composer.removeScene(getPrev)
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    camera = perspective.createView()
    
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
      local wallMaterial = { density = 1.0, friction = 0.3, bounce = 0.0 }
      
      wall1 = display.newRect(sceneGroup, -150, H/2, 30, H + 300)
      wall1.alpha = 0
      camera:add(wall1, 8)
      wall1.type = "wall"

      wall2 = display.newRect(sceneGroup, W/2, -150, W + 300, 30)
      wall2.alpha = 0
      camera:add(wall2, 8)
      wall2.type = "wall"


      wall3 = display.newRect(sceneGroup, W + 150, H/2, 30, H + 300)
      wall3.alpha = 0
      camera:add(wall3, 8)
      wall3.type = "wall"

      wall4 = display.newRect(sceneGroup, W/2, H + 150, W + 300, 30)
      wall4.alpha = 0
      camera:add(wall4, 8)
      wall4.type = "wall"

      -- Create bounding wall for the level
      physics.addBody( wall1, "kinematic", wallMaterial )
      physics.addBody( wall2, "kinematic", wallMaterial )
      physics.addBody( wall3, "kinematic", wallMaterial )
      physics.addBody( wall4, "kinematic", wallMaterial )
      
      ----------------------
      --    Background/UI    --
      ----------------------
------------------------------------------------------------------------------------------------------
      
      --bg1Pt1 = display.newImageRect(sceneGroup, "transition.png", 1625, 1100)
      --camera:add(bg1Pt1, 8)
      --bg1Pt2 = display.newImageRect(sceneGroup, "levels/backgrounds/level1/bg1Pt2.png", 1625, 900)
      --camera:add(bg1Pt2, 8)
      --bg1Pt3 = display.newImageRect(sceneGroup, "levels/backgrounds/level1/bg1Pt3.png", 1625, 900)
      --camera:add(bg1Pt3, 8)
      
      --cloud1Pt1 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/bg1Pt1New.png", 1625, 1100)
      --camera:add(cloud1Pt1, 7)
      --cloud1Pt2 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds1Pt2.png", 1625, 900)
      --camera:add(cloud1Pt2, 7)
      --cloud1Pt3 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds1Pt3.png", 1625, 900)
      --camera:add(cloud1Pt3, 7)
      
      --cloud2Pt1 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds2Pt1.png", 1625, 900)
      --camera:add(cloud2Pt1, 6)
      --cloud2Pt2 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds2Pt2.png", 1625, 900)
      --camera:add(cloud2Pt2, 6)
      --cloud2Pt3 =  display.newImageRect(sceneGroup, "levels/backgrounds/level1/clouds2Pt3.png", 1625, 900)
      --camera:add(cloud2Pt3, 6)
      
      -- Background
      --bg1Pt1:scale(1, 1)
      --bg1Pt1.anchorX = 0;
      --bg1Pt1.anchorY = 0.5;
      --bg1Pt1.x = 0;
      --bg1Pt1.y = H/2;
  
      --[[bg1Pt2:scale(1, 1)
      bg1Pt2.anchorX = 0;
      bg1Pt2.anchorY = 0.5;
      bg1Pt2.x = 1625;
      bg1Pt2.y = H/2;
  
      bg1Pt3:scale(1, 1)
      bg1Pt3.anchorX = 0;
      bg1Pt3.anchorY = 0.5;
      bg1Pt3.x = 3250; 
      bg1Pt3.y = H/2;]]--
      
      -- Obstacle count
      --[[for obst = 1, obstacleCount do
        obstacles[obst] = display.newImageRect(sceneGroup, "trackObstacle.png", 100, 100)
        obstacles[obst].isVisible = false
        obstacles[obst].isBodyActive = false
        camera:add(obstacles[obst], 8)
      end]]--
      
      -- Small stars
      local emitter1 = pd.newEmitter("starFieldSmall.json")
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
      camera:add(emitter3, 8)
      
      -- Clouds Layer 1
      --cloud1Pt1:scale(1, 1)
      --cloud1Pt1.anchorX = 0;
      --cloud1Pt1.anchorY = 0.5;
      --cloud1Pt1.x = 0;
      --cloud1Pt1.y = H/2;
  
      --[[cloud1Pt2:scale(1, 1)
      cloud1Pt2.anchorX = 0;
      cloud1Pt2.anchorY = 0.5;
      cloud1Pt2.x = 1625; 
      cloud1Pt2.y = H/2;
  
      cloud1Pt3:scale(1, 1)
      cloud1Pt3.anchorX = 0;
      cloud1Pt3.anchorY = 0.5;
      cloud1Pt3.x = 3250; 
      cloud1Pt3.y = H/2;
      
      -- Clouds Layer 2
      cloud2Pt1:scale(1, 1)
      cloud2Pt1.anchorX = 0;
      cloud2Pt1.anchorY = 0.5;
      cloud2Pt1.x = 0;
      cloud1Pt1.y = H/2;
  
      cloud2Pt2:scale(1, 1)
      cloud2Pt2.anchorX = 0;
      cloud2Pt2.anchorY = 0.5;
      cloud2Pt2.x = 1625;
      cloud1Pt2.y = H/2;
  
      cloud2Pt3:scale(1, 1)
      cloud2Pt3.anchorX = 0;
      cloud2Pt3.anchorY = 0.5;
      cloud2Pt3.x = 3250; 
      cloud1Pt3.y = H/2;]]--
      
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
        camera:add(ast3[c], 1)
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

      for p = 1, objectCount do
        ast15[p] = display.newImageRect(sceneGroup, "levels/normalMode/level1/ast11Small.png", 100, 90)
        ast15[p].isVisible = false
        ast15[p].isBodyActive = false
        camera:add(ast15[p], 2)
        local function rotate()
          transition.to(ast15[p], {time = 2000, rotation = ast15[p].rotation+360, onComplete = rotate, tag = "transTag"})
        end
        
        rotate()
      end

      for q = 1, objectCount do
        scCrak[q] = display.newImageRect(sceneGroup, "levels/normalMode/level1/screencrack_5.png", 784, 848)
        scCrak[q].isVisible = false
        scCrak[q].isBodyActive = false
        camera:add(scCrak[q], 1)
      end

     --[[ for q = 1, objectCount do
        astField[q] = display.newCircle(sceneGroup, 0, 0, 100 ) ; astField[q].alpha = 0.3
        astField[q].type = "area"
        astField[q].isVisible = false
        astField[q].isBodyActive = false
        camera:add(astField[q], 2)
      end--]]
      
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
            {speed = 2, loops = -1})
            
        char:newAnim("forward", 
            mcx.sequence({name = "playerSel/characters/spirdy/forwardAnim/fwd",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            124, 168,
            {speed = 2, loops = -1})
            
        char:newAnim("back", 
            mcx.sequence({name = "playerSel/characters/spirdy/backAnim/back",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            136, 169,
            {speed = 2, loops = -1})
            
        char:newAnim("up", 
            mcx.sequence({name = "playerSel/characters/spirdy/upAnim/up",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            110, 171,
            {speed = 2, loops = -1})
            
        char:newAnim("down", 
            mcx.sequence({name = "playerSel/characters/spirdy/downAnim/down",
              extension = "png",
              endFrame = 8,
              zeros = 2}),
            132, 171,
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
      
      char.x = W - 1500
      char.y = H*.5
      
      char.isVisible = false
      char.isBodyActive = false
      
      sceneGroup:insert(char)
      camera:add(char, 2)
      
      -- Moving stars
      local emitter6 = pd.newEmitter("movingStars.json")
      emitter6.x = centerX + 600
      emitter6.y = centerY
      emitter6.startColorBlue = 1
      emitter6.startColorRed = 1
      emitter6.startColorGreen = 0
      sceneGroup:insert(emitter6)
      camera:add(emitter6, 1)
      
      --[[emitter4 = pd.newEmitter("fogTop.json")
      emitter4.x = W/2 + 1400
      emitter4.y = H/2 - 500

      emitter4.alpha = 0.008

      emitter4.startColorBlue = 1
      emitter4.startColorRed = 1
      emitter4.startColorGreen = 0

      emitter4.startParticleSize = 550
      sceneGroup:insert(emitter4)
      camera:add(emitter4, 1)

      emitter5 = pd.newEmitter("fogBottom.json")
      emitter5.x = W/2 + 1400
      emitter5.y = H/2 + 550

      emitter5.alpha = 0.008

      emitter5.startColorBlue = 1
      emitter5.startColorRed = 1
      emitter5.startColorGreen = 0

      emitter5.startParticleSize = 550
      sceneGroup:insert(emitter5)
      camera:add(emitter5, 1)]]--
      
      -- Variables for the in-game displays
      gemCounter = display.newImageRect(sceneGroup, "gameUI/counter_gem.png", 271, 128)
      coinCounter = display.newImageRect(sceneGroup, "gameUI/counter_coin.png", 271, 128)
      
      gemCounter.x = W/2 - 500
      gemCounter.y = H/2 - 330
      gemCounter.isVisible = false
      gemCounter.isBodyActive = false
      camera:add(gemCounter, 1)
        
      coinCounter.x = W/2 - 220
      coinCounter.y = H/2 - 330
      coinCounter.isVisible = false
      coinCounter.isBodyActive = false
      camera:add(coinCounter, 1)
      
      coinFont = display.newText(sceneGroup, myData.coins, W/2-170, H/2-325, "Soup Of Justice", 42)
      coinFont:setFillColor( 0, 0, 0 )
      coinFont.isVisible = false
      coinFont.isBodyActive = false
      coinFont.anchorX = 0
      camera:add(coinFont, 1)
      
      scoreText = display.newText(sceneGroup, myData.lv1Score, W/2-450, H/2-325, "Soup Of Justice", 42)
      scoreText:setFillColor(0, 0, 0)
      scoreText.isVisible = false
      scoreText.isBodyActive = false
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
      pause.isVisible = false
      pause.isBodyActive = false
      sceneGroup:insert(pause)
      camera:add(pause, 1)
      
      -- Set parameters for the Analog stick
      MyStick = Analog.NewStick({x = 0, y = 0, thumbSize = 45, borderSize = 65, 
            snapBackSpeed = .75, R = 255, G = 255, B = 255})
      sceneGroup:insert(MyStick)
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
      
      local getPrev = composer.getPrevious()
      if getPrev ~= nil then
        composer.removeScene(getPrev)
      end
      
      --composer.removeScene("loadIntro")
      --composer.removeScene("levelSelNorm")
      --composer.removeScene("retry")
      
        --[[function move(event)
  
          bg1Pt1.x = bg1Pt1.x - myData.bgScrollSpeed
          bg1Pt2.x = bg1Pt2.x - myData.bgScrollSpeed
          bg1Pt3.x = bg1Pt3.x - myData.bgScrollSpeed
        
          if(bg1Pt1.x + bg1Pt1.contentWidth) < -1625 then
            bg1Pt1:translate(1625*3, 0)
          end
        
          if(bg1Pt2.x + bg1Pt2.contentWidth) < -1625 then
            bg1Pt2:translate(1625*3, 0)
          end
        
          if(bg1Pt3.x + bg1Pt3.contentWidth) < -1625 then
            bg1Pt3:translate(1625*3, 0)
          end
        end
  
      Runtime:addEventListener("enterFrame", move)
      
      function move2(event)
  
        cloud1Pt1.x = cloud1Pt1.x - myData.bgScrollSpeed
        cloud1Pt2.x = cloud1Pt2.x - myData.bgScrollSpeed
        cloud1Pt3.x = cloud1Pt3.x - myData.bgScrollSpeed
          
        if(cloud1Pt1.x + cloud1Pt1.contentWidth) < -1625 then
          cloud1Pt1:translate(1625*3, 0)
        end
          
        if(cloud1Pt2.x + cloud1Pt2.contentWidth) < -1625 then
          cloud1Pt2:translate(1625*3, 0)
        end
          
        if(cloud1Pt3.x + cloud1Pt3.contentWidth) < -1625 then
          cloud1Pt3:translate(1625*3, 0)
        end
      end
  
      Runtime:addEventListener("enterFrame", move2)
      
      function move3(event)
  
        cloud2Pt1.x = cloud2Pt1.x - myData.bgScrollSpeed
        cloud2Pt2.x = cloud2Pt2.x - myData.bgScrollSpeed
        cloud2Pt3.x = cloud2Pt3.x - myData.bgScrollSpeed
          
        if(cloud2Pt1.x + cloud2Pt1.contentWidth) < -1625 then
          cloud2Pt1:translate(1625*3, 0)
        end
          
        if(cloud2Pt2.x + cloud2Pt2.contentWidth) < -1625 then
          cloud2Pt2:translate(1625*3, 0)
        end
          
        if(cloud2Pt3.x + cloud2Pt3.contentWidth) < -1625 then
          cloud2Pt3:translate(1625*3, 0)
        end
      end
  
      Runtime:addEventListener("enterFrame", move3)]]--
      
    --[[elseif ( phase == "did" ) then
     -- Called when the scene is now on screen.
     -- Insert code here to make the scene come alive.
     -- Example: start timers, begin animation, play audio, etc.
       
     myData.adjustSpeed = 0
     
     local function checkTime()
      musicTimer = musicTimer + 1
      
      -- Speeds up the level speed based on the beat of the music
      if musicTimer == 9 then
        myData.adjustSpeed = 1000
        myData.adjustTimer = 300
      end
      
      print(musicTimer)
     end
     
     secondsTimer = timer.performWithDelay(1000, checkTime, -1)]]--
     
     --[[local function waveLength()
      -- Every iteration of 1 that adds to the waveLegnth function counts as 100 miliseconds
      -- This function is used to check the wavelength of the song playing in the background, based on the wavelength of the song playing,
      --  the auras located behind each asteroid will scale bigger and smaller based on the song data
      waveLengthTimer = waveLengthTimer + 1
      
      if waveLengthTimer == 1 then
      
      end
     end
     
     waveLengthChecker = timer.performWithDelay(100, waveLength, -1)]]--
     
     local function debug(event)
      local go = event.target.id
        if go == "debug" then
          debugBtn.id = "debugOff"
          char.type = "godMode"
        end
        
        if go == "debugOff" then
          debugBtn.id = "debug"
          char.type = "player"
        end
       
     end
     
     debugBtn = widget.newButton({label = "Debug", onRelease = debug})
     debugBtn.id = "debug"
     debugBtn.x = W/2 - 600
     debugBtn.y = H/2 + 300
     sceneGroup:insert(debugBtn)
     camera:add(debugBtn, 1)
     
     -- Loads the music for level 1   
     sound.lv1()
      
     -- Listens for the Analog stick
     function moveAnalog(e)
        if e.phase == "began" then
          MyStick.x = e.x
          MyStick.y = e.y
          e.target = MyStick.Thumb
          e.phase = "began"
          MyStick.onDrag(e)

        elseif e.phase == "moved" then
          analogTimer = timer.performWithDelay(10, transition.cancel(tapAnalog))
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
        
        --local function trackX()
          --transition.to(ast6[1], {time = 3500 - myData.adjustSpeed, x = W/2 - 1000, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end
        
        transition.to(ast11[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1850, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast8[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1650, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast10[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1400, onComplete = targetRemove, tag = "transTag"})
        --transition.to(ast6[1], {time = 3000 - myData.adjustSpeed, x = W/2 + 500, onComplete = trackX, tag = "transTag"})
        transition.to(ast6[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1200, onComplete = targetRemove, tag = "transTag"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(myData.spawnGen - myData.adjustTimer, ranGen, 1)
        end
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
        
        --local function trackX()
          --transition.to(ast7[1], {time = 3400 - myData.adjustSpeed, x = W/2 - 1000, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end
      
        transition.to(ast11[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2050, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast8[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2050, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast10[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1600, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1200, onComplete = targetRemove, tag = "transTag"})
        --transition.to(ast7[1], {time = 4000 - myData.adjustSpeed, x = W/2 + 500, onComplete = trackX, tag = "transTag"})
        transition.to(ast7[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1100, onComplete = targetRemove, tag = "transTag"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(myData.spawnGen - myData.adjustTimer, ranGen, 1)
        end
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
        
        --local function trackX()
          --transition.to(ast9[1], {time = 4600 - myData.adjustSpeed, x = W/2 - 1800, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end
      
        transition.to(ast4[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2250, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2050, onComplete = targetRemove, tag = "transTag"})
        --transition.to(ast9[1], {time = 2100 - myData.adjustSpeed, x = W/2 + 500, onComplete = trackX, tag = "transTag"})
        transition.to(ast11[3], {time = myData.obstacleSpeed - 2500 - myData.adjustSpeed, x = W/2 - 1600, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast9[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1800, onComplete = targetRemove, tag = "transTag"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(2700 - myData.adjustTimer, ranGen, 1)
        end
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
        
        --local function trackX()
          --transition.to(ast6[4], {time = 4000 - myData.adjustSpeed, x = W/2 - 1700, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end
      
        transition.to(ast4[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2250, onComplete = targetRemove, tag = "transTag"})
        --transition.to(ast6[4], {time = 2000 - myData.adjustSpeed, x = W/2 + 800, onComplete = trackX, tag = "transTag"})
        transition.to(ast14[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[4], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1700, onComplete = targetRemove, tag = "transTag"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(2700 - myData.adjustTimer, ranGen, 1)
        end
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
        
        --local function trackX()
          --transition.to(ast6[5], {time = 4000 - myData.adjustSpeed, x = W/2 - 1700, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end
      
        transition.to(ast4[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2250, onComplete = targetRemove, tag = "transTag"})
        --transition.to(ast6[5], {time = 1500 - myData.adjustSpeed, x = W/2 + 800, onComplete = trackX, tag = "transTag"})
        transition.to(ast14[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast6[5], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1700, onComplete = targetRemove, tag = "transTag"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(2700 - myData.adjustTimer, ranGen, 1)
        end
    end
    
    -- Obstacle 6
    local opMove6 = function()
        
        physics.addBody(ast7[2], "kinematic", physicsData:get("ast7") )
        physics.addBody(ast8[3], "kinematic", physicsData:get("ast8") )
        physics.addBody(ast10[3], "kinematic", physicsData:get("ast10") )
        physics.addBody(ast11[4], "kinematic", physicsData:get("ast11") )
        physics.addBody(ast3[1], "kinematic", physicsData:get("ast3") )
        
        ast7[2].x = W/2 + 2000
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

        ast11[4].x = W/2 + 2100
        ast11[4].y = H/2 - 300
        ast11[4].isVisible = true
        ast11[4].isBodyActive = true
        ast11[4].type = "obstacle"

        ast3[1].x = W/2 + 2200
        ast3[1].y = H/2 + 600
        ast3[1].isVisible = true
        ast3[1].isBodyActive = true
        ast3[1].type = "obstacle"
        
        --local function trackX()
          --transition.to(ast11[4], {time = 3800 - myData.adjustSpeed, x = W/2 - 1400, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end
      
        transition.to(ast7[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1300, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast8[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast10[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        --transition.to(ast11[4], {time = 3000 - myData.adjustSpeed, x = W/2 + 400, onComplete = trackX, tag = "transTag"})
        transition.to(ast3[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1400, onComplete = targetRemove, tag = "transTag"})
        transition.to(ast11[4], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1400, onComplete = targetRemove, tag = "transTag"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(myData.spawnGen - myData.adjustTimer, ranGen, 1)
        end
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
        ast14Rev[1].y = H/2 + 200
        --ast14[4].xScale = -1
        ast14Rev[1].isVisible = true
        ast14Rev[1].isBodyActive = true
        ast14Rev[1].type = "obstacle"
        
        --local function trackX()
          --transition.to(ast14Rev[1], {time = 4000 - myData.adjustSpeed, x = W/2 - 1800, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
       -- end
      
        transition.to(ast14[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2000, onComplete = targetRemove, tag = "transTag"})
        --transition.to(ast14Rev[1], {time = 2000 - myData.adjustSpeed, x = W/2 + 650, onComplete = trackX, tag = "transTag"})
        transition.to(ast14Rev[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1800, onComplete = targetRemove, tag = "transTag"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(3000 - myData.adjustTimer, ranGen, 1)
        end
    end
    
    
    
    local opMove8 = function()
        
        local function remove(target)
          target.isVisible = false
          target.isBodyActive = false
          physics.removeBody(target)
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

        transition.to(ast8[4], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2400, onComplete = remove, tag = "transTag"})
        transition.to(ast6[6], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2400, onComplete = remove, tag = "transTag"})
        transition.to(ast5[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2400, onComplete = remove, tag = "transTag"})
        transition.to(ast6[6], {time = 1700 - myData.adjustSpeed, y = H/2 - 180, onComplete = collision, tag = "obst8"})
        
        ast8[5].x = W/2 + 2400
        ast8[5].y = H/2 - 400
        ast8[5].isVisible = true
        ast8[5].isBodyActive = true
        ast8[5].type = "obstacle"

        ast6[7].x = W/2 + 2400
        ast6[7].y = H/2
        ast6[7].isVisible = true
        ast6[7].isBodyActive = true
        ast6[7].type = "obstacle"

        ast5[2].x = W/2 + 2400
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
            transition.to(ast6[7], {time = 1700, y = H/2 + 230, onComplete = collision2, tag = "obst8"})
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
        
        --local function trackX()
          --transition.to(ast6[7], {time = 3600 - myData.adjustSpeed, x = W/2 - 1900, onComplete = remove, tag = "transTag"})
          --ranGen()
       -- end

        transition.to(ast8[5], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1900, onComplete = remove, tag = "transTag"})
        --transition.to(ast6[7], {time = 3200 - myData.adjustSpeed, x = W/2 + 400, onComplete = trackX, tag = "transTag"})
        transition.to(ast6[7], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1900, onComplete = remove, tag = "transTag"})
        transition.to(ast5[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1900, onComplete = remove, tag = "transTag"})
        transition.to(ast6[7], {time = 1700 - myData.adjustSpeed, y = H/2 + 230, onComplete = collision2, tag = "obst8"})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(3000 - myData.adjustTimer, ranGen, 1)
        end
    end
    
    local opMove9 = function()
    
      physics.addBody(ast9[2], "kinematic", physicsData:get("ast9") )
      physics.addBody(ast3[2], "kinematic", physicsData:get("ast3") )
      physics.addBody(ast11[5], "kinematic", physicsData:get("ast11") )
      physics.addBody(ast8[6], "kinematic", physicsData:get("ast8") )
      physics.addBody(ast10[4], "kinematic", physicsData:get("ast10") )

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
        
        --local function trackX()
          --transition.to(ast3[2], {time = 4000 - myData.adjustSpeed, x = W/2 - 1400, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end

        transition.to(ast9[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2200, tag = "transTag", onComplete = targetRemove})
        --transition.to(ast3[2], {time = 4000 - myData.adjustSpeed, x = W/2 + 500, tag = "transTag", onComplete = trackX})
        transition.to(ast11[5], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1600, tag = "transTag", onComplete = targetRemove})
        transition.to(ast10[4], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2000, tag = "transTag", onComplete = targetRemove})
        transition.to(ast8[6], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2400, tag = "transTag", onComplete = targetRemove})
        transition.to(ast3[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1400, tag = "transTag", onComplete = targetRemove})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(3000 - myData.adjustTimer, ranGen, 1)
        end
    end
    
    local opMove10 = function()
    
      physics.addBody(ast9[3], "kinematic", physicsData:get("ast9") )
      physics.addBody(ast4[4], "kinematic", physicsData:get("ast4") )
      physics.addBody(ast11[6], "kinematic", physicsData:get("ast11") )
      physics.addBody(ast12[1], "kinematic", physicsData:get("ast12") )
      physics.addBody(ast7[3], "kinematic", physicsData:get("ast7") )

        ast9[3].x = W/2 + 1600
        ast9[3].y = H/2 - 400
        ast9[3].isVisible = true
        ast9[3].isBodyActive = true
        ast9[3].type = "obstacle"

        ast4[4].x = W/2 + 2300
        ast4[4].y = H/2
        ast4[4].isVisible = true
        ast4[4].isBodyActive = true
        ast4[4].type = "obstacle"

        ast11[6].x = W/2 + 1900
        ast11[6].y = H/2 + 300
        ast11[6].isVisible = true
        ast11[6].isBodyActive = true
        ast11[6].type = "obstacle"

        ast12[1].x = W/2 + 1400
        ast12[1].y = H/2 + 400
        ast12[1].isVisible = true
        ast12[1].isBodyActive = true
        ast12[1].type = "obstacle"

        ast7[3].x = W/2 + 2600
        ast7[3].y = H/2 - 150
        ast7[3].isVisible = true
        ast7[3].isBodyActive = true
        ast7[3].type = "obstacle"
        
        --local function trackX()
          --transition.to(ast7[3], {time = 4000 - myData.adjustSpeed, x = W/2 - 1600, onComplete = targetRemove, tag = "transTag"})
          --ranGen()
        --end

        transition.to(ast9[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2500, tag = "transTag", onComplete = targetRemove})
        transition.to(ast4[4], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1900, tag = "transTag", onComplete = targetRemove})
        transition.to(ast11[6], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2100, tag = "transTag", onComplete = targetRemove})
        transition.to(ast12[1], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2300, tag = "transTag", onComplete = targetRemove})
        --transition.to(ast7[3], {time = 4000 - myData.adjustSpeed, x = W/2 + 500, tag = "transTag", onComplete = trackX})
        transition.to(ast7[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1600, tag = "transTag", onComplete = targetRemove})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(3400 - myData.adjustTimer, ranGen, 1)
        end
    end
    
    local opMove11 = function()
    
        local function remove(target)
          target.isVisible = false
          target.isBodyActive = false
          physics.removeBody(target)
          transition.cancel("op11Move")
        end
        
        physics.addBody(ast5[3], "kinematic", physicsData:get("ast5"))
        physics.addBody(ast4[5], "kinematic", physicsData:get("ast4"))
        physics.addBody(ast6[8], "kinematic", physicsData:get("ast6"))
        physics.addBody(ast12[2], "kinematic", physicsData:get("ast12"))
        physics.addBody(ast8[7], "kinematic", physicsData:get("ast8"))
        physics.addBody(ast11[7], "kinematic", physicsData:get("ast11"))

        ast5[3].x = W/2 + 1400
        ast5[3].y = H/2 + 300
        ast5[3].isVisible = true
        ast5[3].isBodyActive = true
        ast5[3].type = "obstacle"

        ast4[5].x = W/2 + 1700
        ast4[5].y = H/2 + 500
        ast4[5].isVisible = true
        ast4[5].isBodyActive = true
        ast4[5].type = "obstacle"

        ast6[8].x = W/2 + 1700
        ast6[8].y = H/2 - 200
        ast6[8].isVisible = true
        ast6[8].isBodyActive = true
        ast6[8].type = "obstacle"

        ast12[2].x = W/2 + 2150
        ast12[2].y = H/2 + 100
        ast12[2].isVisible = true
        ast12[2].isBodyActive = true
        ast12[2].type = "obstacle"

        ast8[7].x = W/2 + 2050
        ast8[7].y = H/2 - 450
        ast8[7].isVisible = true
        ast8[7].isBodyActive = true
        ast8[7].type = "obstacle"

        ast11[7].x = W/2 + 2500
        ast11[7].y = H/2 + 400
        ast11[7].isVisible = true
        ast11[7].isBodyActive = true
        ast11[7].type = "obstacle"

        local function upDown()
          if ast6[8].y == H/2 - 1000 then
            transition.to(ast4[5], {time = 1500, y = H/2 + 500, tag = "op11Move"})
            transition.to(ast6[8], {time = 1500, y = H/2 - 200, onComplete = upDown, tag = "op11Move"})
          end

          if ast6[8].y == H/2 - 200 then
            transition.to(ast4[5], {time = 1500, y = H/2 - 300, tag = "op11Move"})
            transition.to(ast6[8], {time = 1500, y = H/2 - 1000, onComplete = upDown, tag = "op11Move"})
          end
        end

        -- Moving asteroids
        transition.to(ast4[5], {time = 1500, y = H/2 - 300, tag = "op11Move"})
        transition.to(ast6[8], {time = 1500, y = H/2 - 1000, onComplete = upDown, tag = "op11Move"})

        transition.to(ast5[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2700, tag = "transTag", onComplete = remove})
        transition.to(ast4[5], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2400, tag = "transTag", onComplete = remove})
        transition.to(ast6[8], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2400, tag = "transTag", onComplete = remove})
        transition.to(ast11[7], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 1600, tag = "transTag", onComplete = remove})
        transition.to(ast12[2], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2000, tag = "transTag", onComplete = remove})
        transition.to(ast8[7], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2 - 2100, tag = "transTag", onComplete = remove})
        

        if char.isVisible == true then
          obstTimer = timer.performWithDelay(3400 - myData.adjustTimer, ranGen, 1)
        end
    end
    
    local opMove12 = function()
    
        local function remove(target)
          target.isVisible = false
          target.isBodyActive = false
          physics.removeBody(target)
          transition.cancel("op12Move")
        end
    
        physics.addBody(ast5[4], "kinematic", physicsData:get("ast5"))
        physics.addBody(ast4[6], "kinematic", physicsData:get("ast4"))
        physics.addBody(ast9[4], "kinematic", physicsData:get("ast6"))
        physics.addBody(ast12[3], "kinematic", physicsData:get("ast12"))
        physics.addBody(ast8[8], "kinematic", physicsData:get("ast8"))
        physics.addBody(ast11[8], "kinematic", physicsData:get("ast11"))

        ast5[4].x = W/2 + 1600
        ast5[4].y = H/2 + 400
        ast5[4].isVisible = true
        ast5[4].isBodyActive = true
        ast5[4].type = "obstacle"

        ast4[6].x = W/2 + 1900
        ast4[6].y = H/2 + 500
        ast4[6].isVisible = true
        ast4[6].isBodyActive = true
        ast4[6].type = "obstacle"

        ast9[4].x = W/2 + 1900
        ast9[4].y = H/2 - 200
        ast9[4].isVisible = true
        ast9[4].isBodyActive = true
        ast9[4].type = "obstacle"

        ast12[3].x = W/2 + 1600
        ast12[3].y = H/2 + 100
        ast12[3].isVisible = true
        ast12[3].isBodyActive = true
        ast12[3].type = "obstacle"

        ast8[8].x = W/2 + 1500
        ast8[8].y = H/2 - 450
        ast8[8].isVisible = true
        ast8[8].isBodyActive = true
        ast8[8].type = "obstacle"

        ast11[8].x = W/2 + 1600
        ast11[8].y = H/2 - 200
        ast11[8].isVisible = true
        ast11[8].isBodyActive = true
        ast11[8].type = "obstacle"

        local function upDown()
          if ast9[4].y == H/2 - 1000 then
            transition.to(ast4[6], {time = 1500, y = H/2 + 500, tag = "op12Move"})
            transition.to(ast9[4], {time = 1500, y = H/2 - 200, onComplete = upDown, tag = "op12Move"})
          end

          if ast9[4].y == H/2 - 200 then
            transition.to(ast4[6], {time = 1500, y = H/2 - 300, tag = "op12Move"})
            transition.to(ast9[4], {time = 1500, y = H/2 - 1000, onComplete = upDown, tag = "op12Move"})
          end
        end

        transition.to(ast4[6], {time = 1500, y = H/2 - 300, tag = "op12Move"})
        transition.to(ast9[4], {time = 1500, y = H/2 - 1000, onComplete = upDown, tag = "op12Move"})

        transition.to(ast5[4], {time = 8000, x = W/2 - 2100, tag = "transTag", onComplete = remove})
        transition.to(ast4[6], {time = 8000, x = W/2 - 1800, tag = "transTag", onComplete = remove})
        transition.to(ast9[4], {time = 8000, x = W/2 - 1800, tag = "transTag", onComplete = remove})
        transition.to(ast11[8], {time = 8000, x = W/2 - 2100, tag = "transTag", onComplete = remove})
        transition.to(ast12[3], {time = 5500, x = W/2 - 2100, tag = "transTag", onComplete = remove})
        transition.to(ast8[8], {time = 5500, x = W/2 - 2200, tag = "transTag", onComplete = remove})
        
        if char.isVisible == true then
          obstTimer = timer.performWithDelay(4000 - myData.adjustTimer, ranGen, 1)
        end
    end

    local opMove13 = function()

--removes following asreoids
      local function remove(target)
        physics.removeBody( target )
      end

-- add physics to the asteroids
        physics.addBody(ast15[1], "kinematic", physicsData:get("ast11Small") )
        physics.addBody(ast15[2], "kinematic", physicsData:get("ast11Small") ) 
        physics.addBody(ast15[3], "kinematic", physicsData:get("ast11Small") )
        physics.addBody(ast15[4], "kinematic", physicsData:get("ast11Small") )
        physics.addBody(ast15[5], "kinematic", physicsData:get("ast11Small") )   
        physics.addBody(ast15[6], "kinematic", physicsData:get("ast11Small") )
        physics.addBody(ast15[7], "kinematic", physicsData:get("ast11Small") )
        physics.addBody(ast15[8], "kinematic", physicsData:get("ast11Small") )    

-- add the asteroids in
        ast15[1].anchorX = 0
        ast15[1].x = W/2 + 1200
        ast15[1].y = H/2
        ast15[1].isVisible = true
        ast15[1].isBodyActive = true
        ast15[1].type = "obstacle"

        ast15[2].anchorX = 0
        ast15[2].x = W/2 + 1200
        ast15[2].y = H/2 - 1000
        ast15[2].isVisible = true
        ast15[2].isBodyActive = true
        ast15[2].type = "obstacle"

        ast15[3].anchorX = 0
        ast15[3].x = W/2 + 1200
        ast15[3].y = H/2 + 1000
        ast15[3].isVisible = true
        ast15[3].isBodyActive = true
        ast15[3].type = "obstacle"

        ast15[4].anchorX = 0
        ast15[4].x = W/2 + 500
        ast15[4].y = H/2 - 1000
        ast15[4].isVisible = true
        ast15[4].isBodyActive = true
        ast15[4].type = "obstacle"

        ast15[5].anchorX = 0
        ast15[5].x = W/2 + 500
        ast15[5].y = H/2 + 1000
        ast15[5].isVisible = true
        ast15[5].isBodyActive = true
        ast15[5].type = "obstacle"

        ast15[6].anchorX = 0
        ast15[6].x = W/2 - 500
        ast15[6].y = H/2 + 1000
        ast15[6].isVisible = true
        ast15[6].isBodyActive = true
        ast15[6].type = "obstacle"

        ast15[7].anchorX = 0
        ast15[7].x = W/2 - 500
        ast15[7].y = H/2 + 1000
        ast15[7].isVisible = true
        ast15[7].isBodyActive = true
        ast15[7].type = "obstacle"

        ast15[8].anchorX = 0
        ast15[8].x = W/2 - 1200
        ast15[8].y = H/2
        ast15[8].isVisible = true
        ast15[8].isBodyActive = true
        ast15[8].type = "obstacle"

--makes asteroids fly towards spridy
local function follow()
  
  playX1 = char.x - ast15[1].x
  playY1 = char.y - ast15[1].y

  playX2 = char.x - ast15[2].x
  playY2 = char.y - ast15[2].y

  playX3 = char.x - ast15[3].x
  playY3 = char.y - ast15[3].y

  playX4 = char.x - ast15[4].x
  playY4 = char.y - ast15[4].y

  playX5 = char.x - ast15[5].x
  playY5 = char.y - ast15[5].y

  playX6 = char.x - ast15[6].x
  playY6 = char.y - ast15[6].y

  playX7 = char.x - ast15[7].x
  playY7 = char.y - ast15[7].y

  playX8 = char.x - ast15[8].x
  playY8 = char.y - ast15[8].y
  
  ast15[1]:setLinearVelocity( playX1, playY1)

  ast15[2]:setLinearVelocity( playX2, playY2)

  ast15[3]:setLinearVelocity( playX3, playY3)

  ast15[4]:setLinearVelocity( playX4, playY4)

  ast15[5]:setLinearVelocity( playX5, playY5)

  ast15[6]:setLinearVelocity( playX6, playY6)

  ast15[7]:setLinearVelocity( playX7, playY7)

  ast15[8]:setLinearVelocity( playX8, playY8)
end

--decides how long to follow spirdy
stop6Timer = timer.performWithDelay( 200,follow, 15)

--makes asterids disappear and fly away from spirdy
local function disappear()


             op6tran =  transition.moveBy(ast15[1], {time = 2000, x = 1500, y = 0, transition = easing.inOutCirc, onComplete = remove, tag = "transTag"})

             op7tran = transition.moveBy(ast15[2], {time = 2000, x = -1500, y = 0, transition = easing.inOutCirc,onComplete = remove,tag = "transTag"})

             op8tran =  transition.moveBy(ast15[3], {time = 2000, x = 0, y = 1500, transition = easing.inOutCirc,onComplete = remove,tag = "transTag"})
 
             op9tran =  transition.moveBy(ast15[4], {time = 2000, x = 0, y = -1500, transition = easing.inOutCirc,onComplete = remove,tag = "transTag"})

             op10tran = transition.moveBy(ast15[5], {time = 2000, x = -1500, y = -1500, transition = easing.inOutCirc,onComplete = remove,tag = "transTag"})
 
             op11tran =  transition.moveBy(ast15[6], {time = 2000, x = 1500, y = 1500, transition = easing.inOutCirc,onComplete = remove,tag = "transTag"})
 
             op12tran =  transition.moveBy(ast15[7], {time = 2000, x = 1500, y = -1500, transition = easing.inOutCirc,onComplete = remove,tag = "transTag"})

             op13tran = transition.moveBy(ast15[8], {time = 2000, x = -1500, y = 1500, transition = easing.inOutCirc,onComplete = remove,tag = "transTag"})

end

stop5Timer = timer.performWithDelay( 2500,disappear, 1)

        if char.isVisible == true then
          obstTimer = timer.performWithDelay(7000 - myData.adjustTimer, ranGen, 1)
        end

-- removes asteroids incase they are on screen before the next call is made
        local function remove()
      ast15[1].isVisible = false
      ast15[1].isBodyActive = false
      physics.removeBody( ast15[1] )
      ast15[2].isVisible = false
      ast15[2].isBodyActive = false
      physics.removeBody( ast15[2] )
      ast15[3].isVisible = false
      ast15[3].isBodyActive = false
      physics.removeBody( ast15[3] )
      ast15[4].isVisible = false
      ast15[4].isBodyActive = false
      physics.removeBody( ast15[4] )
      ast15[5].isVisible = false
      ast15[5].isBodyActive = false
      physics.removeBody( ast15[5] )
      ast15[6].isVisible = false
      ast15[6].isBodyActive = false
      physics.removeBody( ast15[6] )
      ast15[7].isVisible = false
      ast15[7].isBodyActive = false
      physics.removeBody( ast15[7] )
      ast15[8].isVisible = false
      ast15[8].isBodyActive = false
      physics.removeBody( ast15[8] )
    end

    stop4Timer = timer.performWithDelay(5000, remove, 1)
    end



     local opMove15 = function()

--adds the main asteroids in
physics.addBody(ast5[5], "kinematic", physicsData:get("ast5") ) 
          ast5[5].x = W/2 +1400
          ast5[5].y = H/2 
          ast5[5].isVisible = true
          ast5[5].isBodyActive = true
          ast5[5].type = "obstacle"

physics.addBody(ast4[6], "kinematic", physicsData:get("ast4") ) 
          ast4[6].x = W/2 +1000
          ast4[6].y = H/2 -300
          ast4[6].isVisible = true
          ast4[6].isBodyActive = true
          ast4[6].type = "obstacle"

physics.addBody(ast6[10], "kinematic", physicsData:get("ast6") ) 
          ast6[10].x = W/2 +1000
          ast6[10].y = H/2 +400
          ast6[10].isVisible = true
          ast6[10].isBodyActive = true
          ast6[10].type = "obstacle"

physics.addBody(ast11[8], "kinematic", physicsData:get("ast11") ) 
          ast11[8].x = W/2 +2500
          ast11[8].y = H/2 -400
          ast11[8].isVisible = true
          ast11[8].isBodyActive = true
          ast11[8].type = "obstacle"

physics.addBody(ast12[3], "kinematic", physicsData:get("ast12") ) 
          ast12[3].x = W/2 +4000
          ast12[3].y = H/2 +400
          ast12[3].isVisible = true
          ast12[3].isBodyActive = true
          ast12[3].type = "obstacle"

--removes the exploding asteroids
    local function targetRemove3(target)

      if target.isVisible == true then
        physics.removeBody( target )
        target.isVisible = false
        target.isBodyActive = false
        timer.cancel( stop3timer )
        timer.cancel( stoptimer )
        --target:scale( .3, .3 )
   
    end
    end

-- Makes  asteroid explode and shake when exploding
          local function exploder()

             local shakeCount = 0
    local xShake = 8
    local yShake = 4
    local shakePeriod = 2

    --cooridinates for shake
    local function shake()
       if(shakeCount % shakePeriod == 0 ) then
          display.currentStage.x = display.currentStage.x0 + math.random( -xShake, xShake )
          display.currentStage.y = display.currentStage.y0 + math.random( -yShake, yShake )
       end
       shakeCount = shakeCount + 1
    end
           
    -- Start shake function      
          local function startShake()
       display.currentStage.x0 = display.currentStage.x
       display.currentStage.y0 = display.currentStage.y
       shakeCount = 0
       Runtime:addEventListener( "enterFrame", shake )
    end

    --stop shake function
    local function stopShake()
       Runtime:removeEventListener( "enterFrame", shake )
       stoptimer = timer.performWithDelay( 50, 
       function() 
          display.currentStage.x = display.currentStage.x0 
          display.currentStage.y = display.currentStage.y0
       end )
    end
          startShake()

          stop3timer = timer.performWithDelay( 100, stopShake )
           
-- makes asteroids explode where the original asteroid was
           obX =  ast5[5].x
           obY =  ast5[5].y
--adds in the exploding asteroids
            physics.addBody(ast15[10], "kinematic", physicsData:get("ast11Small") ) 
            ast15[10].x = obX
            ast15[10].y = obY 
            ast15[10].isVisible = true
            ast15[10].isBodyActive = true
            ast15[10].type = "obstacle"

            physics.addBody(ast15[11], "kinematic", physicsData:get("ast11Small") ) 
            ast15[11].x = obX
            ast15[11].y = obY 
            ast15[11].isVisible = true
            ast15[11].isBodyActive = true
            ast15[11].type = "obstacle"
  
           physics.addBody(ast15[12], "kinematic", physicsData:get("ast11Small") ) 
            ast15[12].x = obX
            ast15[12].y = obY 
            ast15[12].isVisible = true
            ast15[12].isBodyActive = true
            ast15[12].type = "obstacle"

            physics.addBody(ast15[13], "kinematic", physicsData:get("ast11Small") ) 
            ast15[13].x = obX
            ast15[13].y = obY 
            ast15[13].isVisible = true
            ast15[13].isBodyActive = true
            ast15[13].type = "obstacle"

           --physics.addBody(ast15[14], "kinematic", physicsData:get("ast11Small") ) 
            ast15[14].x = obX
            ast15[14].y = obY 
            ast15[14].isVisible = true
            ast15[14].isBodyActive = true
            ast15[14].type = "obstacle"

--makes main asteroid that explodes disappear at the time of explosion
            ast5[5].isVisible = false
            ast5[5].isBodyActive = false
            physics.removeBody( ast5[5] )
--liitle asteroids explode from four sides

local function screnCrack()

  local function shake()
       if(shakeCount % shakePeriod == 0 ) then
          display.currentStage.x = display.currentStage.x0 + math.random( -xShake, xShake )
          display.currentStage.y = display.currentStage.y0 + math.random( -yShake, yShake )
       end
       shakeCount = shakeCount + 1
    end
           
    -- Start shake function      
          local function startShake()
       display.currentStage.x0 = display.currentStage.x
       display.currentStage.y0 = display.currentStage.y
       shakeCount = 0
       Runtime:addEventListener( "enterFrame", shake )
    end

    --stop shake function
    local function stopShake()
       Runtime:removeEventListener( "enterFrame", shake )
       stoptimer = timer.performWithDelay( 50, 
       function() 
          display.currentStage.x = display.currentStage.x0 
          display.currentStage.y = display.currentStage.y0
       end )
    end

startShake()
stop3timer = timer.performWithDelay( 100, stopShake )
            system.vibrate()

            scCrak[1].x = centerX
            scCrak[1].y = centerY
            scCrak[1].isVisible = true
            scCrak[1].isBodyActive = true
            scCrak[1].type = "obstacle"
            scCrak[1].alpha = 1

            
            ast15[14].isVisible = false
            ast15[14].isBodyActive = false
            ast15[14]:scale( .3, .3 )

            transition.fadeOut( scCrak[1], {time = 2000} )
            
          end
             op2tran =  transition.moveBy(ast15[10], {time = 2000, x = 2000, y = 0,tag = "transTag",onComplete = targetRemove3})

             op3tran = transition.moveBy(ast15[11], {time = 2000, x = -2000, y = 0,tag = "transTag",onComplete = targetRemove3})
 
             op4tran =  transition.moveBy(ast15[12], {time = 2000, x = 0, y = 2000,tag = "transTag",onComplete = targetRemove3})
 
             op5tran =  transition.moveBy(ast15[13], {time = 2000, x = 0, y = -2000,tag = "transTag",onComplete = targetRemove3})

             op6tran =  transition.to(ast15[14], {time = 1000, x = centerX, y = centerY, xScale = 3, yScale = 3, tag = "transTag",onComplete = screnCrack})
             camera:add(ast15[14], 1)
             system.vibrate()
            

end

-- removes the other main asteroids after the finish transition
 local function targetRemove2(target)
  target.isVisible = false
  target.isBodyActive = false
    
    end
-- transitions the regular asteroids
      transition.to(ast4[6], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2-2400, onComplete = targetRemove2, tag = "transTag"})
      transition.to(ast6[10], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2-2800, onComplete = targetRemove2,tag = "transTag"})
      transition.to(ast11[8], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2-2400, onComplete = targetRemove2,tag = "transTag"})
      transition.to(ast12[3], {time = myData.obstacleSpeed - myData.adjustSpeed, x = W/2-2000, onComplete = targetRemove2,tag = "transTag"})


--Shake before explodes
         local function shakeAst()

           transition.moveBy(ast5[5], { time = 50, x = 10, y = 10, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 50, time = 50, x = -10, y = -10, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 100, time = 50, x = 20, y = -10, tag = "transTag"})           
           transition.moveBy(ast5[5], { delay = 150, time = 50, x = 12, y = -18, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 200, time = 50, x = 0, y = 20, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 250, time = 50, x = -9, y = -9, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 300, time = 50, x = 3, y = 5, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 350, time = 50, x = 7, y = 20, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 400, time = 50, x = 5, y = 12, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 450,time = 50, x = 10, y = 10, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 500, time = 50, x = -10, y = -10, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 550, time = 50, x = 20, y = -10, tag = "transTag"})           
           transition.moveBy(ast5[5], { delay = 600, time = 50, x = 12, y = -18, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 650, time = 50, x = 0, y = 20, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 700, time = 50, x = -9, y = -9, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 750, time = 50, x = 3, y = 5, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 800, time = 50, x = 7, y = 20, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 850, time = 50, x = 5, y = 12, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 900, time = 50, x = 10, y = 10, tag = "transTag"})
           transition.moveBy(ast5[5], { delay = 950, time = 50, x = -10, y = -10, onComplete = exploder, tag = "transTag"})

end

-- randomly picks a x corrdinate where it will explode

local spot = math.random(1, 3)

if spot == 1 then
     transition.to(ast5[5], {time = 3000, x = W/2 +300, onComplete = shakeAst, tag = "transTag"})
end

if spot == 2 then
     transition.to(ast5[5], {time = 3000, x = W/2-300, onComplete = shakeAst, tag = "transTag"})
end

if spot == 3 then
     transition.to(ast5[5], {time = 3000, x = W/2, onComplete = shakeAst, tag = "transTag"})
end

if char.isVisible == true then
          obstTimer = timer.performWithDelay(7000 - myData.adjustTimer, ranGen, 1)
        end
    end



local opMove14 = function()

--removes bouncing asteroid
    local function remover(target)
      target.isVisible = false
      target.isBodyActive = false
      physics.removeBody( target )
      timer.cancel( offtimer )
              offtimer = nil
      transition.cancel( tran1 )
              trans1 = nil
      transition.cancel(tran2)
              trans2 = nil

            if bounceTimer ~= nil then
              timer.cancel( bounceTimer )
              bouneTimer = nil
            end

             if stop3timer ~= nil then
               timer.cancel( stop3timer )
               stop3Timer = nil
            end

            if stoptimer ~= nil then
            
              timer.cancel( stoptimer )
              stoptimer = nil
              Runtime:removeEventListener( "enterFrame", shake )
            end
              
    end

    --calls the physics for the object
    physics.addBody(ast6[9], "kinematic", physicsData:get("ast6") )
 
    --makes the object visible and active
    ast6[9].x = W/2 + 1200
    ast6[9].y = H/2
    ast6[9].isVisible = true
    ast6[9].isBodyActive = true
    ast6[9].type = "obstacle"

    --makes asteroid change physics type and applies force to bounce around
   local function bouncer()
      physics.removeBody(ast6[9])

      local function add()
          physics.addBody(ast6[9], "dynamic", physicsData:get("ast6"))
         ast6[9]:applyForce( 30000, 30000, ast6[9].x, ast6[9].y )
        end
      
      bounceTimer =  timer.performWithDelay(200, add, 1)

      char:applyForce(0, 0, char.x, char.y)
    end

    --shake variables
    local shakeCount = 0
    local xShake = 8
    local yShake = 4
    local shakePeriod = 2

    --cooridinates for shake
    local function shake()
       if(shakeCount % shakePeriod == 0 ) then
          display.currentStage.x = display.currentStage.x0 + math.random( -xShake, xShake )
          display.currentStage.y = display.currentStage.y0 + math.random( -yShake, yShake )
       end
       shakeCount = shakeCount + 1
    end
           
    -- Start shake function      
          local function startShake()
       display.currentStage.x0 = display.currentStage.x
       display.currentStage.y0 = display.currentStage.y
       shakeCount = 0
       Runtime:addEventListener( "enterFrame", shake )
    end

    --stop shake function
    local function stopShake()
       Runtime:removeEventListener( "enterFrame", shake )
       stoptimer = timer.performWithDelay( 50, 
       function() 
          display.currentStage.x = display.currentStage.x0 
          display.currentStage.y = display.currentStage.y0
       end )
    end

    --changes asteroid back to original physics and transitions off screen
    local function Off()
     
      physics.removeBody(ast6[9])
        physics.addBody(ast6[9], "kinematic", physicsData:get("ast6"))
        ast6[9]:applyForce( 0, 0, ast6[9].x, ast6[9].y )

    tran1 =   transition.to(ast6[9], {time = 1500, x = -1000, transition = easing.linear, onComplete = remover, tag = "transTag"})
      --stop2timer = timer.performWithDelay( 1, stopShake,1 )
    end

    --moves the asteroid onto the screen and then starts the bouncer function
    tran2 = transition.to(ast6[9], {time = 1500,x = 1000, onComplete = bouncer, tag = "transTag"})


      offtimer = timer.performWithDelay( 10000, Off, 1)
   

   -- collision function to make screen shake when asteroid hits the wall
   function collision2(self, event)

          if event.other.type == "wall" then
              startShake()
              system.vibrate()

          stop3timer = timer.performWithDelay( 100, stopShake )

          end
        end

    -- calls the collision
    ast6[9].collision = collision2 
    ast6[9]:addEventListener("collision", ast6[9])

 
    if char.isVisible == true then
      obstTimer2 = timer.performWithDelay(11000, ranGen, 1)
    end

  end
    
    
    function ranGen()
        local obstacle = math.random(15, 15)
        print(obstacle)
      
        if obstacle == 1 and char.isVisible == true and ast6[1].isVisible == false and ast8[1].isVisible == false and ast10[1].isVisible == false 
          and ast11[1].isVisible == false then
            opMove1()
            --myData.spawnGen = 3500
            
        elseif obstacle == 2 and char.isVisible == true and ast6[2].isVisible == false and ast8[2].isVisible == false and ast10[2].isVisible == false 
          and ast11[2].isVisible == false and ast7[1].isVisible == false then 
            opMove2()
            --myData.spawnGen = 4000
          
        elseif obstacle == 3 and char.isVisible == true and ast6[3].isVisible == false and ast4[1].isVisible == false and ast9[1].isVisible == false 
          and ast11[3].isVisible == false then 
            opMove3()
            --myData.spawnGen = 3000
        
        elseif obstacle == 4 and char.isVisible == true and ast6[4].isVisible == false and ast4[2].isVisible == false 
          and ast14[1].isVisible == false then 
            opMove4()
            --myData.spawnGen = 3000
            
        elseif obstacle == 5 and char.isVisible == true and ast6[5].isVisible == false and ast4[3].isVisible == false 
          and ast14[2].isVisible == false then
            opMove5()
            --myData.spawnGen = 3000
            
        elseif obstacle == 6 and char.isVisible == true and ast8[3].isVisible == false and ast10[3].isVisible == false and ast11[4].isVisible == false 
          and ast7[2].isVisible == false and ast3[1].isVisible == false then 
            opMove6()
            --myData.spawnGen = 3000
        
        elseif obstacle == 7 and char.isVisible == true and ast14[3].isVisible == false and ast14Rev[1].isVisible == false then 
          opMove7()
          --myData.spawnGen = 3000
          
        elseif obstacle == 8 and char.isVisible == true and ast8[4].isVisible == false and ast8[5].isVisible == false and ast6[6].isVisible == false 
          and ast6[7].isVisible == false and ast5[1].isVisible == false and ast5[2].isVisible == false then 
          opMove8()
          --myData.spawnGen = 3000
          
        elseif obstacle == 9 and char.isVisible == true and ast10[4].isVisible == false and ast11[5].isVisible == false and ast3[2].isVisible == false 
          and ast9[2].isVisible == false and ast8[6].isVisible == false then 
          opMove9()
          --myData.spawnGen = 3000
          
        elseif obstacle == 10 and char.isVisible == true and ast11[6].isVisible == false and ast9[3].isVisible == false and ast4[4].isVisible == false 
          and ast12[1].isVisible == false and ast7[3].isVisible == false then 
          opMove10()
          --myData.spawnGen = 3000
        
        elseif obstacle == 11 and char.isVisible == true and ast11[7].isVisible == false and ast8[7].isVisible == false and ast12[2].isVisible == false 
          and ast6[8].isVisible == false and ast4[5].isVisible == false and ast5[3].isVisible == false then 
          opMove11()
          
        elseif obstacle == 12 and char.isVisible == true and ast12[3].isVisible == false and ast8[8].isVisible == false and ast11[8].isVisible == false 
          and ast9[4].isVisible == false and ast4[6].isVisible == false and ast5[4].isVisible == false then 
          opMove12()

        elseif obstacle == 13 and char.isVisible == true and ast15[1].isVisible == false and ast15[2].isVisible == false and ast15[3].isVisible == false 
          and ast15[4].isVisible == false and ast15[5].isVisible == false and ast15[6].isVisible == false and ast15[7].isVisible == false and ast15[8].isVisible == false then 
          opMove13()

        elseif obstacle == 15 and char.isVisible == true and ast15[9].isVisible == false and ast15[10].isVisible == false and ast15[11].isVisible == false and ast15[12].isVisible == false and ast15[13].isVisible == false   then
          opMove15()

        elseif obstacle == 14 and char.isVisible == true and ast6[9].isVisible == false then
          opMove14()

        elseif char.isVisible == false then
          return char
        else
          ranGen()
          
          -- A 500 milisecond delay to take into account a possible second run through if no booleans match up
          --myData.spawnGen = 3500
        end
    end
    
    --ranGen()
    ranTimer = timer.performWithDelay(1000, ranGen)
    gemTimer = timer.performWithDelay(math.random(1000,4000), genGems, 99999)
-- ----------------------------------------------------------------------------------------------------

     -- Spirdy collision function can add more to function if needed
     function collision(self, event)
      if event.phase == "began" then
  
             --Collision with asteroids
                if self.type == "player"  and event.other.type == "obstacle" then

            local function trans()

            charDies:stop()
  
            if gem ~= nil then
              gem:removeSelf()
              gem = nil
            end
            
            resetScore()
            transition.cancel()
            timer.cancel(ranTimer)
            timer.cancel(gemTimer)

              if offtimer ~= nil then
                  timer.cancel( offtimer )
                  offtimer = nil
              end

              if switchTimer ~= nil then
                  timer.cancel( switchTimer )
                  switchTimer = nil
              end

              if bounceTimer ~= nil then
                  timer.cancel( bounceTimer )
                  stop3timer = nil
              end

              if stop3timer ~= nil then
                  timer.cancel( stop3timer )
                  stop3timer = nil
              end

              if stop4timer ~= nil then
                  timer.cancel( stop4timer )
                  stop4timer = nil
              end

              if stop5timer ~= nil then
                  timer.cancel( stop5timer )
                  stop5timer = nil
              end

              if stop6timer ~= nil then
                  timer.cancel( stop6timer )
                  stop6timer = nil
              end

              if stoptimer ~= nil then
                  timer.cancel( stoptimer )
                  stoptimer = nil
              end
              
              if removeexploder ~= nil then
                  timer.cancel( removeexploder )
                  removeexploder = nil
              end
                        
            composer.showOverlay("gameOver")
        
          end
          
          if char:currentAnimation() == "back" or char:currentAnimation() == "up" or char:currentAnimation() == "down" or
          char:currentAnimation() == "forward" or char:currentAnimation() == "idle" then
            system.vibrate()
            -- Stop all listeners
            objectCount = nil
         
            Runtime:removeEventListener( "enterFrame", main )
            Runtime:removeEventListener("touch", moveAnalog)
            char:removeEventListener("collision", char)
             
            transition.cancel("transTag")
            transition.cancel("obst8Rotation")
            transition.cancel("obst8")

            if obstTimer ~= nil then
               timer.cancel(obstTimer)
               obstTimer = nil
            end

              if offtimer ~= nil then
                  timer.cancel( offtimer )
                  offtimer = nil
              end

              if switchTimer ~= nil then
                  timer.cancel( switchTimer )
                  switchTimer = nil
              end

              if bounceTimer ~= nil then
                  timer.cancel( bounceTimer )
                  stop3timer = nil
              end

              if stop3timer ~= nil then
                  timer.cancel( stop3timer )
                  stop3timer = nil
              end

              if stop4timer ~= nil then
                  timer.cancel( stop4timer )
                  stop4timer = nil
              end

              if stop5timer ~= nil then
                  timer.cancel( stop5timer )
                  stop5timer = nil
              end

              if stop6timer ~= nil then
                  timer.cancel( stop6timer )
                  stop6timer = nil
              end

              if stoptimer ~= nil then
                  timer.cancel( stoptimer )
                  stoptimer = nil
              end
              
              if removeexploder ~= nil then
                  timer.cancel( removeexploder )
                  removeexploder = nil
              end
        
            timer.pause(ranTimer)
          
            timer.pause(gemTimer)
           
            if obstTimer2 ~= nil then
              ast6[9]:removeEventListener("collision", ast6[9])
              timer.cancel(obstTimer2)
            end
             

            if gem ~= nil then
              gem:pause()
            end

            
            
            -- Sets the previous score and sets the high score
            setPrevScore()
            highScore()
            
            -- Looks for the x and y coordinates where the death event occurs and plays the death animation
            print( event.x,event.y )
            charDies.x = event.x
            charDies.y = event.y
            
            sound.lv1Remove()
            
            -- Pay the death aniamtion
            charDies:newAnim("dead", 
              mcx.sequence({name = "playerSel/characters/spirdy/gameOverAnim/dies",
              extension = "png",
              endFrame = 24,
              zeros = 2}),
            450, 422,
            {speed = 1, loops = 1})
            
            sceneGroup:insert(charDies)
            camera:add(charDies, 1)
            
            physics.removeBody(char)
            char:stop()
            
            char.isVisible = false
            char.isBodyActive = false
            
            sound.spirdyDies()
            charDies:play({name = "dead"})
            transition.to(charDies, {delay = 1000, onComplete = trans})
           end
           
        -- Collision with gems 
        elseif self.type == "player" and event.other.type == "gems" then 
          sound.gemSound()
          myData.lv1Score = myData.lv1Score + 1
          scoreText.text = myData.lv1Score
          myData.totalGems = myData.lv1Score + 1
          
          -- The animation that occurs when the player collects gems
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
      char.type = "player"
      
      char.isVisible = true
      char.isBodyActive = true
      
      char.collision = collision 
      char:addEventListener("collision", char)
      physics.addBody(char, "dynamic", physicsIdle:get("idle00") )
    
      char:play({name = "idle"})
      
      char.isFixedRotation = true
      --charDies.isFixedRotation = true
    
    -- Moves Spirdy around the level
    function main( event )
        -- moves both the sprite sheet (bird1) and the physics image (spirdy)
        MyStick:move(char, 14.0, false)
        --MyStick:move(charDies, 12.0, false)
        
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
    
    -- Counters inserted into seperate group to make them move with the player
    local function counters()
     local group = display.newGroup()

        group:insert(gemCounter)
        gemCounter.isVisible = true
        gemCounter.isBodyActive = true
        
        group:insert(coinCounter)
        coinCounter.isVisible = true
        coinCounter.isBodyActive = true
        
        group:insert(coinFont)
        coinFont.isVisible = true
        coinFont.isBodyActive = true
        
        group:insert(scoreText)
        scoreText.isVisible = true
        scoreText.isBodyActive = true
        
        group:insert(pause)
        pause.alpha = 0.7
        pause.isVisible = true
        pause.isBodyActive = true
        
        group:insert(debugBtn)
        --group:insert(MyStick)
        
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
    --Runtime:removeEventListener("enterFrame", move)
    --Runtime:removeEventListener("enterFrame", move2)
    --Runtime:removeEventListener("enterFrame", move3)
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