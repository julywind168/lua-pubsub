# Event publish/subscribe for Lua


## Test
```
    cd lua-pubsub
    1. lua test.lua
    2. lua client.lua
```

## 说明
```
    这是一个非常简单的 发布/订阅 lua 库, pubsub.lua 带空格不到100行。

    第一个例子 (test.lua)
         展示了 非常简单的用法, 包括订阅和仅订阅一次

    第二个例子 (client)
        简单演示了，如何通过 pubsub 让状态和视图分离的做法（游戏客户端 unity 等）
        首先我们先给了 state 模块一个初始状态, 然后定义了 Interface 部分,

        Interface 在网络游戏中一般由网络消息包调用(当然也有本地状态, 这部分由玩家操作驱动),
        调用完后，state 会自动发布该事件

        我们只需要在 view 部分使用 state.sub 订阅与自己相关的事件即可 (重新读取state,
        刷新ui, 有些事件可能还会触发动画)

        我让 state 接管了 pubsub 的订阅功能, state 内的 事件名添加了前缀 以免和其他代码冲突,
        state.sub 还检查了 Interface 必须先定义, 避免拼写错误
```