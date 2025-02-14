--!strict
local M = {}
local common = require "./common"

local PLACEHOLDER_VALUE = 0

function M.testPreallocated(
	seed: number,
	size: number,
	running: () -> (),
	finished: () -> ()
) : number
	local array = table.create(size, PLACEHOLDER_VALUE)
	local pattern = common.createAccessPattern(size, seed)

	local generator = Random.new(seed)
	for _, index in ipairs(pattern) do array[index] = generator:NextNumber() end

	running()
	local sum = 0; for i = 1, size do sum += array[i] end
	finished()

	return sum
end

function M.testNonPreallocated(
	seed: number,
	size: number,
	singlePass: boolean,
	running: () -> (),
	finished: () -> ()
) : number
	local array = {}
	local pattern = common.createAccessPattern(size, seed)

	local generator = Random.new(seed)
	if singlePass then
		for _, index in ipairs(pattern) do array[index] = generator:NextNumber() end
	else
		for _, index in ipairs(pattern) do array[index] = PLACEHOLDER_VALUE end
		for _, index in ipairs(pattern) do array[index] = generator:NextNumber() end
	end

	running()
	local sum = 0; for i = 1, size do sum += array[i] end
	finished()

	return sum
end

return M