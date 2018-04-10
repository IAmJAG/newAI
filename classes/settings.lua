----Settings
local settings = {}
settings.__index = settings

local function settings.create()
	local set = {}
	setmetatable(set, settings)
	
	local scr = getAppUsableScreenSize()
	
	set = ogu:addType('settings', set)
	return set
end