## 索引因子（提升） Index Boost

允许在跨越多个索引进行搜索时为每个索引配置不同的提升级别。当来自一个索引的命中超过来自另一索引的命中时（这认为每个用户具有索引的社交图），这是非常方便的。

Allows to configure different boost level per index when searching across more than one indices. This is very handy when hits coming from one index matter more than hits coming from another index (think social graph where each user has an index).

![Warning](/images/icons/warning.png)

### Deprecated in 5.2.0. 

这种格式已被弃用。 请改用数组格式：    
    
    GET /_search
    {
        "indices_boost" : {
            "index1" : 1.4,
            "index2" : 1.3
        }
    }

您也可以将其指定为一个数组来控制提升次序。    
    
    GET /_search
    {
        "indices_boost" : [
            { "alias1" : 1.4 },
            { "index*" : 1.3 }
        ]
    }

当使用别名或通配符表达式时，这很重要。 如果找到多个匹配，则将使用第一个匹配。 例如，如果一个索引被包含在`alias1`和`index *`中，`1.4`的提升值被应用。

