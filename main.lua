scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "classes/?.lua"
package.path = package.path .. ";" .. scrptPth .. "?.lua"

_G.__addLogger = dofile(scrptPth .. 'classes/logger.lua')
_G:__addLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))	

setImagePath(scrptPth .. 'images')
local gu = require('gameUtility').create()
gu:ShowStatusBar()
gu:Status('Create pattern list')

local imgList = gu:scanDirectory(scriptPath() .. 'images', "png")
local patList = {}
local pat = require('pattern')
for i, x in pairs(imgList) do
	local xx = x:gsub(scriptPath() .. 'images/', '')
	local p  = pat.create()
	p:initialize(xx)
	patList[#patList+1] = p
	gu:Status(xx)
end

--patList = require("gameAgent").create()
gu:saveJSON(patList, scriptPath() .. 'data/patterns.json')

-- while true 
	-- wait(1)
-- end