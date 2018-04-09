--================ Image Sequence Processor ===============
local ISP = {}
ISP.__index = ISP

function ISP.create()
	local isp = {} 
	setmetatable(isp, ISP)
	
	isp.dateCompleted	= nil
	isp.suspended			= false
	isp.activities		= {}
	
	return isp
end

function ISP:Initialize(profile)
	
end

function ISP:complete()
	self.dateCompleted = os.date("%Y%m%d")
end

function ISP:suspend()
	self.suspended = true
end

function ISP:isSuspended()
	return self.suspended
end

function ISP:isComplete()
	return self.dateCompleted == os.date("%Y%m%d")
end
