
local Vector2D = require( "util.vector2d" )

Bezier = {}

function Bezier:CalculatePoint(_t, _p0, _p1, _p2, _p3)
  local u   = 1 - _t
  local tt  = _t*_t
  local uu  = u*u
  local uuu = uu * u
  local ttt = tt * _t
 
  local pr = Vector2D:new(_p0.x, _p0.y)
  local temp = Vector2D:new(0,0)

  -- pr = uuu * _p0
  pr:mult(uuu)
  -- pr = pr + 3 * uu * _t * _p1
  temp.x = _p1.x * 3 * uu * _t
  temp.y = _p1.y * 3 * uu * _t
  pr:add(temp)

  -- pr = pr + 3 * u * tt * _p2
  temp.x = _p2.x * 3 * u * tt
  temp.y = _p2.y * 3 * u * tt
  pr:add(temp)

  -- pr = pr + ttt * _p3
  temp.x = _p3.x * ttt
  temp.y = _p3.y * ttt
  pr:add(temp)

  return pr
end

return Bezier