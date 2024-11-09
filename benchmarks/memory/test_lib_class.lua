local class = require 'src.class'
local tests = require 'benchmarks.memory.memory_tests'

---@param mbs number
---@return string
local function blob(mbs)
    local sizeInBytes = mbs * 1024 * 1024
    local blob_value = ""
    local chunkSize = 1024

    while #blob_value < sizeInBytes do
        blob_value = blob_value .. string.rep("A", chunkSize)
    end

    return blob_value:sub(1, sizeInBytes)
end

return function()
    ---@type Blob
    local Blob = {
        create_blob = function(self, mbs)
            self.blob = blob(mbs)
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
