--[[
	Portable JSON Vector Graphics
	LOVE Renderer
]]

local renderer = {
	available = not not love,
}

function renderer.draw(vgo, x, y)
	x, y = x or 0, y or 0

	local state = {
		colors = {},
		fonts = {}
	}

	if (vgo.fonts) then
		for key, value in pairs(vgo.fonts) do
			local font
			if (value.name) then
				font = love.graphics.newFont(value.name, value.size)
			else
				font = love.graphics.newFont(value.size)
			end

			state.fonts[key] = font
		end
	end

	love.graphics.translate(x, y)
	for key, value in ipairs(vgo.document) do
		renderer.drawObject(state, value)
	end
	love.graphics.translate(-x, -y)
end

function renderer.drawObject(state, object)
	if (object.type == "shape") then
		renderer.drawShape(state, object)
	end

	if (object.children) then
		if (object.position) then
			love.graphics.translate(object.position[1], object.position[2])
		end

		for key, value in ipairs(object.children) do
			renderer.drawObject(state, value)
		end

		if (object.position) then
			love.graphics.translate(-object.position[1], -object.position[2])
		end
	end
end

local shapes = {}
renderer.shapes = shapes

function renderer.drawShape(state, shape)
	if (shapes[shape.shape]) then
		return shapes[shape.shape](state, shape)
	end

	print(("Can't render shape of type %q"):format(shape.shape))
end

function shapes.text(state, shape)
	love.graphics.setColor(shape.color)
	love.graphics.setFont(state.fonts[shape.font])
	love.graphics.print(shape.text, shape.position[1], shape.position[2])
end

function shapes.fillRectangle(state, shape)
	love.graphics.setColor(shape.color)
	love.graphics.rectangle("fill", shape.position[1], shape.position[2], shape.size[1], shape.size[2])
end

function shapes.lineRectangle(state, shape)
	love.graphics.setColor(shape.color)
	love.graphics.setLineWidth(shape.lineWidth)
	love.graphics.rectangle("line", shape.position[1], shape.position[2], shape.size[1], shape.size[2])
end

return renderer