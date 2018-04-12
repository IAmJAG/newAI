--require

__require = require

function require(moduleName)
	local ltyp = moduleName:lower()
	local utyp = moduleName:upper()
	local req = nil
	if _G['req' .. utyp] == nil then
		trace('Require regular type ' .. moduleName) 
		req = __require(ltyp)
	else
		trace('Require custom type ' .. moduleName)
		req = _G['req' .. utyp]()
	end
	return req
end
