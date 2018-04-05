local oGU	= require('gameutility')

local taskMeta={}
taskMeta.__index = taskMeta		
		
function action.create()
	local task={}
	setmetatable(task, taskMeta)
	task.LEFT			=	nil
	task.RIGHT		= nil
	task.command	= 'click'
	task.pslr			= nil
	task.region		= nil
	task.timeOut  = nil
	return task
end

function taskMeta:execute(agent)
	if agent[self.command]==nil then
		error('command '.. self.command .. ' is not specified!')
		trace('assuming command is click')
		agent[self.command] = 'click'
	end
	return agent[self.command](agent, self.pslr, self:timeOut)
end

return action