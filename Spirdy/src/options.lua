system.getInfo("model")

display.setStatusBar(display.HiddenStatusBar)


local centerY = display.contentCenterY
local centerX = display.contentCenterX

local composer = require( "composer" )
local widget = require("widget")
local music = require("sounds")
local backCount = 0

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local tran = display.newImageRect(sceneGroup, "options/transition.png", 800, 400)
      tran.x = centerX
      tran.y = centerY
      tran.alpha = 0.3
        
    local back = display.newImageRect(sceneGroup, "options/backBtn.png", 60, 60)
      back.x = -30
      back.y = 25
      back.alpha = 0
        
    local butSel = display.newImageRect(sceneGroup, "buttonSel.png", 60, 60)
      butSel.x = 30
      butSel.y = 25
      butSel.alpha = 0
        
    transition.to(back, {delay = 1000, time = 1250, alpha = 1, x = 30})
    transition.to(butSel, {delay = 3000, alpha = 1})
        
        music.options(sceneGroup)
        
     function butSel:touch(event)
      local phase = event.phase
        if event.phase == "began" then
        
          backCount = backCount + 1
        
          local function go()
            composer.hideOverlay()
          end

          butSel:removeSelf()
          butSel = nil
          music.removeSliders()
          transition.to(back, {time = 700, alpha = 0, x = -30, onComplete = go})

        return true
      end
    end
    
    butSel:addEventListener("touch", butSel)
        
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
        if backCount >= 1 then
          parent:mainMenu()
        end
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