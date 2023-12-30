local gfx = playdate.graphics

class('Passenger').extends(playdate.graphics.sprite)
local personImage = gfx.image.new("images/person");

COMING = 0
LEAVING = 1
WAITING = 2

function Passenger:init(x, y, state, destinationFloor)
	Passenger.super.init(self)
	self:setImage(personImage)
	self:moveTo(x, y)
	self:add()
	self.speed = 0.3 + math.random() * (0.7 - 0.3)
	self.state = state
	self.destinationFloor = destinationFloor
end