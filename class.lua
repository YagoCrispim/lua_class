return function(classDefinition)
    local constants = {
        constructor = 'constructor',
        extends = 'extends',
    }

    local newFn = {
        new = function(_, constructorParams)
            --[[
                \-1 = super() not needed \
                0 = super() needed, but not called \
                1 = super() needed and called
            ]]
            local wasSuperCalled = -1

            ---
            local newClassInstance = {}

            if not classDefinition then return newClassInstance end

            local constructor = nil
            local methods = {}

            if methods then
                for key, value in pairs(classDefinition) do
                    if key == constants.constructor then
                        constructor = value
                    elseif type(value) == "function" then
                        newClassInstance[key] = function(self, ...)
                            return value(self, ...)
                        end
                    else
                        newClassInstance[key] = value
                    end
                end
            end

            local superClass = classDefinition.extends
            if superClass and type(superClass) == "table" then
                wasSuperCalled = 0

                newClassInstance.super = function()
                    wasSuperCalled = 1
                    local superClassInstance = superClass:new(constructorParams)
                    for k, v in pairs(superClassInstance) do
                        newClassInstance[k] = v
                    end
                end
            end

            if constructor and type(constructor) == "function" then
                constructor(newClassInstance, constructorParams)
            end

            if wasSuperCalled == 0 then
                if classDefinition.name then
                    error("super() was not called in the constructor of the class " .. classDefinition.name)
                else
                    error("some class constructor did not call super()")
                end
            end

            return newClassInstance
        end,
    }

    return newFn
end
