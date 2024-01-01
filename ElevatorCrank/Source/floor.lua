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
local DESTINATION_SIGN_PICS = 3
local DESTINATION_SIGN_X = 200
local DESTINATION_SIGN_OFFSET_Y = -16
local DESTINATION_SIGN_TRANSITION = 10

function Floor:init(floorNum, startX, startY)
	Floor.super.init(self)
	
	self:setImage(floorImage)
	self:moveTo(startX, startY)
	self:add()
	
	self.destinationSignIndex = 1
	self.destinationSignFrame = 0
	self.destinationSignImage = gfx.imagetable.new('images/destinationSign')
	self.destinationSignSprite = gfx.sprite.new()
	self.destinationSignSprite:setImage(self.destinationSignImage[self.destinationSignIndex])
	self.destinationSignSprite:moveTo(startX + DESTINATION_SIGN_X, startY + DESTINATION_SIGN_OFFSET_Y)
	self.destinationSignSprite:add()
	self.isDestination = true
	
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
		self.destinationSignSprite:moveTo(DESTINATION_SIGN_X, y + DESTINATION_SIGN_OFFSET_Y)
	end

	function self:addComingPassenger(passenger)
		passenger:setState(COMING)
		passenger:moveTo(NEW_PASSENGER_X, self.y + PASSENGER_Y_OFFSET)
		passenger:show()
		table.insert(self.passengers, passenger)
	end

	function self:addLeavingPassenger(passenger)
		passenger:setState(LEAVING)
		passenger:moveTo(ELEVATOR_SPAWN_X, self.y + PASSENGER_Y_OFFSET)
		passenger:show()
		table.insert(self.passengers, passenger)
	end

	function self:handleTick()
		local toBeFreedIndices = {}
		for i, passenger in ipairs(self.passengers) do
			if passenger.state == COMING then
				if passenger.x > ELEVATOR_SPAWN_X then
					passenger:moveBy(-passenger.speed, 0)
				else
					passenger:setState(WAITING)
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
					passenger:setState(INACTIVE)
					passenger:hide()
				end
			end
			self.passengers = tempPassengers
		end

		if self.isDestination then
			self.destinationSignSprite:setVisible(true)
			self.destinationSignFrame = self.destinationSignFrame + 1
			if self.destinationSignFrame > DESTINATION_SIGN_TRANSITION then
				self.destinationSignFrame = 0
				self.destinationSignIndex = self.destinationSignIndex + 1
				if self.destinationSignIndex > DESTINATION_SIGN_PICS then
					self.destinationSignIndex = 1
				end
				self.destinationSignSprite:setImage(self.destinationSignImage[self.destinationSignIndex])
			end
		else
			self.destinationSignSprite:setVisible(false)
		end
	end

	function self:setIsDestination(val)
		self.isDestination = val
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