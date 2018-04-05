local gameMode = {}
gameMode.__index = gameMode

local ogu = require('gameUtility')
local odi	= require('dictionary')

function gameMode.create()
	local mode = {}
	setmetatable(mode, gameMode)	
	mode.Name			= ''
	mode.tasks		= odi.create('task')
	mode.patterns	= odi.create('pattern')
	mode = ogu:addType('gameMode', mode)
	return mode
end

function gameMode:initialize(name)
	self.Name = name
end

function gameMode:addTask(key, tsk, entryImage)
	self.tasks:add(key, tsk)
	if entryImage then 
		self.patterns:add(key, entryImage)
	end
end

function gameMode:removeTask(key)
	self.tasks:remove(key)
	self.patterns:remove(key)
end

function gameMode:getTask(key)
	return self.task[key]
end

function gameMode:getEntryPoint()
	local k = nil
	for key, pat in ipairs(self.patterns) do
		if pat:exist() then
			k = key
			break
		end
	end
	return k
end
return gameMode