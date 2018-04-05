local profile = {}
profile.__index = profile

local ogu = require('gameUtility')
local odi = require('dictionary')

local currentMode = nil

function profile.create()
	local prof = {}
	setmetatable(prof, profile)
	
	local scrPath	= scriptPath()
	
	prof.Name		= ''
	prof.Modes	= odi.create('script')
	
	prof = ogu:addType('Profile', prof)
	return prof
end

function profile:getNextMode()
	currentMode = currentMode or mods
end

return profile

local nextMode = profile.Modes:getFirst()
while nextMode:isJumpAllowed() do	
	nextMode:save()
	nextMode = profiles.Modes:getNext()
end

local recommendEnd
while nextMode do	
	local key = nextMode:getEntryPoint()
	local task = nextMode:getTask(key)
	while task do
		task = nextMode:getTask(task:execute(profile))
	end
	
	while nextMode:isJumpAllowed() do	
		nextMode:save()
		nextMode = profiles.Modes:getNext()
	end
end