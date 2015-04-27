--[[
	Portable JSON Vector Graphics
	Filesystem interface
]]

local path = (...):gsub("%..-$", "") .. "."

local core = require(path .. "core")
local fs = {}

function fs.read(filename)
	if (love) then
		local body = love.filesystem.read(filename)

		if (body) then
			return body
		end
	end

	local handle = io.open(filename, "rb")

	if (not handle) then
		return false, "Could not open file for reading."
	end

	local body = handle:read("*a")
	handle:close()

	return body
end

function fs.write(filename, body)
	if (love and core.loveFSEnabled) then
		if (love.filesystem.write(filename, body)) then
			return true
		end
	else
		local handle = io.open(filename, "wb")

		if (not handle) then
			return false, "Could not open file for writing."
		end

		handle:write(body)
		handle:close()

		return true
	end
end

return fs