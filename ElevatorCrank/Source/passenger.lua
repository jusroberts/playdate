local gfx = playdate.graphics

class('Passenger').extends(playdate.graphics.sprite)
local personImage = gfx.image.new("images/person");

COMING = 0
LEAVING = 1
WAITING = 2
INACTIVE = 3
ON_ELEVATOR = 4

function Passenger:init()
	Passenger.super.init(self)
	self:setImage(personImage)
	self:moveTo(0, 0)
	self:add()
	self.speed = 0.3 + math.random() * (0.7 - 0.3)
	self.state = INACTIVE
	self.destinationFloor = destinationFloor
	self:hide()
	self.timerStart = 0
	self.timeElapsed = 0
end

function Passenger:setState(state)
	if state == WAITING then
		self.timerStart = playdate.getCurrentTimeMilliseconds()
	elseif (state == LEAVING) then
		local score = 10000 - (playdate.getCurrentTimeMilliseconds() - self.timerStart)
		if score < 0 then
			score = 1
		end
		print(score)
	end
	self.state = state
end

function Passenger:hide()
	self:setVisible(false)
end

function Passenger:show()
	self:setVisible(true)
end