## 修改你的数据

ES提供了近实时的数据操作和查询的能力，默认地，你可以创建/更新/删除（index/update/delete）你的数据并能在1秒的延迟内能查询到你操作的数据。这功能类似SQL平台的事务操作，当一个事务完成的时候，你就可以立即看到了操作的数据。

### 创建或替换（Indexing/Replacing）文档

我们之前操作过如何去创建一个文档，现在我重新查看这条命令：
        
    PUT /customer/external/1?pretty
    {
      "name": "John Doe"
    }

上面的命令指出了索引是customer，类型为external并且文档的主键（ID）为1，如果我们再一次执行上面的命令并使用不同的文档，ES将会替换（或重创建）主键为1一个新的文档
    
    PUT /customer/external/1?pretty
    {
      "name": "Jane Doe"
    }

上面的命令改变了文档1的内容：从`John Doe`变到`Jane Doe`,ES使用一个id操作一个文档的时候，如果文档已经存在则是替换（重新创建）一个文档，否则是新建一个文档。
        
    PUT /customer/external/2?pretty
    {
      "name": "Jane Doe"
    }

上面的命令是创建一个Id为2的新索引

当创建索引的时候，Id是可选项，如果没有明确指定。ES会生成一个随机ID并分配给该文档，Index API被调用的时候ES会返回文档的Id。


下面的例子展示了没有明确指定一个Id的情况。    
    
    POST /customer/external?pretty
    {
      "name": "Jane Doe"
    }

注意上面的例子, 我们没有明确一个Id的时候，使用 `POST`方法 而不是`PUT`方法.
