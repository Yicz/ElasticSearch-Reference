## 批处理

除了索引，更新，删除文档。ES也提供了同时执行上面操作的[`_bulk` API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-bulk.html)操作，称作批处理。这个功能ES执行多个操作来是是非常高效的，它尽可能地减少了网络传输。

给一个快速的例子，下面进行使用批处理索引两个文档（主键（ID）为 1的 John Doe 和主键（ID）为2的Jane Doe）：
    
    
    POST /customer/external/_bulk?pretty
    {"index":{"_id":"1"} }
    {"name": "John Doe" }
    {"index":{"_id":"2"} }
    {"name": "Jane Doe" }

下面使用批处理更新文档1并删除文档2的内容：
    
    POST /customer/external/_bulk?pretty
    {"update":{"_id":"1"} }
    {"doc": { "name": "John Doe becomes Jane Doe" } }
    {"delete":{"_id":"2"} }

在上面的删除操作中，只要求ID并不要求有文档的内容字段。

批处理操作并不会因为其中的一个操作失败而失败。无论任何情况的单个操作的失败，批处理都会照常执行。它会返回单个操作失败的原因。
