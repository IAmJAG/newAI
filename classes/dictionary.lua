local dictionary = {}
dictionary.__index = dictionary 

local ogu 	= require('gameUtility')
local o  		= nil
local keys	= {}

function dictionary.create(typ)
	typ = typ or nil
	local dict = {}
	setmetatable(dict, dictionary)
	
	local scrPath	= scriptPath()
	
	dict.ContentType	= ''
	
	dict = ogu:addType('dictionary', dict)
	
	if typ then
		dict:intialize(typ)
	end
	
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
	obj = obj or nil
	local ret = nil
	for i, key in pairs(keys) do
		if self[key] == obj then
			ret = self[keys[i+1]]
			break
		end
	end
	return ret
end

function dictionary:add(key, obj)
	if self.ContentType == nil or self.ContentType == '' then
		Debug('Dictionary not initialized!')
	else
		obj = obj or require(self.ContentType).create()
		if obj['Type'] == nil then
			Debug('Invalid type! 1')
		else
			if obj.Type ~= self.ContentType then
				Debug('Invalid type! 2')
			else
				self[key] = obj
				keys[#keys+1] = key
			end
		end
	end
end

function dictionary:remove(key)
	self[key] = nil
	for i, k in pairs(keys) do
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