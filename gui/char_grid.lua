local lg = love.graphics

local const = require "constants"
local state = require "state"
local ui = require "ui"

local function makeTextViewFunc(str)
	local text = false
	return function(w, h)
		if not text then
			text = lg.newText(state.font8, str)
		end
		local tw, th = text:getDimensions()
		lg.draw(text, (w - tw) / 2, (h - th) / 2)
	end
end

local char_grid = ui.Grid.create()

char_grid:addRow()
char_grid:addChild(ui.Nothing.create(10, 10))
for x = 0, 15 do
	local textViewFunc = makeTextViewFunc(string.format("%X", x))
	char_grid:addChild(ui.Single.create(10, 10, textViewFunc))
end

local function makeCharViewFunc(x, y)
	local quad = false
	return function(w, h)
		if not quad then
			quad = lg.newQuad(
				x * const.char_width,
				y * const.char_height,
				const.char_width,
				const.char_height,
				state.image_data:getDimensions()
			)
		end
		lg.draw(
			state.getCharImage(),
			quad,
			0,
			0,
			0,
			const.small_char_scale,
			const.small_char_scale
		)
	end
end

for y = 0, 15 do
	if y == 2 or y == 8 then
		char_grid:addRow()
		char_grid:addChild(ui.Nothing.create(0, 2))
	end
	char_grid:addRow()
	local textViewFunc = makeTextViewFunc(string.format("%X", y))
	char_grid:addChild(ui.Single.create(10, 10, textViewFunc))
	for x = 0, 15 do
		local charEventFunc
		do
			local char_idx = y * 16 + x
			function charEventFunc(x, y, w, h, type, key)
				if type == 'mousereleased' and key == 1 then
					state.current_char_idx = char_idx
					print(state.current_char_idx)
				end
			end
		end

		local charViewFunc = makeCharViewFunc(x, y)

		local single = ui.Single.create(
			const.char_width * const.small_char_scale,
			const.char_height * const.small_char_scale,
			charViewFunc,
			charEventFunc
		)
		local pad = ui.Padding.create(
			single,
			const.small_char_margin,
			const.small_char_margin,
			const.small_char_margin,
			const.small_char_margin
		)
		char_grid:addChild(pad)
	end
	char_grid:addChild(ui.Nothing.create(10, 10))
end

char_grid:addRow()
char_grid:addChild(ui.Nothing.create(10, 10))

return char_grid
