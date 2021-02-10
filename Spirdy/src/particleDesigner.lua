local particleDesigner = {}

local json = require "json"
local emitter
particleDesigner.loadParams = function( filename, baseDir )

	-- load file
	local path = system.pathForFile( filename, baseDir )

	local f = io.open( path, 'r' )

	local data = f:read( "*a" )
	f:close()

	-- convert json to Lua table
	local params = json.decode( data )

	return params
end

particleDesigner.newEmitter = function( filename, baseDir )

	local emitterParams = particleDesigner.loadParams( filename, baseDir )

  emitter = display.newEmitter( emitterParams )

	return emitter
end

particleDesigner.remove = function()
  emitter:removeSelf()
  emitter = nil
end

return particleDesigner
