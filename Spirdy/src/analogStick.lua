module (..., package.seeall)
--[[


                {
                x             = [X-COORD],
                y             = [Y-COORD],
                thumbSize     = [THUMB  SIZE],
                borderSize    = [BORDER SIZE], 
                snapBackSpeed = [THUMB SNAP BACK SPEED 0.0 - 1.0], 
                R             = [COLOR RED   0 - 255],
                G             = [COLOR GREEN 0 - 255],
                B             = [COLOR BLUE  0 - 255],
                } )
 

 
----------------------------------------------------------------
]]--
 
local Pi    = math.pi
local Sqr   = math.sqrt
local Rad   = math.rad
local Sin   = math.sin
local Cos   = math.cos
local Ceil  = math.ceil
local Atan2 = math.atan2
 

-- FUNCTION: CREATE 

function NewStick( Props )
 
        local Group         = display.newGroup()
        Group.x             = Props.x
        Group.y             = Props.y
        Group.Timer                     = nil
        Group.angle                     = 0
        Group.distance          = 0
        Group.percent           = 0
        Group.maxDist           = Props.borderSize
        Group.snapBackSpeed = Props.snapBackSpeed ~= nil and Props.snapBackSpeed or .7
 
        Group.Border = display.newCircle(0,0,Props.borderSize)
        Group.alpha = .01
        Group.Border.strokeWidth = 1
        Group.Border:setFillColor  (Props.R,Props.G,Props.B,46)
        Group.Border:setStrokeColor(Props.R,Props.G,Props.B,255)
        Group:insert(Group.Border)
 
        Group.Thumb = display.newCircle(0,0,Props.thumbSize)
        Group.Thumb.strokeWidth = 1
        Group.Thumb:setFillColor  (Props.R,Props.G,Props.B,96)
        Group.Thumb:setStrokeColor(Props.R,Props.G,Props.B,255)
        Group.Thumb.x0 = 0
        Group.Thumb.y0 = 0
        Group:insert(Group.Thumb)
 
        
        -- METHOD: DELETE STICK
       
        function Group:delete()
                self.Border    = nil
                self.Thumb     = nil
                if self.Timer ~= nil then timer.cancel(self.Timer); self.Timer = nil end
                self:removeSelf()

        end
        
        
        -- METHOD: MOVE AN OBJECT
        
        function Group:move(Obj, maxSpeed, rotate)
                if rotate == true then Obj.rotation = self.angle end
                Obj.x = Obj.x + Cos( Rad(self.angle-90) ) * (maxSpeed * self.percent) 
                Obj.y = Obj.y + Sin( Rad(self.angle-90) ) * (maxSpeed * self.percent) 
        end
        
        
        -- GETTER METHODS
        
        function Group:getDistance() return self.distance    end
        function Group:getPercent () return self.percent     end
        function Group:getAngle   () return Ceil(self.angle) end
 
       
        -- HANDLER: ON DRAG
        
        Group.onDrag = function ( event )
  


                print(event.target)
                local T     = event.target -- THUMB
                local S     = T.parent     -- STICK
                local phase = event.phase
                local ex,ey = S:contentToLocal(event.x, event.y)
                      ex = ex - T.x0
                      ey = ey - T.y0
 MyStick.alpha = .01
                if "began" == phase then
                        if S.Timer ~= nil then timer.cancel(S.Timer); S.Timer = nil end
                        display.getCurrentStage():setFocus( T )
                        T.isFocus = true
                        -- STORE INITIAL POSITION
                        T.x0 = ex - T.x
                        T.y0 = ey - T.y
                        MyStick.alpha = .1
 
                elseif T.isFocus then
                        if "moved" == phase then
                                -----------
                                S.distance    = Sqr (ex*ex + ey*ey)
                                if S.distance > S.maxDist then S.distance = S.maxDist end
                                S.angle       = ( (Atan2( ex-0,ey-0 )*180 / Pi) - 180 ) * -1
                                S.percent     = S.distance / S.maxDist
                                -----------
                                T.x       = Cos( Rad(S.angle-90) ) * (S.maxDist * S.percent) 
                                T.y       = Sin( Rad(S.angle-90) ) * (S.maxDist * S.percent) 
                                MyStick.alpha = .1
                        elseif "ended"== phase or "cancelled" == phase then
                                T.x0      = 0
                                T.y0      = 0
                                T.isFocus = false
                                display.getCurrentStage():setFocus( nil )
 
                                S.Timer = timer.performWithDelay( 33, S.onRelease, 0 )
                                S.Timer.MyStick = S
                                MyStick.alpha = .01

                        end
                end
 
                
                return true
 
        end
 
       
        -- HANDLER: ON DRAG RELEASE
        
        Group.onRelease = function( event )
 
                local S = event.source.MyStick
                local T = S.Thumb
 
                local dist = S.distance > S.maxDist and S.maxDist or S.distance
                          dist = dist * S.snapBackSpeed
 
                T.x = Cos( Rad(S.angle-90) ) * dist 
                T.y = Sin( Rad(S.angle-90) ) * dist 
 
                local ex = T.x
                local ey = T.y
                -----------
                S.distance = Sqr (ex*ex + ey*ey)
                if S.distance > S.maxDist then S.distance = S.maxDist end
                S.angle    = ( (Atan2( ex-0,ey-0 )*180 / Pi) - 180 ) * -1
                S.percent  = S.distance / S.maxDist
                -----------
                if S.distance < .5 then
                        S.distance = 0
                        S.percent  = 0
                        T.x            = 0
                        T.y            = 0
                        timer.cancel(S.Timer); S.Timer = nil
                end
 
        end
 
        Group.Thumb:addEventListener( "touch", Group.onDrag )
 
        return Group
 
end