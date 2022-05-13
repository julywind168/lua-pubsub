local ps = require "pubsub"


ps.sub("hello", function (...)
    print("hello", ...)
end)


ps.sub_once("hello", function (...)
    print("I will receive once `hello`", ...)
end)



for i = 1, 3 do
    ps.pub("hello", "world", i)
end