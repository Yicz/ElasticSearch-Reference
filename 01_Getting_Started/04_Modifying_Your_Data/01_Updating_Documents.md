## 更新文档

除了可以索引和替换索引，我们还可以更新索引。提示：ES并不是真的直接替换一个文档，而是在我们进行更新的时候，ES标志删除文档并新增加一个文档。

这是一个例子：如何更改在前面章节中主键（ID）为1的文档的名字字段变成“Jane Doe”：
    
    
    POST /customer/external/1/_update?pretty
    {
      "doc": { "name": "Jane Doe" }
    }

这是一个例子：如何更改在前面章节中主键（ID）为1的文档的名字字段变成“Jane Doe”，并添加了一个`age`的字段：

    
    POST /customer/external/1/_update?pretty
    {
      "doc": { "name": "Jane Doe", "age": 20 }
    }

更新操作同时可以简单的脚本来执行,下面的例子是使用脚本对`age`增加5:
    
    
    POST /customer/external/1/_update?pretty
    {
      "script" : "ctx._source.age += 5"
    }

在上面例子中，`ctx._source`参考了当前源文档

提示：当前的更新操作，ES只允许候一个文档，在将来ES可能会提供通过条件查询并批量修改文档的能力，类似`SQL UPDATE-WHERE`语句。