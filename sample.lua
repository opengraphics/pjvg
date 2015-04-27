local pjvg = require("pjvg")

local test = assert(pjvg.load("test.pjvg"))

function love.draw()
	test:draw()
end