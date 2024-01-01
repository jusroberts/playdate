import "panel_button"
import "utils"
local gfx = playdate.graphics

class('ElevatorPanel').extends(playdate.graphics.sprite)

local BUTTONS_PER_ROW = 5
local ROW_HEIGHT = 30
local COLUMN_WIDTH = 32
local SCREEN_HEIGHT = 240
local X_OFFSET = 16
local Y_OFFSET = 10

function ElevatorPanel:init(numFloors)
	ElevatorPanel.super.init(self)
	self.pickupButtons = {}
	self.dropoffButtons = {}
	for i=1, numFloors do
		table.insert(self.pickupButtons, PanelButton(font, i, self:getPickupX(i), self:getPickupY(i)))
		table.insert(self.dropoffButtons, PanelButton(font, i, self:getDropoffX(i), self:getDropoffY(i)))
	end

	self.font = gfx.font.new('font/Roobert/Roobert-11-Medium')

	local pickupsImage = gfx.image.new(100, 20)
	gfx.pushContext(pickupsImage)
		gfx.setFont(self.font)
		gfx.drawText("Pickups", 0, 0)
	gfx.popContext()
	self.pickupsText = gfx.sprite.new(pickupsImage)
	local y = self:getPickupY(numFloors) - 36
	self.pickupsText:moveTo(X_OFFSET + 50, y)
	self.pickupsText:add()

	local dropoffsImage = gfx.image.new(100, 20)
	gfx.pushContext(dropoffsImage)
		gfx.setFont(self.font)
		gfx.drawText("Dropoffs", 0, 0)
	gfx.popContext()
	self.dropoffsText = gfx.sprite.new(dropoffsImage)
	self.dropoffsText:moveTo(X_OFFSET + 50, 18)
	self.dropoffsText:add()
end

function ElevatorPanel:getPickupX(floorNum)
	return X_OFFSET + (COLUMN_WIDTH * ((floorNum - 1) % BUTTONS_PER_ROW))
end

function ElevatorPanel:getPickupY(floorNum)
	return SCREEN_HEIGHT - (ROW_HEIGHT * math.floor((floorNum - 1) / BUTTONS_PER_ROW)) - Y_OFFSET
end

function ElevatorPanel:getDropoffX(floorNum)
	return self:getPickupX(floorNum)
end

function ElevatorPanel:getDropoffY(floorNum)
	return self:getPickupY(floorNum) - 116
end

function ElevatorPanel:markFloorAsRequested(floorNum, isRequested)
	if isRequested then
		self.pickupButtons[floorNum]:show()
	else
		self.pickupButtons[floorNum]:hide()
	end
end

function ElevatorPanel:setDropoffFloors(dropoffFloorNums)
	for i, button in ipairs(self.dropoffButtons) do
		if containsValue(dropoffFloorNums, i) then
			button:show()
		else
			button:hide()
		end
	end
end
