-- import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "floor_number"
import "floor"
import "utils"
import "passenger"

local gfx = playdate.graphics
Building = {}
Building.__index = Building
local FLOOR_HEIGHT = 64
local SPAWN_TIME = 100
local USE_PRECISE_MOVEMENT = true
math.randomseed(math.randomseed(playdate.getSecondsSinceEpoch()))

function Building:new(numFloors, x, y, passengerPoolSize)
	local self = setmetatable({}, Building)
	self.numFloors = numFloors
	self.floors = {}
	self.bottomFloorHeight = y
	self.x = x
	self.movementLocked = false
	self.stopped = false
	self.spawnCounter = 0
	self.crankPosition = crankPosition
	for i = 1, numFloors do -- lua arrays start at 1
		local height = self.bottomFloorHeight - (FLOOR_HEIGHT*(i-1))
		self.floors[i] = Floor(i, x, height)
	end
	
	self.passengerPool = {}
	for _=1, passengerPoolSize do
		table.insert(self.passengerPool, Passenger())
	end
	
	function self:setElevator(elevator)
		self.elevator = elevator
	end
	
	function self:setElevatorPanel(elevatorPanel)
		self.elevatorPanel = elevatorPanel
	end

	function self:moveFloors()
		local startY = self:getCurrentY()
		if USE_PRECISE_MOVEMENT then
			local crankChange = playdate.getCrankChange()
			if math.abs(crankChange) < 2 then
				self:automatedSnapping()
			else
				self:handlePreciseMovement(crankChange)
			end
		else
			self:handleTickMovement(playdate.getCrankTicks(360/90))
		end
		self.stopped = self:atFloor() and startY == self:getCurrentY()
	end
	
	function self:handlePreciseMovement(crankChange)
		local newY = self:getCurrentY() + crankChange
		local minY = self.bottomFloorHeight
		local maxY = minY + (self.numFloors-1) * FLOOR_HEIGHT
		if newY < minY then
			self:moveFloorsTo(minY)
		elseif (newY > maxY) then
			self:moveFloorsTo(maxY)
		else
			self:moveFloorsBy(crankChange)
		end
	end
	
	function self:handleTickMovement(crankChange)
		local speed = 32
		local newY = self:getCurrentY() + speed * crankChange
		local minY = self.bottomFloorHeight
		local maxY = minY + (self.numFloors-1) * FLOOR_HEIGHT
		if newY < minY then
			self:moveFloorsTo(minY)
		elseif (newY > maxY) then
			self:moveFloorsTo(maxY)
		else
			self:moveFloorsBy(speed * crankChange)
		end
	end

	function self:automatedSnapping()
		local goalY = self:getDesiredY()
		local goalDir = 0
		local distance = self:getCurrentY() - goalY
		local SPEED = 2.0
		if (math.abs(distance)) > SPEED then
			if distance > 0 then
				goalDir = -1
			elseif (distance < 0) then
				goalDir = 1
			end
			self:moveFloorsBy(SPEED * goalDir)
		else
			self:moveFloorsTo(goalY)
		end
	end

	function self:moveFloorsTo(goal)
		for i, floor in ipairs(self.floors) do
			local offset = FLOOR_HEIGHT * (i-1)
			floor:handleMoveTo(self.x, goal - offset)
		end
	end

	function self:moveFloorsBy(crankChange)
		for _, floor in ipairs(self.floors) do
			floor:handleMoveBy(0, crankChange)
		end
	end

	function self:atFloor()
		return self:getCurrentY() - self:getDesiredY() == 0
	end

	function self:getDesiredY()
		return ((self:getCurrentFloor() - 1) * FLOOR_HEIGHT) + self.bottomFloorHeight
	end

	function self:getCurrentFloor()
		local y = self:getCurrentY() - self.bottomFloorHeight
		if y < 0 then
			print("low error")
			return 1
		end
		return round(y / FLOOR_HEIGHT) + 1
	end

	function self:getCurrentY()
		return self.floors[1].y
	end

	function self:update()
		self:moveFloors()

		self:spawnRandomNewPassenger()
		local destinationFloors = self.elevator:getDestinationFloors()
		for i, floor in ipairs(self.floors) do
			floor:handleTick()
			floor:setIsDestination(containsValue(destinationFloors, i))
			self.elevatorPanel:markFloorAsRequested(i, floor:hasWaitingPassengers())
		end
		self.elevatorPanel:setDropoffFloors(destinationFloors)

		if (playdate.buttonJustPressed("B")) then
			self:handleBPressed()
		end

		if self.stopped then
			self.elevator:setStopped()
		else
			self.elevator:setMoving()
		end
	end

	function self:spawnRandomNewPassenger()
		self.spawnCounter = self.spawnCounter + 1
		if self.spawnCounter > SPAWN_TIME then
			local passenger = self:getNextPassenger(INACTIVE)
			self.spawnCounter = 0
			if passenger == nil then
				return
			end
			local floorToSpawnAt = 1
			local destinationFloor = 1
			-- prefer spawning at the first floor for now
			if math.random(1, 2) == 2 then
				floorToSpawnAt = math.random(1, numFloors)
			end
			if (floorToSpawnAt == 1) then
				destinationFloor = math.random(2, numFloors)
			end
			passenger.destinationFloor = destinationFloor
			self.floors[floorToSpawnAt]:addComingPassenger(passenger)
		end
	end

	function self:movePassengersFromFloorToElevator()
		if not self.stopped then
			return false
		end
		local floorNum = self:getCurrentFloor()
		local floor = self.floors[floorNum]

		while (elevator:canAddPassengers() and floor:hasWaitingPassengers()) do
			local passenger = floor:takeWaitingPassenger()
			if passenger ~= nil then
				passenger:hide()
				passenger:setState(ON_ELEVATOR)
				elevator:addPassenger(passenger)
			else
				break
			end
		end
	end
	
	function self:movePassengersFromElevatorToFloor()
		if not self.stopped then
			return false
		end
		local floorNum = self:getCurrentFloor()
		local floor = self.floors[floorNum]
		local passengers = elevator:removePassengersForFloor(floorNum)
		for i, passenger in ipairs(passengers) do
			passenger:show()
			floor:addLeavingPassenger(passenger)
		end
	end
	
	function self:handleBPressed()
		self:movePassengersFromElevatorToFloor()
		self:movePassengersFromFloorToElevator()
	end
	
	function self:getNextPassenger(state)
		for _, passenger in ipairs(self.passengerPool) do
			if passenger.state == state then
				return passenger
			end
		end
	end
	
	return self
end

function round(number)
	return math.floor(number + 0.5)
end