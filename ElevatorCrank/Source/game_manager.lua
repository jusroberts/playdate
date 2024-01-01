class('GameManager')

function GameManager:init()
	self.levels = {
		Level(1, 4, 10, 5),
		Level(2, 6, 15, 5),
		Level(3, 8, 20, 5),
		Level(4, 10, 25, 10),
		Level(5, 15, 30, 10),
		Level(6, 15, 30, 30),
		Level(7, 15, 60, 60)
	}
	self.currentLevel = levels[1]
end

function GameManager:setLevel(num)
	self.currentLevel = levels[num]
end

function GameManager:runLevel()
	
end