system.getInfo("model")

display.setStatusBar(display.HiddenStatusBar)


local centerY = display.contentCenterY
local centerX = display.contentCenterX

local composer = require( "composer" )

local scene = composer.newScene()
local widget = require("widget")
local myData = require("myData")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local backCount = 0
-- -------------------------------------------------------------------------------

local function handleSpirdyEvent( event )
  if ( "ended" == event.phase ) then
    myData.myCharacter = "Spirdy"
  end
end
        
local function handleMymeEvent( event )
  if ( "ended" == event.phase ) then
    myData.myCharacter = "Myme"
  end
end
-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    -- Create the widget
        local button1 = widget.newButton
        {
            label = "button",
            onEvent = handleSpirdyEvent,
            emboss = false,
            --properties for a rounded rectangle button...
            shape="roundedRect",
            width = 200,
            height = 40,
            cornerRadius = 2,
            fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
            strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
            strokeWidth = 4
        }
        sceneGroup:insert(button1)
        
        -- Center the button
        button1.x = display.contentCenterY - 50
        button1.y = display.contentCenterY
        
        -- Change the button's label text
        button1:setLabel( "Spirdy" )
        
        local button2 = widget.newButton
        {
            label = "button2",
            onEvent = handleMymeEvent,
            emboss = false,
            --properties for a rounded rectangle button...
            shape="roundedRect",
            width = 200,
            height = 40,
            cornerRadius = 2,
            fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
            strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
            strokeWidth = 4
        }
        sceneGroup:insert(button2)
        
        -- Center the button
        button2.x = display.contentCenterY + 200
        button2.y = display.contentCenterY
        
        -- Change the button's label text
        button2:setLabel( "Myme" )
    
    local backBut = display.newImageRect(sceneGroup, "modeSelect/mode_back.png", 60, 60)
    local butSel = display.newImageRect(sceneGroup, "buttonSel.png", 60, 60)
    
    backBut.x = -30
    backBut.y = 25
    backBut.alpha = 0
  
    butSel.x = 30
    butSel.y = 25
    butSel.alpha = 0
    
    transition.to(backBut, {delay = 1000, time = 1250, alpha = 1, x = 30})
    transition.to(butSel, {delay = 3000, alpha = 1})
    
    function butSel:touch(event)
      local phase = event.phase
        if event.phase == "began" then
          
          backCount = backCount + 1
          
          local function go()
            composer.hideOverlay()
          end  
          
          butSel:removeSelf()
          butSel = nil
          button1:removeSelf()
          button1 = nil
          button2:removeSelf()
          button2 = nil
          transition.to(backBut, {time = 700, alpha = 0, x = -30, onComplete = go})
          
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