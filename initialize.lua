-- Settings and Loaders

local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "classes/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"

_G.__addLogger = dofile(scrptPth .. 'utilities/logger.lua')
_G:__addLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))	

-- local oGU = require('gameutility').create()

-- local mu = {}

-- mu[#mu +1] = "Tap your fingers continuously on the table."
-- mu[#mu +1] = "Throw your phone."
-- mu[#mu +1] = "Call google."
-- mu[#mu +1] = "Ask for a refund"
-- mu[#mu +1] = "Pretend to be sleeping."
-- mu[#mu +1] = "Go get a cup of coffe."

-- oGU:saveJSON(mu, scrptPth .. 'data/randomMessages.json')
-- scriptExit()

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