
local group = {}

-- Create timer and add it to the table
function timer:createTimer(delay, listener, iterations)

	local id = null

	id = timer.performWithDelay( delay, listener, iterations )

	table.insert(group,id)

	-- Garbage Collection
	if iterations ~= nil and iterations ~= 0 then
		timer.performWithDelay( delay*iterations+100, function(self)
			timer:destroyTimer(id)
		end, 1 )
	end

	return id

end

-- Find ID of timer in table and destroy it
function timer:destroyTimer(id)

	for i=1, table.maxn(group), 1 do
		if group[i] == id then
			timer.cancel(id)
			table.remove(group,i)
			return true
		end
	end

	return false

end

function timer:flushAllTimers()
	
	for i=table.maxn(group), 1, -1 do
		timer.cancel(group[i])
		table.remove(group,i)
	end

end

function group.timer:pauseAllTimers()

	for i=1, table.maxn(group), 1 do
		timer.pause(group[i])
	end

end

function timer:resumeAllTimers()

	for i=1, table.maxn(group), 1 do
		timer.resume(group[i])
	end

end

return group

---- Uncomment this to see the total number of timer objects in the table
--timer.performWithDelay( 1000, function(self)
-- 		print(table.maxn(group))
-- 	end, 0 )