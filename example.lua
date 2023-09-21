local class = require "class"

local SecretAgent = class({
  constructor = function(self, params)
    self.agentId = params.agentId
  end,
  methods = {
    getSecretName = function(self)
      return "Confidential"
    end,
    getAgentId = function(self)
      return self.agentId
    end,
  },
})

local Person = class({
  extends = SecretAgent,
  constructor = function(self, params)
    self.super({ agentId = params.agentId })
    self.name = params.name
    self.age = params.age
  end,
  methods = {
    getName = function(self)
      return self.name
    end,
    getAge = function(self)
      return self.age
    end,
  },
})

local john = Person:new({ name = "John Doe", age = 21, agentId = 123 })
local jane = Person:new({ name = "Jane Doe", age = 20, agentId = 456 })

print("Name: " .. john:getName())
print("Age: " .. john:getAge())
print("SecretName: " .. john:getSecretName())
print("AgentId: " .. john:getAgentId())

print("---------------")

print("Name: " .. jane:getName())
print("Age: " .. jane:getAge())
print("SecretName: " .. jane:getSecretName())
print("AgentId: " .. jane:getAgentId())
