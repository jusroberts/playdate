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
		print("Spawning on " .. self.floorNum)
	end

	function self:handleTick()
		for _, passenger in ipairs(self.passengersComing) do
			print(passenger.x .. " " .. passenger.y)
			if passenger.x > ELEVATOR_SPAWN_X then
				passenger:moveBy(-0.5, 0)
			end
		end
		local toBeFreed = {}
		for i, passenger in ipairs(self.passengersLeaving) do
			passenger:moveBy(0.5, 0)
			if passenger.x > NEW_PASSENGER_X then 
				table.insert(toBeFreed, i)
			end
		end
		if #toBeFreed > 0 then
			local tempPassengersLeaving = {}
			for i, passenger in ipairs(self.passengersLeaving) do
				if not containsValue(toBeFreed, i) then
					table.insert(tempPassengersLeaving, passenger)
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