import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")

local gfx = playdate.graphics

local SCREEN_HEIGHT = 240
local SCREEN_WIDTH = 400
local PLANET_WIDTH = 200
local PLANET_Y = ((SCREEN_HEIGHT - PLANET_WIDTH) / 2) + (PLANET_WIDTH/2)
local PLANET_X = SCREEN_WIDTH
local RADIUS = 35

class('Eye').extends(gfx.sprite)

local eyeImage = gfx.imagetable.new('assets/sprites/Eye')

function Eye:init(relativeAngle, rotationOffset)
	self.eyeDirection = 270
	self.relativeAngle = relativeAngle -- the angle relative to the planet's 0 position
	self:setImage(eyeImage:getImage(1))
	self:updatePosition(rotationOffset)
	self:add()
end


function Eye:updatePosition(planetAngle)
	local newAngle = self.relativeAngle + planetAngle
	local x = PLANET_X + (math.sin(math.rad(newAngle)) * RADIUS)
	local y = PLANET_Y - (math.cos(math.rad(newAngle)) * RADIUS)
	self:setRotation(180 + self.eyeDirection + planetAngle)
	self:moveTo(x, y)
	self:setScale(.75)
	self:setEyeImage(planetAngle)
end

function Eye:setEyeImage(angle)
	local imageNum = 1
	if angle > 350 or angle < 10 then
		imageNum = 1
	elseif (angle < 30) then
		imageNum = 2
	elseif (angle < 70) then
		imageNum = 3
	elseif (angle < 90) then
		imageNum = 4
	elseif (angle < 180) then
		imageNum = 5
	elseif (angle > 320) then
		imageNum = 6
	elseif (angle > 290) then
		imageNum = 7
	elseif (angle > 270) then
		imageNum = 8
	elseif (angle > 180) then
		imageNum = 9
	end
	self:setImage(eyeImage:getImage(imageNum))
end