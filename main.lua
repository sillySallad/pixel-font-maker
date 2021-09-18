require "global_guard"

local lg = love.graphics

lg.setDefaultFilter("nearest", "nearest")

local import = require "import"

local gui = require "gui"

do
	local w, h = gui:getDimensions()
	love.window.updateMode(w, h)
end

require "graphics_state"

function love.draw()
	lg.setBackgroundColor(0.25, 0.25, 0.25)
	gui:draw(lg.getDimensions())
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.mousepressed(x, y, key)
	local w, h = lg.getDimensions()
	gui:fireEventAt(x, y, w, h, 'mousepressed', key)
end

function love.mousereleased(x, y, key)
	local w, h = lg.getDimensions()
	gui:fireEventAt(x, y, w, h, 'mousereleased', key)
end

function love.mousemoved(x, y)
	local w, h = lg.getDimensions()
	if love.mouse.isDown(1) then
		gui:fireEventAt(x, y, w, h, 'mousedrag', 1)
	end
	if love.mouse.isDown(2) then
		gui:fireEventAt(x, y, w, h, 'mousedrag', 2)
	end
end

function love.filedropped(file)
	assert(file:open("r"))
	import(file)
	file:close()
end
