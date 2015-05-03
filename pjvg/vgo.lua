--[[
	Portable JSON Vector Graphics
	Vector Graphics Object
]]

local path = (...):gsub("%..-$", "") .. "."

local core = require(path .. "core")
local fs = require(path .. "fs")
local json = require(path .. "json")
local renderer = require(path .. "renderer")

local class = {}
local object = {}
class.object = object

function class.verify(document)
	return true
end

function class.new(document)
	local success, err = class.verify(document)

	if (not success) then
		return false, err
	end

	setmetatable(document, {
		__index = class.object
	})

	return document
end

function object:serialize()
	return json.encode(self, class.schema)
end

function object:save(filename)
	fs.write(filename, self:serialize())
end

function object:draw()
	renderer.draw(self)
end

function object:parseSelector(str)
	if (type(str) == "table") then
		return str
	end

	local selector = {}

	for key in str:gmatch("[^%.]+") do
		table.insert(selector, tonumber(key) or key)
	end

	return selector
end

function object:select(root, selector, start, finish)
	selector = self:parseSelector(selector)

	start = start or 1
	finish = finish or #selector

	local at = root or self.document
	local prop = false

	for key = start, finish do
		local nav = selector[key]

		if (prop) then
			at = at[nav]
		else
			if (type(nav) == "number") then
				at = at.children[nav]
			elseif (nav:sub(1, 1) == "#") then
				at = at.children[nav:sub(2)]
			else
				at = at[nav]
				prop = true
			end
		end

		if (not at) then
			return nil, key
		end
	end

	return at, #selector
end

function object:selectParent(root, selector, ...)
	selector = self:parseSelector(selector)

	local reselect = {}
	for i = 1, #selector - 1 do
		reselect[i] = selector[i]
	end

	return self:select(root, reselect, ...)
end

function object:getPropertyKey(selector)
	selector = self:parseSelector(selector)

	for key, nav in ipairs(selector) do
		if (prop or type(nav) == "string" and nav:sub(1, 1) ~= "#") then
			return key
		end
	end
end

function object:splitSelector(selector)
	selector = self:parseSelector(selector)

	local prop_selector = {}
	local object_selector = {}
	local prop = false

	for key, nav in ipairs(selector) do
		if (prop or type(nav) == "string" and nav:sub(1, 1) ~= "#") then
			prop = true
			table.insert(prop_selector, nav)
		else
			table.insert(object_selector, nav)
		end
	end

	return object_selector, prop_selector
end

return class