--!strict
local testcache = require "./testCacheLocality"
local testalloc = require "./testArrayAllocation"
local M = {}

local TIMER_SUFFIX = " ms"
local TESTING_PREFIX = "testing"
local BAD_RESULT_MESSAGE =  "functions didn't produce same results"
local USE_SEED = 1

function M.runAll()
	local done: () -> ()
	local function test(label: string)
		local t0 = os.clock()
		done = function() print(TESTING_PREFIX, label, (os.clock() - t0) * 1000, TIMER_SUFFIX) end
	end


	do
		local FIELDS_AMOUNT = 100
		local STRUCTURES_AMOUNT = 1000

		test "struct of arrays"
		local sum1 = testcache.testSOA(USE_SEED, FIELDS_AMOUNT, STRUCTURES_AMOUNT)
		done()

		test "array of structs"
		local sum2 = testcache.testAOS(USE_SEED, FIELDS_AMOUNT, STRUCTURES_AMOUNT)
		done()

		assert(sum1 == sum2, BAD_RESULT_MESSAGE)
	end

	do
		local ARRAY_SIZE = 1000

		test "preallocated"
		local sum1 = testalloc.testPreallocated(USE_SEED, ARRAY_SIZE)
		done()

		test "non preallocated single pass"
		local sum2 = testalloc.testNonPreallocated(USE_SEED, ARRAY_SIZE, true)
		done()

		test "non preallocated double pass"
		local sum3 = testalloc.testNonPreallocated(USE_SEED, ARRAY_SIZE, false)
		done()

		assert(sum1 == sum2 and sum3 == sum1, BAD_RESULT_MESSAGE)
	end
end

return M