local dictionary = {}
dictionary.__index = dictionary

local ogu 	= require('gameUtility')
local o  		= nil
local keys	= {}

function dictionary.create()
	local dict = {}
	setmetatable(dict, dictionary)
	
	local scrPath	= scriptPath()
	
	dict.ContentType	= ''
	
	dict = ogu:addType('dictionary', dict)
	return dict
end

function dictionary:intialize(typ)
	self.ContentType 	= typ
	o = require(typ)
end

function dictionary:getObject(key)
	return self[key]
end

function dictionary:getKeys()
	return keys
end

function dictionary:getFirst()
	if keys[1] ~= nil then
		return self[keys[1]]
	end	
	return nil
end

function dictionary:getNext(obj)
	local obj = nil
	for i, key in pairs(keys)
		if self[keys[i]] == obj then
			obj = self[keys[i+]]
			break
		end
	end
	return obj
end

function dictionary:add(key, obj)
	if self.ContentType = nil or self.ContentType = '' then
		Debug('Dictionary not initialized!')
	else
		obj = obj or require(self.ContentType).create()
		if obj['Type'] == nil then
			Debug('Invalid type!')
		else
			if obj.Type ~= self.ContentType then
				Debug('Invalid type!')
			else
				self[key] = obj
				keys[#keys+1] = key
			end
		end
	end
end

function dictionary:remove(key)
	self[key] = nil
	for i, k in pairs(keys)
		if key == k then
			table.remove(keys, i)
			break
		end
	end
end

function dictionary:count()
	return #keys
end

return dictionary