-- Import Playdate SDK libraries
-- import "CoreLibs/graphics"
-- import "CoreLibs/sprites"
import("building")
import("elevator")
import("elevator_panel")

-- Initialize graphics
local gfx = playdate.graphics
local SCREEN_HEIGHT = 240
local SCREEN_WIDTH = 400
local HALL_WIDTH = 220
local HALL_HEIGHT = 64
local hall_x = SCREEN_WIDTH - (HALL_WIDTH/2)
local elevator_x = SCREEN_WIDTH - (92 + 64)
local elevator_y = 120
local numFloors = 15
local passengerPoolSize = 2 * numFloors

-- Load sprites
building = Building:new(numFloors, hall_x, elevator_y, passengerPoolSize)
elevator = Elevator(elevator_x, elevator_y)
elevatorPanel = ElevatorPanel(numFloors)
building:setElevator(elevator)
building:setElevatorPanel(elevatorPanel)


-- Main game loop
function playdate.update()
    building:update()
    gfx.sprite.update()
end
