-- import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "floor_number"
import "floor"

local gfx = playdate.graphics
Building = {}
Building.__index = Building
local FLOOR_HEIGHT = 64
local SPAWN_TIME = 100
math.randomseed(math.randomseed(playdate.getSecondsSinceEpoch()))

function Building:new(numFloors, x, y)
	local self = setmetatable({}, Building)
	self.numFloors = numFloors
	self.floors = {}
	self.bottomFloorHeight = y
	self.x = x
	self.movementLocked = false
	self.stopped = false
	self.spawnCounter = 0
	for i = 1, numFloors do -- lua arrays start at 1
		local height = self.bottomFloorHeight - (FLOOR_HEIGHT*(i-1))
		self.floors[i] = Floor(i, x, height)
	end
	
	function self:setElevator(elevator)
		self.elevator = elevator
	end
	
	function self:setElevatorPanel(elevatorPanel)
		self.elevatorPanel = elevatorPanel
	end

	function self:moveFloors(crankChange)
		self.stopped = false
		local startY = self:getCurrentY()
		if not self.movementLocked then
			if math.abs(crankChange) < 0.5 then
				self:automatedSnapping()
			else
				self:handleManualMovement(crankChange)
			end
		end
		if (startY == self:getCurrentY()) then
			self.stopped = true
		end
	end

	function self:handleManualMovement(crankChange)
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

	function self:automatedSnapping()
		local goalY = self:getDesiredY()
		local goalDir = 0
		local distance = self:getCurrentY() - goalY
		local SPEED = 0.5
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
		local crankChange = playdate.getCrankChange() / 10.0
		self:moveFloors(crankChange)

		self:spawnRandomNewPassenger()
		for i, floor in ipairs(self.floors) do
			floor:handleTick()
			self.elevatorPanel:markFloorAsRequested(i, floor:hasWaitingPassengers())
		end
		self.elevatorPanel:setDropoffFloors(self.elevator:getDestinationFloors())
		
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
			self.spawnCounter = 0
			local floorToSpawnAt = 1
			local destinationFloor = 1
			if math.random(1,2) == 2 then
				floorToSpawnAt = math.random(1, numFloors)
			end
			if (floorToSpawnAt == 1) then
				destinationFloor = math.random(2, numFloors)
			end
			self.floors[floorToSpawnAt]:spawnComingPassenger(destinationFloor)
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
				elevator:addPassenger(passenger.destinationFloor)
				passenger:remove()
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
		local numPassengers = elevator:removePassengersForFloor(floorNum)
		for _ = 1, numPassengers do
			floor:spawnLeavingPassenger()
		end
	end
	
	function self:handleBPressed()
		self:movePassengersFromFloorToElevator()
		self:movePassengersFromElevatorToFloor()
	end
	
	return self
end

function round(number)
	return math.floor(number + 0.5)
end