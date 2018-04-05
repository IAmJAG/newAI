local region = {}
region.__index = region

local gu = require('gameUtility')

function region.create()
	local rgn = {}
	setmetatable(rgn, region)
	local scr = getAppUsableScreenSize()
	rgn.x = 0
	rgn.y = 0
	rgn.w = scr:getX()
	rgn.h = scr:getY()
	
	rgn = gu:addType('region', rgn)
	return rgn
end

function region:intialize(x, y, w, h)
	rgn.x = x
	rgn.y = y
	rgn.w = w
	rgn.h = h
end

function region:getRegion()
	return Region(x, y, w, h)
end

function region:click()
	local rgn = self:getRegion()
	rgn:click()
end

function region:save(fName)
	local rgn = self:getRegion()
	rgn:save(fName)
end

function region:exist(pat)
	local p = pat:getPattern()
	local rgn = self:getRegion()
	return rgn:exist(p)
end

function region:getX()
	return self.x
end

function region:getY()
	return self.y
end

function region:getW()
	return self.w
end

function region:getH()
	return self.h
end

return region