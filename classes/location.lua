local location = {}
location.__index = location

local gu = require('gameUtility')

function location.create()
	local loc = {}
	setmetatable(loc, location)
	
	loc.x = 0
	loc.y = 0
	
	loc = gu:addType('location', loc)
	return loc
end

function location:initialize(x, y)
	self.x = x
	self.y = y
end

function location:getLocation()
	return Location(x, y)
end

function location:click()
	local loc = self:getLocation()
	click(loc)
end

function location:getX()
	return self.x
end

function location:getY()
	return self.y
end

return location