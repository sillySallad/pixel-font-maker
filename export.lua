local state = require "state"
local const = require "constants"

local function filename()
	if state.export_deterministic_name then
		return string.format(
			"font%dx%d-%s-%s-%s",
			const.char_width,
			const.char_height,
			state.export_type,
			state.export_shape,
			state.export_major
		)
	else
		return string.format(
			"font%dx%d-%s-%s-%s-%d",
			const.char_width,
			const.char_height,
			state.export_type,
			state.export_shape,
			state.export_major,
			os.time()
		)
	end
end

local function export_png()
	state.export_shape = "grid"
	state.export_major = "row"
	state.image_data:encode("png", filename() .. '.png')
end

local function export_rgba_grid()
	state.export_major = "row"
	local t = {}
	local white = "\xff\xff\xff\xff"
	local black = "\x00\x00\x00\x00"
	for y = 0, 16 * const.char_height - 1 do
		for x = 0, 16 * const.char_width - 1 do
			local r, g, b, a = state.image_data:getPixel(x, y)
			local c = r < 0.5 and black or white
			table.insert(t, c)
		end
	end
	local data = table.concat(t)
	local name = filename() .. ".bin"
	love.filesystem.write(name, data)
end

local function export_rgba_line()
	state.export_major = "column"
	local t = {}
	local white = "\xff\xff\xff\xff"
	local black = "\x00\x00\x00\x00"
	for Y = 0, 15 do
		for X = 0, 15 do
			for y = 0, const.char_height - 1 do
				local py = Y * const.char_height + y
				for x = 0, const.char_width - 1 do
					local px = X * const.char_width + x
					local r, g, b, a = state.image_data:getPixel(px, py)
					local c = r < 0.5 and black or white
					table.insert(t, c)
				end
			end
		end
	end
	local data = table.concat(t)
	local name = filename() .. ".bin"
	love.filesystem.write(name, data)
end

local function export_rgba()
	if state.export_shape == "grid" then
		export_rgba_grid()
	else
		state.export_shape = "line"
		export_rgba_line()
	end
end

local function export_bits()
	if const.char_width > 8 then
		state.export_type = "png"
		export()
		return
	end
	state.export_shape = "line"
	state.export_major = "column"
	local t = {}
	for Y = 0, 15 do
		for X = 0, 15 do
			for y = 0, const.char_height - 1 do
				local n = 0
				local m = 1
				for x = 0, const.char_width - 1 do
					local px = X * const.char_width + x
					local py = Y * const.char_height + y
					local r, g, b, a = state.image_data:getPixel(px, py)
					local c = r < 0.5 and 0 or 1
					n = n + m * c
					m = m * 2
				end
				table.insert(t, string.char(n))
			end
		end
	end
	local data = table.concat(t)
	local name = filename() .. ".bin"
	love.filesystem.write(name, data)
end

local function export()
	if state.export_type == "rgba" then
		export_rgba()
	elseif state.export_type == "bits" then
		export_bits()
	else
		state.export_type = "png"
		export_png()
	end
end

return export
