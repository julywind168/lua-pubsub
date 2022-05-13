local state = require "client.state"
local view = require "client.view"


view.init()


view.dump()

-- In online games, the interface in state is generally triggered and called by network messages
state.add_gold(10)

view.dump()


-- open and test
-- view.try_sub_undefind_interface()
