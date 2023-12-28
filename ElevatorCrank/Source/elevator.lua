local gfx = playdate.graphics
local MAX_PASSENGERS = 6
local NUM_FRAMES = 7

class('Elevator').extends(playdate.graphics.sprite)

function Elevator:init(startX, startY)
	Elevator.super.init(self)

	self.numPassengers = 0
	self.passengers = {}
	self.images = playdate.graphics.imagetable.new('images/elevator')
	self.frame = 1
	self:setImage(self.images[self.frame])
	-- self:updateFrame()
	self:moveTo(startX, startY)
	self:add()
end

function Elevator:canAddPassengers()
	return self.numPassengers < MAX_PASSENGERS
end

function Elevator:addPassenger(destinationFloor)
	table.insert(self.passengers, destinationFloor)
	self.numPassengers = self.numPassengers + 1
	self.frame = self.frame + 1
	self:updateFrame()
end

function Elevator:removePassengersForFloor(targetFloor)
	local tempPassengers = {}
	local numRemoved = 0
	for _, floor in ipairs(self.passengers) do
		if floor == targetFloor then
			numRemoved = numRemoved + 1
			self.frame = self.frame - 1
		else
			table.insert(tempPassengers, floor)
		end
	end
	self:updateFrame()
	self.passengers = tempPassengers
	self.numPassengers = self.numPassengers - numRemoved
	return numRemoved
end

function Elevator:hasPassengerForFloor(targetFloor)
	for floor in values(self.passengers) do
		if floor == targetFloor then
			return true
		end
	end
	return false
end

function Elevator:handleTick()
	
end

function Elevator:updateFrame()
	self:setImage(self.images[self.frame])
end