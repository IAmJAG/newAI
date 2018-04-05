local pattern = {}
pattern.__index = pattern

local ogu = require('gameUtility')

function pattern.create()
	local pat = {}
	setmetatable(pat, pattern)
	
	local scr = getAppUsableScreenSize()
	pat.x = 0
	pat.y = 0
	pat.w = scr:getX()
	pat.h = scr:getY()
	pat.fileName 	= ''
	
	pat = ogu:addType('pattern', pat)
	return pat
end

function pattern:intialize(fname, x, y, w, h)
	local scr = getAppUsableScreenSize()
	self.fileName = fname
	self.x 				= x or 0
	self.y 				= y or 0
	self.w 				= w or scr:getX()
	self.h 				= h or scr:getY()
end

function pattern:setRegion(x, y, w, h)
	local scr = getAppUsableScreenSize()
	self.x 				= x or 0
	self.y 				= y or 0
	self.w 				= w or scr:getX()
	self.h 				= h or scr:getY()
end

function pattern:getPattern()
	if self.fileName == '' then
		Debug('Pattern is not initialized')
		return nil
	else
		return Pattern(self.fileName)
	end	
end

function pattern:getRegion()
	return Region(x, y, w, h)
end

function pattern:exist()
	local rgn = self:getRegion()
	return rgn:exist(self.fileName)
end

return pattern