-- This level select class does not have the background transition and use only to transition from mainMenu -> modeSel -> play
system.getInfo("model")
local widget = require( "widget" )

display.setStatusBar(display.HiddenStatusBar)


local centerY = display.contentCenterY
local centerX = display.contentCenterX

local composer = require( "composer" )
local scene = composer.newScene()
--local score = require( "score" )
local musicOn = require("sounds")
local widget = require("widget")
local myData = require("myData")
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------
  
local backCount = 0
local playCount = 0
local prevScore, highScore, prevCoin

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
    local sHead = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudtop.png", 713, 88)
    local uiLok = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudconnector.png", 713, 404)
    local sFooter1 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudleft.png", 357, 176)
    local sFooter2 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudright.png", 357, 176)
    local buttonLevel1 = display.newImageRect(sceneGroup, "buttonSel.png", 390, 200) -- Touch event image that fits the upper part of the level sceen
    local buttonLevel1ad = display.newImageRect(sceneGroup, "buttonSel.png", 135, 100) -- Smaller squre image that fits under the buttonLevel1 to expand the touch event for level 1
    local backBut = display.newImageRect(sceneGroup, "modeSelect/mode_back.png", 60, 60)
    local butSel = display.newImageRect(sceneGroup, "buttonSel.png", 60, 60)
    local gems = display.newImageRect(sceneGroup, "levelSel/gemsCount.png", 260, 130)
    local leaderBoard = display.newImageRect(sceneGroup, "levelSel/leader.png", 228, 83)
    local time = display.newImageRect(sceneGroup, "levelSel/levelTime.png", 274, 50)
    local bestTime = display.newImageRect(sceneGroup, "levelSel/bestTime.png", 271, 50)
    local muteB = display.newImageRect(sceneGroup, "mainMenu/speakerButton.png", 50, 50)
    local muteOn = display.newImageRect(sceneGroup, "mainMenu/speakerMute.png", 50, 50)
      
    sFooter1.x = -100
    sFooter1.y = 313
    sFooter1.alpha = 0

    sFooter2.x = 813
    sFooter2.y = 313
    sFooter2.alpha = 0
    
    buttonLevel1.x = 355
    buttonLevel1.y = 180
    buttonLevel1.alpha = 0
    
    buttonLevel1ad.x = 355
    buttonLevel1ad.y = 325
    buttonLevel1ad.alpha = 0
    
    backBut.x = -30
    backBut.y = 25
    backBut.alpha = 0
  
    butSel.x = 30
    butSel.y = 25
    butSel.alpha = 0
    
    gems.x = 130
    gems.y = 292
    gems.alpha = 0
    
    leaderBoard.x = 600
    leaderBoard.y = 270
    leaderBoard.alpha = 0
    
    time.x = 576
    time.y = 332
    time.alpha = 0
    
    bestTime.x = 575
    bestTime.y = 378
    bestTime.alpha = 0
    
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
    
    prevCoin = display.newText(sceneGroup, myData.coins, 110, 328, "Soup Of Justice", 24)
    prevCoin:setFillColor( 0, 0, 0 )
    prevCoin.alpha = 0
    prevCoin.anchorX = 0
      
    prevScore = display.newText(sceneGroup, myData.lv1Score, 620, 332, "Soup Of Justice", 24)
    prevScore:setFillColor(0, 0, 0)
    prevScore.alpha = 0
    prevScore.anchorX = 0
    
    highScore = display.newText(sceneGroup, myData.lv1Score, 620, 378, "Soup Of Justice", 24)
    highScore:setFillColor(0, 0, 0)
    highScore.alpha = 0
    highScore.anchorX = 0
    
    transition.to(sHead, {delay = 1000, time = 1250, alpha = 1, y = 43})
    transition.to(uiLok, {delay = 2000, time = 1250, alpha = 1})
    transition.to(sFooter1, {delay = 1000, time = 1250, alpha = 1, x = 177})
    transition.to(sFooter2, {delay = 1000, time = 1250, alpha = 1, x = 533})
    transition.to(buttonLevel1, {delay = 2000, time = 1750, alpha = 1})
    transition.to(buttonLevel1ad, {delay = 2000, time = 1750, alpha = 1})
    transition.to(backBut, {delay = 1000, time = 1250, alpha = 1, x = 30})
    transition.to(butSel, {delay = 3000, alpha = 1})
    transition.to(muteB, {delay = 1000, time = 1250, alpha = 1, x = 680})
    transition.to(gems, {delay = 2100, time = 1800, alpha = 1})
    transition.to(leaderBoard, {delay = 2100, time = 1800, alpha = 1})
    transition.to(time, {delay = 2100, time = 1800, alpha = 1})
    transition.to(bestTime, {delay = 2100, time = 1800, alpha = 1})
    transition.to(prevCoin, {delay = 2300, time = 1800, alpha = 1})
    transition.to(prevScore, {delay = 2300, time = 1800, alpha = 1})
    transition.to(highScore, {delay = 2300, time = 1800, alpha = 1})
    
    -- Back Button
      function butSel:touch(event)
      local phase = event.phase
        if event.phase == "began" then
          
          backCount = backCount + 1
          
          local function go()
            composer.hideOverlay()
          end  
          
          butSel:removeSelf()
          butSel = nil
          buttonLevel1:removeSelf()
          buttonLevel1 = nil
          buttonLevel1ad:removeSelf()
          buttonLevel1ad = nil
          prevCoin:removeSelf()
          prevCoin = nil
          prevScore:removeSelf()
          prevScore = nil
          highScore:removeSelf()
          highScore = nil
          transition.to(sHead, {time = 600, y = -40, alpha = 0})
          transition.to(uiLok, {time = 600, alpha = 0})
          transition.to(muteB, {time = 640, x = 750, alpha = 0})
          transition.to(muteOn, {time = 640, x = 750, alpha = 0})
          transition.to(backBut, {time = 700, alpha = 0, x = -30})
          transition.to(gems, {time = 840, alpha = 0, x = -200})
          transition.to(leaderBoard, {time = 785, alpha = 0, x = 913})
          transition.to(time, {time = 860, alpha = 0, x = 913})
          transition.to(bestTime, {time = 860, alpha = 0, x = 913})
          transition.to(sFooter1, {time = 1000, alpha = 0, x = -200})
          transition.to(sFooter2, {time = 1000, alpha = 0, x = 913, onComplete = go})
          
        return true
      end
    end
    
    butSel:addEventListener("touch", butSel) 
      
   -- Function for level 1 select
 function buttonLevel1:touch(event)
     local phase = event.phase
      if event.phase == "began" then
         
        playCount = playCount + 1
        
        prevCoin:removeSelf()
        prevCoin = nil
        prevScore:removeSelf()
        prevScore = nil
        highScore:removeSelf()
        highScore = nil
        --musicOn.remove()  
        composer.hideOverlay()                         
        composer.gotoScene("playGame")
                    
        return true
      end
     end
                
  buttonLevel1:addEventListener("touch", buttonLevel1)
  
  function muteB:touch(event)
    local phase = event.phase
      if event.phase == "began" then
      
        muteB.alpha = 0
        
        muteOn.alpha = 1
        
        musicOn.soundOff()
        
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
    
    --composer.removeScene("modeSel")
    --composer.removeScene("modeSelBack")

    prevScore.text = myData.lv1PrevScore
    prevCoin.text = myData.prevCoins
    highScore.text = myData.lv1HighScore
    
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      local function load()
        composer.loadScene("playGame")
      end
      
      timer.performWithDelay(500, {onComplete = load})
      
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
        
        if playCount >= 1 then
          parent:emitterStop()
          --composer.removeScene("loadIntro")
          --composer.removeScene("bgScene")
        end
        
        if backCount >= 1 then
          parent:modeSel()
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene