local composer = require( "composer" )

local scene = composer.newScene()
--local muteButton = require("muteButton")
local widget = require("widget")
local musicOn = require("bgMusic")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
  local sHead
  local uiLok
  local muteB, muteOn
  local sFooter1
  local sFooter2
  local text
  local normMode
  local chalMode
  local backBut
  local butSel
  local normal
  local challenge

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    sHead = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudtop.png", 713, 88)
    uiLok = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudconnector.png", 713, 404)
    sFooter1 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudleft.png", 357, 176)
    sFooter2 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudright.png", 357, 176)
    text = display.newImageRect(sceneGroup, "modeSelect/mode_text.png", 330, 50)
    normMode = display.newImageRect(sceneGroup, "modeSelect/mode_normal.png", 270, 140)
    chalMode = display.newImageRect(sceneGroup, "modeSelect/mode_challenge.png", 270, 140)
    backBut = display.newImageRect(sceneGroup, "modeSelect/mode_back.png", 60, 60)
    butSel = display.newImageRect(sceneGroup, "buttonSel.png", 60, 60)
    normal = display.newImageRect(sceneGroup, "buttonSel.png", 190, 90)
    challenge = display.newImageRect(sceneGroup, "buttonSel.png", 190, 90)
    muteB = display.newImageRect(sceneGroup, "mainMenu/speakerButton.png", 50, 50)
    muteOn = display.newImageRect(sceneGroup, "mainMenu/speakerMute.png", 50, 50)
    
    --muteButton.muteBtn()
    
    sFooter1.x = -100
    sFooter1.y = 313
    sFooter1.alpha = 0
    
    sFooter2.x = 813
    sFooter2.y = 313
    sFooter2.alpha = 0   
   
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
    
    muteB.x = 750
    muteB.y = 26
    muteB.alpha = 0
              
    muteOn.x = 680
    muteOn.y = 26
    muteOn.alpha = 0
    
    uiLok.x = 355
    uiLok.y = 200
    uiLok.alpha = 0
    
    sHead.x = 355
    sHead.y = -15
    sHead.alpha = 0
    
    backBut.x = -30
    backBut.y = 25
    backBut.alpha = 0
    
    butSel.x = 30
    butSel.y = 25
    butSel.alpha = 0
    
    
    transition.to(sHead, {delay = 1000, time = 1250, alpha = 1, y = 43})
    transition.to(normMode, {delay = 2250, time = 1500, alpha = 1})
    transition.to(chalMode, {delay = 2250, time = 1500, alpha = 1})
    transition.to(sFooter1, {delay = 1000, time = 1250, alpha = 1, x = 177})
    transition.to(sFooter2, {delay = 1000, time = 1250, alpha = 1, x = 533})
    transition.to(uiLok, {delay = 2000, time = 1250, alpha = 1})
    transition.to(text, {delay = 2000, time = 2000, alpha = 1})
    transition.to(normal, {delay = 4000, alpha = 1})
    transition.to(challenge, {delay = 4000, alpha = 1})
    transition.to(backBut, {delay = 1000, time = 1250, alpha = 1, x = 30})
    transition.to(butSel, {delay = 3000, alpha = 1})
    transition.to(muteB, {delay = 1000, time = 1250, alpha = 1, x = 680})
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    
    composer.removeScene("levelSelNorm")
    composer.removeScene("levelSelChal")

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
     -- Back button
     function butSel:touch(event)
      local phase = event.phase
        if event.phase == "began" then
        
        --local backButton = require("mainMenu")
          local function go()
            --muteButton.remove()
            composer.gotoScene("mainMenu")
          end

          butSel:removeSelf()
          butSel = nil
          transition.to(sHead, {time = 600, y = -40, alpha = 0})
          transition.to(uiLok, {time = 600, alpha = 0})
          transition.to(normal, {alpha = 0})
          transition.to(challenge, {alpha = 0})
          transition.to(normMode, {time = 620, alpha = 0, x = -100})
          transition.to(chalMode, {time = 620, alpha = 0, x = 813})
          transition.to(backBut, {time = 700, alpha = 0, x = -30})
          transition.to(text, {time = 500, alpha = 0})
          transition.to(muteB, {time = 640, x = 750, alpha = 0})
          transition.to(muteOn, {time = 640, x = 750, alpha = 0})
          transition.to(sFooter1, {time = 1000, alpha = 0, x = -200})
          transition.to(sFooter2, {time = 1000, alpha = 0, x = 913, onComplete = go})

        return true
      end
    end
    
    butSel:addEventListener("touch", butSel) 
   
  -- Normal mode selection touch event
    function normal:touch(event)
      local phase = event.phase
        if event.phase == "began" then
          
          local function go()

            --muteButton.remove()
            composer.gotoScene("levelSelNorm")
          end

          normal:removeSelf()
          normal = nil 
          challenge:removeSelf()
          challenge = nil
          butSel:removeSelf()
          butSel = nil
          transition.to(sHead, {time = 600, y = -40, alpha = 0})
          transition.to(uiLok, {time = 600, alpha = 0})
          transition.to(normMode, {time = 612, alpha = 0, x = -100})
          transition.to(chalMode, {time = 612, alpha = 0, x = 813})
          transition.to(text, {time = 500, alpha = 0})
          transition.to(muteB, {time = 640, x = 750, alpha = 0})
          transition.to(muteOn, {time = 640, x = 750, alpha = 0})
          transition.to(backBut, {time = 700, alpha = 0, x = -30})
          transition.to(sFooter1, {time = 1000, alpha = 0, x = -200})
          transition.to(sFooter2, {time = 1000, alpha = 0, x = 913, onComplete = go})

        return true
      end
    end
    
    normal:addEventListener("touch", normal)
    
    function challenge:touch(event)
      local phase = event.phase
        if event.phase == "began" then
          
          local function go()
            --muteButton.remove()
            composer.gotoScene("levelSelChal")
          end

          normal:removeSelf()
          normal = nil 
          challenge:removeSelf()
          challenge = nil
          butSel:removeSelf()
          butSel = nil
          transition.to(sHead, {time = 600, y = -40, alpha = 0})
          transition.to(uiLok, {time = 600, alpha = 0})
          transition.to(normMode, {time = 600, alpha = 0, x = -100})
          transition.to(chalMode, {time = 600, alpha = 0, x = 813})
          transition.to(text, {time = 500, alpha = 0})
          transition.to(muteB, {time = 640, x = 750, alpha = 0})
          transition.to(muteOn, {time = 640, x = 750, alpha = 0})
          transition.to(backBut, {time = 700, alpha = 0, x = -30})
          transition.to(sFooter1, {time = 1000, alpha = 0, x = -200})
          transition.to(sFooter2, {time = 1000, alpha = 0, x = 913, onComplete = go})
      
        return true
      end
    end
    
    challenge:addEventListener("touch", challenge)
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