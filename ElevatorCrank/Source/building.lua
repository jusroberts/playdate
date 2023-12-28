-- import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "floor_number"
import "floor"

local gfx = playdate.graphics
Building = {}
Building.__index = Building
local FONT_X = 200
local FLOOR_HEIGHT = 64
local SPAWN_TIME = 100
math.randomseed(math.randomseed(playdate.getSecondsSinceEpoch()))

function Building:new(numFloors, x, y)
	local self = setmetatable({}, Building)

	self.font = gfx.font.new('text/Roobert-24-Medium-Numerals');
	self.numFloors = numFloors
	self.floors = {}
	self.bottomFloorHeight = y
	self.x = x
	self.movementLocked = false
	self.spawnCounter = 0
	for i = 1, numFloors do -- lua arrays start at 1
		local height = self.bottomFloorHeight - (FLOOR_HEIGHT*(i-1))
		self.floors[i] = Floor(i, x, height)
	end
	
	function self:setElevator(elevator)
		self.elevator = elevator
	end

	function self:moveFloors(crankChange)
		if not self.movementLocked then
			if math.abs(crankChange) < 0.5 then
				self:automatedSnapping()
			else
				self:handleManualMovement(crankChange)
			end
		end
	end

	function self:handleManualMovement(crankChange)
		local newY = self:getCurrentY() + crankChange
		local minY = self.bottomFloorHeight
		local maxY = minY + self.numFloors * FLOOR_HEIGHT
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
		return (self:getCurrentFloor() * FLOOR_HEIGHT) + self.bottomFloorHeight
	end

	function self:getCurrentFloor()
		local y = self:getCurrentY() - self.bottomFloorHeight
		if y < 0 then
			print("low error")
			return 0
		end
		return round(y / FLOOR_HEIGHT)
	end

	function self:getCurrentY()
		return self.floors[1].y
	end

	function self:update()
		local crankChange = playdate.getCrankChange() / 10.0
		self:moveFloors(crankChange)

		self:spawnRandomNewPassenger()
		for _, floor in ipairs(self.floors) do
			floor:handleTick()
		end
	end

	function self:spawnRandomNewPassenger()
		self.spawnCounter = self.spawnCounter + 1
		if self.spawnCounter > SPAWN_TIME then
			self.spawnCounter = 0
			local floorToSpawnAt = math.random(1, numFloors)
			self.floors[floorToSpawnAt]:spawnComingPassenger()
			-- if self.elevator:canAddPassengers() then
			-- 	self.elevator:addPassenger(1)
			-- else
			-- 	self.elevator:removePassengersForFloor(1)
			-- end
		end
	end
	
	return self
end

function round(number)
	return math.floor(number + 0.5)
end