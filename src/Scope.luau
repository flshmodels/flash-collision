local Scope = {}

function Scope.collect(roots, expand, predicate, limits)
    limits = limits or { maxNodes = 5000, maxTargets = 1000, allowServices = false }
    assert(#roots > 0 and #roots <= 500, "Choose between 1 and 500 selection roots.")
    local queued, stack, targets = {}, {}, {}
    local discovered = 0
    local function enqueue(object)
        if queued[object] then return end
        discovered += 1
        assert(discovered <= limits.maxNodes, "Scope exceeds " .. limits.maxNodes .. " objects. Select a smaller area.")
        queued[object] = true
        table.insert(stack, object)
    end
    for index = #roots, 1, -1 do
        local object = roots[index]
        assert(object.Parent and object:IsDescendantOf(game), "Selection contains a detached object.")
        assert(limits.allowServices or object.Parent ~= game, "Select objects inside a service, not the service itself.")
        enqueue(object)
    end
    while #stack > 0 do
        local object = table.remove(stack)
        if predicate(object) then
            assert(#targets < limits.maxTargets, "More than " .. limits.maxTargets .. " targets. Select a smaller area.")
            table.insert(targets, object)
        end
        if expand then
            local children = object:GetChildren()
            for index = #children, 1, -1 do enqueue(children[index]) end
        end
    end
    return targets, discovered
end

return Scope
