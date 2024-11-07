local class = require 'src.class'
local tests = require 'benchmarks.memory.memory_tests'

return function()
    ---@type Blob
    local Blob = {
        create_blob = function(self, mbs)
            self.blob = tests.blob(mbs)
            --
        end
    }

    ---@class Person
    local Person = class {
        __use = {Blob},
        blob = '',
        file_content = {}
        --
    }

    print('----- Lib Class -----')
    tests.run_tests(Person)
end
