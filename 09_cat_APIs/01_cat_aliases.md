## 查看别名 cat aliases

`aliases`展示了当前索引配置的别名（aliases）,包含了过滤和由路信息。
    
    GET /_cat/aliases?v

响应内容：
    
    
    alias  index filter routing.index routing.search
    alias1 test1 -      -            -
    alias2 test1 *      -            -
    alias3 test1 -      1            1
    alias4 test1 -      2            1,2

上面的输出显示了`alias2`配置了一个滤过和`alias3`和`alias4`配置路由信息。

如果你只想获取单个别名（alias）,你可以在URL上添加别名（alias）进行明确指定一个别名。
