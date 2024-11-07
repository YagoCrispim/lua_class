local tests = require 'benchmarks.memory.memory_tests'

return function()
    local function Person()
        local _blob = nil

        return {
            get_blog = function(_)
                --
                return _blob
            end,
            create_blob = function(_, mbs)
                --
                _blob = tests.blob(mbs)
            end
        }
    end

    print('----- Regular OOP two -----')
    ---@diagnostic disable-next-line: missing-fields
    tests.run_tests({new = Person})
end
