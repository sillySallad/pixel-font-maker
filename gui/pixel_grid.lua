local lg = love.graphics

local const = require "constants"
local state = require "state"
local ui = require "ui"

local pixel_grid = ui.Grid.create()

for y = 0, const.char_height - 1 do
	pixel_grid:addRow()
	for x = 0, const.char_width - 1 do
		local pixelViewFunc, pixelEventFunc
		do
			local cx, cy = x, y
			function pixelViewFunc(w, h)
				local X = state.current_char_idx % 16
				local Y = math.floor(state.current_char_idx / 16)
				X, Y = X * const.char_width + cx, Y * const.char_height + cy
				local r, g, b, a = state.image_data:getPixel(X, Y)
				lg.setColor(r, g, b, a)
				lg.rectangle(
					"fill",
					0,
					0,
					const.large_char_scale,
					const.large_char_scale
				)
				lg.setColor(1, 1, 1, 1)
			end
			function pixelEventFunc(x, y, w, h, type, key)
				if type == 'mousepressed' or type == 'mousedrag' then
					local c = 0
					if key == 1 then
						c = 1
					elseif key ~= 2 then
						return false
					end
					local X = state.current_char_idx % 16
					local Y = math.floor(state.current_char_idx / 16)
					X, Y = X * const.char_width + cx, Y * const.char_height + cy
					state.image_data:setPixel(X, Y, c, c, c, 1)
					state.image_data_dirty = true
					return true
				end
				return false
			end
		end
		pixel_grid:addChild(
			ui.Padding.create(
				ui.Single.create(
					const.large_char_scale,
					const.large_char_scale,
					pixelViewFunc,
					pixelEventFunc
				), 1, 1, 0, 0
			)
		)
	end
end

return ui.Center.create(pixel_grid)
