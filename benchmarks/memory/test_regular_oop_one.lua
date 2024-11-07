local tests = require 'benchmarks.memory.memory_tests'

return function()
    local Person = {
        blob = nil,
        file_content = {}
        --
    }
    Person.__index = Person

    function Person:new()
        return setmetatable({}, Person)
        --
    end

    function Person:create_blob(mbs)
        self.blob = tests.blob(mbs)
        --
    end

    print('----- Regular OOP one -----')
    tests.run_tests(Person)
end
