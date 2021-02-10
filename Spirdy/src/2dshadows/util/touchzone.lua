-------------------------------------------------
--
-- touchzone.lua
--
-- Creates a module for detecting touches on a certain box area 
--
-- HOW TO USE
--
--[[
    local TouchZone = require( "util.touchzone" )

    local touchZone = TouchZone:new( _W2, _H2, _W, _H)
    sceneGroup:insert( touchZone )
    touchZone.isVisible = false
--]]
--
-- The touchzone object lsitens for touch events and dispatches 
-- custom events to its parent object so that the parent 
-- can react to the touches
-- The event's name is "touchzone" and does support "begin",
-- "moved" and "ended" phases.
-------------------------------------------------

local Helper = require( "util.helper" )
local Log   = require( "util.log" )

local TouchZone = {}

function TouchZone:new(px,py,pw,ph)
    Log:p(1, "TouchZone:new()" )

    local object                = display.newGroup( )

    object.x                    = px or 0
    object.y                    = py or 0
    object.isVisible            = true
    object.isHitTestable        = true

    object.rect                 = display.newRect( object, 0, 0, pw or 100, ph or 100 )
    object.rect.alpha           = 0.07
    object.rect.isVisible       = true
    object.rect.isHitTestable   = true

    object.isTouched            = false


    -----------------------------------------------------------------------------
    -- object:touch(event)
    -----------------------------------------------------------------------------
    function object:touch(event)
        Log:p(0, "TouchZone:touch phase:" .. event.phase)
        Log:p(0, "Unique touch ID: "..tostring(event.id) )

        if event.phase == "began" then
            -- begin focus
            display.getCurrentStage():setFocus( self, event.id )

            self.isFocus   = true
            self.isTouched = true

                local event = {
                    name = "touchzone",
                    type = "began",
                    id = event.id,
                    x = event.x,
                    y = event.y
                }
                self.parent:dispatchEvent( event )

        elseif self.isFocus then

            if event.phase == "moved" then

                Log:p(0, "TouchZone:moved" )

                local event = {
                    name = "touchzone",
                    type = "moved",
                    id = event.id,
                    x = event.x,
                    y = event.y
                }
                self.parent:dispatchEvent( event )

            elseif event.phase == "ended" or event.phase == "cancelled" then

                Log:p(0, "TouchZone:ended" )
                
                -- end focus
                display.getCurrentStage():setFocus( self, nil )
                self.isFocus   = false
                self.isTouched = false

                local event = {
                    name = "touchzone",
                    type = "ended",
                    id = event.id,
                    x = event.x,
                    y = event.y
                }
                self.parent:dispatchEvent( event )
            end

      end

      return true
   end

   -- create an event listener for touching
   object:addEventListener("touch", object)

   return object
end

return TouchZone