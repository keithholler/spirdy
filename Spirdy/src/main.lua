local W = display.contentWidth
local H = display.contentHeight
local centerY = display.contentCenterY
local centerX = display.contentCenterX
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight
local screenTopSB = screenTop + display.topStatusBarContentHeight
local screenHeightSB = display.viewableContentHeight - screenTopSB
local screenBottomSB = screenTopSB + screenHeightSB

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
local mem = require("misc.memTest")
mem.createEasyMeter(centerX, 40, 800, 22)

composer.loadScene( "playGame" )

--local function goTo()
  --composer.gotoScene( "playGame" )
--end

--timer.performWithDelay(2000, goTo)

composer.gotoScene( "lv1Loading" )