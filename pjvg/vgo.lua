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

local schema_object = {"dictionary",
	type = {"string"},
	children = {"sequenceof?"}
}
schema_object.children[2] = schema_object

local schema_color = {"sequence"}

local schema_font = {"dictionary",
	name = {"string?"},
	size = {"number?"}
}

class.schema = {"dictionary",
	pjvgVersion = {"sequenceof", {"string, number"}},
	colors = {"dictionaryof?", schema_color},
	fonts = {"dictionaryof?", schema_font},
	document = {"sequenceof", schema_object}
}

function class.verify(document)
	return json.verify(document, class.schema)
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