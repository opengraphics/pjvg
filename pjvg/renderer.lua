--[[
	Portable JSON Vector Graphics
	Renderer Interface
]]

local path = (...):gsub("%..-$", "") .. "."
local renderers = require(path .. "renderers")

local renderer = {
	renderers = renderers,
	currentRendererName = nil,
	currentRenderer = nil
}

function renderer.set(name)
	renderer.currentRendererName = name
	renderer.currentRenderer = renderers[name]
end

local best
local highest = 0
for key, value in pairs(renderers) do
	if ((value.priority or 1) > highest) then
		best = key
		highest = value.priority or 1
	end
end

renderer.set(best)

setmetatable(renderer, {
	__index = function(self, key)
		local r = rawget(self, "currentRenderer")

		return r and r[key]
	end
})

return renderer