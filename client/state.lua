local ps = require "pubsub"

local state = {id = "123456", gold = 0, nick = "windy"}


-- Your Interface
local I = {}

function I.add_gold(n)
    state.gold = state.gold + n
end


-------------------------------------------------------
local M = {}

local PREFIX = "__state_"

local function safely(f)
    return function (name, ...)
        assert(I[name], "undefined interface: "..tostring(name))
        return f(PREFIX..name, ...)
    end
end

M.sub = safely(ps.sub)
M.sub_once = safely(ps.sub_once)
M.sub_many = safely(ps.sub_many)

return setmetatable(M, {__index = function (_, name)
    local f = I[name]
    if f then
        return function (...)
            f(...)
            ps.pub(PREFIX..name, ...)
        end
    else
        return state[name]
    end
end})