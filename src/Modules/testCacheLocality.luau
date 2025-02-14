--!strict
local M = {}
local common = require "./common"

local PLACEHOLDER_VALUE = 0
local NONE = 0

type soaContainer = {[number]: {number}}
type aosContainer = {number}

function M.testSOA(
	seed: number,
	fieldsAmount: number,
	structuresAmount: number,
	running: () -> (),
	finished: () -> ()
) : number
	local function isIdValid(id: number) return id <= structuresAmount and id > 0 end
	local arrays: soaContainer = {}
	local pattern = common.createAccessPattern(fieldsAmount, seed)

	for i = 1, fieldsAmount do arrays[i] = table.create(structuresAmount, PLACEHOLDER_VALUE) end

	local generator = Random.new(seed)
	for structId = 1, structuresAmount do for fieldIndex = 1, fieldsAmount do
		arrays[fieldIndex][structId] = generator:NextNumber()
	end end

	local function sumStruct(structId: number): number
		if not isIdValid(structId) then return NONE end

		local sum = 0; for _, fieldIndex in ipairs(pattern) do sum += arrays[fieldIndex][structId] end
		return sum
	end
	
	running()
	local sum = 0; for id = 1, structuresAmount do sum += sumStruct(id) end
	finished()

	return sum
end

function M.testAOS(
	seed: number,
	fieldsAmount: number,
	structuresAmount: number,
	running: () -> (),
	finished: () -> ()
) : number
	local lastIndex = structuresAmount * fieldsAmount + 1
	local function isIdValid(id: number) return id <= lastIndex and id >= 0 end

	local structs = table.create(fieldsAmount * structuresAmount, PLACEHOLDER_VALUE)
	local pattern = common.createAccessPattern(fieldsAmount, seed)

	local generator = Random.new(seed)
	for structId = 1, structuresAmount do for fieldIndex = 1, fieldsAmount do
		local trueId = ((structId - 1) * fieldsAmount)
		structs[trueId + fieldIndex] = generator:NextNumber()
	end end

 	local function sumStruct(structId: number) : number
		if not isIdValid(structId) then return NONE end

		local sum = 0; for _, fieldIndex in ipairs(pattern) do sum += structs[structId + fieldIndex] end
		return sum
	end

	running()
	local sum = 0; for i = 1, structuresAmount do sum += sumStruct((i - 1) * fieldsAmount) end
	finished()

	return sum
end

return M