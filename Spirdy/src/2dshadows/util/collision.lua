local math_sqrt = math.sqrt

local Collision = {}


-----------------------------------------------------------------------------
-- HasCollidedRect( obj1, obj2 )
-- Check if the rectangle boundaries of two objects do overlap
-----------------------------------------------------------------------------
function Collision:HasCollidedRect( obj1, obj2 )
    if ( obj1 == nil ) then  --make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  --make sure the other object exists
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

    return (left or right) and (up or down)
end


-----------------------------------------------------------------------------
-- HasCollidedCircle( obj1, obj2 )
-- Check if the circle boundaries of two objects do overlap
-----------------------------------------------------------------------------
function Collision:HasCollidedCircle( obj1, obj2 )
   if ( obj1 == nil ) then  --make sure the first object exists
      return false
   end
   if ( obj2 == nil ) then  --make sure the other object exists
      return false
   end

   local dx = obj1.x - obj2.x
   local dy = obj1.y - obj2.y

   local distance = math_sqrt( dx*dx + dy*dy )
   local objectSize = (obj2.contentWidth * 0.5) + (obj1.contentWidth * 0.5)

   if ( distance < objectSize ) then
      return true
   end
   return false
end


-----------------------------------------------------------------------------
-- HasCollidedPointInRect( px, py, obj )
-- Check if the rectangle boundaries of two objects do overlap
-----------------------------------------------------------------------------
function Collision:HasCollidedPointInRect( px, py, obj )
    if ( obj == nil ) then  --make sure the first object exists
        return false
    end

    local horizontal = px >= obj.contentBounds.xMin and px <= obj.contentBounds.xMax
    local vertical = py >= obj.contentBounds.yMin and py <= obj.contentBounds.yMax

    return horizontal and vertical
end


return Collision
