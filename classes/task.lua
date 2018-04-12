local oGU	= require('gameutility')
local taskMeta={}
taskMeta.__index = taskMeta		
		
function taskMeta.create(cmd)
	local task={}
	setmetatable(task, taskMeta)
	task.LEFT			=	nil
	task.RIGHT		= nil
	task.command	= cmd or 'click'
	task.paramType= ''
	task.pslr			= nil
	task.region		= nil
	task.timeOut  = nil
	
	task = oGU:addType('task', task)
	return task
end

function taskMeta:execute(agent)
	if agent[self.command]==nil then
		error('command '.. self.command .. ' is not specified!')
		trace('assuming command is click')
		agent[self.command] = 'click'
	end
	local ticks = oGU:ms()
	trace('Executing ' .. self.command)
	local result = agent[self.command](agent, self.pslr, self.timeOut)
	Status('Executed ' .. self.command .. ' for ' .. oGU:ms() - ticks .. 'ms')
	if result then
		return self.RIGHT
	else
		return self.LEFT
	end
end

return taskMeta