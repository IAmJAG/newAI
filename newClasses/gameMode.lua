local gameMode = {}
gameMode.__index = gameMode

local ogu = require('gameUtility')
local odi	= require('dictionary')

function gameMode.create()
	local mode = {}
	setmetatable(mode, gameMode)	
	mode.tasks		= odi.create('task')
	mode.patterns	= odi.create('pattern')
	mode = ogu:addType('gameMode', mode)
	return mode
end

function gameMode.addTask(key, tsk, entryImage)
	self.tasks:add(key, tsk)
	if entryImage then 
		self.patterns:add(key, entryImage)
	end
end

function gameMode.removeTask(key)
	self.tasks:remove(key)
	self.patterns:remove(key)
end

return gameMode