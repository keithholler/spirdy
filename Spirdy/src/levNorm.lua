-- This level select class does not have the background transition and use only to transition from playGame -> level select -> to this class
system.getInfo("model")
local widget = require( "widget" )

display.setStatusBar(display.HiddenStatusBar)


local centerY = display.contentCenterY
local centerX = display.contentCenterX

local composer = require( "composer" )
local scene = composer.newScene()
--local score = require( "score" )
local music = require("bgMusic")
--local mute = require("muteButton")
local widget = require("widget")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------
local sHead
local uiLok
local muteB, muteOn
local sFooter1
local sFooter2
local buttonLevel1
local buttonLevel1ad
local backBut
local butSel
local textName
local time
local bestTime
local gems
local leaderBoard

local loadLevel = require("chooseLevel")

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
    sHead = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudtop.png", 713, 88)
    uiLok = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudconnector.png", 713, 404)
    sFooter1 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudleft.png", 357, 176)
    sFooter2 = display.newImageRect(sceneGroup, "mainMenu/homebutton_hudright.png", 357, 176)
    buttonLevel1 = display.newImageRect(sceneGroup, "buttonSel.png", 390, 200) -- Touch event image that fits the upper part of the level sceen
    buttonLevel1ad = display.newImageRect(sceneGroup, "buttonSel.png", 135, 100) -- Smaller squre image that fits under the buttonLevel1 to expand the touch event for level 1
    backBut = display.newImageRect(sceneGroup, "modeSelect/mode_back.png", 60, 60)
    butSel = display.newImageRect(sceneGroup, "buttonSel.png", 60, 60)
    gems = display.newImageRect(sceneGroup, "levelSel/gemsCount.png", 260, 130)
    leaderBoard = display.newImageRect(sceneGroup, "levelSel/leader.png", 228, 83)
    time = display.newImageRect(sceneGroup, "levelSel/levelTime.png", 274, 50)
    bestTime = display.newImageRect(sceneGroup, "levelSel/bestTime.png", 271, 50)
    muteB = display.newImageRect(sceneGroup, "mainMenu/speakerButton.png", 50, 50)
    muteOn = display.newImageRect(sceneGroup, "mainMenu/speakerMute.png", 50, 50)
      
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
    
    --loadLevel.levelSetTrue()
    --loadLevel.setLevel1()
    
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
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
    --composer.loadScene("playGame")
    composer.removeScene("modeSel")
    composer.removeScene("modeSelBack")

    --local scoreText = score.init({fontSize = 20, font = "Soup Of Justice", x = 90, y = 330, maxDigits = 5, leadingZeros = false, filename = "scorefile.txt",})
        --scoreText:setFillColor(0, 0, 0)
        
--[[function loadScore()
      
        local prevScore = score.load()
        if prevScore then
          score.set(prevScore)
        
      end
      return true
    end

loadScore()]]--
    
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      
      -- Back Button
      function butSel:touch(event)
      local phase = event.phase
        if event.phase == "began" then
        
          local function go()
            --mute.remove()
            composer.gotoScene("modeSelBack")
          end  
          
          butSel:removeSelf()
          butSel = nil
          buttonLevel1:removeSelf()
          buttonLevel1 = nil
          buttonLevel1ad:removeSelf()
          buttonLevel1ad = nil
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
          loadLevel.setFalse1()

        return true
      end
    end
    
    butSel:addEventListener("touch", butSel) 
      
   -- Function for level 1 select
 function buttonLevel1:touch(event)
     local phase = event.phase
      if event.phase == "began" then
                    
        --mute.remove()
        music.remove()                           
        
        composer.gotoScene("playGame")
        --loadLevel.setFalse1()
                    
        return true
      end
     end
                
  buttonLevel1:addEventListener("touch", buttonLevel1)
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