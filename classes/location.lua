local xlocation = {}
xlocation.__index = xlocation

local gu = require('gameUtility')

function xlocation.create()
	local loc = {}
	setmetatable(loc, xlocation)
	
	loc.x = 0
	loc.y = 0

	loc.LOCINDEX = -1
	
	loc = gu:addType('location', loc)
	return loc
end

function xlocation:initialize(x, y)
	self.x = x
	self.y = y
end

function xlocation:getLocation()
	trace(string.format('Location x=%d, Location y=%d', self.x, self.y))
	_G['LOCATIONS'] = _G['LOCATIONS'] or {}
	
	if self.LOCINDEX == -1 then
		self.x = tonumber(self.x)
		self.y = tonumber(self.y)
		LOCATIONS[self.LOCINDEX] = Location(self.x, self.y)
		trace('Intialize location')
	end
	return LOCATIONS[self.LOCINDEX]
end

function xlocation:click()
	local loc = self:getLocation()
	trace('X of the loc ' .. loc:getX())
	click(loc)
end

function xlocation:getX()
	return self.x
end

function xlocation:getY()
	return self.y
end

return xlocation