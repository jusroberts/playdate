import("floor_number")
import("passenger")
import("utils")
local gfx = playdate.graphics

class('Floor').extends(playdate.graphics.sprite)
local floorImage = gfx.image.new("images/floorHall");
local FLOOR_NUM_X = 200
local SCREEN_X = 400
local NEW_PASSENGER_X = SCREEN_X + 32
local ELEVATOR_SPAWN_X = 400 - 110
local PASSENGER_Y_OFFSET = 10

function Floor:init(floorNum, startX, startY)
	Floor.super.init(self)
	
	self:setImage(floorImage)
	self:moveTo(startX, startY)
	self:add()
	
	self.passengers = {}
	self.floorNum = floorNum

	self.floorNumber = FloorNumber(floorNum, FLOOR_NUM_X, startY)

	function self:handleMoveBy(x, y)
		self:moveBy(x, y)
		self:moveChildren(self.y)
	end

	function self:handleMoveTo(x, y)
		self:moveTo(x, y)
		self:moveChildren(y)
	end

	function self:moveChildren(y)
		self.floorNumber:moveTo(FLOOR_NUM_X, y)
		for _, passenger in ipairs(self.passengers) do
			passenger:moveTo(passenger.x, y + PASSENGER_Y_OFFSET)
		end
	end

	function self:spawnLeavingPassenger()
		table.insert(self.passengers, Passenger(ELEVATOR_SPAWN_X, self.y + PASSENGER_Y_OFFSET, LEAVING, 1))
	end

	function self:spawnComingPassenger(destinationFloor)
		table.insert(self.passengers, Passenger(NEW_PASSENGER_X, self.y + PASSENGER_Y_OFFSET, COMING, destinationFloor))
	end

	function self:handleTick()
		local toBeFreedIndices = {}
		for i, passenger in ipairs(self.passengers) do
			if passenger.state == COMING then
				if passenger.x > ELEVATOR_SPAWN_X then
					passenger:moveBy(-passenger.speed, 0)
				else
					passenger.state = WAITING
				end
			elseif (passenger.state == LEAVING) then
				passenger:moveBy(passenger.speed, 0)
				if passenger.x > NEW_PASSENGER_X then 
					table.insert(toBeFreedIndices, i)
				end
			end
		end
		if #toBeFreedIndices > 0 then
			local tempPassengers = {}
			for i, passenger in ipairs(self.passengers) do
				if not containsValue(toBeFreedIndices, i) then
					table.insert(tempPassengers, passenger)
				else
					passenger:remove()
				end
			end
			self.passengers = tempPassengers
		end
	end

	function self:hasWaitingPassengers()
		for _, passenger in ipairs(self.passengers) do
			if passenger.state == WAITING then
				return true
			end
		end
		return false
	end

	function self:takeWaitingPassenger()
		local tempPassengers = {}
		local removedPassenger = nil
		for _, passenger in ipairs(self.passengers) do
			if passenger.state == WAITING and removedPassenger == nil then
				removedPassenger = passenger
			else 
				table.insert(tempPassengers, passenger)
			end
		end
		self.passengers = tempPassengers
		return removedPassenger
	end
end