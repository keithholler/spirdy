system.getInfo("model")

display.setStatusBar(display.HiddenStatusBar)

local composer = require( "composer" )

local scene = composer.newScene()

local myData = require("myData")
local widget = require("widget")
local perspective = require("perspective")
--local music = require("bgMusic")

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
local camera, prevScore


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
-- -------------------------------------------------------------------------------
local function onButtonRelease(event)
  local go = event.target.id
  if go == "quit" then
    composer.hideOverlay()
    composer.gotoScene("bgMain")
    --music.mmSound()
  elseif go =="levelSel" then
    composer.hideOverlay()
    composer.gotoScene("bgLevel")
    --music.mmSound()
  elseif go =="retry" then
    composer.hideOverlay()
    --composer.removeScene("playGame")
    composer.gotoScene("retry")
  end
end
-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    camera = perspective.createView()

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local tran = display.newImageRect(sceneGroup, "transition.png", 1425, 900)
    tran.x = centerX
    tran.y = centerY
    tran.alpha = 0.3
    camera:add(tran, 8)
   
    local gameOverMenu = display.newImageRect(sceneGroup, "gameOver/gameOverMenu.png", 1055, 590)
    gameOverMenu.x = W/2 + 1600
    gameOverMenu.y = H/2
    gameOverMenu.alpha = 0
    camera:add(gameOverMenu, 3)
    
    local gemText = display.newImageRect(sceneGroup, "gameOver/gemsText.png", 271, 145)
    gemText.x = W/2 + 100
    gemText.y = H/2
    gemText.alpha = 0
    camera:add(gemText, 1)
    
    local timeText = display.newImageRect(sceneGroup, "gameOver/timeText.png", 264, 144)
    timeText.x = W/2 + 100
    timeText.y = H/2 - 160
    timeText.alpha = 0
    camera:add(timeText, 1)
    
    local coinText = display.newImageRect(sceneGroup, "gameOver/coinText.png", 267, 152)
    coinText.x = W/2 + 100
    coinText.y = H/2 + 160
    coinText.alpha = 0
    camera:add(coinText, 1)
    
    local retryBtn = widget.newButton({width = 400, height = 154, defaultFile = "gameOver/restartBtn.png", id = "retry", onRelease = onButtonRelease})
    retryBtn.x = W/2 + 500
    retryBtn.y = H/2 - 160
    retryBtn.alpha = 0
    sceneGroup:insert(retryBtn)
    camera:add(retryBtn, 2)
   
    --[[local levelBtn = widget.newButton({width = 404, height = 162, defaultFile = "gameOver/levelSelBtn.png", id = "levelSel", onRelease = onButtonRelease})
    levelBtn.x = W/2 + 500
    levelBtn.y = H/2
    levelBtn.alpha = 0
    sceneGroup:insert(levelBtn)
    camera:add(levelBtn, 2)
    
    local quitBtn = widget.newButton({width = 402, height = 152, defaultFile = "gameOver/mainMenuBtn.png", id = "quit", onRelease = onButtonRelease})
    quitBtn.x = W/2 + 500
    quitBtn.y = H/2 + 160
    quitBtn.alpha = 0
    sceneGroup:insert(quitBtn)
    camera:add(quitBtn, 2)]]--
    
    prevScore = display.newText(sceneGroup, myData.lv1Score, W/2 + 100, H/2, "Soup Of Justice", 48)
    prevScore:setFillColor(0, 0, 0)
    prevScore.alpha = 0
    prevScore.anchorX = 0
    camera:add(prevScore, 1)
    
    transition.to(gameOverMenu, {time = 1500, x = W/2 + 200, alpha = 1})
    transition.to(gemText, {delay = 1500, time = 1000, alpha = 1})
    transition.to(timeText, {delay = 1500, time = 1000, alpha = 1})
    transition.to(coinText, {delay = 1500, time = 1000, alpha = 1})
    transition.to(retryBtn, {delay = 1500, time = 1000, alpha = 1})
    --transition.to(levelBtn, {delay = 1500, time = 1000, alpha = 1})
    --transition.to(quitBtn, {delay = 1500, time = 1000, alpha = 1})
    transition.to(prevScore, {delay = 1500, time = 1800, alpha = 1})
    
    camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3)

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        prevScore.text = myData.lv1PrevScore
        
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
        parent:remove()
        camera:destroy()
        
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