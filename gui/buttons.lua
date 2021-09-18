local lg = love.graphics

local const = require "constants"
local state = require "state"
local ui = require "ui"
local export = require "export"

local left_buttons = ui.Grid.create()

local function makeButton(buttons, title, get, set)
	local text = false
	local function viewFunc(w, h)
		if not text then
			text = lg.newText(state.font8, title)
		end
		lg.rectangle("line", 0, 0, w, h)
		local dx = 0
		if get then
			dx = h
			lg.line(h, 0, h, h)
			if get() then
				lg.rectangle(
					"fill",
					const.button_radial_spacing,
					const.button_radial_spacing,
					h - const.button_radial_spacing * 2,
					h - const.button_radial_spacing * 2
				)
			end
		end
		local dy = (h - text:getHeight()) / 2
		lg.draw(text, dx + dy, dy)
	end
	local function eventFunc(x, y, w, h, type, key)
		if type == 'mousereleased' and key == 1 then
			set()
			return true
		end
		return false
	end

	local button = ui.Single.create(
		const.button_width,
		const.button_height,
		viewFunc,
		eventFunc
	)
	buttons:addRow()
	buttons:addChild(
		ui.Padding.create(
			button,
			const.button_spacing,
			const.button_spacing,
			const.button_spacing,
			const.button_spacing
		)
	)
end

local function dividerViewFunc(w, h)
	lg.rectangle("fill", 0, 0, w, h)
end

local function makeHorizontalDivider(buttons)
	-- buttons:addRow()
	-- buttons:addChild(
	-- 	ui.Padding.create(
	-- 		ui.Single.create(1, 1, dividerViewFunc),
	-- 		1, 1, 1, 1
	-- 	)
	-- )
end

makeButton(
	left_buttons,
	"Row Major",
	function() return state.export_major == 'row' end,
	function() state.export_major = 'row' end
)

makeButton(
	left_buttons,
	"Column Major",
	function() return state.export_major == 'column' end,
	function() state.export_major = 'column' end
)

makeHorizontalDivider(left_buttons)

makeButton(
	left_buttons,
	".PNG",
	function() return state.export_type == 'png' end,
	function() state.export_type = 'png' end
)

makeButton(
	left_buttons,
	"Binary Bits",
	function() return state.export_type == 'bits' end,
	function() state.export_type = 'bits' end
)

makeButton(
	left_buttons,
	"Binary RGBA",
	function() return state.export_type == 'rgba' end,
	function() state.export_type = 'rgba' end
)

-- makeButton(
-- 	left_buttons,
-- 	"C Array",
-- 	function() return state.export_type == 'c' end,
-- 	function() state.export_type = 'c' end
-- )

makeHorizontalDivider(left_buttons)

makeButton(
	left_buttons,
	"Grid",
	function() return state.export_shape == 'grid' end,
	function() state.export_shape = 'grid' end
)

makeButton(
	left_buttons,
	"Line",
	function() return state.export_shape == 'line' end,
	function() state.export_shape = 'line' end
)

makeHorizontalDivider(left_buttons)

makeButton(
	left_buttons,
	"Unique Filename",
	function() return state.export_deterministic_name == false end,
	function() state.export_deterministic_name = false end
)

makeButton(
	left_buttons,
	"Consistent Filename",
	function() return state.export_deterministic_name == true end,
	function() state.export_deterministic_name = true end
)

makeHorizontalDivider(left_buttons)
makeButton(
	left_buttons,
	"Export",
	false,
	function() export() end
)

local right_buttons = ui.Grid.create()

local function makeShiftImageData(xx, xy, x1, yx, yy, y1)
	return function()
		local cache = {}
		local Y = math.floor(state.current_char_idx / 16)
		local X = state.current_char_idx % 16
		X, Y = X * const.char_width, Y * const.char_height
		for y = 0, const.char_height - 1 do
			for x = 0, const.char_width - 1 do
				local r, g, b, a = 0, 0, 0, 1
				local fx = x * xx + y * xy + x1
				local fy = x * yx + y * yy + y1
				if 0 <= fx and fx < const.char_width and 0 <= fy and fy < const.char_height then
					r, g, b, a = state.image_data:getPixel(X + fx, Y + fy)
				end
				local idx = (y * const.char_width + x) * 4
				cache[idx + 1] = r
				cache[idx + 2] = g
				cache[idx + 3] = b
				cache[idx + 4] = a
			end
		end
		for y = 0, const.char_height - 1 do
			for x = 0, const.char_width - 1 do
				local idx = (y * const.char_width + x) * 4
				local r, g, b, a
				r = cache[idx + 1]
				g = cache[idx + 2]
				b = cache[idx + 3]
				a = cache[idx + 4]
				state.image_data:setPixel(X + x, Y + y, r, g, b, a)
			end
		end
		state.image_data_dirty = true
	end
end

makeButton(
	right_buttons,
	"Shift Pixels Left",
	false,
	makeShiftImageData(1, 0, 1, 0, 1, 0)
)

makeButton(
	right_buttons,
	"Shift Pixels Right",
	false,
	makeShiftImageData(1, 0, -1, 0, 1, 0)
)

makeButton(
	right_buttons,
	"Shift Pixels Up",
	false,
	makeShiftImageData(1, 0, 0, 0, 1, 1)
)

makeButton(
	right_buttons,
	"Shift Pixels Down",
	false,
	makeShiftImageData(1, 0, 0, 0, 1, -1)
)

makeHorizontalDivider(right_buttons)

makeButton(
	right_buttons,
	"Rotate CW",
	false,
	makeShiftImageData(0, 1, 0, -1, 0, 7)
)

makeButton(
	right_buttons,
	"Rotate CCW",
	false,
	makeShiftImageData(0, -1, 7, 1, 0, 0)
)

makeHorizontalDivider(right_buttons)

makeButton(
	right_buttons,
	"Flip X",
	false,
	makeShiftImageData(-1, 0, const.char_width - 1, 0, 1, 0)
)

makeButton(
	right_buttons,
	"Flip Y",
	false,
	makeShiftImageData(1, 0, 0, 0, -1, const.char_height - 1)
)

local function makeVerticalDivider(buttons)
	buttons:addChild(
		ui.Padding.create(
			ui.Single.create(1, 1, dividerViewFunc),
			1, 1, 1, 1
		)
	)
end

local buttons = ui.Grid.create()
buttons:addRow()
buttons:addChild(left_buttons)
makeVerticalDivider(buttons)
makeVerticalDivider(buttons)
buttons:addChild(right_buttons)

return ui.Center.create(buttons)
