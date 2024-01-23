return function(classDefinition)
    local constants = {
        constructor = 'constructor',
        extends = 'extends',
    }

    return {
        new = function(self, constructorParams)
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

            for k, v in pairs(classDefinition) do
                if k == constants.constructor then
                    constructor = v
                else
                    if k ~= constants.extends then
                        methods[k] = v
                    end
                end
            end

            if methods then
                for methodName, method in pairs(methods) do
                    newClassInstance[methodName] = function(self, ...)
                        return method(self, ...)
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
end
