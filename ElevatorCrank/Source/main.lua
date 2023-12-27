-- Import Playdate SDK libraries
-- import "CoreLibs/graphics"
-- import "CoreLibs/sprites"
import("building")
import("elevator")

-- Initialize graphics
local gfx = playdate.graphics
local SCREEN_HEIGHT = 240
local SCREEN_WIDTH = 400
local HALL_WIDTH = 128
local HALL_HEIGHT = 64
local hall_x = SCREEN_WIDTH - HALL_WIDTH
local elevator_x = SCREEN_WIDTH - (92 + 64)
local elevator_y = 120

-- Load sprites
building = Building:new(11, hall_x, elevator_y)
elevator = Elevator(elevator_x, elevator_y)


-- Main game loop
function playdate.update()
    building:update()
    gfx.sprite.update()
end