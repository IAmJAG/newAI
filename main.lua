-- read Settings

scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"

require 'initialize'

setImagePath(scrptPth .. 'images')

local profile = {}

randomStatus()
function profile:click(pslr, to)
	to = to or 0
	pslr:click()
	local tcks = oGU:ms() + to
	while oGU:ms() <= tcks do
	end
	return true
end

randomStatus()
function profile.wait(pslr, to)
	to = to or 500
	local tcks = oGU:ms() + to
	trace('wait for' .. to .. ' ms')
	while oGU:ms() <= tcks do
	end
	return true
end

randomStatus()
oGU = require('gameUtility').create()

--settrace(OFF)
local opa = require('pattern')
local olo = require('location')
local otk = require('task')
local otk = require('task')
randomStatus()
local mod = oGU:readJSON(oGU.scriptPath .. 'data/storyMode.json', 'gameMode')
--settrace(ON)

Status('Running bot')

-- local tsk1 = otk.create('wait')
-- -- local pat = opa.create('co-opplay.pat.png')
-- -- tsk1.pslr = opa.create('waitCoop')
-- tsk1.timeOut = 2000

-- -- -- local tsk2= otk.create('click')
-- -- -- pat = opa.create('co-opplay.pat.png')
-- -- -- tsk2.pslr = oGU:patternToLocation(pat)

-- mod:addTask('waitCoop', tsk1)
-- -- mod:addTask('co-opplay.pat.png', tsk2, 'co-opplay.pat.png')

-- oGU:saveJSON(mod, oGU.scriptPath .. 'data/storyMode.json')
-- -- scriptExit()

local key = mod:getEntryPoint()
Status('Got first key ' .. key)
local task = mod:getTask(key)
trace(key)
Status('Execute Task')
while task ~= nil do
	task = mod:getTask(task:execute(profile))
end
Status('Execute Task')

Status('NOt Saving mode...')
--oGU:saveJSON(mod, oGU.scriptPath .. 'data/storyMode.json')

wait(5)