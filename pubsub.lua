local M = {}

local subscribers = {}

local function subscriber_queue(name)
    subscribers[name] = subscribers[name] or {}
    return subscribers[name]
end

local function copy(list)
    local new = {}
    for i,v in ipairs(list) do
        new[i] = v
    end
    return new
end


local processing = false
local defer = {}

-- Interface
function M.pub(name, ...)
    if processing then
        table.insert(defer, {name = name, args = {...}})
        return
    end

    processing = true
    do
        local queue = copy(subscriber_queue(name))
        for _,s in ipairs(queue) do
            if s.active then
                s.callback(...)
            end
        end
    end
    processing = false

    local e = table.remove(defer, 1)
    if e then
        M.pub(e.name, table.unpack(e.args))
    end
end


function M.sub(name, callback)
    local queue = subscriber_queue(name)
    local subscriber = {active = true, callback = callback}
    table.insert(queue, subscriber)

    return function ()
        for i,s in ipairs(queue) do
            if s == subscriber then
                subscriber.active = false
                return table.remove(queue, i)
            end
        end
    end
end


function M.sub_once(name, callback)
    local unsub; unsub = M.sub(name, function (...)
        unsub()
        callback(...)
    end)
end


function M.sub_many(name, callback, num)
    assert(num >= 1)
    local count = 0
    local unsub; unsub = M.sub(name, function (...)
        count = count + 1
        if count == num then
            unsub()
        end
        callback(...)
    end)
end


return M