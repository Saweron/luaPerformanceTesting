--!strict
local M = {}

function M.createAccessPattern(size: number, seed: number): {number}
	local pattern = table.create(size, PLACEHOLDER_VALUE)
	for i = 1, size do pattern[i] = i end
	Random.new(seed):Shuffle(pattern)
	return pattern
end

return M