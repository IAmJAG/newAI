local gameMode = {}
gameMode.__index = gameMode

local ogu = require('gameUtility')
local odi	= require('dictionary')
local opa = require('pattern')

function gameMode.create(name)
	local mode = {}
	setmetatable(mode, gameMode)	
	mode.Name						= name or ''
	mode.tasks					= odi.create('task')
	mode.patterns				= odi.create('pattern')
	mode.dateCompleted	= nil
	mode.timeResume 		= ogu:ms()
	mode = ogu:addType('gameMode', mode)
	
	return mode
end

function gameMode:suspend(timeout)
	self.timeResume = timeout
end

function gameMode:IsSuspended()
	return self.timeResume <= ogu:ms()
end

function gameMode:complete()
	self.dateCompleted = os.date("%Y%m%d")
end

function gameMode:IsCompleted()
	return self.dateCompleted < os.date("%Y%m%d")
end

function gameMode:canRun()
	return (not self:IsCompleted()) and (not self:IsSuspended())
end

function gameMode:initialize(name)
	self.Name = name
end

function gameMode:addTask(key, tsk, entryImage)
	self.tasks:add(key, tsk)	
	if entryImage ~= nil then 
		trace('Creating entry image')
		local pat = opa.create(key)
		pat:initialize(entryImage)
		self.patterns:add(key, pat)
	end
end

function gameMode:removeTask(key)
	self.tasks:remove(key)
	self.patterns:remove(key)
end

function gameMode:getTask(key)
	return self.tasks[key]
end

function gameMode:getEntryPoint()
	local k = nil
	for key, pat in pairs(self.patterns) do
		if pat['Type'] ~= nil then
			if pat.Type == 'pattern' then
				if pat:exists() then
					k = key
					break
				end
			end
		end
	end
	return k
end

return gameMode