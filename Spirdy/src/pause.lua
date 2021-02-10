local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local physics = require("physics")
local music = require("sounds")
local perspective = require("perspective")

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
local tran, resumeBtn
local scrollSpeed, scrollSpeed2, camera
local group = {}


---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------
local function resume(event)
  local go = event.target.id
  if go == "resume" then
    composer.hideOverlay("fade", 400)
    tran:removeSelf()
    tran = nil
    resumeBtn:removeSelf()
    resumeBtn = nil
   end
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   
   camera = perspective.createView()
   
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   --setUpDisplay(sceneGroup)
    tran = display.newImageRect(sceneGroup, "transition.png", 1425, 900)
    tran.x = centerX
    tran.y = centerY
    tran.alpha = 0.3
    --camera:add(tran, 2)
    
    resumeBtn = widget.newButton({sceneGroup, label = "Resume", id="resume", onRelease = resume})
    resumeBtn.x = centerX
    resumeBtn.y = centerY
    --camera:add(resumeBtn, 1)
    
    camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3)
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
   local parent = event.parent
   
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
        parent:resumeGame()
        camera:destroy()
      
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      
   end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

---------------------------------------------------------------------------------

return scene