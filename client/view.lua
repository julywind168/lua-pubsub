local state = require "client.state"

local label = "Gold:100000"

local function refresh()
    label = "Gold:" .. state.gold
end


---------------------------------------
state.sub("add_gold", function (n)
    print(string.format("View get `add_gold` event, get %d gold, you maybe run an animation", n))
    refresh()
end)


local view = {}

function view.init()
    refresh()
end

function view.dump()
    print("View Label.text:", label)
end

function view.try_sub_undefind_interface()
    state.sub("add_diamond", function ()
        -- pass
    end)
end

return view