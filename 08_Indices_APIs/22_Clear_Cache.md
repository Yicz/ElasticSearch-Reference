## 清除缓存 Clear Cache

清除缓存API允许清除与一个或多个索引关联的所有缓存或特定缓存。    
    
    POST /twitter/_cache/clear

这个API默认会清除所有的缓存。 通过设置`query`，`fielddata`或`request`可以明确清除特定的缓存。

所有与特定字段相关的缓存也可以通过用逗号分隔的相关字段列表指定`fields`参数来清除。

### 多索引 Multi Index

清除缓存API可以在一次请求中设置多个索引或者全部(`_all`)索引   
    
    POST /kimchy,elasticsearch/_cache/clear
    
    POST /_cache/clear
