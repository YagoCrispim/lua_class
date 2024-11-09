(function()
    local lib_oo = require 'benchmarks.memory.test_lib_class'
    local regular_oop_one = require 'benchmarks.memory.test_regular_oop_one'
    local regular_oop_two = require 'benchmarks.memory.test_regular_oop_two'

    local test = {
        lib = function() lib_oo() end,
        oop_one = function()
            print('--'); regular_oop_one()
        end,
        oop_two = function()
            print('--'); regular_oop_two()
        end
    }
    test[arg[1]]()
end)()
