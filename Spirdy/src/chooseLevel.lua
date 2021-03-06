system.getInfo("model")
local widget = require( "widget" )

display.setStatusBar(display.HiddenStatusBar)

local centerY = display.contentCenterY
local centerX = display.contentCenterX

local level1
local level2
local level3
local level4
local level5
local left
local right

local levelChoose = {}

  levelChoose.loadLevel1 = function()
    level1 = display.newImageRect("levelSel/level1.png", 713, 450)
     level1.x = centerX
     level1.y = centerY
     level1.alpha = 0
   end
  
  levelChoose.loadLevel2 = function()
   level2 = display.newImageRect("levelSel/level2.png", 713, 450)
    level2.x = centerX
    level2.y = centerY
    level2.alpha = 0
  end
  
  levelChoose.loadLevel3 = function()
    level3 = display.newImageRect("levelSel/level3.png", 713, 450)
     level3.x = centerX
     level3.y = centerY
     level3.alpha = 0
  end
  
  levelChoose.loadLevel4 = function()
    level4 = display.newImageRect("levelSel/level4.png", 713, 450)
     level4.x = centerX
     level4.y = centerY
     level4.alpha = 0
  end
  
  levelChoose.loadLevel5 = function()
    level5 = display.newImageRect("levelSel/level5.png", 713, 450)
     level5.x = centerX
     level5.y = centerY
     level5.alpha = 0
  end
  
  levelChoose.levelSetTrue = function()
  
    --left = display.newImageRect("levelSel/scrollLeft.png", 45, 44)
    --right = display.newImageRect("levelSel/scrollRight.png", 45, 44)
    
       left = widget.newButton
        {
          width = 45, 
          height = 44,
          defaultFile = "levelSel/scrollLeft.png",
          overFile = "levelSel/sLeftTouch.png",
          onEvent = levelChoose.level5Right
        }
        
        right = widget.newButton
        {
          width = 45, 
          height = 44, 
          defaultFile = "levelSel/scrollRight.png",
          overFile = "levelSel/sRightTouch.png",
          onEvent = levelChoose.level2Left
        }
    
      right.x = 595
      right.y = 180
      right.alpha = 0
      
      left.x = 115
      left.y = 180
      left.alpha = 0
  
      transition.to(right, {delay = 2000, time = 2000, alpha = 1})
      transition.to(left, {delay = 2000, time = 2000, alpha = 1})
      
  end
  
  levelChoose.setLevel1 = function()
    transition.to(level1, {delay = 1000, time = 2000, alpha = 1})
  end
  
  levelChoose.setFalse1 = function()
      --level1:removeSelf()
      --level1 = nil
      --right:removeSelf()
      --right = nil
      --left:removeSelf()
      --left = nil
      transition.to(level1, {time = 500, alpha = 0})
      transition.to(right, {time = 500, alpha = 0})
      transition.to(left, {time = 500, alpha = 0})
  end
  
  levelChoose.remove = function()
    level1.alpha = 0
    right.alpha = 0
    left.alpha = 0
  end
  
  levelChoose.level1Left = function()
  
    
  end
  
  levelChoose.level1Right = function()
  
  end
  
  levelChoose.level2Left = function()
  
  end
  
  levelChoose.level2Right = function()
  
  end
  
  levelChoose.level3Left = function()
  
  end
  
  levelChoose.level3Right = function()
  
  end
  
  levelChoose.level4Left = function()
  
  end
  
  levelChoose.level4Right = function()
  
  end
  
  levelChoose.level5Left = function()
  
  end
  
  levelChoose.level5Right = function()
  
  end

return levelChoose