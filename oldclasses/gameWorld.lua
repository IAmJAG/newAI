local gameworld = {}
gameworld.__index = gameworld

local gu = require('gameUtility')

function gameworld.create()
	local gw = {}
	setmetatable(gw, gameworld)
	
	gw = gu:addType('gameWorld', gw)
	return gw
end

function gameworld:train(agent)
	
end

function gameWorld:Execute(agent)
	agent.loadScript()
	local nextAct
	
	for p, pat in ipairs(agent.Script.Patterns)
		if pat:exist() then
			nextAct = agent.Script.Patterns[p]
			break
		end
	end
	
	while nextAct do
		local result = nextAct:execute()
		if result then
			nextAct = agent.Script.Actions[nextAct.right]
		else
			nextAct = agent.Script.Actions[nextAct.left]
		end
	end
end