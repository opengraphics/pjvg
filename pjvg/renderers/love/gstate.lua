--[[
	PJVG-LOVE
	State object and methods
]]

local root = (...):match("(.-%.?pjvg).+$") .. "."

local utility = require(root .. "utility")

local class = {}
local object = {}
class.object = object

function class:new(body)
	return setmetatable(body, {
		__index = self.object
	})
end

local function select_parents_same(self, selector)
	local objectSelector, propertySelector = self.vgo:splitSelector(selector)

	local rescope = {}
	for i = 1, #objectSelector - 1 do
		table.insert(rescope, objectSelector[i])
	end

	for i = 1, #propertySelector do
		table.insert(rescope, propertySelector[i])
	end

	return rescope
end

local unit_map = {
	box = function(self, selector)
		local pkey = self.vgo:getProperty(selector)
		local parent = self.vgo:selectParent(nil, (self.vgo:splitSelector(selector)))
		local rescope = {}
		for i = 1, pkey - 2 do
			rescope[i] = selector[i]
		end
		table.insert(rescope, "size")
		table.insert(rescope, selector[#selector])

		return self:units(rescope)
	end,

	position = function(self, selector)
		local parentSelector = self.vgo:splitSelector(selector)
		parentSelector[#parentSelector] = nil
		table.insert(parentSelector, "size")
		table.insert(parentSelector, selector[#selector])

		return self:units(parentSelector)
	end,

	clip = function(self, selector)
		local objectSelector = self.vgo:splitSelector(selector)
		local pos_x, pos_y = self:vec2(objectSelector, "position")
		local size_x, size_y = self:vec2(objectSelector, "size")
		local key1, key2 = selector[#selector - 1], selector[#selector]

		-- This is certainly not ideal.
		if (key1 == 1) then
			if (key2 == 1) then
				return pos_x
			else
				return pos_y
			end
		else
			if (key2 == 1) then
				return size_x
			else
				return size_y
			end
		end
	end,

	points = function(self, selector)
		local parentSelector = self.vgo:splitSelector(selector)
		parentSelector[#parentSelector] = nil
		local key = selector[#selector]
		local size_x, size_y = self:vec2(parentSelector, "size")

		if (key == 1) then
			return size_x
		else
			return size_y
		end
	end,

	fontSize = function(self, selector)
		local parentSelector = self.vgo:splitSelector(selector)
		parentSelector[#parentSelector] = nil
		local size_x, size_y = self:vec2(parentSelector, "size")

		return size_y
	end
}

function object:units(selector, dim)
	dim = dim or self.vgo:select(nil, selector)

	if (not dim) then
		return 0
	end

	if (type(dim) == "number") then
		return dim
	elseif (type(dim) == "string") then
		local value, unit = dim:match("(.-)([%a%%]+)$")

		if (unit:len() == 0) then
			error("Invalid empty unit!")
		end

		if (unit == "px" or unit == "pt" or unit == "rad") then
			return tonumber(value)
		elseif (unit == "deg") then
			return math.rad(tonumber(value))
		elseif (unit == "%") then
			local frac = tonumber(value) / 100

			local pkey, pname = self.vgo:getProperty(selector)

			local pval
			if (unit_map[pname]) then
				pval = unit_map[pname](self, selector)
			else
				pval = self:units(select_parents_same(self, selector))
			end

			if (pval) then
				return frac * pval
			else
				return 0
			end
		else
			error("Unknown unit: " .. unit)
		end
	else
		error("Invalid unit: " .. tostring(dim))
	end
end

function object:single(selector, name)
	return
		self:units(utility.tableAppend(selector, name))
end

function object:vec2(selector, name)
	return
		self:units(utility.tableAppend(selector, name, 1)),
		self:units(utility.tableAppend(selector, name, 2))
end

function object:box(selector, name)
	return
		self:units((utility.tableAppend(selector, name, 1, 1))),
		self:units((utility.tableAppend(selector, name, 1, 2))),
		self:units((utility.tableAppend(selector, name, 2, 1))),
		self:units((utility.tableAppend(selector, name, 2, 2)))
end

return class