local gfx = playdate.graphics
local MAX_PASSENGERS = 6

class('Elevator').extends(playdate.graphics.sprite)

function Elevator:init(startX, startY)
	Elevator.super.init(self)

	self.numPassengers = 0
	self.passengers = {}

	self:setImage(gfx.image.new("images/elevator"))
	self:moveTo(startX, startY)
	self:add()

	function self:canAddPassengers()
		return table.getn(self.numPassengers) < MAX_PASSENGERS
	end

	function self:addPassenger(destinationFloor)
		table.insert(self.passengers, destinationFloor)
	end

	function self:removePassengersForFloor(targetFloor)
		local tempPassengers = {}
		local retVal = 0
		for floor in values(self.passengers) do
			if floor == targetFloor then
				retVal = retVal + 1
			else
				table.insert(tempPassengers, floor)
			end
		end
		self.passengers = tempPassengers
		return retVal
	end

	function self:hasPassengerForFloor(targetFloor)
		for floor in values(self.passengers) do
			if floor == targetFloor then
				return true
			end
		end
		return false
	end
	
	function self:handleTick()
		
	end
		
end