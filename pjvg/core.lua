local function version(...)
	local tab = {...}

	setmetatable(tab, {
		__tostring = function(self)
			return table.concat(self, ".")
		end
	})

	return tab
end

local core = {
	loveFSEnabled = true,
	specVersion = version("draft"),
	version = version(0, 0, 0, "draft")
}

return core