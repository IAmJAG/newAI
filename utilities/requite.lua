--require

__require = require

function require(moduleName)
	local ltyp = moduleName:lower()
	local utyp = moduleName:upper()
	if _G['req' .. utyp] == nil then
		return __require(ltyp)
	else
		return _G['req' .. utyp]()
	end
end
