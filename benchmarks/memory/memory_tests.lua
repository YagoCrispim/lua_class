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

local function measure_memory_and_time(func, ...)
    local start_memory = collectgarbage("count") -- Memória em kilobytes
    local start_time = os.clock()                -- Tempo em segundos

    func(...)

    local end_memory = collectgarbage("count")
    local end_time = os.clock()

    local memory_used_kb = end_memory - start_memory
    local time_taken = end_time - start_time
    local memory_used_mb = memory_used_kb / 1024

    return memory_used_kb, memory_used_mb, time_taken
end

---@param Person Person
---@return nil
local function run_tests(Person)
    -- Medindo o uso de memória e tempo para criar um blob de 10 MB
    local mbs = 10
    local memory_used_kb, memory_used_mb, time_taken = measure_memory_and_time(function()
        local person = Person:new()
        person:create_blob(mbs)
    end)

    print(string.format("Memória usada: %.2f KB (%.2f MB)", memory_used_kb, memory_used_mb))
    print(string.format("Tempo gasto: %.2f segundos", time_taken))
end

return { blob = blob, run_tests = run_tests }
