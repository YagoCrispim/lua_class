local constants = {
    constructor = 'constructor',
    extends = 'extends',
    implements = 'implements'
}

---@param obj table
---@param seen? table
---@return table | nil
local function table_copy(obj, seen)
    --[[
        Validate if unstable with table that have meta tables
    ]]
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[table_copy(k, s)] = table_copy(v, s) end
    return res
end

---@param context _Cls_Context
local function set_methods(context)
    local c = context
    local class_definition = c.class_definition

    for key, value in pairs(c.class_definition) do
        if key == constants.constructor then
            c.constructor = value
        elseif type(value) == "function" then
            c.new_instance[key] = function(...) return value(...) end
        elseif type(value) == "table" then
            c.new_instance[key] = table_copy(value)
        else
            c.new_instance[key] = value
        end
    end

    if class_definition.__extends and type(class_definition.__extends) ==
        "table" then
        c.was_super_called = 0

        ---@diagnostic disable-next-line: inject-field
        c.new_instance.super = function(_, params)
            c.was_super_called = 1
            local super_class_instance = class_definition.__extends:new(params)
            for k, v in pairs(super_class_instance) do
                c.new_instance[k] = v
            end
        end
    end
end

---@param context _Cls_Context
local function run_constructor_if_available(context)
    local c = context

    if c.constructor and type(c.constructor) == "function" then
        c.constructor(c.new_instance, c.constructor_params)
    end
end

---@param context _Cls_Context
local function check_if_super_was_called(context)
    local c = context

    if c.was_super_called == 0 then error("'super()' not called") end
end

---@generic T
---@param self T
---@return table
local function values(self)
    local function get_values(class)
        local class_values = {}

        for k, v in pairs(class) do
            if type(v) == 'number' or type(v) == 'string' or type(v) ==
                'boolean' then class_values[k] = v end

            if type(v) == 'table' and k ~= '__use' then
                class_values[k] = get_values(v)
            end
        end

        return class_values
    end

    return get_values(self)
end

---@param context _Cls_Context
local function set_traits(context)
    local c = context
    if not c.class_definition.__use or #c.class_definition.__use == 0 then
        return
    end

    local traits_list = c.class_definition.__use

    for _, trait in pairs(traits_list) do
        for k, v in pairs(trait) do
            local value = v

            if type(v) == "table" then value = table_copy(v) end
            c.new_instance[k] = value
        end
    end
end

---@param class_definition? Cls_Definition
---@return Class
return function(class_definition)
    return {
        new = function(_, constructor_params)
            if not class_definition then return {} end

            ---@type _Cls_Context
            local context = {
                was_super_called = nil,
                constructor = nil,
                new_instance = {
                    __name = class_definition.__name or '',
                    __values = values,
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    new = nil
                },
                class_definition = class_definition,
                constructor_params = constructor_params
            }

            set_methods(context)
            set_traits(context)
            run_constructor_if_available(context)
            check_if_super_was_called(context)

            local instance = context.new_instance

            ---@diagnostic disable-next-line: cast-local-type
            context = nil

            return instance
        end
    }
end
--[[

  TYPES

]]
---@class Class : table
---@field __name string
---@field __values fun(self: Class): table
---@field new fun(self: Class, constructor_params?: table): table
---@field super? fun(self: Class, params?: table): nil
--
---@class Cls_Definition : table
---@field __name? string
---@field __use? table<string, function>
---@field __extends? Class
---@field constructor? fun(self: table, params: table): nil
--
---@class _Cls_Context
---@field new_instance Class
---@field constructor function | nil
---@field class_definition table  
---@field was_super_called number | nil
---@field constructor_params table
