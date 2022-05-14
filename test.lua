local ps = require "pubsub"


ps.sub("hello", function (...)
    print("hello", ...)
end)


ps.sub_once("hello", function (...)
    print("I will receive 1 `hello`", ...)
    ps.pub("hello", "world", 2)
end)

ps.sub_many("hello", function (...)
    print("I will receive 3 `hello`", ...)
end, 3)


ps.pub("hello", "world", 1)
ps.pub("hello", "world", 3)