class('Level')

function Level:init(number, numFloors, numPassengers, passengerPool)
	self.number = number
	self.numFloors = numFloors
	self.numPassengers = numPassengers
	self.passengerPool = passengerPool
end