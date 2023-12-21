local describe = ltest.describe
local it = ltest.it

local class = require "class"

describe("class", {
  it("should execute the class constructor", function()
    local wasConstructorCalled = false
    class({
      constructor = function(_self)
        wasConstructorCalled = true
      end,
    }):new()

    return {
      assert(wasConstructorCalled == true),
    }
  end),
  it("should set the class methods", function()
    local Person = class({
      methods = {
        getName = function(_self)
          return "John Doe"
        end,
        getAge = function(_self)
          return 21
        end,
      },
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
      constructor = function(_self, params)
        constructorParamsReceivedBySuperClass = params
      end,
      methods = {
        supleClassMethods = function(_self)
          return true
        end,
      },
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
      constructor = function(_self, params)
        constructorParamsReceivedBySuperClass = params
      end,
      methods = {
        supleClassMethods = function(_self)
          return true
        end,
      },
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
  it("should crash when trying to override a method or property from the super class", function()
    local function createPerson()
      local SecretAgent = class({
        methods = {
          getName = function(_self)
            return true
          end,
        },
      })

      local Person = class({
        extends = SecretAgent,
        constructor = function(self, params)
          self.super(params)
        end,
        methods = {
          getName = function(_self)
            return false
          end,
        },
      })

      return Person:new({
        methods = {
          getName = function(_self)
            return 21
          end,
        },
      })
    end

    return {
      assert(pcall(createPerson) == false),
    }
  end),
})
