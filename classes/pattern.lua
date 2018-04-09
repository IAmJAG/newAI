local pattern = {}
pattern.__index = pattern

local ogu = require('gameUtility')

function pattern.create(fileName)
	local pat = {}
	setmetatable(pat, pattern)
	
	local scr = getAppUsableScreenSize()
	pat.x = 0
	pat.y = 0
	pat.w = scr:getX()
	pat.h = scr:getY()
	pat.fileName 	= fileName or ''
	pat.PATINDEX	= -1
	pat.RGNINDEX	= -1
	
	pat = ogu:addType('pattern', pat)
	return pat
end

function pattern:initialize(fname, x, y, w, h)
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
		if _G['PATTERNS'] == nil then
			_G['PATTERNS'] = {}
		end
		
		if self.PATINDEX == -1 then
			PATTERNS[#PATTERNS +1] = Pattern(self.fileName)
			self.PATINDEX = #PATTERNS
		end
		
		return PATTERNS[self.PATINDEX]
	end	
end

function pattern:getRegion()
	trace(string.format('Get Region with x=%d, y=%d, w=%d, h=%d', self.x, self.y, self.w, self.h))
	if _G['REGIONS'] == nil then
		_G['REGIONS'] = {}
	end
	
	if self.RGNINDEX == -1 then
		REGIONS[#REGIONS +1] = Region(self.x, self.y, self.w, self.h)
		self.RGNINDEX = #REGIONS
	end
	
	return REGIONS[self.RGNINDEX]
end

function pattern:click()
	local rgn 	= self:getRegion()
	local pat 	= self:getPattern()	
	rgn:click(pat)
	local match = rgn:getLastMatch()
	if match:getH() ~= self.h or match:getW() ~= self.w then
		self.x = match:getX()
		self.y = match:getY()
		self.w = match:getW()
		self.h = match:getH()
	end
end

function pattern:exists()
	local rgn 	= self:getRegion()
	local exsts 	= rgn:exists(self.fileName)
	
	if exsts then
		local match = rgn:getLastMatch()
		if match:getW() ~= self.w or match:getH() ~= self.h then
			self.x = match:getX()
			self.y = match:getY()
			self.w = match:getW()
			self.h = match:getH()
		end
	end
	
	return exsts
end

return pattern