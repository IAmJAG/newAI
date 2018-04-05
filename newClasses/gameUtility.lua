local gameUtility = {}
gameUtility.__index = gameUtility

local json 						= require('json')
local minifyJSONSave 	= true

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

	-- creating statusBar
	local statusBar = UI:new(style)		
	statusBar:add("status")
	statusBar.status.position = "bottom=15%|left=10"

	statusBar.status.width = "99%"
	statusBar.status.height = "90%"

	-- colors defined on uiconfig
	statusBar.status.background = "gray_light"
	statusBar.status.color = "white"
	statusBar.status.font_size = "30%"
	
	_G.statusBar				= statusBar
	
	gu = gu:addType('gameUtility', gu)
	return gu
end

function gameUtility:addType(name, o)
	if not _G['Types'] then
		_G['Types'] = {}
	end
	
	Types[name] = name:lower()
	o.Type = Types[name]
	return o
end

function gameUtility:ShowStatusBar()
	_G.statusBar:showAll()
end

function gameUtility:Status(msg)
	--self.statusBar.status:hide()
	_G.statusBar.status.text = msg
	_G.statusBar.status:show()
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
	return self:convert(dta, typ)
end

function gameUtility:convertToType(dta, typ)
	local obj = {}
	if typ ~= nil then
		obj = require(typ)
	end
	
	for k, o in ipairs(dta) do		
		obj[k] = self:convert(o, self:typeOf(obj[k]))
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
	return obj
end	

function gameUtility:saveJSON(j, filePath)
	local strJSON
	if self:typeOf(j) == 'string' then
		strJSON = self:encodeJSON(self:decodeJSON(j), minifyJSONSave)
	else
		strJSON = self:encodeJSON(j, minifyJSONSave)
	end
	local fp = io.open(filePath, "w")
	fp:write(strJSON)
	fp:close()
end

function gameUtility:readJSON(filePath, obj)
	local strJSON = self:readFile(filePath)
	obj = self:decodeJSON(strJSON, obj)
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