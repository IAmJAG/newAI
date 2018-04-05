local gameAgent = {}
gameAgent.__index = gameAgent

local gf = require('gameFactory')
local gu = require('gameUtility')
local pa = require('pattern')

function gameAgent.create()
	local ga = {}
	setmetatable(ga, gameAgent)
	local scrPath	= scriptPath()
	
	ga.Name						= ''
	ga.scriptPath			= scrPath
	ga.imagePath			= scrPath .. 'images'
	ga.OCRPath				= scrPath .. 'OCRImages'
	ga.OCRImage				= 'thunder'
	ga.RESOURCES			= gf.createResources()
	ga.BotScriptPath	= ''
	ga.EndCondition		= nil
	
	ga.gameActions = {
		Click 			= "click",
		Wait				= "wait",
		WaitPattern	= "waitpattern"
	}
	
	ga = gu:addType('gameAgent', ga)
	return ga
end

function gameAgent:loadScript()
	local scriptFile = self:getScriptFullPath()
	if gu:fileExist(scriptFile) then
		self.Script = gu:readJSON(scriptFile)
	else
		self.Script = {Patterns = {}, Actions = {}}		
	end
end

function gameAgent:addPattern(fName)
	if self.Script.Patterns[fName] == nil then
		local pat = pa.create()
		pat:intialize(fName)
		self.Script.Patterns[fName] = pa
	else
		Debug('Pattern ' .. fName .. ' already exist!')
	end
end

function gameAgent:getScriptFullPath()
	return self.BotScript .. '\' .. self.Name
end

function gameAgent:setBotScriptPath(path)
	self.BotScript = path
end

function gameAgent:setImagePath(path)
	setImagePath(path)
	trace('Image path changed to ' .. path)
	self.imagePath = path
end

function gameAgent:setOCRImagePath(path)
	self.OCRPath = path
	trace('OCR image path changed to ' .. path)
end

function gameAgent:setAgentName(name)
	self.name = name
end

function gameAgent:getResource(name)
	return self.RESOURCES[name]:getValue()
end

function gameAgent:IntializeResources(resources)
	for name, res in ipairs(resources) do
		if res:IntializeValue() then
			trace(name .. ' is ' .. res:getValues())
		else
			trace(name .. ' intialize failed.')
		end
	end
end

return gameAgent