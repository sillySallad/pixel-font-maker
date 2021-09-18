local state = require "state"

local function import(filedata)
	state.export_type = 'png'
	state.export_shape = 'grid'
	state.export_major = 'row'

	state.image_data = love.image.newImageData(filedata)
	state.image_data_dirty = true
end

return import
