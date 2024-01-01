import "CoreLibs/graphics"
local gfx = playdate.graphics

class('PanelButton').extends(playdate.graphics.sprite)

local BUTTON_RADIUS = 12

function PanelButton:init(font, floorNum, x, y)
	PanelButton.super.init(self)
	self.font = gfx.font.new('font/Roobert/Roobert-24-Medium-Numberals');
	self.floorNum = floorNum
	
	self.circle = gfx.sprite.new()
	self.circle:setSize(BUTTON_RADIUS * 2, BUTTON_RADIUS * 2)
	function self.circle:draw()
		gfx.fillCircleAtPoint(BUTTON_RADIUS, BUTTON_RADIUS, BUTTON_RADIUS)
	end
	self.circle:moveTo(x, y-BUTTON_RADIUS + 4)
	self.circle:add()
	

	-- gfx.setFont(self.font)
	local width = gfx.getTextSize(self.floorNum)
	self:setSize(width, 32)
	self:moveTo(x, y)
	self:markDirty()
	self:add()
end

function PanelButton:show()
	self.circle:setVisible(true)
	self:setVisible(true)
end

function PanelButton:hide()
	self.circle:setVisible(false)
	self:setVisible(false)
end

function PanelButton:setPos(x, y)
	self:moveTo(x, y)
	self.circle:moveTo(x, y-BUTTON_RADIUS + 4)
end

function PanelButton:draw(x, y, width, height)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	gfx.setFont(self.font)
	gfx.drawText(self.floorNum, 0, 0)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
end