local gamemode = {}
gamemode.__index = gamemode

local gu = require('gameUtility')
local reg = require('region')

function gamemode.create()
	local gm = {}
	setmetatable(gm, gamemode)
	
	md.Name						= ''
	md.dateCompleted	= os.date("%Y%m%d")
	md.resumeTime			= 0
	
	md = gu:addType('gameMode', md)
	return md
end

function gamemode:setModeName(name)
	self.Name	= name
end

function gamemode:comepleted()
	return self:dateCompleted	== os.date("%Y%m%d")
end

function gamemode:complete()
	self.dateCompleted = os.date("%Y%m%d")
end

function gamemode:suspended()
	return gu:ms() <= self.resumeTime
end

function gamemode:suspend(t)
	t = t or 5000 -- Suspension defualt time -- 5mintues
	self.resumeTime = gu:ms() + t
end

return gamemode