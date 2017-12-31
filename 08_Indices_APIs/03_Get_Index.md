## 获取索引 Get Index

获取索引API允许对一个或者多个索引进行检索信息。
    
    GET /twitter
上面的例子检索了一个名字叫做`twitter`的索引。获取索引API必须指定一个索引（index）,别名（alias）或者通配符表达式（wildcard expression）。


获取索引API可以指定多个文档，或者使用`_all`和`*`代表全部的文档

### 过滤索引信息 Filtering index information

返回的响应内容可以通过指定内容进行过滤，可以使用`,`进行分隔指定多个内容。
    
    GET twitter/_settings,_mappings

上述的例子只会返回`twitter`引过中的`settings`和`mappings`内容


可以指定的内容有 `_settings`, `_mappings` 和 `_aliases`.
