local M = {}

local listeners = {}

local function event_queue(name)
    listeners[name] = listeners[name] or {}
    return listeners[name]
end

local processing = false
local unsub_list = {}

-- Interface
function M.pub(name, ...)
    processing = true
    local queue = event_queue(name)
    for _,cb in ipairs(queue) do
        cb(...)
    end
    processing = false

    for i = 1, #unsub_list do
        unsub_list[i]()
        unsub_list[i] = nil
    end
end


function M.sub(name, callback)
    local queue = event_queue(name)
    table.insert(queue, callback)

    local function unsub()
        for i,cb in ipairs(queue) do
            if cb == callback then
                return table.remove(queue, i)
            end
        end
    end

    return function ()
        if processing then
            table.insert(unsub_list, unsub)
        else
            unsub()
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