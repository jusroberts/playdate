import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")

local gfx = playdate.graphics

local SCREEN_HEIGHT = 240
local SCREEN_WIDTH = 400
local PLANET_WIDTH = 200
local PLANET_RADIUS = PLANET_WIDTH / 2
local PLANET_Y = ((SCREEN_HEIGHT - PLANET_WIDTH) / 2) + (PLANET_WIDTH/2)
local PLANET_X = SCREEN_WIDTH

class('Turret').extends(gfx.sprite)

local turretImage = gfx.image.new('assets/sprites/Turret')

function Turret:init(relativeAngle, rotationOffset)
	self.relativeAngle = relativeAngle -- the angle relative to the planet's 0 position
	self:setImage(turretImage)
	self:updatePosition(rotationOffset)
	self:add()
end

function Turret:updatePosition(planetAngle)
	local newAngle = self.relativeAngle + planetAngle
	local x = PLANET_X + (math.sin(math.rad(newAngle)) * PLANET_RADIUS)
	local y = PLANET_Y - (math.cos(math.rad(newAngle)) * PLANET_RADIUS)
	self:setRotation(newAngle)
	self:moveTo(x, y)
end

