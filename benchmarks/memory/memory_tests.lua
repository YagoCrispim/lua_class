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

---@param person_class Person
---@return nil
local function run_tests(person_class)
    local cycles = 50
    print("Cycles: " .. cycles)
    print("Memory before execution:", collectgarbage("count") .. ' kbps')

    local c = 0
    while c < cycles do
        local john = person_class:new()
        local jane = person_class:new()

        john:create_blob(1)
        jane:create_blob(1)

        c = c + 1
    end

    print("Memory after execution: " .. collectgarbage("count") .. ' kbps')
    collectgarbage('collect')
    print("Memory after forced GC exection: " .. collectgarbage("count") ..
              ' kbps')
    print('')
end

return {blob = blob, run_tests = run_tests}

