--- Status Bar

-- creating statusBar
local statusBar = UI:new(style)		
statusBar:add("status")
statusBar.status.position = "bottom=5%|left=5"

statusBar.status.width = "99%"
statusBar.status.height = "90%"

-- colors defined on uiconfig
statusBar.status.background = "gray_light"
statusBar.status.color = "white"
statusBar.status.font_size = "30%"

_G['statusBar']	= statusBar

function ShowStatusBar()
	_G.statusBar:showAll()
end

function Status(msg)
	--self.statusBar.status:hide()
	_G.statusBar.status.text = msg
	_G.statusBar.status:show()
end

function randomStatus()
	if _G['RNDMMSG'] == nil then
		_G['RNDMMSG'] = _oGU.readJSON(scriptPath() .. 'data/randomMessages.json')
	end
	
	local rndmsg = math.random(1, #RNDMMSG)
	Status(RNDMMSG[rndmsg])
end