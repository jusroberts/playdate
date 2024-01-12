import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("planet")
import("asteroid")

local gfx = playdate.graphics
local SCREEN_HEIGHT = 240
local SCREEN_WIDTH = 400

gfx.setColor(gfx.kColorWhite)

local bg_image = gfx.image.new('assets/sprites/SpaceBackground')
local bg_sprite = playdate.graphics.sprite.new()
bg_sprite:setImage(bg_image)
bg_sprite:moveTo(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
bg_sprite:add()

local planet = Planet()
local asteroid = Asteroid()


function playdate.update()
    playdate.drawFPS(0,0)
    gfx.sprite.update()
end
