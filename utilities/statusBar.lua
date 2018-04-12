--- Status Bar
dofile(scriptPath() .. "UI.luac")

local style = {
	width = "100%",
	height = "5%",
	position = "bottom|left",
	background = "black",
	color = "white",
	font_size = 20,
}

-- creating statusBar
statusBar = UI:new(style)		
statusBar:add("status")
statusBar.status.position = "bottom=5%|left=5"

statusBar.status.width = "99%"
statusBar.status.height = "90%"

-- colors defined on uiconfig
statusBar.status.background = "gray_light"
statusBar.status.color = "white"
statusBar.status.font_size = "30%"

function ShowStatusBar()
	statusBar:showAll()
end

function Status(msg)
	--self.statusBar.status:hide()
	statusBar.status.text = msg
	statusBar.status:show()
end
