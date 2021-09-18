local ui = {}

local function add(name)
	local class = require("ui." .. name)
	assert(class.type, name)
	assert(class.draw, name)
	assert(class.getDimensions, name)
	assert(class.fireEventAt, name)
	ui[name] = class
end

-- add 'Row'
-- add 'Column'
add 'Nothing'
add 'Padding'
add 'Grid'
add 'Center'
add 'Single'

return ui
