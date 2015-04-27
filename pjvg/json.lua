--[[
	Simple JSON implementation for Lua.
]]

local json = {}
local parse = {}

local function is_sequence(object, schema)
	if (schema and schema[1] == "sequence") then
		return true
	end

	if (#object == 0) then
		return false
	end

	for key, value in pairs(object) do
		if (type(key) ~= "number") then
			return false
		end
	end

	local last = 0
	for key in ipairs(object) do
		if (key ~= last + 1) then
			return false
		end

		last = key
	end

	return true
end

local function unescape_string(object)
	return (
		object
			:gsub("\\\"", "\"")
			:gsub("\\r", "\r")
			:gsub("\\n", "\n")
			:gsub("\\t", "\t")
	)
end

local function escape(object, schema)
	local typeof = type(object)

	if (typeof == "table") then
		return json.encode(object, schema)
	elseif (typeof == "string") then
		return '"' .. object
			:gsub("\"", "\\\"")
			:gsub("\r", "\\r")
			:gsub("\n", "\\n")
			:gsub("\t", "\\t")
			.. '"'
	elseif (typeof == "boolean") then
		return object and "true" or "false"
	elseif (typeof == "number") then
		return object
	elseif (typeof == "nil") then
		return "null"
	else
		return escape(tostring(object))
	end
end

function parse.root(parent)
	local first = parent:match("^%s*[%[{]")

	if (first == "{") then
		return parse.object(parent)
	elseif (first == "[") then
		return parse.list(parent)
	else
		error("invalid")
	end
end

function parse.object(parent, index)
	local out = {}
	local object = parent:match("%b{}", index)

	local i = 2
	while (true) do
		local start, finish = object:find("%b\"\":", i)

		if (not start) then
			break
		end

		local realkey = object:sub(start + 1, finish - 2)

		i = finish + 1

		local char
		while (true) do
			char = object:sub(i, i)
			if (char == "," or char:match("%s")) then
				i = i + 1
			else
				break
			end
		end

		if (char == "\"") then
			local value = object:match("%b\"\"", i)
			i = i + #value
			out[realkey] = unescape_string(value:sub(2, -2))
		elseif (char:match("[%d%.%-]")) then
			local value, len = parse.number(object, i)
			i = i + len
			out[realkey] = value
		elseif (char == "[") then
			local value, len = parse.list(object, i)
			i = i + len
			out[realkey] = value
		elseif (char == "{") then
			local value, len = parse.object(object, i)
			i = i + len
			out[realkey] = value
		else
			local value, len = parse.constant(object, i)
			i = i + len
			out[realkey] = value
		end
	end

	return out, #object
end

function parse.list(parent, index)
	local out = {}
	local list = parent:match("%b[]", index)

	local i = 2
	while i < #list do
		local char = list:sub(i, i)

		if (not char) then
			break
		end

		if (char == "," or char:match("%s")) then
			i = i + 1
		elseif (char == "\"") then
			local value = list:match("%b\"\"", i)
			i = i + #value
			table.insert(out, unescape_string(value:sub(2, -2)))
		elseif (char:match("[%d%.%-]")) then
			local value, len = parse.number(list, i)
			i = i + len
			table.insert(out, value)
		elseif (char == "[") then
			local value, len = parse.list(list, i)
			i = i + len
			table.insert(out, value)
		elseif (char == "{") then
			local value, len = parse.object(list, i)
			i = i + len
			table.insert(out, value)
		else
			local value, len = parse.constant(list, i)
			i = i + len
			table.insert(out, value)
		end
	end

	return out, #list
end

function parse.constant(parent, index)
	local value = parent:match("^%w+", index)

	if (value == "null") then
		return nil, 4
	elseif (value == "true") then
		return true, 4
	elseif (value == "false") then
		return false, 5
	end
end

function parse.number(parent, index)
	local value = parent:match("^[+%-]?%d+%.?%d*[eE]?[+%-]?%d*", index)

	if (value) then
		return tonumber(value), #value
	end
end

function json.encode(object, schema)
	local buffer = {}

	if (is_sequence(object, schema)) then
		for i = 1, #object do
			table.insert(buffer, escape(object[i], schema and schema[i + 1]))
		end

		return "[" .. table.concat(buffer, ",") .. "]"
	else
		for key, value in pairs(object) do
			table.insert(buffer, escape(tostring(key)) .. ":" .. escape(value, schema and schema[key]))
		end

		return "{" .. table.concat(buffer, ",") .. "}"
	end
end

function json.verify(object, schema, path)
	if (not schema) then
		return true
	end

	path = path or "root"
	local t = type(object)

	if (schema[1]:sub(-1, -1) == "?") then
		if (object == nil) then
			return true
		end
	end

	if (schema[1]:match("sequence")) then
		if (t ~= "table") then
			return false, ("At %s, expected table/sequence, got %s"):format(path, t)
		end

		local of = not not (schema[1]:match("sequenceof"))

		for key, value in ipairs(object) do
			local success, err = json.verify(value, of and schema[2] or schema[key + 1], path .. "[" .. key .. "]")

			if (not success) then
				return false, err
			end
		end
	elseif (schema[1]:match("dictionary")) then
		if (t ~= "table") then
			return false, ("At %s, expected table/dictionary, got %s"):format(path, t)
		end

		for key, value in pairs(object) do
			local success, err = json.verify(value, schema[key], path .. "." .. key)

			if (not success) then
				return false, err
			end
		end
	elseif (not schema[1]:match(t)) then
		return false, ("At %s, expected %s, got %s"):format(path, schema[1], t)
	end

	return true
end

function json.decode(object)
	return (parse.root(object))
end

return json