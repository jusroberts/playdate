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