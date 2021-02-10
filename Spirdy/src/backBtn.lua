local M = {}

local backBtn
local btnSel

M.backBtn = function()
  
end

M.modeSel = function()
  backBtn = display.newImageRect("modeSelect/mode_back.png", 60, 60)
  btnSel = display.newImageRect("buttonSel.png", 60, 60)
  
  backBtn.x = 30
  backBtn.y = 25
  backBtn.alpha = 0

  btnSel.x = 30
  btnSel.y = 25
  btnSel.alpha = 0
  
  transition.to(backBtn, {delay = 2000, time = 2000, alpha = 1})
  transition.to(btnSel, {delay = 3000, alpha = 1})
  
end

M.levelSel = function()
  transition.to(btnSel, {delay = 3000, alpha = 1})
end

M.playerSel = function()
  transition.to(btnSel, {delay = 3000, alpha = 1})
end

M.remove = function()

end

return M