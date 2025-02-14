--!strict
local testcache = require "./testCacheLocality"
local testalloc = require "./testArrayAllocation"
local M = {}

local TIMER_SUFFIX = " ms"
local TESTING_PREFIX = "testing"
local BAD_RESULT_MESSAGE =  "functions didn't produce same results"
local USE_SEED = 1

function M.runAll()
	local rundone: () -> ()? = nil
	local function done() if rundone then rundone() end end

	local function test(label: string)
		local t0 = os.clock()
		rundone = function() print(TESTING_PREFIX, label, (os.clock() - t0) * 1000, TIMER_SUFFIX) end
	end

	local function cb(call: (string) -> (), with): () -> () return function() call(with) end end

	do
		local FIELDS_AMOUNT = 100
		local STRUCTURES_AMOUNT = 1000

		local sum1 = testcache.testSOA(
			USE_SEED, FIELDS_AMOUNT, STRUCTURES_AMOUNT,
			cb(test, "struct of arrays"), done
		)

		local sum2 = testcache.testAOS(
			USE_SEED, FIELDS_AMOUNT, STRUCTURES_AMOUNT,
			cb(test, "array of structs"), done
		)

		assert(sum1 == sum2, BAD_RESULT_MESSAGE)
	end

	do
		local ARRAY_SIZE = 1000

		local sum1 = testalloc.testPreallocated(
			USE_SEED, ARRAY_SIZE,
			cb(test, "preallocated"), done
		)

		local sum2 = testalloc.testNonPreallocated(
			USE_SEED, ARRAY_SIZE, true,
			cb(test, "non preallocated single pass"), done
		)

		local sum3 = testalloc.testNonPreallocated(
			USE_SEED, ARRAY_SIZE, false,
			cb(test, "non preallocated double pass"), done
		)

		assert(sum1 == sum2, BAD_RESULT_MESSAGE)
		assert(sum1 == sum3, BAD_RESULT_MESSAGE)
	end
end

return M