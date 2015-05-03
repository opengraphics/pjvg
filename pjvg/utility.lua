--[[
	PJVG Sample Implementation
	Utilities
]]

local utility = {}

function utility.tableAppend(a, ...)
	local new = {}
	for i = 1, #a do
		table.insert(new, a[i])
	end

	for i = 1, select("#", ...) do
		table.insert(new, (select(i, ...)))
	end

	return new
end

return utility