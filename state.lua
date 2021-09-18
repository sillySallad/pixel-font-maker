local const = require "constants"

local state = {}

-- these depend on love.graphics,
-- which can't be used when there's no window.
state.image_data = false
state.image_image = false
state.font8 = false

state.current_char_idx = 0
state.image_data_dirty = false
state.image_data = love.image.newImageData(const.char_width * 16, const.char_height * 16)
state.export_major = "row" -- row / column
state.export_type = "png" -- png / c / bits / rgba
state.export_shape = "grid" -- grid / line
state.export_deterministic_name = false

state.image_data:mapPixel(function(x,y) return 0,0,0,1 end)

function state.getCharImage()
	if state.image_data_dirty then
		state.image_image:replacePixels(state.image_data)
		state.image_data_dirty = false
	end
	return state.image_image
end

setmetatable(state, {
	__index = function(g, k)
		error(string.format("get state.%s", k))
	end,
	__newindex = function(g, k, v)
		error(string.format("set state.%s = %s", k, v))
	end,
})


return state
