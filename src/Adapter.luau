local Rules = require(script.Parent.Rules)
local Scope = require(script.Parent.Scope)
local Adapter = {}

function Adapter.registered()
    -- Collision groups are per-world in current Studio. Older versions use PhysicsService.
    local ok, groups = pcall(function() return workspace:GetRegisteredCollisionGroups() end)
    if not ok then groups = game:GetService("PhysicsService"):GetRegisteredCollisionGroups() end
    local names = {}
    for _, group in ipairs(groups) do names[group.name] = true end
    return names
end

local function eligible(object)
    return object:IsA("BasePart") and object:IsDescendantOf(workspace)
        and object:FindFirstAncestorWhichIsA("WorldRoot") == workspace
end

function Adapter.controls(panel, changed)
    panel.label("Assign existing collision groups. This does not change the group's collision rules or create groups.")
    local group = panel.field("Collision group (exact name)", "Default")
    local expand = panel.cycle("Scope", { "Selection only", "Include descendants" }, changed)
    local list = panel.label("")
    local function refresh()
        local ok, names = pcall(Adapter.registered)
        if not ok then list.Text = "Could not read groups: " .. tostring(names) return end
        local sorted = {}
        for name in pairs(names) do table.insert(sorted, name) end
        table.sort(sorted)
        list.Text = "Registered in Workspace: " .. table.concat(sorted, ", ")
    end
    panel.button("Refresh registered groups", function() changed() refresh() end)
    group:GetPropertyChangedSignal("Text"):Connect(changed)
    refresh()
    return function() return { group = group.Text, expand = expand() == "Include descendants" } end
end

function Adapter.plan(selection, options)
    local parts, scanned = Scope.collect(selection, options.expand, eligible)
    local rows = {}
    for _, part in ipairs(parts) do
        assert(not part.Locked, "A target part is locked. Unlock it or use a smaller selection.")
        table.insert(rows, { target = part, parent = part.Parent, group = part.CollisionGroup })
    end
    local plan = Rules.plan(rows, options.group, Adapter.registered())
    plan.summary = string.format("%d changes / %d eligible parts / %d objects scanned.", #plan, #parts, scanned)
    for _, entry in ipairs(plan) do
        entry.label = entry.before.target:GetFullName() .. "\n" .. entry.before.group .. " -> " .. entry.after
    end
    return plan
end

function Adapter.validate(plan)
    local groups = Adapter.registered()
    for _, entry in ipairs(plan) do
        local before = entry.before
        if not groups[entry.after] then return false, "The destination group was removed or renamed. Preview again." end
        if not eligible(before.target) or before.target.Locked or before.target.Parent ~= before.parent or before.target.CollisionGroup ~= before.group then
            return false, "A target changed world, parent, lock state or collision group. Preview again."
        end
    end
    return true
end

function Adapter.write(entry)
    entry.before.target.CollisionGroup = entry.after
end

return Adapter
