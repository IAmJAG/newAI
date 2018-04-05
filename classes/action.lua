local action={}
action.__index		=	action

function action:Initialize(agent, resetAction)
	self.reset				= resetAction
	self.agent				= agent
end

function action.create()
	local act={}
	setmetatable(act,action)
	act.left				=	nil
	act.right				= nil
	act.command			= ''
	act.pslr				= nil
	act.timeOut			= nil
	return act
end

function action:execute()
	if self.agent[self.command]==nil then
		error('command '.. self.command .. ' does not exist')
		return false
	end
	return self.agent[self.command](self.agent, self.pslr, self:timeOut)
end

function action:setLeftBranch(child)
	self.left = child
end

function action:setRightBranch(child)
	self.right = child
end

return action