local gfx = playdate.graphics

class('FloorNumber').extends(playdate.graphics.sprite)

function FloorNumber:init(number, startX, startY)

	FloorNumber.super.init(self)
	self.number = number
	self.font = gfx.font.new('text/Roobert-24-Medium-Numerals2');
	self:setCenter(1, 0)

	gfx.setFont(self.font)
	local width = gfx.getTextSize(self.number)
	self:setSize(width, 32)
	-- self:setSize(32, 32)
	self:moveTo(startX, startY)
	self:markDirty()
	self:add()
end

function FloorNumber:draw(x, y, width, height)
	gfx.setFont(self.font)
	gfx.drawText(self.number, 0, 0);
end
