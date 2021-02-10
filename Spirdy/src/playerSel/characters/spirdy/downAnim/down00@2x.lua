-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
	local physics = { data =
	{ 
		
		["down00@2x"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   49.5, -140.5  ,  25.5, -149.5  ,  44.5, -166.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -15.5, -145.5  ,  70.5, -101.5  ,  -25.5, -136.5  ,  -31.5, -148.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -99.5, -45.5  ,  -64.5, -50.5  ,  -79.5, 5.5  ,  -126.5, -18.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -65.5, 57.5  ,  -57.5, 107.5  ,  -63.5, 138.5  ,  -76.5, 135.5  ,  -106.5, 82.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   95.5, 19.5  ,  58.5, 15.5  ,  89.5, 1.5  ,  127.5, -13.5  ,  128.5, 11.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   64.5, -13.5  ,  72.5, -39.5  ,  93.5, -39.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   64.5, -13.5  ,  56.5, 7.5  ,  -62.5, 45.5  ,  48.5, -54.5  ,  72.5, -39.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   56.5, -75.5  ,  68.5, -94.5  ,  82.5, -95.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -2.5, 149.5  ,  -38.5, 113.5  ,  -65.5, 57.5  ,  7.5, 113.5  ,  8.5, 148.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   25.5, -149.5  ,  -15.5, -145.5  ,  23.5, -161.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   70.5, -101.5  ,  -15.5, -145.5  ,  25.5, -149.5  ,  49.5, -140.5  ,  70.5, -119.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -65.5, 57.5  ,  -38.5, 113.5  ,  -57.5, 107.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   127.5, -13.5  ,  89.5, 1.5  ,  112.5, -16.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -64.5, -50.5  ,  -34.5, -73.5  ,  70.5, -101.5  ,  68.5, -94.5  ,  56.5, -75.5  ,  -62.5, 45.5  ,  -79.5, 5.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -25.5, -136.5  ,  70.5, -101.5  ,  -34.5, -73.5  ,  -41.5, -98.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   7.5, 113.5  ,  -65.5, 57.5  ,  34.5, 51.5  ,  25.5, 105.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -65.5, 57.5  ,  -62.5, 45.5  ,  56.5, 7.5  ,  34.5, 51.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   48.5, -54.5  ,  -62.5, 45.5  ,  56.5, -75.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   68.5, 1.5  ,  58.5, 15.5  ,  56.5, 7.5  ,  64.5, -13.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 0, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   89.5, 1.5  ,  58.5, 15.5  ,  68.5, 1.5  }
                    }
                    
                    
                    
		}
		
	} }

        -- apply scale factor
        local s = scale or 1.0
        for bi,body in pairs(physics.data) do
                for fi,fixture in ipairs(body) do
                    if(fixture.shape) then
                        for ci,coordinate in ipairs(fixture.shape) do
                            fixture.shape[ci] = s * coordinate
                        end
                    else
                        fixture.radius = s * fixture.radius
                    end
                end
        end
	
	function physics:get(name)
		return unpack(self.data[name])
	end

	function physics:getFixtureId(name, index)
                return self.data[name][index].pe_fixture_id
	end
	
	return physics;
end

return M

