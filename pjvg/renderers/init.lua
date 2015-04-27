local path = (...):gsub("%.init$", "") .. "."

return {
	love = require(path .. "love")
}