function getRelays()
    local peripheralList = peripheral.getNames()

    local filteredList = {}
    for _, str in ipairs(peripheralList) do
        if str:match("^redstone_relay_%d+$") then
            table.insert(filteredList, str)
        end
    end

    table.sort(filteredList, function(a, b)
        local numA = tonumber(a:match("_(%d+)$"))
        local numB = tonumber(b:match("_(%d+)$"))
        return numA < numB
    end)

    local wrapped = {}
    for _, str in ipairs(filteredList) do
        local peri = peripheral.wrap(str)
        table.insert(wrapped,peri)
    end

    return wrapped
end

return {wrapped = wrapped}
