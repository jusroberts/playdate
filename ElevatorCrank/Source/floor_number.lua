local gfx = playdate.graphics

class('FloorNumber').extends(playdate.graphics.sprite)

function FloorNumber:init(number, startX, startY)

	FloorNumber.super.init(self)
	self.number = number
	self.font = gfx.font.new('font/Roobert/Roobert-24-Medium-Numberals');
	self:setCenter(1, 0)

	gfx.setFont(self.font)
	local width = gfx.getTextSize(self.number)
	self:setSize(width, 32)
	self:moveTo(startX, startY)
	self:markDirty()
	self:add()
end

function FloorNumber:draw(x, y, width, height)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	gfx.setFont(self.font)
	gfx.drawText(self.number, 0, 0);
	gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
end
