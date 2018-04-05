local resource = {}
resource.__index = resource

local gu = require('gameUtility')
local reg = require('region')

function resource.create()
	local res = {}
	setmetatable(res, resource)
	
	res.NAME					= ''
	res.VALUE					= 0
	res.region				= nil
	res.separator			= nil
	res.validInterval	= 1500 --default check interval 
	res.lastCheck			= gu.ms() - (res.validInterval)
	res.ImagePrefix		= "pttrn.thunder0"
	res.OCRDir				= scriptPath() .. 'Images'
	res.ImageTrigger	= ''
	
	res = gu:addType('gameResource', res)
	return res
end

function resource:setImageCheckTrigger(fName)
	self.ImageTrigger = fName
end

function resource:setImagePrefix(preName)
	self.ImagePrefix = preName
end

function resource:setOCRImageDir(path)
	self.OCRDir = path
end

function resource:setRegion(x, y, w, h)
	self.region = Region(x, y, w, h)
end

function resource:setResourceName(name)
	self.NAME = name
end

function resource:setCheckInterval(chkIntrvl)
	self.validInterval = chkIntrvl
end

function resource:getSeparator()
	return self.separator:getFileName()
end

function resource:getValue()
	return self.VALUE
end

function resource:getName()
	return self.NAME
end

function resource:setSeparator(pttrn)
	self.separator = pttrn
end

function resource:IntializeValue(forced)
	local ticks = gu.ms()
	if ticks >= (self.lastCheck+self.validInterval) or forced then
		if self.separator==nil then
			self.localRGN = self.region
			return self:getResourceValue()
		else
			return self:getResourceWSprtrValue()
		end
	else
		local m = gu.ms() - self.lastCheck
		if m >= self.validInterval then
			return self.VALUE 
		end
	end
end

function resource:getResourceWSprtrValue()
	self.localRGN = nil
	if (self.region:exists(self.separator)) then
		mtch = self.region:getLastMatch()
		local r = reg.create()
		r:initialize(self.region:getX(), self.region:getY(), mtch:getX()-self.region:getX()+1, self.region:getH())
		self.localRGN = r		
		return self:getResourceValue()
	else
		Debug("Separator " .. self.separator:getFilename() .. " does not exists!")
		return nil
	end
end

function resource:getResourceValue()	
	local res = nil
	setImagePath(self.OCRDir)
	res = numberOCR(self.localRGN:getRegion(), self.ImagePrefix)
	self.VALUE = res or 0
	trace(self.NAME .. ": " .. self.VALUE)
	setImagePath(gu.imagePath)
	return res
end

return resource