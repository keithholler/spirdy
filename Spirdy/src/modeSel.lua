local composer = require( "composer" )

local scene = composer.newScene()
--local muteButton = require("muteButton")
local widget = require("widget")
local musicOn = require("sounds")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
  local normCount = 0
  local chalCount = 0
  local backCount = 0


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local modeHeader = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudtop.png", 713, 88)
    local modeLock = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudconnector.png", 713, 404)
    local modeFooter1 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudleft.png", 357, 176)
    local modeFooter2 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudright.png", 357, 176)
    local text = display.newImageRect(sceneGroup, "modeSelect/mode_text.png", 330, 50)
    local normMode = display.newImageRect(sceneGroup, "modeSelect/mode_normal.png", 270, 140)
    local chalMode = display.newImageRect(sceneGroup, "modeSelect/mode_challenge.png", 270, 140)
    local backBut = display.newImageRect(sceneGroup, "modeSelect/mode_back.png", 60, 60)
    local butSel = display.newImageRect(sceneGroup, "buttonSel.png", 60, 60)
    local normal = display.newImageRect(sceneGroup, "buttonSel.png", 190, 90)
    local challenge = display.newImageRect(sceneGroup, "buttonSel.png", 190, 90)
    local modeMuteOff = display.newImageRect(sceneGroup, "mainMenu/speakerButton.png", 50, 50)
    local modeMuteOn = display.newImageRect(sceneGroup, "mainMenu/speakerMute.png", 50, 50)
    
    modeFooter1.x = -100
    modeFooter1.y = 313
    modeFooter1.alpha = 0
    
    modeFooter2.x = 813
    modeFooter2.y = 313
    modeFooter2.alpha = 0   
   
    text.x = 355
    text.y = 150
    text.alpha = 0
    
    normMode.x = 140
    normMode.y = 320
    normMode.alpha = 0
    
    chalMode.x = 570
    chalMode.y = 320
    chalMode.alpha = 0
    
    normal.x = 120
    normal.y = 330
    normal.alpha = 0
    
    challenge.x = 590
    challenge.y = 330
    challenge.alpha = 0
    
    modeMuteOff.x = 750
    modeMuteOff.y = 26
    modeMuteOff.alpha = 0
              
    modeMuteOn.x = 680
    modeMuteOn.y = 26
    modeMuteOn.alpha = 0
    
    modeLock.x = 355
    modeLock.y = 200
    modeLock.alpha = 0
    
    modeHeader.x = 355
    modeHeader.y = -15
    modeHeader.alpha = 0
    
    backBut.x = -30
    backBut.y = 25
    backBut.alpha = 0
    
    butSel.x = 30
    butSel.y = 25
    butSel.alpha = 0
    
    transition.to(modeHeader, {delay = 1000, time = 1250, alpha = 1, y = 43})
    transition.to(normMode, {delay = 2250, time = 1500, alpha = 1})
    transition.to(chalMode, {delay = 2250, time = 1500, alpha = 1})
    transition.to(modeFooter1, {delay = 1000, time = 1250, alpha = 1, x = 177})
    transition.to(modeFooter2, {delay = 1000, time = 1250, alpha = 1, x = 533})
    transition.to(modeLock, {delay = 2000, time = 1250, alpha = 1})
    transition.to(text, {delay = 2000, time = 2000, alpha = 1})
    transition.to(normal, {delay = 4000, alpha = 1})
    transition.to(challenge, {delay = 4000, alpha = 1})
    transition.to(backBut, {delay = 1000, time = 1250, alpha = 1, x = 30})
    transition.to(butSel, {delay = 3000, alpha = 1})
    transition.to(modeMuteOff, {delay = 1000, time = 1250, alpha = 1, x = 680})
    
    function butSel:touch(event)
      local phase = event.phase
        if event.phase == "began" then
        
          backCount = backCount + 1
        
          local function go()
            composer.hideOverlay()
          end

          butSel:removeSelf()
          butSel = nil
          normal:removeSelf()
          normal = nil
          challenge:removeSelf()
          challenge = nil
          transition.to(modeHeader, {time = 600, y = -40, alpha = 0})
          transition.to(modeLock, {time = 600, alpha = 0})
          transition.to(normal, {alpha = 0})
          transition.to(challenge, {alpha = 0})
          transition.to(normMode, {time = 620, alpha = 0, x = -100})
          transition.to(chalMode, {time = 620, alpha = 0, x = 813})
          transition.to(backBut, {time = 700, alpha = 0, x = -30})
          transition.to(text, {time = 500, alpha = 0})
          transition.to(modeMuteOff, {time = 640, x = 750, alpha = 0})
          transition.to(modeMuteOn, {time = 640, x = 750, alpha = 0})
          transition.to(modeFooter1, {time = 1000, alpha = 0, x = -200})
          transition.to(modeFooter2, {time = 1000, alpha = 0, x = 913, onComplete = go})

        return true
      end
    end
    
    butSel:addEventListener("touch", butSel) 
   
  -- Normal mode selection touch event
    function normal:touch(event)
      local phase = event.phase
        if event.phase == "began" then
          
          normCount = normCount + 1
          
          local function go()
            composer.hideOverlay()
          end

          normal:removeSelf()
          normal = nil 
          challenge:removeSelf()
          challenge = nil
          butSel:removeSelf()
          butSel = nil
          transition.to(modeHeader, {time = 600, y = -40, alpha = 0})
          transition.to(modeLock, {time = 600, alpha = 0})
          transition.to(normMode, {time = 612, alpha = 0, x = -100})
          transition.to(chalMode, {time = 612, alpha = 0, x = 813})
          transition.to(text, {time = 500, alpha = 0})
          transition.to(modeMuteOff, {time = 640, x = 750, alpha = 0})
          transition.to(modeMuteOn, {time = 640, x = 750, alpha = 0})
          transition.to(backBut, {time = 700, alpha = 0, x = -30})
          transition.to(modeFooter1, {time = 1000, alpha = 0, x = -200})
          transition.to(modeFooter2, {time = 1000, alpha = 0, x = 913, onComplete = go})

        return true
      end
    end
    
    normal:addEventListener("touch", normal)
    
    function challenge:touch(event)
      local phase = event.phase
        if event.phase == "began" then
          
          chalCount = chalCount + 1
          
          local function go()
            composer.hideOverlay()
          end

          normal:removeSelf()
          normal = nil 
          challenge:removeSelf()
          challenge = nil
          butSel:removeSelf()
          butSel = nil
          transition.to(modeHeader, {time = 600, y = -40, alpha = 0})
          transition.to(modeLock, {time = 600, alpha = 0})
          transition.to(normMode, {time = 600, alpha = 0, x = -100})
          transition.to(chalMode, {time = 600, alpha = 0, x = 813})
          transition.to(text, {time = 500, alpha = 0})
          transition.to(modeMuteOff, {time = 640, x = 750, alpha = 0})
          transition.to(modeMuteOn, {time = 640, x = 750, alpha = 0})
          transition.to(backBut, {time = 700, alpha = 0, x = -30})
          transition.to(modeFooter1, {time = 1000, alpha = 0, x = -200})
          transition.to(modeFooter2, {time = 1000, alpha = 0, x = 913, onComplete = go})
      
        return true
      end
    end
    
    challenge:addEventListener("touch", challenge)
    
    function modeMuteOff:touch(event)
    local phase = event.phase
      if event.phase == "began" then
      
        modeMuteOff.alpha = 0
        
        modeMuteOn.alpha = 1
        
        musicOn.soundOff()
        
        return true
        
    end
  end
      
  modeMuteOff:addEventListener("touch", modeMuteOff)
  
  function modeMuteOn:touch(event)
    local phase = event.phase
      if event.phase == "began" then
      
        modeMuteOff.alpha = 1
        
        modeMuteOn.alpha = 0

        musicOn.soundOn()
        
        return true
        
    end
  end
      
  modeMuteOn:addEventListener("touch", modeMuteOn)
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
  
        --composer.removeScene("mainMenu")
        --composer.removeScene("mainMenuBack")
 
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
       
     -- Back button
     
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
        
        if normCount >= 1 then
          parent:levelSelNorm()
        end
        
        if chalCount >= 1 then
          parent:levelSelChal()
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