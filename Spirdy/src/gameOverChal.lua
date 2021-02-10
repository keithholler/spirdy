local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local music = require("bgMusic")

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
local tran, retryBtn, tran2, retryBtn2, levelBtn, levelBtn2, quitBtn, quitBtn2

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

local function quit(event)
  local go = event.target.id
  if go == "quit" then
    --composer.hideOverlay("fade", 400)
    composer.gotoScene("mainMenuBack")
    music.mmSound()
    tran2:removeSelf()
    tran2 = nil
    retryBtn2:removeSelf()
    retryBtn2 = nil
    levelBtn2:removeSelf()
    levelBtn2 = nil
    quitBtn2:removeSelf()
    quitBtn2 = nil

   end
end

local function level(event)
  local go = event.target.id
  if go == "levelSel" then
    --composer.hideOverlay("fade", 400)
    composer.gotoScene("levelSelChal")
    music.mmSound()
    tran2:removeSelf()
    tran2 = nil
    retryBtn2:removeSelf()
    retryBtn2 = nil
    levelBtn2:removeSelf()
    levelBtn2 = nil
    quitBtn2:removeSelf()
    quitBtn2 = nil

   end
end

local function retry(event)
  local go = event.target.id
  if go == "retry" then
    --composer.hideOverlay("fade", 400)
    composer.gotoScene("playGameChal")
    tran2:removeSelf()
    tran2 = nil
    retryBtn2:removeSelf()
    retryBtn2 = nil
    levelBtn2:removeSelf()
    levelBtn2 = nil
    quitBtn2:removeSelf()
    quitBtn2 = nil

   end
end

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   local group = display.newGroup()
   group:insert(sceneGroup)
   
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
    composer.removeScene("playGameChal")
    tran2 = display.newImage("transition.png")
    tran2.x = centerX
    tran2.y = centerY
    tran2.alpha = 0.3
    sceneGroup:insert(tran2)
    --tran2.alpha = 0.4
    
    retryBtn2 = widget.newButton({label = "Retry", id = "retry", onRelease = retry})
    retryBtn2.x = centerX - 100
    retryBtn2.y = centerY
    sceneGroup:insert(retryBtn2)
    
    levelBtn2 = widget.newButton({label = "Level Select", id = "levelSel", onRelease = level})
    levelBtn2.x = centerX
    levelBtn2.y = centerY
    sceneGroup:insert(levelBtn2)
    
    quitBtn2 = widget.newButton({label = "Quit", id = "quit", onRelease = quit})
    quitBtn2.x = centerX + 100
    quitBtn2.y = centerY
    sceneGroup:insert(quitBtn2)
      
    
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      
  --[[function retryBtn2:touch(event)
     local phase = event.phase
      if event.phase == "began" then
        --composer.removeScene("playGame")
        composer.gotoScene("playGame")
        tran2:removeSelf()
        tran2 = nil
        retryBtn2:removeSelf()
        retryBtn2 = nil
        levelBtn2:removeSelf()
        levelBtn2 = nil
        quitBtn2:removeSelf()
        quitBtn2 = nil

                   
        return true
      end
     end
                
  retryBtn2:addEventListener("touch", retryBtn2)
  
    function quitBtn2:touch(event)
     local phase = event.phase
      if event.phase == "began" then
        
        composer.gotoScene("mainMenuBack") 
        tran2:removeSelf()
        tran2 = nil
        retryBtn2:removeSelf()
        retryBtn2 = nil
        levelBtn2:removeSelf()
        levelBtn2 = nil
        quitBtn2:removeSelf()
        quitBtn2 = nil
                   
        return true
      end
     end
                
  quitBtn2:addEventListener("touch", quitBtn2)
  
    function levelBtn2:touch(event)
     local phase = event.phase
      if event.phase == "began" then
        --composer.removeScene("playGame")
        composer.loadScene("levelSelNorm") 
        tran2:removeSelf()
        tran2 = nil
        retryBtn2:removeSelf()
        retryBtn2 = nil
        levelBtn2:removeSelf()
        levelBtn2 = nil
        quitBtn2:removeSelf()
        quitBtn2 = nil
                   
        return true
      end
     end
                
  levelBtn2:addEventListener("touch", levelBtn2)]]--

  
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene