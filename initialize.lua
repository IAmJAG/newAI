-- Settings and Loaders

local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "classes/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"

ShowStatusBar()
_oGU = require('gameUtility').create()
require('statusBar')

randomStatus()
_G.__addLogger = dofile(scrptPth .. 'classes/logger.lua')
_G:__addLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))	

randomStatus()