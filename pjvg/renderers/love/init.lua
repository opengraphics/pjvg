--[[
	Portable JSON Vector Graphics
	LOVE Renderer
]]

local root = (...):match("(.-%.?pjvg).+$") .. "."
local path = (...):gsub("%.init$", "") .. "."

local utility = require(root .. "utility")
local gcontext = require(path .. "gcontext")
local gstate = require(path .. "gstate")

local renderer = {
	available = not not love
}

function renderer.draw(vgo, x, y)
	x, y = x or 0, y or 0

	local state = gstate:new {
		fonts = {
			["$default"] = love.graphics.newFont(12)
		},
		translations = {},
		scissors = {},
		scope = {},
		vgo = vgo,
		g = gcontext()
	}

	if (vgo.document) then
		state.g:translate(x, y)
		renderer.drawDocument(vgo.document, state)
		state.g:untranslate()
	end
end

function renderer.drawDocument(self, state)
	if (self.scale) then
		love.graphics.scale(self.scale[1], self.scale[2])
	end

	local size_x, size_y
	if (self.size) then
		size_x = self.size[1]
		size_y = self.size[2]
	end

	local pos_x, pos_y = state.g:current_translation()

	state.g:scissor(pos_x, pos_y,
		state:units(nil, self.size[1]),
		state:units(nil, self.size[2])
	)

	if (self.children) then
		local skey = #state.scope + 1
		for key, object in ipairs(self.children) do
			state.scope[skey] = key
			renderer.drawObject(object, state)
			state.scope[skey] = nil
		end
	end

	state.g:unscissor()
end

function renderer.drawObject(self, state)
	if (self.type == "shape") then
		renderer.drawShape(self, state)
	end

	if (self.children) then
		if (self.position) then
			state.g:translate(
				state:units(utility.tableAppend(state.scope, "position", 1)),
				state:units(utility.tableAppend(state.scope, "position", 2))
			)
		end

		local skey = #state.scope + 1
		for key, child in ipairs(self.children) do
			state.scope[skey] = key
			renderer.drawObject(child, state)
			state.scope[skey] = nil
		end

		if (self.position) then
			state.g:untranslate()
		end
	end
end

local shapes = {}
renderer.shapes = shapes

function renderer.drawShape(self, state)
	if (shapes[self.shape]) then
		return shapes[self.shape](self, state)
	end

	print(("Can't render shape of type %q"):format(self.shape))
end

function shapes.text(self, state)
	love.graphics.setColor(self.color)
	love.graphics.setFont(state.fonts["$default"])
	local pos_x = state:units(utility.tableAppend(state.scope, "position", 1)) or 0
	local pos_y = state:units(utility.tableAppend(state.scope, "position", 2)) or 0

	local font_size = state:units(utility.tableAppend(state.scope, "fontSize")) or "$default"
	if (not state.fonts[font_size]) then
		state.fonts[font_size] = love.graphics.newFont(font_size)
	end

	love.graphics.setFont(state.fonts[font_size])

	local box = self.box
	if (box) then
		local bpos_x = state:units((utility.tableAppend(state.scope, "box", 1, 1))) or 0
		local bpos_y = state:units((utility.tableAppend(state.scope, "box", 1, 2))) or 0
		local bsize_x = state:units((utility.tableAppend(state.scope, "box", 2, 1))) or 0
		local bsize_y = state:units((utility.tableAppend(state.scope, "box", 2, 2))) or 0

		local bsx_selector = utility.tableAppend(state.scope, "box", 2, 1)

		local align = self.horizontalAlign or "left"
		love.graphics.printf(self.text, pos_x, pos_y, bsize_x, align)
	else
		love.graphics.print(self.text, pos_x, pos_y)
	end
end

function shapes.rectangle(self, state)
	if (self.filled) then
		love.graphics.setColor(self.fillColor)
		local pos_x = state:units(utility.tableAppend(state.scope, "position", 1)) or 0
		local pos_y = state:units(utility.tableAppend(state.scope, "position", 2)) or 0
		local size_x = state:units(utility.tableAppend(state.scope, "size", 1)) or 0
		local size_y = state:units(utility.tableAppend(state.scope, "size", 2)) or 0
		love.graphics.rectangle("fill", pos_x, pos_y, size_x, size_y)
	end

	if (self.outline) then
		love.graphics.setColor(self.outlineColor)
		love.graphics.setLineWidth(self.outlineWidth)
		love.graphics.rectangle("line", self.position[1], self.position[2], self.size[1], self.size[2])
	end
end

return renderer