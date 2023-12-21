return function(classDefinition)
    return {
        new = function(_, constructorParams)
            local newClassInstance = {}

            if not classDefinition then
                return newClassInstance
            end

            local methods = classDefinition.methods
            local constructor = classDefinition.constructor
            local superClass = classDefinition.extends

            if methods then
                for methodName, method in pairs(methods) do
                    newClassInstance[methodName] = function(self, ...)
                        return method(self, ...)
                    end
                end
            end

            if superClass then
                if type(superClass) == "table" then
                    newClassInstance.super = function(self)
                        local superClassInstance = superClass:new(constructorParams)
                        for k, v in pairs(superClassInstance) do
                            if newClassInstance[k] == nil then
                                newClassInstance[k] = v
                            else
                                error(
                                    "[ERROR]: The child class already has a property named '[" ..
                                    k .. "]' inherited from the parent class."
                                )
                            end
                        end
                    end
                end
            end

            if constructor then
                if constructor and type(constructor) == "function" then
                    constructor(newClassInstance, constructorParams)
                end
                return newClassInstance
            end

            return newClassInstance
        end,
    }
end
