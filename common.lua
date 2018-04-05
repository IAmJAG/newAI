--common

function saveScreen(fName)
	local scr = getAppUsableScreenSize()
	local rgn = Region(1, 1, scr:getX(), scr:getY())
	rgn:save(fName)
end

serialize = function(o)
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
	elseif typeOf(o) == "table" then
		serialize(o)
	elseif typeOf(o) == "number" or typeOf(o) == "boolean" then
			return so
	else
			return string.format("%q", so)
	end
end
	
tbl_toString = function(t, name, indent)
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

--------------------------------------------------------------------------------------------
---------- function: 		ms
---------- Description:	Returns current value of the clock in miliseconds
---------- Parameters:	None
--------------------------------------------------------------------------------------------
function ms()
	return tonumber(string.format("%.0f", os.clock() * 1000))			
end

function currentTimeStamp()
	local td = os.date('%Y%m%d%H%M%%S') .. ms()
end

function timeDateToTimeStamp(strDate)
	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	local runyear, runmonth, runday, runhour, runminute, runseconds = strDate:match(pattern)
	local convertedDate = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
	return convertedDate
end

function day(day)
	return ((60*60*24) * (day or 1))
end

function isDir(path)
  local f = io.open(path, "r")
	if f then 
		print('Opened')
	else
		print('Not Found')
		return false 
	end
  local ok, err, code = f:read(1)
	print(ok, err, code)
  f:close()
  return code == 21
end