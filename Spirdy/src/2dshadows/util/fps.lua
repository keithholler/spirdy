-------------------------------------------------
--
-- fps.lua
--
-- FPS Module
--
-- Shows frames per second with smooth average (not so jumpy)
-- and optional memory usage 
--
-- Usage: put the following two lines in your main.lua
--
-- local FPS = require('util.fps')
-- local fps = FPS:new()
--
-- to show memory usage use true as first parameter:
-- local fps = FPS:new( true )
--
-- to change size of avergae smoothnes of the FPS counter use second parameter
-- local fps = FPS:new( true, 25 )
-- this will calculate the average time of 25 frames (default is 50)
--
-------------------------------------------------
 

local math_floor        = math.floor
local system_getInfo    = system.getInfo
local system_getTimer   = system.getTimer
local string_format     = string.format
local _collectgarbage   = collectgarbage
local timer_performWithDelay = timer.performWithDelay


local FPS = {}


-------------------------------------------------
-- CONSTRUCTOR
-- FPS:new( pShowMem, pFPSAvg )
-------------------------------------------------
function FPS:new( pShowMem, pFPSAvg )

    local fps               = display.newGroup( )
    fps.x = 10
    fps.y = 10

    fps.text                = display.newText('FPS',10,0, native.systemFont, 14);
    fps.text:setFillColor(1)
    fps.text.anchorX        = 0
    fps.text.anchorY        = 0
    fps:insert( fps.text )

    fps.deltaTimes          = {}                    -- store an amount of deltatTimes to calc smooth average
    fps.deltaTimeCounter    = 0                     -- neede for iterating the smooth average values table
    fps.fps                 = 0                     -- the current fps value
    fps.avgSize             = pFPSAvg or 50         -- size of averages
    fps.showMemUsage        = pShowMem or false     -- if the mem usage should be shown too


    -----------------------------------------------------------------------------
    -- fps:Update( event )
    -----------------------------------------------------------------------------
    function fps:Update( event )
        local curTime = system_getTimer()

        self.deltaTimeCounter = self.deltaTimeCounter + 1

        self.deltaTimes[self.deltaTimeCounter] = curTime

        if self.deltaTimeCounter == self.avgSize then 
            local avg = 0
            for i=1,self.deltaTimeCounter-1 do
                local delta = self.deltaTimes[i+1] - self.deltaTimes[i]
                avg = avg + delta
            end
            avg = avg / self.deltaTimeCounter
            self.fps = math_floor( 1000 / avg )
            self.deltaTimeCounter = 0
        end

        self.text.text = self.fps .. " FPS"
        if self.showMemUsage == true then
            self.text.text = self.text.text .. " | " .. self:MemUsage()
        end
    end

    
    -----------------------------------------------------------------------------
    -- fps:MemUsage()
    -----------------------------------------------------------------------------
    function fps:MemUsage()          
        local memUsed = ( _collectgarbage("count") ) / 1000
        local texUsed = system_getInfo( "textureMemoryUsed" ) / 1000000
        
        local result = "Mem: " .. string_format("%.03f", memUsed) .. " MB | TexMem: " .. string_format("%.03f", texUsed) .. " MB"
         
        return result
    end




    -----------------------------------------------------------------------------
    -- fps:timer( event )
    -----------------------------------------------------------------------------
    function fps:timer( event )
        self:Update( event )
    end
    local tm = timer_performWithDelay( 1, fps, 0 )

    return fps
end

return FPS