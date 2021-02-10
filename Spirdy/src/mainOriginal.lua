system.getInfo("model")

display.setStatusBar(display.HiddenStatusBar)

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

local composer = require( "composer" )
composer.isDebug = true
composer.recycleOnSceneChange = true

local mem = require("misc.memTest")
mem.createEasyMeter(centerX, 20, 400, 11)

composer.gotoScene("loadIntro")

