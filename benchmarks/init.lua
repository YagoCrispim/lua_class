local function run_memory_test()
    local lib_oo = require 'benchmarks.memory.test_lib_class'
    local regular_oop_one = require 'benchmarks.memory.test_regular_oop_one'
    local regular_oop_two = require 'benchmarks.memory.test_regular_oop_two'

    lib_oo()
    regular_oop_one()
    regular_oop_two()
end

run_memory_test()
