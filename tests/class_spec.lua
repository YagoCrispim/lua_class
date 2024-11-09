local mt = require "lua_modules.moontest.moontest"
local class = require "src.class"

---@class TableStringify
local TableStringify = {

    stringify = function(table)
        local result = ""

        local function recursive_print(tbl, indent)
            if not indent then indent = 0 end
            for k, v in pairs(tbl) do
                local formatting = string.rep("  ", indent) .. k .. ": "
                if type(v) == "table" then
                    result = result .. formatting .. ", "
                    recursive_print(v, indent + 1)
                elseif type(v) == "boolean" then
                    result = result .. formatting .. tostring(v) .. ", "
                else
                    result = result .. formatting .. v .. ", "
                end
            end
        end

        local values = table:__values()
        recursive_print(values)
        return result
    end
}

---@class SuperTestPerson : Class
---@field is_super boolean
---@field get_is_super fun(self: SuperTestPerson): boolean
---@field super_name string
local SuperTestPerson = class {
    --
    is_super = true,
    super_name = "",

    constructor = function(self, params)
        if params then self.super_name = params.super_name end
    end,

    get_is_super = function(self) return self.is_super end
}

---@class TestPerson : Class, TableStringify
---@field name string
---@field age number
---@field constructor_called boolean
---@field get_name_and_age table
local TestPerson = class {
    __use = { TableStringify },
    name = "John Doe",
    age = 21,
    constructor_called = false,

    ---@param self TestPerson
    constructor = function(self, params)
        if params then
            self.name = params.name or self.name
            self.age = params.age or self.age
        end
        self.constructor_called = true
    end,

    ---@param self TestPerson
    get_name_and_age = function(self)
        return { name = self.name, age = self.age }
    end
}

-- Test context
---@class TestContext
---@field instance TestPerson | nil
local tc = { instance = nil }

mt.describe("class", {
    -- before_all = function() print(">> Before all") end,
    -- after_all = function() print(">> After all") end,
    --
    before_each = function() tc.instance = TestPerson:new({}) end,
    -- after_each = function() print("After each") end,
    --
    mt.it("should execute the class constructor", function()
        return {
            --
            tc.instance.constructor_called
        }
    end), --
    --
    mt.it("should set the class methods", function()
        local data = tc.instance:get_name_and_age()
        return {
            --
            data.name == "John Doe", data.age == 21
        }
    end), --
    --
    mt.it(
        "should instantiate the super class, inherit its methods and pass the constructor params",
        function()
            ---@class Test : Class, SuperTestPerson
            local Test = class({
                __extends = SuperTestPerson,

                ---@param self Test
                constructor = function(self) self:super() end
            })

            ---@type Test
            local instance = Test:new({})

            return { instance:get_is_super(), instance.is_super }
        end), --
    --
    mt.it("should instantiate an empty class", function()
        local EmptyClass = class()
        local emptyClassInstance = EmptyClass:new()
        return { emptyClassInstance ~= nil, type(emptyClassInstance) == "table" }
    end), --
    --
    mt.it(
        "should instantiate the super class twice without affecting the actual instances",
        function()
            ---@class Test : Class, SuperTestPerson
            ---@field name string
            ---@field tbl_value { value: string }
            ---@field set_name fun(self: Test, name: string): nil
            local Test = class({
                __extends = SuperTestPerson,
                name = "",
                tbl_value = { value = 'John' },

                ---@param self Test
                constructor = function(self, params)
                    self:super(params)
                    if params then 
                        self.name = params.name
                        self.tbl_value.value = params.name
                    end
                end,

                ---@param self Test
                set_name = function(self, name) self.name = name end
            })

            ---@type Test
            local john = Test:new({ name = "John", super_name = "Super John" })
            ---@type Test
            local jane = Test:new({ name = "Jane", super_name = "Super Jane" })

            john:set_name("John Again")
            jane:set_name("Jane Again")

            return {
                john.name == "John Again",       --
                jane.name == "Jane Again",       --
                john.super_name == "Super John", --
                jane.super_name == "Super Jane", --
                john.tbl_value.value == "John",  --
                jane.tbl_value.value == "Jane"
            }
        end), --
    --
    mt.it(
        "should throw error if class extends another class but the super is not called",
        function()
            local Test = class({ __extends = SuperTestPerson })
            local status, err = pcall(function() Test:new({}) end)

            ---@diagnostic disable-next-line: need-check-nil
            local errMessage = err:match(":%d+: (.*)")

            return { status == false, errMessage == "'super()' not called" }
        end), --
    --
    mt.it("should extend trait behavior", function()
        local result = tc.instance:stringify()
        return { result:match("age: 21"), result:match("name: John Doe") }
    end), --
    --
    mt.it(
        'should apply trait considering non function values as unique per instance',
        function()
            local AnyTrait = {
                trait_table = { value = 21 },
                set_value = function(self, value)
                    self.trait_table.value = value
                end
            }

            local AnyClass = class { __use = { AnyTrait } }

            local instance_one = AnyClass:new()
            instance_one:set_value(100)

            local instance_two = AnyClass:new()
            instance_two:set_value(200)

            return {
                instance_one.trait_table.value == 100,
                instance_two.trait_table.value == 200
            }
        end)
})
