## 删除一个索引

现在让我们删除索引并再一次列出所有的索引：
    
    DELETE /customer?pretty
    GET /_cat/indices?v

响应:
    
    
    health status index uuid pri rep docs.count docs.deleted store.size pri.store.size

这意味着我们成功删除了索引，并又回到了ES作集群没有数据的状态。

在我们往下学习之前，我们回顾一下至今我们学到的API有哪些：
    
    
    PUT /customer
    PUT /customer/external/1
    {
      "name": "John Doe"
    }
    GET /customer/external/1
    DELETE /customer

如果我们认真学习了上面的命令，我们就会总结出一个在ES集群中访问数据的模式，这个模式总结如下：
    
    <REST Verb> /<Index>/<Type>/<ID>

这就是RES风格的模式，你可以简单地记住它们，这样就可以对ES的学习有了一个好的开头。