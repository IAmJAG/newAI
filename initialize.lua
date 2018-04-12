-- Settings and Loaders

local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "classes/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"

_G.__addLogger = dofile(scrptPth .. 'utilities/logger.lua')
_G:__addLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))	

require 'statusBar'
require 'require'

local oGU = require('gameutility').create()

function randomStatus()
	if _G['RNDMMSG'] == nil then
		_G['RNDMMSG'] = oGU:readJSON(scriptPath() .. 'data/randomMessages.json')
	end
	
	local rndmsg = math.random(1, #RNDMMSG)
	trace('RAndom message ' .. RNDMMSG[rndmsg] .. ' from ' .. rndmsg)
	Status(RNDMMSG[rndmsg])
end

ShowStatusBar()
randomStatus()
wait(5)