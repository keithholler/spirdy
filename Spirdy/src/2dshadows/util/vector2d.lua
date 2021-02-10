Vector2D = {}

local math_sqrt = math.sqrt

function Vector2D:new(x, y)  
  local object = { x = x or 0, y = y or 0 }
  setmetatable(object, { __index = Vector2D })  
  return object
end
 
function Vector2D:copy()
   return Vector2D:new(self.x, self.y)
end
 
function Vector2D:magnitude()
   return math_sqrt(self.x^2 + self.y^2)
end
 
function Vector2D:normalize()
   local temp
   temp = self:magnitude()
   if temp > 0 then
      self.x = self.x / temp
      self.y = self.y / temp
   end
end
 
function Vector2D:limit(l)
   if self.x > l then
      self.x = l     
   end
   
   if self.y > l then
      self.y = l     
   end
end
 
function Vector2D:equals(vec)
   if self.x == vec.x and self.y == vec.y then
      return true
   else
      return false
   end
end
 
function Vector2D:add(vec)
   self.x = self.x + vec.x
   self.y = self.y + vec.y
end
 
function Vector2D:sub(vec)
   self.x = self.x - vec.x
   self.y = self.y - vec.y
end
 
function Vector2D:mult(s)
   self.x = self.x * s
   self.y = self.y * s
end
 
function Vector2D:div(s)
   self.x = self.x / s
   self.y = self.y / s
end
 
function Vector2D:dot(vec)
   return self.x * vec.x + self.y * vec.y
end
 
function Vector2D:dist(vec2)
   --return math_sqrt( (vec2.x - self.x) + (vec2.y - self.y) )
   dx = (vec2.x - self.x)
   dy = (vec2.y - self.y)
   return math_sqrt( dx*dx + dy*dy )
end
 
-- Class Methods
 
function Vector2D:NormalA(vec)
  local tempVec = Vector2D:new(0,0)
  tempVec.x = vec.y * (-1)
  tempVec.y = vec.x
  return tempVec
end

function Vector2D:NormalB(vec)
  local tempVec = Vector2D:new(0,0)
  tempVec.x = vec.y
  tempVec.y = vec.x * (-1)
  return tempVec
end

function Vector2D:Normalize(vec) 
   local tempVec = Vector2D:new(vec.x,vec.y)
   local temp
   temp = tempVec:magnitude()
   if temp > 0 then
      tempVec.x = tempVec.x / temp
      tempVec.y = tempVec.y / temp
   end
   
   return tempVec
end
 
function Vector2D:Limit(vec,l)
   local tempVec = Vector2D:new(vec.x,vec.y)
   
   if tempVec.x > l then
      tempVec.x = l     
   end
   
   if tempVec.y > l then
      tempVec.y = l     
   end
   
   return tempVec
end
 
function Vector2D:LimitMagnitude(vec, max)
    local tempVec = Vector2D:new(vec.x, vec.y)
    local lengthSquared = tempVec.x * tempVec.x + tempVec.y * tempVec.y
    if lengthSquared > max * max and lengthSquared > 0 then
        local ratio = max / math_sqrt(lengthSquared)
        tempVec.x = tempVec.x * ratio
        tempVec.y = tempVec.y * ratio
    end

    return tempVec
end

function Vector2D:Add(vec1, vec2)
   local vec = Vector2D:new(0,0)
   vec.x = vec1.x + vec2.x
   vec.y = vec1.y + vec2.y
   return vec
end
 
function Vector2D:Sub(vec1, vec2)
   local vec = Vector2D:new(0,0)
   vec.x = vec1.x - vec2.x
   vec.y = vec1.y - vec2.y
   
   return vec
end
 
function Vector2D:Mult(vec, s)
   local tempVec = Vector2D:new(0,0)
   tempVec.x = vec.x * s
   tempVec.y = vec.y * s
   
   return tempVec
end
 
function Vector2D:Div(vec, s)
   local tempVec = Vector2D:new(0,0)
   tempVec.x = vec.x / s
   tempVec.y = vec.y / s
   
   return tempVec
end

-- ----------------------------------------------------------------
-- Manhattan - Fast but innacurate distance heuristic
function Vector2D:DistManhattan(vec1, vec2)
   dx = math.abs((vec2.x - vec1.x))
   dy = math.abs((vec2.y - vec1.y))
   return dx + dy
end

-- ----------------------------------------------------------------
-- distEuclidianSquared - Fast semi-accurate distance heuristic. 
-- The only issue with this one is it treats distances as the square of itself.
function Vector2D:DistEuclidianSquared(vec1, vec2)
   dx = (vec2.x - vec1.x)
   dy = (vec2.y - vec1.y)
   return ((dx*dx) + (dy*dy))
end

-- ----------------------------------------------------------------
-- Euclidian - Slow but accurate distance heuristic
function Vector2D:Dist(vec1, vec2)
   dx = (vec2.x - vec1.x)
   dy = (vec2.y - vec1.y)
   return math_sqrt( dx*dx + dy*dy )
end

function Vector2D:Draw( _radius )
  display.newCircle( self.x, self.y, _radius or 2 )
end

return Vector2D