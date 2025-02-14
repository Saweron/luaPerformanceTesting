--!strict
local M = {}
local PLACEHOLDER_VALUE = 0

export type summable = {sum: (self: summable) -> (number)}

do
	local ARRAY_MT,ARRAY_PT={},{};ARRAY_MT.__index=ARRAY_PT
	type arrayImpl = {_fields: {[number]: number}}

	function M.newArrayImpl(seed: number, size: number): summable
		local fields = table.create(PLACEHOLDER_VALUE, size)
		local generator = Random.new(seed)
		for i = 1, size do fields[i] = generator:NextNumber() end

		local self = {_fields = fields} :: arrayImpl
		return setmetatable(self, ARRAY_MT) :: any
	end

	function ARRAY_PT.sum(self: arrayImpl)
		local sum = 0; for _, value in self._fields do sum += value end
		return sum
	end
end

do
	local HASHTABLE_MT,HASHTABLE_PT={},{};HASHTABLE_MT.__index=HASHTABLE_PT
	type hashtableImpl = {_fields: {[string]: number}} & summable

	function M.newHashtableImpl(seed: number, size: number, nameFormat: string)
		local fields = {}
		local generator = Random.new(seed)
		for i = 1, size do fields[string.format(nameFormat, i)] = generator:NextNumber() end

		local self = {} :: hashtableImpl
		return setmetatable(self, HASHTABLE_PT)
	end

	function HASHTABLE_PT.sum(self: hashtableImpl)
		local sum = 0; for _, value in self._fields do sum += value end
		return sum
	end
end

return M