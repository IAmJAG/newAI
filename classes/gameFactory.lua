local gameFactory = {}
gameFactory.__index = gameFactory

local gr = require('gameResource')
local gu = require('gameUtility')
local rgn = require('region')
local pat = require('pattern')

local resources = {
	"ENERGY",
	"BOOSTPOINTS"
}

function gameFactory.create()
   local factory = {}             -- our new object
   setmetatable(factory,gameFactory) 
	 
	 factory = gu:addType('gameFactory', factory)
   return factory
end

function gameFactory:createResources()
	local RESOURCES	= {}
	local pttrn			= pat.create('slash.pttrn.png')
	
	for i, resName in pairs(resources) do
		local file = scriptPath() .. 'data/' .. resName:lower() .. ".json"
		RESOURCES[resName] = gu:readJSON(file, gr.create())
	end
	return RESOURCES
end

return gameFactory