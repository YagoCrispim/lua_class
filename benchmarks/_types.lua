---@class Person : Class, Blob
---@field blob string
---@field file_content table
---@field new fun(constructor_params: table?): Person
--
---@class Blob
---@field create_blob fun(self: table, mbs: number): nil
