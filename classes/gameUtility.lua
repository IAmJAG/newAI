local gameUtility = {}
gameUtility.__index = gameUtility

local json 						= require('json')
local minifyJSONSave 	= false

function gameUtility.create()
	local gu = {}
	setmetatable(gu, gameUtility)
	
	local scrPath			= scriptPath()
	
	gu.imagePath			= scrPath .. 'images'
	gu.OCRPath				= scrPath .. 'images/OCR'
	gu.scriptPath			= scrPath
	
	if not _G['Types'] then
		_G.Types = {}
	end
	
	_G.Types['Array'] 	= 'array'
	_G.Types['Object']	= 'object'	
	
	dofile(scrPath .. "UI.luac")

	-- Status Bar
	-- ========================================
	local style = {
			width = "100%",
			height = "5%",
			position = "bottom|left",
			background = "black",
			color = "white",
			font_size = 20,
	}
	
	gu = gu:addType('gameUtility', gu)
	return gu
end

function gameUtility:patternToLocation(pttrn)
	local rgn = Region(pttrn.x, pttrn.y, pttrn.w, pttrn.h)
	local loc = nil
	if rgn:exists(pttrn.fileName) then
		trace('Pattern convert')
		local match = rgn:getLastMatch()
		local locX = tonumber(string.format('%d', match:getX() + (match:getW()/2)))
		local locY = tonumber(string.format('%d', match:getY() + (match:getH()/2)))
		trace(string.format('Location X = %d, Location Y = %d', locX, locY))
		loc = require('location').create()
		loc:initialize(locX, locY)
		trace(loc:getX())
		trace(loc:getY())
	else
		Debug('Pattern must be present in the screen to convert pattern to location')
	end
	
	return loc
end

function gameUtility:addType(name, o)
	if not _G['Types'] then
		_G['Types'] = {}
	end
	
	Types[name] = name:lower()
	o.Type = Types[name]
	return o
end

function gameUtility:ms()
	return tonumber(string.format("%.0f", os.clock() * 1000))			
end

function gameUtility:encodeJSON(obj, minify)
	return json.encode(obj, minify)
end

function gameUtility:decodeJSON(jsonStr, typ)
	local dta = json.decode(jsonStr)
	typ = typ or 'object'
	trace(typ .. ' please delete me')
	return self:convert(dta, typ)
end

function gameUtility:convertToType(dta, typ)
	local obj = {}
	if typ ~= nil then
		trace('Require type ' .. typ)
		obj = require(typ).create()
		trace('Object created of type ' .. obj.Type)
	end
	
	for k, o in pairs(dta) do
		typ = self:typeOf(dta[k])
		trace('Converting type ' .. typ)
		obj[k] = self:convert(o, typ)
	end
	
	return obj
end

function gameUtility:convertToObject(dta)
	local obj = {}	
	for k, o in ipairs(dta) do		
		obj[k] = self:convert(o, self:typeOf(obj[k]))
	end	
	return obj
end

function gameUtility:convertToArray(dta)
	local obj = {}	
	for k, o in pairs(dta) do		
		obj[k] = self:convert(o, self:typeOf(obj[k]))
	end	
	return obj
end

function gameUtility:convert(o, typ)
	local obj 
	if typ == 'string' then
		obj = o
	elseif typ == 'number' then
		obj = o
	elseif typ == 'boolean' then
		obj = o
	elseif typ == 'array' then
		obj = self:convertToArray(o)
	elseif typ == 'object' then
		obj = self:convertToObject(o)
	else
		if o['Type'] ~= nil then
			obj = self:convertToType(o, o.Type)
		else
			Debug('Type not recognize ' .. typ)
			obj = o
		end
	end
	trace('Convert type ' .. typ)
	return obj
end	

function gameUtility:saveJSON(j, filePath)
	local strJSON
	if self:typeOf(j) == 'string' then
		strJSON = self:encodeJSON(self:decodeJSON(j), minifyJSONSave)
	else
		strJSON = self:encodeJSON(j, minifyJSONSave)
	end
	trace('writting to ' .. filePath)
	local fp = io.open(filePath, "w")
	fp:write(strJSON)
	fp:close()
end

function gameUtility:readJSON(filePath, typ)
	local strJSON = self:readFile(filePath)
	local obj = self:decodeJSON(strJSON, typ)
	return obj
end

function gameUtility.tbl_toString(t, name, indent)
	table.show = function(t, name, indent)
		local cart -- a container
		local autoref -- for self references

		--[[ counts the number of elements in a table
		local function tablecount(t)
			 local n = 0
			 for _, _ in pairs(t) do n = n+1 end
			 return n
		end
		]]
		-- (RiciLake) returns true if the table is empty
		local function isemptytable(t) return next(t) == nil end

		local function basicSerialize(o)
				local so = tostring(o)
				if typeOf(o) == "function" then
						local info = debug.getinfo(o, "S")
						-- info.name is nil because o is not a calling level
						if info.what == "C" then
								return string.format("%q", so .. ", C function")
						else
								-- the information is defined through lines
								return string.format("%q", so .. ", defined in (" ..
												info.linedefined .. "-" .. info.lastlinedefined ..
												")" .. info.source)
						end
				elseif typeOf(o) == "number" or typeOf(o) == "boolean" then
						return so
				else
						return string.format("%q", so)
				end
		end

		local function addtocart(value, name, indent, saved, field)
				indent = indent or ""
				saved = saved or {}
				field = field or name

				cart = cart .. indent .. field

				if typeOf(value) ~= "table" then
						cart = cart .. " = " .. basicSerialize(value) .. ";\n"
				else
						if saved[value] then
								cart = cart .. " = {}; -- " .. saved[value]
												.. " (self reference)\n"
								autoref = autoref .. name .. " = " .. saved[value] .. ";\n"
						else
								saved[value] = name
								--if tablecount(value) == 0 then
								if isemptytable(value) then
										cart = cart .. " = {};\n"
								else
										cart = cart .. " = {\n"
										for k, v in pairs(value) do
												k = basicSerialize(k)
												local fname = string.format("%s[%s]", name, k)
												field = string.format("[%s]", k)
												-- three spaces between levels
												addtocart(v, fname, indent .. "   ", saved, field)
										end
										cart = cart .. indent .. "};\n"
								end
						end
				end
		end

		name = name or "__unnamed__"
		if typeOf(t) ~= "table" then
				return name .. " = " .. basicSerialize(t)
		end
		cart, autoref = "", ""
		addtocart(t, name, indent)
		return cart .. autoref
	end
	return table.show(t, name, indent)
end

function gameUtility:typeOf(o)
	local typ = typeOf(o)
	if typ=='table' then
		if o['Type'] ~= nil then
			typ = o.Type
		else
			if #o >= 0 then
				typ = 'array'
			else
				typ = 'object'
			end
		end
	end
	return typ
end

function gameUtility:fileExist(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function gameUtility:readFile(file)
  if not self:fileExist(file) then return '' end
  lines = ''
  for line in io.lines(file) do 
    lines = lines .. line .. '\n' 
  end
  return lines
end

function gameUtility:scanDirectory(dir, ext)
	local listFile = dir .. "/files.lst"
	ext = ext or "*";
	local query = dir .. "/*." .. ext
	local command = "ls " .. query .. " > " .. listFile
  os.execute(command)
  local lines = {}
  local i = 1
  for line in io.lines(listFile) do
		lines[#lines + 1] = line
  end
  return lines
end

return gameUtility