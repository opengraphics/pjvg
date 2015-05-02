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

return class