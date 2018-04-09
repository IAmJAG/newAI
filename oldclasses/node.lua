local node={}
node.__index=node

function node.create(_cls)
	local node={}
	setmetatable(node,node)
	node.children=nil
	
	return node
end

function node:addChild(child)
	self.children = self.children or {}
	local indx =(# self.children) + 1
	self.children[indx]=child
end

function node:getChildCount()
	return (# self.children)
end

function node:getChild(index)
	return self.children[index]
end