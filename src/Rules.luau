local Rules = {}

function Rules.plan(rows, group, registered)
    assert(#rows > 0 and #rows <= 1000, "Choose between 1 and 1000 eligible parts.")
    assert(type(group) == "string" and #group > 0 and #group <= 100 and utf8.len(group) and group:match("%S") and not group:find("%c"), "Enter an exact collision-group name, up to 100 UTF-8 bytes, without control characters.")
    assert(registered[group] == true, "That group is not registered in Workspace. Create it with Studio's collision-group editor first.")
    local plan = {}
    for _, row in ipairs(rows) do
        if row.group ~= group then table.insert(plan, { before = row, after = group }) end
    end
    return plan
end

return Rules
