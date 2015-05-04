--[[
	PJVG-LOVE
	Render result
]]

local class = {}
local object = {}
class.object = object

function class:new(canvas)
	return setmetatable({
		__canvas = canvas
	}, {
		__index = self.object
	})
end

function object:type()
	return "pjvgRenderResult"
end

function object:typeOf(t)
	return (t == "pjvgRenderResult")
end

function object:getCanvas()
	return self.__canvas
end

function object:getImageData()
	return self.__canvas:getImageData()
end

function object:draw(x, y)
	love.graphics.draw(self.__canvas, x, y)
end

return class