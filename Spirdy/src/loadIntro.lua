system.getInfo("model")

display.setStatusBar(display.HiddenStatusBar)

local centerY = display.contentCenterY
local centerX = display.contentCenterX
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight
local screenTopSB = screenTop + display.topStatusBarContentHeight
local screenHeightSB = display.viewableContentHeight - screenTopSB
local screenBottomSB = screenTopSB + screenHeightSB

local logo, tran, corona, tran2
local bg, bg2, bg3, bg4, emitter, emitter2, emitter3, emitter4

--local backGround = require("bgScene")
local particleDesigner = require( "particleDesigner")
local widget = require("widget")
local composer = require( "composer" )
local music = require("sounds")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local function loadMenu()
  composer.showOverlay("mainMenu", {isModal = true})
end

function scene:mainMenu()
  composer.showOverlay("mainMenuBack", {isModal = true})
end

function scene:modeSel()
  composer.showOverlay("modeSel", {isModal = true})
end

function scene:levelSelNorm()
  composer.showOverlay("levelSelNorm", {isModal = true})
end

function scene:levelSelChal()
  composer.showOverlay("levelSelChal", {isModal = true})
end

function scene:playerSel()
  composer.showOverlay("playerSel", {isModal = true})
end

function scene:emitterStop()
  emitter:stop()
  emitter2:stop()
  emitter3:stop()
  emitter4:stop()
  
  particleDesigner.remove()
end
-- -------------------------------------------------------------------------------
-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local function mainBG()
    
      bg = display.newImageRect(sceneGroup, "nebula.png", 820, 820)
      bg.x = centerX
      bg.y = centerY
      bg.alpha = 0
         
      bg2 = display.newImageRect(sceneGroup, "bgstars2.png", 820, 820)
      bg2.x = centerX
      bg2.y = centerY
      bg2.alpha = 0
         
      bg3 = display.newImageRect(sceneGroup, "bgstars1.png", 700, 700)
      bg3.x = centerX
      bg3.y = centerY
      bg3.alpha = 0
         
      bg4 = display.newImageRect(sceneGroup, "planets.png", 820, 820)
      bg4.x = centerX
      bg4.y = centerY
      bg4.alpha = 0
         
         --particles.mainMenu()
      emitter = particleDesigner.newEmitter( "pCloud2.json")
      emitter2 = particleDesigner.newEmitter( "pCloud.json")
      emitter3 = particleDesigner.newEmitter( "stars2.json")
      emitter4 = particleDesigner.newEmitter( "stars1.json")
         
      emitter.x = centerX
      emitter.y = centerY
         
      emitter2.x = centerX
      emitter2.y = centerY
         
      emitter3.x = centerX
      emitter3.y = centerY
         
      emitter4.x = centerX
      emitter4.y = centerY
      
      sceneGroup:insert(emitter)
      sceneGroup:insert(emitter2)
      sceneGroup:insert(emitter3)
      sceneGroup:insert(emitter4)
      
      logo:removeSelf()
      logo = nil
      tran:removeSelf()
      tran = nil
      corona:removeSelf()
      corona = nil
      tran2:removeSelf()
      tran2 = nil
         
      transition.to(bg, {time = 3000, alpha = 1})
      transition.to(bg2, {time = 3000, alpha = 1})
      transition.to(bg3, {time = 3000, alpha = 1})
      transition.to(bg4, {time = 3000, alpha = 1, onComplete = loadMenu})
           local function rotateImg()
            
             transition.to(bg, {rotation = bg.rotation -360, time = 40000, onComplete = rotateImg, tag = "bgTag" })
             
           end
           
           local function rotateImg2()
           
            transition.to(bg2, {rotation = bg2.rotation -360, time = 27000, onComplete = rotateImg2, tag = "bgTag" })
           
           end
           
           local function rotateImg3()
           
            transition.to(bg3, {rotation = bg3.rotation -360, time = 24000, onComplete = rotateImg3, tag = "bgTag" })
           
           end
           
           local function rotateImg4()
           
            transition.to(bg4, {rotation = bg4.rotation -360, time = 22000, onComplete = rotateImg4, tag = "bgTag" })
           
           end
          
          transition.to(bg, {time = 40000, rotation = -360, onComplete = rotateImg, tag = "bgTag"})
          transition.to(bg2, {time = 27000, rotation = -360, onComplete = rotateImg2, tag = "bgTag"})
          transition.to(bg3, {time = 24000, rotation = -360, onComplete = rotateImg3, tag = "bgTag"})
          transition.to(bg4, {time = 22000, rotation = -360, onComplete = rotateImg4, tag = "bgTag"})
          
          music.mmSound()
      end
     
     logo = display.newImageRect(sceneGroup, "orphin_logov2.png", 400, 200)
     logo.x = centerX
     logo.y = centerY
     logo.alpha = 0
     
     tran = display.newImage(sceneGroup, "transition.png")
     tran.x = centerX
     tran.y = centerY
     tran.alpha = 0
     
     corona = display.newImageRect(sceneGroup, "corona.png", 600, 400)
     corona.x = centerX
     corona.y = centerY
     corona.alpha = 0
     
     tran2 = display.newImage(sceneGroup, "transition.png")
     tran2.x = centerX
     tran2.y = centerY
     tran2.alpha = 0
     
     transition.to(logo, {time = 3000, alpha = 1})
     transition.to(tran, {delay = 3000, time = 1000, alpha = 1})
     transition.to(corona, {delay = 4000, time = 3000, alpha = 1})
     transition.to(tran2, {delay = 7000, time = 2000, alpha = 1, onComplete = mainBG})
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
         
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
        particleDesigner.remove()
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