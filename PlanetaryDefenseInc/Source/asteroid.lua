import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")

local gfx = playdate.graphics

local SCREEN_HEIGHT = 240
local SCREEN_WIDTH = 400

class('Asteroid').extends(gfx.sprite)

local asteroidImage = gfx.image.new('assets/sprites/Asteroid')
-- local ceil <const> = math.ceil
-- w, h = asteroidImage:getSize()
-- resizedImage = asteroidImage:scaledImage(ceil(64 / w), ceil(64 / h))

function Asteroid:init()
	self:setImage(asteroidImage)
	self:moveTo(100, SCREEN_HEIGHT / 2)
	self:setScale(.25)
	self:add()
end

function Asteroid:update()
	self:setRotation(self:getRotation() + 0.1)
	-- self:moveBy(1, 0)
end