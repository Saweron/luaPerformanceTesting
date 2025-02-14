--!strict
local M = {}
local PLACEHOLDER_VALUE = 0

function M.testPreallocated(
	seed: number,
	size: number,
	running: () -> (),
	finished: () -> ()
) : number
	local array = table.create(size, PLACEHOLDER_VALUE)

	local generator = Random.new(seed)
	for i = 1, size do array[i] = generator:NextNumber() end

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
	local generator = Random.new(seed)

	if singlePass then
		for i = 1, size do array[i] = generator:NextNumber() end
	else
		for i = 1, size do array[i] = PLACEHOLDER_VALUE end
		for i = 1, size do array[i] = generator:NextNumber() end
	end

	running()
	local sum = 0; for i = 1, size do sum += array[i] end
	finished()

	return sum
end

return M