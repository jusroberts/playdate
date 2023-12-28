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
building:setElevator(elevator)

function playdate.start()
    -- Load the splash image
    local splashImage = gfx.image.new("images/splashScreen.png")
    
    -- Check if the image was loaded successfully
    if splashImage == nil then
        error("Could not load the splash image.")
        return
    end
    
    -- Draw the image
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            splashImage:draw(0, 0)
            gfx.clearClipRect()
        end
    )
    
    -- Update the display
    gfx.sprite.update()
    
    -- Optional: Wait for a key press or a certain amount of time
    playdate.wait(2000)
end

-- Main game loop
function playdate.update()
    building:update()
    gfx.sprite.update()
end