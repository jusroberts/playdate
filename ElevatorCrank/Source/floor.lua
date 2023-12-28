import("floor_number")
import("passenger")
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
	
	self.passengersComing = {}
	self.passengersLeaving = {}
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
		for _, passenger in ipairs(self.passengersComing) do
			passenger:moveTo(passenger.x, y + PASSENGER_Y_OFFSET)
		end
		for _, passenger in ipairs(self.passengersLeaving) do
			passenger:moveTo(passenger.x, y + PASSENGER_Y_OFFSET)
		end
	end

	function self:spawnLeavingPassenger()
		table.insert(self.passengersLeaving, Passenger(ELEVATOR_SPAWN_X, self.y + PASSENGER_Y_OFFSET))
	end

	function self:spawnComingPassenger()
		table.insert(self.passengersComing, Passenger(NEW_PASSENGER_X, self.y + PASSENGER_Y_OFFSET))
	end

	function self:handleTick()
		local toBeWaitingIndices = {}
		for i, passenger in ipairs(self.passengersComing) do
			if passenger.x > ELEVATOR_SPAWN_X then
				passenger:moveBy(-passenger.speed, 0)
			else
				table.insert(toBeWaitingIndices, i)
			end
		end
		if #toBeWaitingIndices > 0 then
			self.passengersComing = getArrayWithoutIndices(toBeWaitingIndices, self.passengersComing)
		end
		
		local toBeFreedIndices = {}
		for i, passenger in ipairs(self.passengersLeaving) do
			passenger:moveBy(passenger.speed, 0)
			if passenger.x > NEW_PASSENGER_X then 
				table.insert(toBeFreed, i)
			end
		end
		if #toBeFreedIndices > 0 then
			local tempPassengersLeaving = {}
			for i, passenger in ipairs(self.passengersLeaving) do
				if not containsValue(toBeFreedIndices, i) then
					table.insert(tempPassengersLeaving, passenger)
				else
					passenger:remove()
				end
			end
			self.passengersLeaving = tempPassengersLeaving
		end
	end
end

function containsValue(array, value)
	for i, v in ipairs(array) do
		if v == value then
			return true
		end
	end
	return false
end

function getArrayWithoutIndices(indexArray, oldArray)
	local tempArray = {}
	for i, value in ipairs(oldArray) do
		if not containsValue(indexArray, i) then
			table.insert(tempArray, value)
		end
	end
	return tempArray
end