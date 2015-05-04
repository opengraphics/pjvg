--[[
	PJVG-LOVE
	Graphics context/utilities
]]

return function()
	local gcontext = {
		history_scissor = {},
		history_translation = {},
		history_scale = {}
	}

	function gcontext:scissor(x, y, w, h)
		local history = self.history_scissor

		local last = history[#history]
		if (last) then
			x = x + last[1]
			y = y + last[2]
		end

		table.insert(history, {x, y, w, h})
		love.graphics.setScissor(x, y, w, h)
	end

	function gcontext:unscissor()
		local history = self.history_scissor

		local slast = history[#history - 1]

		if (slast) then
			love.graphics.setScissor(unpack(slast))
			history[#history] = nil
		else
			love.graphics.setScissor()
		end
	end

	function gcontext:translate(x, y)
		table.insert(self.history_translation, {x, y})
		love.graphics.translate(x, y)
	end

	function gcontext:untranslate()
		local history = self.history_translation

		local last = history[#history]

		if (last) then
			love.graphics.translate(-last[1], -last[2])
			history[#history] = nil
		end
	end

	function gcontext:current_translation()
		local x, y = 0, 0

		for key, value in ipairs(self.history_translation) do
			x = x + value[1]
			y = y + value[2]
		end

		return x, y
	end

	function gcontext:scale(x, y)
		table.insert(self.history_scale, {x, y})
		love.graphics.scale(x, y)
	end

	function gcontext:unscale()
		local history = self.history_scale

		local last = history[#history]
		if (last) then
			love.graphics.scale(1 / last[1], 1 / last[2])
			history[#history] = nil
		end
	end

	return gcontext
end