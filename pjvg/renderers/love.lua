--[[
	Portable JSON Vector Graphics
	LOVE Renderer
]]

local renderer = {
	available = not not love,
}

local function subscissor(history, x, y, w, h)
	local last = history[#history]
	if (last) then
		x = x + last[1]
		y = y + last[2]
	end

	table.insert(history, {x, y, w, h})
	love.graphics.setScissor(x, y, w, h)
end

local function unsubscissor(history)
	local slast = history[#history - 1]

	if (slast) then
		love.graphics.setScissor(unpack(slast))
		history[#history] = nil
	else
		love.graphics.setScissor()
	end
end

local function translate(history, x, y)
	table.insert(history, {x, y})
	love.graphics.translate(x, y)
end

local function untranslate(history, x, y)
	local last = history[#history]

	if (last) then
		love.graphics.translate(-last[1], -last[2])
		history[#history] = nil
	end
end

local function current_translation(history)
	local x, y = 0, 0

	for key, value in ipairs(history) do
		x = x + value[1]
		y = y + value[2]
	end

	return x, y
end

local function table_append(a, ...)
	local new = {}
	for i = 1, #a do
		table.insert(new, a[i])
	end

	for i = 1, select("#", ...) do
		table.insert(new, (select(i, ...)))
	end

	return new
end

local function do_selector(document, scope, no_props)
	local at = document
	local prop = false

	for key, nav in ipairs(scope) do
		if (prop) then
			if (not at[nav]) then
				return nil, key
			end

			at = at[nav]
		elseif (type(nav) == "number") then
			if (not at.children[nav]) then
				return nil, key
			end

			at = at.children[nav]
		else
			if (no_props) then
				return at, key - 1
			end

			if (not at[nav]) then
				return nil, key
			end

			at = at[nav]
			prop = true
		end
	end

	return at, #scope
end

local function select_parents_same(document, scope)
	local object, object_key = do_selector(document, scope, true)

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

local function get_parent(document, scope, ...)
	local rescope = {}
	for i = 1, #scope - 1 do
		rescope[i] = scope[i]
	end

	return do_selector(document, rescope, ...)
end

local function simple_units(str)
	return tonumber(str:match("(.-)[%a%%]+$")) or 0
end

local function units(document, scope)
	local dim = do_selector(document, scope)

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
			if (pname == "box") then
				local rescope = {}
				for i = 1, pkey - 2 do
					rescope[i] = scope[i]
				end
				table.insert(rescope, "size")
				table.insert(rescope, scope[#scope])

				pval = units(document, rescope)
			else
				pval = units(document, select_parents_same(document, scope))
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

function renderer.draw(vgo, x, y)
	x, y = x or 0, y or 0

	local state = {
		fonts = {
			["$default"] = love.graphics.newFont(12)
		},
		translations = {},
		scissors = {},
		scope = {},
		document = vgo.document
	}

	if (vgo.document) then
		translate(state.translations, x, y)
		renderer.drawDocument(vgo.document, state)
		untranslate(state.translations)
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

	local pos_x, pos_y = current_translation(state.translations)

	subscissor(state.scissors, pos_x, pos_y,
		simple_units(self.size[1]),
		simple_units(self.size[2])
	)
	if (self.children) then
		local skey = #state.scope + 1
		for key, object in ipairs(self.children) do
			state.scope[skey] = key
			renderer.drawObject(object, state)
			state.scope[skey] = nil
		end
	end
end

function renderer.drawObject(self, state)
	if (self.type == "shape") then
		renderer.drawShape(self, state)
	end

	if (self.children) then
		if (self.position) then
			love.graphics.translate(
				units(state.document, table_append(state.scope, "position", 1)),
				units(state.document, table_append(state.scope, "position", 2))
			)
		end

		local skey = #state.scope + 1
		for key, child in ipairs(self.children) do
			state.scope[skey] = key
			renderer.drawObject(child, state)
			state.scope[skey] = nil
		end

		if (self.position) then
			love.graphics.translate(
				-units(state.document, table_append(state.scope, "position", 1)),
				-units(state.document, table_append(state.scope, "position", 2))
			)
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
	local pos_x = units(state.document, table_append(state.scope, "position", 1)) or 0
	local pos_y = units(state.document, table_append(state.scope, "position", 2)) or 0

	local font_size = units(state.document, table_append(state.scope, "fontSize")) or "$default"
	if (not state.fonts[font_size]) then
		state.fonts[font_size] = love.graphics.newFont(font_size)
	end

	love.graphics.setFont(state.fonts[font_size])

	local box = self.box
	if (box) then
		local bpos_x = units(state.document, (table_append(state.scope, "box", 1, 1))) or 0
		local bpos_y = units(state.document, (table_append(state.scope, "box", 1, 2))) or 0
		local bsize_x = units(state.document, (table_append(state.scope, "box", 2, 1))) or 0
		local bsize_y = units(state.document, (table_append(state.scope, "box", 2, 2))) or 0

		local bsx_selector = table_append(state.scope, "box", 2, 1)

		local align = self.horizontalAlign or "left"
		love.graphics.printf(self.text, pos_x, pos_y, bsize_x, align)
	else
		love.graphics.print(self.text, pos_x, pos_y)
	end
end

function shapes.rectangle(self, state)
	if (self.filled) then
		love.graphics.setColor(self.fillColor)
		local pos_x = units(state.document, table_append(state.scope, "position", 1)) or 0
		local pos_y = units(state.document, table_append(state.scope, "position", 2)) or 0
		local size_x = units(state.document, table_append(state.scope, "size", 1)) or 0
		local size_y = units(state.document, table_append(state.scope, "size", 2)) or 0
		love.graphics.rectangle("fill", pos_x, pos_y, size_x, size_y)
	end

	if (self.outline) then
		love.graphics.setColor(self.outlineColor)
		love.graphics.setLineWidth(self.outlineWidth)
		love.graphics.rectangle("line", self.position[1], self.position[2], self.size[1], self.size[2])
	end
end

return renderer