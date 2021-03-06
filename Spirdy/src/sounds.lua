display.setStatusBar(display.HiddenStatusBar)

local widget = require("widget")

local mmSound = audio.loadStream("sound/bgm/Constellation.mp3")
local lev1Sound = audio.loadStream("sound/bgm/Immaterial.mp3")
local loadScreen = audio.loadStream("sound/bgm/loadScreen1.mp3")

local gemCollect = audio.loadStream("sound/sfx/gemCollectSound.mp3")
local spirdyDies = audio.loadStream("sound/sfx/spirdyDiesSound.mp3")

local mainMenu, gemsC, spirdyD, level1, loadingScreen1, bgSlider, fxSlider

local toggle = {}

local settings = {}
  settings["fxvolume"] = 0.5
  settings["bgvolume"] = 0.5
  
  audio.setVolume( settings["bgvolume"], { channel = 1 }) 
  audio.setVolume( settings["fxvolume"], { channel = 2 }) 
-- ---------------------------------------------------------------------
-- mmSound is the Main Menu music
-- Main Menu background music
-- ---------------------------------------------------------------------

-- Main Menu music
toggle.mmSound = function()
  mainMenu = audio.play( mmSound, { channel = 1, loops = -1, fadein = 1000 }  )
end

toggle.soundOff = function()
  audio.pause(mainMenu)
end

toggle.soundOn = function()
  audio.resume(mainMenu)
end

toggle.rewindMM = function()
  audio.rewind(mainMenu)
end

toggle.remove = function()
  
  audio.stop()
  --mainMenu = nil
  --audio.dispose(mmSound)
  --mmSound = nil
  
end
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Loading screen 1 music
-- ---------------------------------------------------------------------
toggle.ls1 = function()
  loadingScreen1 = audio.play( loadScreen, { channel = 1, loops = -1, fadeout = 3000, fadein = 3000}  )
end

toggle.ls1Pause = function()
  audio.pause(loadingScreen1)
end

toggle.ls1Resume = function()
  audio.resume(loadingScreen1)
end

toggle.ls1Rewind = function()
  audio.rewind(loadingScreen1)
end

toggle.ls1Remove = function()
  audio.stop()
end

-- ---------------------------------------------------------------------
-- Level 1 music
-- ---------------------------------------------------------------------
toggle.lv1 = function()
  level1 = audio.play( lev1Sound, { channel = 1, loops = -1, fadein = 1000 }  )
end

toggle.lv1Pause = function()
  audio.pause(level1)
end

toggle.lv1Resume = function()
  audio.resume(level1)
end

toggle.lv1Rewind = function()
  audio.rewind(lev1Sound)
end

toggle.lv1Remove = function()
  
  audio.stop()
  --level1 = nil
  --audio.dispose(lev1Sound)
  --lev1Sound = nil
  
end
-- ---------------------------------------------------------------------

--[[toggle.ifTrue = function()
  toggle.mmSound = true
end

toggle.ifFalse = function()
  toggle.mmSound = false
end]]--


-- ---------------------------------------------------------------------
-- Gem sound when collecting
-- ---------------------------------------------------------------------
toggle.gemSound = function()
  gemsC = audio.play( gemCollect, { channel = 2, loops = 0 }  )
end

toggle.gemStop = function()
  audio.stop(gemsC)
  gemC = nil
end
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- Spird dies sound
-- ---------------------------------------------------------------------
toggle.spirdyDies = function()
  spirdyD = audio.play( spirdyDies, { channel = 2, loops = 0 }  )
end

toggle.spirdyRemove = function()
  audio.stop(spirdyD)
  spirdyD = nil
end
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- Sliders that control the bg volume and sfx volume
-- ---------------------------------------------------------------------
toggle.options = function(group)
  
  -- Background volume listener 
  local function bgSliderListener( event )
    local sliderValue = event.value
    local logValue
    if sliderValue == nil then sliderValue = 0 end
    if (sliderValue > 0) then
      logValue = (math.pow(3,sliderValue/100)-1)/(3-1)
    else
      logValue = 0.0
    end
    settings["bgvolume"] = logValue
    audio.setVolume( settings["bgvolume"], { channel=1 } )
  end
  
  -- Background volume slider
  bgSlider = widget.newSlider
  {
    -- top = x and left = y
    top = 200, left = 200,    
    width=150,  height=10,    
    value=50,
    background = "options/sliderBg.png",
    fillImage = "options/sliderFill.png",
    fillWidth = 2, leftWidth = 16,
    handle = "options/handle.png",
    handleWidth = 32, handleHeight = 32,
    listener = bgSliderListener
   }
   group:insert( bgSlider )
   
   -- Sound Effects volume listener 
  local function fgSliderListener( event )
    local sliderValue = event.value
    local logValue
    if sliderValue == nil then sliderValue = 0 end
    if (sliderValue > 0) then
      logValue = (math.pow(3,sliderValue/100)-1)/(3-1)
    else
      logValue = 0.0
    end
    settings["fxvolume"] = logValue
    audio.setVolume( settings["fxvolume"], { channel = 2 } )
  end
   
   -- Effects volume slider
  fxSlider = widget.newSlider
  {
    -- top = y and left = x
    top = 200,    left = 400,
    width = 150,    height = 10,
    value = 50,
    background = "options/sliderBg.png",
    fillImage = "options/sliderFill.png",
    fillWidth = 2, 
    leftWidth = 16,
    handle = "options/handle.png",
    handleWidth = 32, 
    handleHeight = 32,
    listener = fgSliderListener
  }
  group:insert( fxSlider )
   
end

toggle.removeSliders = function()
  local function remove()
    fxSlider:removeSelf()
    fxSlider = nil
    bgSlider:removeSelf()
    bgSlider = nil
  end
  
  transition.to(bgSlider, {time = 500, alpha = 0,})
  transition.to(fxSlider, {time = 500, alpha = 0, onComplete = remove})
end
-- ---------------------------------------------------------------------

return toggle