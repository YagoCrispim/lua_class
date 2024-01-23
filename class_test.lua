local describe = ltest.describe
local it = ltest.it

local class = require "class"

describe("class", {
    it("should execute the class constructor", function()
        local wasConstructorCalled = false
        class({
            constructor = function(_)
                wasConstructorCalled = true
            end,
        }):new()

        return {
            assert(wasConstructorCalled == true),
        }
    end),
    it("should set the class methods", function()
        local Person = class({
            getName = function(_)
                return "John Doe"
            end,

            getAge = function(_)
                return 21
            end,

        })

        local john = Person:new({ name = "John Doe", age = 21 })

        return {
            assert(john:getName() == "John Doe"),
            assert(john:getAge() == 21),
        }
    end),
    it("should instantiate the super class, inherit its methods and pass the constructor params", function()
        local constructorParamsReceivedBySuperClass = {}

        local SecretAgent = class({
            constructor = function(_, params)
                constructorParamsReceivedBySuperClass = params
            end,
            supleClassMethods = function(_)
                return true
            end,
        })

        local Person = class({
            extends = SecretAgent,
            constructor = function(self, params)
                self.super(params)
            end,
        })

        local john = Person:new({ name = "John Doe", age = 21, agentId = 123 })

        return {
            assert(constructorParamsReceivedBySuperClass.name == "John Doe"),
            assert(constructorParamsReceivedBySuperClass.age == 21),
            assert(constructorParamsReceivedBySuperClass.agentId == 123),
            assert(john:supleClassMethods() == true),
        }
    end),
    it("should instantiate an empty class", function()
        local EmptyClass = class()
        local emptyClassInstance = EmptyClass:new()

        return {
            assert(emptyClassInstance ~= nil),
            assert(type(emptyClassInstance) == "table"),
        }
    end),
    it("should instantiate the super class twice without affecting the actual instances", function()
        local constructorParamsReceivedBySuperClass = {}

        local SecretAgent = class({
            constructor = function(_, params)
                constructorParamsReceivedBySuperClass = params
            end,
            supleClassMethods = function(_)
                return true
            end,
        })

        local Person = class({
            extends = SecretAgent,
            constructor = function(self, params)
                self.super(params)
            end,
        })

        local john = Person:new({ name = "John Doe", age = 21, agentId = 123 })
        local jane = Person:new({ name = "Jane Doe", age = 22, agentId = 456 })

        return {
            assert(constructorParamsReceivedBySuperClass.name == "Jane Doe"),
            assert(constructorParamsReceivedBySuperClass.age == 22),
            assert(constructorParamsReceivedBySuperClass.agentId == 456),
            assert(john:supleClassMethods() == true),
            assert(jane:supleClassMethods() == true),
        }
    end),
    it('should throw error if super() is called but no super class is found', function()
        local Person = class({
            constructor = function(self, params)
                self.super(params)
            end,
        })

        local status, err = pcall(function()
            Person:new({ name = "John Doe", age = 21, agentId = 123 })
        end)

        return {
            assert(status == false),
        }
    end),
    it('should throw error if class extends another class but the super is not called', function()
        local SecretAgent = class({
            constructor = function(_, params)
            end,
        })

        local Person = class({
            extends = SecretAgent,
            constructor = function(self, params)
            end,
        })

        local status, err = pcall(function()
            Person:new({ name = "John Doe", age = 21, agentId = 123 })
        end)

        local errMessage = err:match(':%d+: (.*)')

        return {
            assert(status == false),
            assert(errMessage == "some class constructor did not call super()"),
        }
    end),
    it(
    'should throw error with className if it was defined AND if class extends another class but the super is not called',
        function()
            local SecretAgent = class({
                name = "SecretAgent",
                constructor = function(_, params)
                end,
            })

            local Person = class({
                name = "Person",
                extends = SecretAgent,
                constructor = function(self, params)
                end,
            })

            local status, err = pcall(function()
                Person:new({ name = "John Doe", age = 21, agentId = 123 })
            end)

            local errMessage = err:match(':%d+: (.*)')
            return {
                assert(status == false),
                assert(errMessage == "super() was not called in the constructor of the class Person"),
            }
        end),
})
