--Localise the maths vars.
local mPi = math.pi
local mS = math.sin
local mC = math.cos
local function makeCircle( startPointXY, endPointXY, degreesStart, degreesEnd, yScale, xScale, value)
	local xy = {} --Holds the points we make.
	local distance = endPointXY[1] - startPointXY[1] --The radius

	--Sets the scales if needed.
	if yScale == nil then yScale = 1 end
	if xScale == nil then xScale = 1 end
	if value == nil then value = 2 end

	--Changes the direction of the path if needed.
	if degreesEnd < degreesStart then 
		value = -value 
	end

	--Now create the circlular path!
	local i 
	for i=degreesStart, degreesEnd, value do
		local radians = i*(mPi/180)
		local x = (endPointXY[1] + ( distance * mS( radians ) )*xScale) 
		local y = (endPointXY[2] + ( distance * mC( radians ) )*yScale) 
		xy[#xy+1] = {x, y}

		--Display a circle to show you the path your making.
		local circle = display.newCircle(0,0,1)
		circle.x = x; circle.y = y; circle:setFillColor(255,60,60)	
	end

	--Return the array.
	return xy
end

--Plug in the needed variables. 
--You could also do the yScale, xScale and value but that doesnt need to be put in.
local waypoints = makeCircle(  {20,400}, {320,400}, 0, 360)

--Now we are going to move a circle around that path.....
--FIrst create the circle
local circle = display.newCircle(0,0,5)

--Then create the gameLoop function which will run every frame.
local int = 1
local function gameLoop()
	if int <= #waypoints then
		circle.x = waypoints[int][1]
		circle.y = waypoints[int][2]
		int = int + 1
	else 
		int = 1
	end
end
Runtime:addEventListener("enterFrame", gameLoop)