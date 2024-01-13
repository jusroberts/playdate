import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("turret")
import("eye")

local gfx = playdate.graphics

local SCREEN_HEIGHT = 240
local SCREEN_WIDTH = 400
local PLANET_WIDTH = 200
local PLANET_Y = ((SCREEN_HEIGHT - PLANET_WIDTH) / 2) + (PLANET_WIDTH/2)

class('Planet').extends(gfx.sprite)

local planet_image = gfx.image.new('assets/sprites/Planet')

function Planet:init()

	self:setImage(planet_image)
	self:moveTo(SCREEN_WIDTH, PLANET_Y)
	print(self:getRotation())
	self:add()
	
	self.turrets = {
		Turret(360-90,0), 
		Turret(360-120,0), 
		Turret(360-60,0), 
		Turret(90,0)
		
	}
	
	self.eyes = {
		Eye(360 - 60, 0),
		Eye(360 - 120, 0)
	}
	
end

function Planet:update()
	if (playdate.getCrankChange() ~= 0) then
		self:setRotation(self:getRotation() + playdate.getCrankChange())
		for _, turret in ipairs(self.turrets) do
			turret:updatePosition(self:getRotation())
		end
		for _, eye in ipairs(self.eyes) do
			eye:updatePosition(self:getRotation())
		end
	end
		 
end