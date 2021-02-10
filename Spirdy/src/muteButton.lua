system.getInfo("model")

display.setStatusBar(display.HiddenStatusBar)


local muteFunct = {}

 local muteB       
 local muteOn

 local musicOn = require("sounds")

muteFunct.muteBtn = function()
  
 muteB = display.newImageRect("mainMenu/speakerButton.png", 50, 50)
 muteB.x = 680
 muteB.y = 26
 muteB.alpha = 0
            
 muteOn = display.newImageRect("mainMenu/speakerMute.png", 50, 50)
 muteOn.x = 680
 muteOn.y = 26
 muteOn.alpha = 0
 --muteB:scale(.17, .17)
 
 transition.to(muteB, {delay = 6500, time = 2000, alpha = 1})
            
end

muteFunct.transOn = function()
  transition.to(muteB, {delay = 6500, time = 2000, alpha = 1})        
end

muteFunct.transOff = function()
  transition.to(muteB, {delay = 6500, time = 2000, alpha = 1})
end

muteFunct.muteTouch = function()

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
end

muteFunct.unMute = function()

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

muteFunct.remove = function()
  
  muteB:removeSelf()
  muteB = nil
  muteOn:removeSelf()
  muteOn = nil
  
end

return muteFunct