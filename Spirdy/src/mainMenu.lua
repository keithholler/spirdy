system.getInfo("model")

display.setStatusBar(display.HiddenStatusBar)

local centerY = display.contentCenterY
local centerX = display.contentCenterX

local muteButton = require("muteButton")
local widget = require("widget")
local musicOn = require("sounds")

local composer = require( "composer" )

local scene = composer.newScene()

--[[local sHead, logoB, spirdyLogo, sFooter1, sFooter2, uiLok, opt, playSel, fb, st, lb, cred, 
  twit, playG, gameBtn, muteB, muteOn, playerSelBtn, optionBtn]]--
local select
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
-- -------------------------------------------------------------------------------
local levelLoad

function scene:show()

end

scene:addEventListener( "show", scene )

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
       
       local sHead = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudtop.png", 713, 88)
       sHead.x = 355
       sHead.y = -15
       sHead.alpha = 0
       
       local logoB = display.newImageRect(sceneGroup, "mainMenu/home_logoframe.png", 338, 64)
       logoB.x = 355
       logoB.y = 45
       logoB.alpha = 0
       
       local spirdyLogo = display.newImageRect(sceneGroup, "mainMenu/homebutton_SLogo.png", 327, 103)
       spirdyLogo.x = 355
       spirdyLogo.y = 50
       spirdyLogo.alpha = 0
       
       local sFooter1 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudleft.png", 357, 176)
       sFooter1.x = -100
       sFooter1.y = 313
       sFooter1.alpha = 0
       
       local sFooter2 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudright.png", 357, 176)
       sFooter2.x = 813
       sFooter2.y = 313
       sFooter2.alpha = 0
       
       local uiLok = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudconnector.png", 713, 404)
       uiLok.x = 355
       uiLok.y = 200
       uiLok.alpha = 0
       
       local opt = display.newImageRect(sceneGroup, "mainMenu/homebutton_options.png", 174, 56)
       opt.x = 88
       opt.y = 255
       opt.alpha = 0
       
       local playSel = display.newImageRect(sceneGroup, "mainMenu/homebutton_playerS.png", 222, 52)
       playSel.x = 114
       playSel.y = 305
       playSel.alpha = 0
       
       local playerSelBtn = display.newImageRect(sceneGroup, "buttonSel.png", 185, 35)
       playerSelBtn.x = 105
       playerSelBtn.y = 305
       playerSelBtn.alpha = 0
       
       local fb = display.newImageRect(sceneGroup, "mainMenu/homebutton_facebook.png", 50, 50)
       fb.x = 25
       fb.y = 375
       fb.alpha = 0
       
       local st = display.newImageRect(sceneGroup, "mainMenu/homebutton_store.png", 172, 53)
       st.x = 620
       st.y = 255
       st.alpha = 0
       
       local lb = display.newImageRect(sceneGroup, "mainMenu/homebutton_LeaderB.png", 220, 51)
       lb.x = 596
       lb.y = 303
       lb.alpha = 0
       
       local cred = display.newImageRect(sceneGroup, "mainMenu/homebutton_credits.png", 269, 68)
       cred.x = 573
       cred.y = 359
       cred.alpha = 0
       
       local twit = display.newImageRect(sceneGroup, "mainMenu/homebutton_twitter.png", 50, 50)
       twit.x = 684
       twit.y = 373
       twit.alpha = 0
       
       local playG = display.newImageRect(sceneGroup, "mainMenu/homebutton_play.png", 269, 70)
       playG.x = 138
       playG.y = 356
       playG.alpha = 0
       
       local gameBtn = display.newImageRect(sceneGroup, "buttonSel.png", 150, 50)
       gameBtn.x = 170
       gameBtn.y = 360
       gameBtn.alpha = 0
       
       local muteB = display.newImageRect(sceneGroup, "mainMenu/speakerButton.png", 50, 50)
       muteB.x = 680
       muteB.y = 26
       muteB.alpha = 0
       
       local muteOn = display.newImageRect(sceneGroup, "mainMenu/speakerMute.png", 50, 50)
       muteOn.x = 680
       muteOn.y = 26
       muteOn.alpha = 0
       
       local optionBtn = display.newImageRect(sceneGroup, "buttonSel.png", 135, 35)
       optionBtn.x = 80
       optionBtn.y = 255
       optionBtn.alpha = 0

      transition.to(sHead, {delay = 3000, time = 1000, alpha = 1, y = 43})
      transition.to(logoB, {delay = 2000, time = 2500, alpha = 1})
      transition.to(spirdyLogo, {delay = 2000, time = 2000, alpha = 1})
      transition.to(sFooter1, {delay = 4000, time = 1500, alpha = 1, x = 177})
      transition.to(sFooter2, {delay = 4000, time = 1500, alpha = 1, x = 533})
      transition.to(uiLok, {delay = 5500, time = 1000, alpha = 1})
      transition.to(opt, {delay = 6500, time = 2000, alpha = 1})
      transition.to(playSel, {delay = 6500, time = 2000, alpha = 1})
      transition.to(fb, {delay = 6500, time = 2000, alpha = 1})
      transition.to(st, {delay = 6500, time = 2000, alpha = 1})
      transition.to(lb, {delay = 6500, time = 2000, alpha = 1})
      transition.to(cred, {delay = 6500, time = 2000, alpha = 1})
      transition.to(twit, {delay = 6500, time = 2000, alpha = 1})
      transition.to(playG, {delay = 6500, time = 2000, alpha = 1}) 
      transition.to(muteB, {delay = 6500, time = 2000, alpha = 1})
      transition.to(gameBtn, {delay = 8500, alpha = 1})
      transition.to(playerSelBtn, {delay = 8500, alpha = 1})
      transition.to(optionBtn, {delay = 8500, alpha = 1})
      
    function gameBtn:touch(event)
     local phase = event.phase
      if event.phase == "began" then
      
        select = "playGame"
        
        local function goModeSel()
          --composer.gotoScene("modeSel")
          composer.hideOverlay()
        end
        
        gameBtn:removeSelf()
        gameBtn = nil  
        playerSelBtn:removeSelf()
        playerSelBtn = nil
        optionBtn:removeSelf()
        optionBtn = nil
        transition.to(sHead, {time = 800, y = -40, alpha = 0})
        transition.to(logoB, {time = 800, alpha = 0, y = -40})
        transition.to(spirdyLogo, {time = 800, alpha = 0, y = -40})
        transition.to(uiLok, {time = 800, alpha = 0})                
        transition.to(st, {time = 540, x = 812 })
        transition.to(lb, {time = 640, x = 827})
        transition.to(cred, {time = 740, x = 847})
        transition.to(twit, {time = 250, x = 762})
        transition.to(opt, {time = 540, x = -99})
        transition.to(playSel, {time = 640, x = -114})
        transition.to(fb, {time = 250, x = -49})
        transition.to(playG, {time = 740, x = -134})
        transition.to(muteB, {time = 740, x = 800, alpha = 0})
        transition.to(muteOn, {time = 740, x = 800, alpha = 0})
        transition.to(sFooter1, {time = 1320, x = -300})
        transition.to(sFooter2, {time = 1320, x = 1000, onComplete = goModeSel})
  
        return true
      end
     end
                
  gameBtn:addEventListener("touch", gameBtn)
  
  function playerSelBtn:touch(event)
     local phase = event.phase
      if event.phase == "began" then
        
        select = "playerSel"
        
        local function go()
          --composer.gotoScene("playerSel")
          composer.hideOverlay()
        end
        
        gameBtn:removeSelf()
        gameBtn = nil    
        playerSelBtn:removeSelf()
        playerSelBtn = nil
        optionBtn:removeSelf()
        optionBtn = nil
        transition.to(sHead, {time = 800, y = -40, alpha = 0})
        transition.to(logoB, {time = 800, alpha = 0, y = -40})
        transition.to(spirdyLogo, {time = 800, alpha = 0, y = -40})
        transition.to(uiLok, {time = 800, alpha = 0})                
        transition.to(st, {time = 540, x = 812 })
        transition.to(lb, {time = 640, x = 827})
        transition.to(cred, {time = 740, x = 847})
        transition.to(twit, {time = 250, x = 762})
        transition.to(opt, {time = 540, x = -99})
        transition.to(playSel, {time = 640, x = -114})
        transition.to(fb, {time = 250, x = -49})
        transition.to(playG, {time = 740, x = -134})
        transition.to(muteB, {time = 740, x = 800, alpha = 0})
        transition.to(muteOn, {time = 740, x = 800, alpha = 0})
        transition.to(sFooter1, {time = 1320, x = -300})
        transition.to(sFooter2, {time = 1320, x = 1000, onComplete = go})
  
        return true
      end
     end
                
  playerSelBtn:addEventListener("touch", playerSelBtn)
  
  function optionBtn:touch(event)
     local phase = event.phase
      if event.phase == "began" then
          composer.showOverlay("options", {isModal = true})
          transition.to(opt, {time = 500, alpha = 0})
          transition.to(playSel, {time = 500, alpha = 0})
          transition.to(fb, {time = 500, alpha = 0})
          transition.to(st, {time = 500, alpha = 0})
          transition.to(lb, {time = 500, alpha = 0})
          transition.to(cred, {time = 500, alpha = 0})
          transition.to(twit, {time = 500, alpha = 0})
          transition.to(playG, {time = 500, alpha = 0}) 
          transition.to(muteB, {time = 500, alpha = 0})
          transition.to(muteOn, {time = 500, alpha = 0})
          transition.to(gameBtn, {alpha = 0})
          transition.to(playerSelBtn, {alpha = 0})
          transition.to(optionBtn, {alpha = 0})
          
        return true
      end
     end
                
  optionBtn:addEventListener("touch", optionBtn)
  
   function muteB:touch(event)
    local phase = event.phase
      if event.phase == "began" then
      
        muteB.alpha = 0
        
        muteOn.alpha = 1
        
        musicOn.soundOff()
        
        --muteSound()
        
        return true
        
    end
  end
      
  muteB:addEventListener("touch", muteB)
  
  function muteOn:touch(event)
    local phase = event.phase
      if event.phase == "began" then
      
        muteB.alpha = 1
        
        muteOn.alpha = 0

        musicOn.soundOn()
        
        --muteSound()
        
        return true
        
    end
  end
      
  muteOn:addEventListener("touch", muteOn)

end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
      --composer.removeScene("loadIntro")
      --levelLoad = require("chooseLevel")
      --levelLoad.loadLevel1()

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
        if select == "playGame" then
          parent:modeSel()
        end
        
        if select == "playerSel" then
          parent:playerSel()
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