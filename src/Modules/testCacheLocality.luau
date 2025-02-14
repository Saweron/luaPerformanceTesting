--!strict
local M = {}
local PLACEHOLDER_VALUE = 0
local NONE = 0

type soaContainer = {[number]: {number}}
type aosContainer = {number}

local function isIdValid(id: number, structuresAmount: number) return id <= structuresAmount and id > 0 end

function M.testSOA(
	seed: number,
	fieldsAmount: number,
	structuresAmount: number,
	running: () -> (),
	finished: () -> ()
) : number
	local arrays: soaContainer = {}
	for i = 1, fieldsAmount do arrays[i] = table.create(structuresAmount, PLACEHOLDER_VALUE) end

	local function sumStruct(structId: number): number
		if not isIdValid(structId, structuresAmount) then return NONE end

		local sum = 0; for _, field in arrays do sum += field[structId] end
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
	local structs = table.create(fieldsAmount * structuresAmount, PLACEHOLDER_VALUE)

 	local function sumStruct(structId: number) : number
		if not isIdValid(structId, structuresAmount) then return NONE end

		local sum = 0; for i = structId, fieldsAmount do sum += structs[i] end
		return sum
	end

	running()
	local sum = 0; for i = 1, structuresAmount, fieldsAmount do sum += sumStruct(i) end
	finished()

	return sum
end

return M