display.setStatusBar(display.HiddenStatusBar)

local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()

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

local perspective = require("perspective")
local sound = require("sounds")
local loading, loading2, loading3, loading4, loading5, loading6, camera, textTimer, btnTimer, continueBtn

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local function continue()
  sound.ls1Remove()
  composer.gotoScene("playGame")
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    camera = perspective.createView()

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local transition = display.newImageRect(sceneGroup, "levelSel/level1.png", 1425, 900)
    transition.x = W/2
    transition.y = H/2
    camera:add(transition, 2)
    
    loading = display.newText(sceneGroup, "Loading    ", W/2 - 100, H/2 + 300, "Soup Of Justice", 48)
    loading:setFillColor(1, 1, 1)
    loading.isVisible = false
    loading.isBodyActive = false
    loading.anchorX = 0
    camera:add(loading, 1)
    
    loading2 = display.newText(sceneGroup, "Loading.   ", W/2 - 100, H/2 + 300, "Soup Of Justice", 48)
    loading2:setFillColor(1, 1, 1)
    loading2.isVisible = false
    loading2.isBodyActive = false
    loading2.anchorX = 0
    camera:add(loading2, 1)
    
    loading3 = display.newText(sceneGroup, "Loading..  ", W/2 - 100, H/2 + 300, "Soup Of Justice", 48)
    loading3:setFillColor(1, 1, 1)
    loading3.isVisible = false
    loading3.isBodyActive = false
    loading3.anchorX = 0
    camera:add(loading3, 1)
    
    loading4 = display.newText(sceneGroup, "Loading... ", W/2 - 100, H/2 + 300, "Soup Of Justice", 48)
    loading4:setFillColor(1, 1, 1)
    loading4.isVisible = false
    loading4.isBodyActive = false
    loading4.anchorX = 0
    camera:add(loading4, 1)
    
    loading5 = display.newText(sceneGroup, "Loading....", W/2 - 100, H/2 + 300, "Soup Of Justice", 48)
    loading5:setFillColor(1, 1, 1)
    loading5.isVisible = false
    loading5.isBodyActive = false
    loading5.anchorX = 0
    camera:add(loading5, 1)
    
    continueBtn = widget.newButton
    {
      label = "Continue",
      font = "Soup Of Justice",
      fontSize = 48,
      onRelease = continue
    }
    continueBtn.id = "debug"
    continueBtn.x = W/2
    continueBtn.y = H/2 + 300
    continueBtn.isVisible = false
    continueBtn.isBodyActive = false
    sceneGroup:insert(continueBtn)
    camera:add(continueBtn, 1)
    
    camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3)
    camera:setBounds(W/2, W/2, H/2, H/2)
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        local getPrev = composer.getPrevious()
        if getPrev ~= nil then
          composer.removeScene(getPrev)
        end
    
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        sound.ls1()
        
        local function textIteration()
            
            loading2.isVisible = true
            loading2.isBodyActive = true
            
            loading.isVisible = false
            loading.isBodyActive = false
            
              local function loadingText2()

                loading3.isVisible = true
                loading3.isBodyActive = true
                
                loading2.isVisible = false
                loading2.isBodyActive = false
                
                local function loadingText3()

                  loading4.isVisible = true
                  loading4.isBodyActive = true
                  
                  loading3.isVisible = false
                  loading3.isBodyActive = false
                  
                  local function loadingText4()

                    loading5.isVisible = true
                    loading5.isBodyActive = true
                    
                    loading4.isVisible = false
                    loading4.isBodyActive = false
                    
                    
                    local function loadingText5()
          
                      loading.isVisible = true
                      loading.isBodyActive = true
                      
                      loading5.isVisible = false
                      loading5.isBodyActive = false
                      
                      -- Repeart the iteration
                      textTimer = timer.performWithDelay(500, textIteration)
                    end
                    
                    -- Timer to call loadingText5
                    textTimer = timer.performWithDelay(500, loadingText5, 1)
                  end
                  
                  -- Timer to call loadingText4
                  textTimer = timer.performWithDelay(500, loadingText4, 1)
                end
                
                -- Timer to call function loadingText3
                textTimer = timer.performWithDelay(500, loadingText3, 1)
              end
            
            -- Timer to call function loadingText2
            textTimer = timer.performWithDelay(500, loadingText2, 1)
            composer.loadScene( "playGame" )
        end
        
        loading.isVisible = true
        loading.isBodyActive = true
        
        -- Timer to call the iteration of text
        textTimer = timer.performWithDelay(500, textIteration, 1)
        
        local function btnDisplay()
          timer.cancel(textTimer)
          if loading.isVisible == true then
            loading.isVisible = false
            loading.isBodyActive = false
            
            continueBtn.isVisible = true
            continueBtn.isBodyActive = true
          elseif loading2.isVisible == true then
            loading2.isVisible = false
            loading2.isBodyActive = false
            
            continueBtn.isVisible = true
            continueBtn.isBodyActive = true
          elseif loading3.isVisible == true then
            loading3.isVisible = false
            loading3.isBodyActive = false
            
            continueBtn.isVisible = true
            continueBtn.isBodyActive = true
          elseif loading4.isVisible == true then
            loading4.isVisible = false
            loading4.isBodyActive = false
            
            continueBtn.isVisible = true
            continueBtn.isBodyActive = true
          elseif loading5.isVisible == true then
            loading5.isVisible = false
            loading5.isBodyActive = false
            
            continueBtn.isVisible = true
            continueBtn.isBodyActive = true
          end
        end
        
        btnTimer = timer.performWithDelay(20000, btnDisplay, 1)
        --transition.to(loading, {time = 200, text = "Loading.", onComplete = textIteration})

        --local function goTo()
          --composer.gotoScene( "playGame" )
        --end

        --timer.performWithDelay(15000, goTo)
        
        camera.damping = 10 -- A bit more fluid tracking
        --camera:setFocus(loading) -- Set the focus to the player
        camera:track() -- Begin auto-tracking 
         
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
    
    camera:destroy()
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene