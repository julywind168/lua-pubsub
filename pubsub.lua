local M = {}

local subscribers = {}

local function subscriber_queue(name)
    subscribers[name] = subscribers[name] or {}
    return subscribers[name]
end


local processing = false
local defer = {}

local destroyed = {}

-- Interface
function M.pub(name, ...)
    if processing then
        table.insert(defer, {name, ...})
        return
    end

    processing = true
    do
        local queue = subscriber_queue(name)
        for i,callback in ipairs(queue) do
            if callback(...) then
                table.insert(destroyed, i)
            end
        end

        -- clear
        for i=#destroyed,1,-1 do
            table.remove(queue, destroyed[i])
            destroyed[i] = nil
        end
    end
    processing = false

    local e = table.remove(defer, 1)
    if e then
        M.pub(table.unpack(e))
    end
end


function M.sub(name, callback)
    local queue = subscriber_queue(name)

    local function subscriber(...)
        if callback then
            callback(...)
        else
            return true
        end
    end

    table.insert(queue, subscriber)

    return function ()
        callback = nil
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