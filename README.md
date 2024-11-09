# lua-class

Classes in Lua - WIP

## Example

```lua
local class = require "src.class"

local LogAllTrait = {
  log_all = function(self)
    print("Name: " .. self.name)
    print("Age: " .. self.age)
    print("SecretName: " .. self.secret_name)
    print("AgentId: " .. self.agent_id)
  end
}

local SecretAgent = class {
  __use = { LogAllTrait },

  constructor = function(self, params)
    self.secret_name = 'Confidential'
    self.agent_id = params.agent_id
  end,

  super_method = function()
    print("[SecretAgent]: Super method")
  end
}

local Person = class {
  __extends = SecretAgent,
  constructor = function(self, params)
    self:super(params)
    self.name = params.name
    self.age = params.age
  end,

  class_method = function()
    print("[Person]: Class method")
  end
}

local john = Person:new({ name = "John Doe", age = 21, agent_id = 123 })
local jane = Person:new({ name = "Jane Doe", age = 20, agent_id = 456 })

--

john:log_all()
john:class_method()
john:super_method()

print('---')

jane:log_all()
jane:class_method()
jane:super_method()

```
