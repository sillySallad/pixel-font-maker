local lg = love.graphics

local const = require "constants"
local state = require "state"
local ui = require "ui"

local gui = ui.Grid.create()
gui:addRow()
gui:addChild(require "gui.char_grid")
gui:addChild(ui.Nothing.create(0, 20))

local right_grid = ui.Grid.create()
right_grid:addRow()
right_grid:addChild(require "gui.pixel_grid")
right_grid:addRow()
right_grid:addChild(ui.Nothing.create(0, 10))
right_grid:addRow()
right_grid:addChild(require "gui.buttons")

gui:addChild(ui.Center.create(right_grid))

return ui.Padding.create(gui, 10, 10, 10, 10)
