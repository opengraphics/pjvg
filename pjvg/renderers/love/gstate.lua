--[[
	PJVG-LOVE
	State object and methods
]]

local class = {}
local object = {}
class.object = object

function class:new(body)
	return setmetatable(body, {
		__index = self.object
	})
end

local function select_parents_same(self, scope)
	local object_key = self.vgo:getPropertyKey(scope) - 1

	local diff = #scope - object_key
	local rescope = {}
	for i = 1, object_key - 1 do
		table.insert(rescope, scope[i])
	end
	for i = diff, #scope do
		table.insert(rescope, scope[i])
	end

	return rescope
end

local unit_map = {
	box = function(self, scope, pkey)
		local parent = self.vgo:selectParent(nil, (self.vgo:splitSelector(scope)))
		local rescope = {}
		for i = 1, pkey - 2 do
			rescope[i] = scope[i]
		end
		table.insert(rescope, "size")
		table.insert(rescope, scope[#scope])

		return self:units(rescope)
	end
}

function object:units(scope, dim)
	dim = dim or self.vgo:select(nil, scope)

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

			local pname, pkey
			for i = #scope, 1, -1 do
				if (type(scope[i]) == "string") then
					pkey = i
					pname = scope[i]
					break
				end
			end

			local pval
			if (unit_map[pname]) then
				pval = unit_map[pname](self, scope, pkey)
			else
				pval = self:units(select_parents_same(self, scope))
			end

			if (pval) then
				return frac * pval
			else
				return 0
			end
		else
			error("Unknown unit: " .. unit)
		end
	end
end

return class