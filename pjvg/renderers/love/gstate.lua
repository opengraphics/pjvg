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
	local object_key = self.vgo:getProperty(selector) - 1

	local diff = #selector - object_key
	local rescope = {}
	for i = 1, object_key - 1 do
		table.insert(rescope, selector[i])
	end
	for i = diff, #selector do
		table.insert(rescope, selector[i])
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
		table.insert(parentSelector, "size")
		table.insert(parentSelector, selector[#selector])

		return self:units(parentSelector)
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

		if (unit == "px" or unit == "pt") then
			return tonumber(value)
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