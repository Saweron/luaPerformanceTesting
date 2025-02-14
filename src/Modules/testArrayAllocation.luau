--!strict
local M = {}
local PLACEHOLDER_VALUE = 0

function M.testPreallocated(size: number, seed: number) : number
	local array = table.create(PLACEHOLDER_VALUE, size)

	local generator = Random.new(seed)
	for i, _ in array do array[i] = generator:NextNumber() end

	local sum = 0; for _, item in array do sum += item end
	return sum
end

function M.testNonPreallocated(size: number, seed: number, singlePass: boolean) : number
	local array = {}
	local generator = Random.new(seed)

	if singlePass then
		for i = 1, size do array[i] = generator:NextNumber() end
	else
		for i = 1, size do array[i] = PLACEHOLDER_VALUE end
		for i = 1, size do array[i] = generator:NextNumber() end
	end

	local sum = 0; for _, item in array do sum += item end
	return sum
end

return M