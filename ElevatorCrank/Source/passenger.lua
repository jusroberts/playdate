local gfx = playdate.graphics

class('Passenger').extends(playdate.graphics.sprite)
local personImage = gfx.image.new("images/person");

function Passenger:init(x, y)
	Passenger.super.init(self)
	self:setImage(personImage)
	self:moveTo(x, y)
	self:add()
end