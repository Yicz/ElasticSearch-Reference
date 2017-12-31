## 删除索引 Delete Index

删除索引API是将一个已经存在的索引进行删除：
    
    DELETE /twitter

上面的例子将一个叫做`twitter`的索引进行了删除，必须指定一个索引（index）,索引别名（alias）或者通配符表达式（wilicard expression）.

删除API可以用于删除一个或者多个的索引，通过使用`,`进行分隔索引的名称列表。或者使用`_all`和`*`代表全部的索引。


禁用使用通配符或者`*`删除索引，可以设置`action.destructive_requires_name=true`,可以设置同样响应更新索引接口。
