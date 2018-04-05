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

function profile:getNextRunableMode(mod)
	local mod = self.Modes:getNext(mod)
	local last = false
	while not mod:canRun() do
		mod = self.Modes:getNext(mod)
		if mod == nil then 
			break 
		end
	end
	return mod
end

return profile

local nextMode = profile:getNextRunableMode()
while nextMode do	
	local key = nextMode:getEntryPoint()
	local task = nextMode:getTask(key)
	while task do
		task = nextMode:getTask(task:execute(profile))
	end
	
	nextMode, isLast = profiles:getNextRunableMode(nextMode)
end