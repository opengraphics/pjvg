--[[
	Portable JSON Vector Graphics
]]

local path = (...):gsub("%.init$", "") .. "."

local fs = require(path .. "fs")
local json = require(path .. "json")
local vgo = require(path .. "vgo")

local pjvg = require(path .. "core")

function pjvg.parse(body)
	local model, err = json.decode(body)

	if (not model) then
		return false, err
	end

	return vgo.new(model)
end

function pjvg.load(filename)
	local body, err = fs.read(filename)

	if (not body) then
		return false, err
	end

	local object, err = pjvg.parse(body)

	if (not object) then
		return false, err
	end

	return object
end

function pjvg.save(filename, object)
	return object:save(filename)
end

function pjvg.draw(object)
	object:draw()
end

return pjvg