## Bulk API

批量API使得可以在单个API调用中执行许多索引/删除操作。 这可以大大提高索引速度。

 **支持批量请求的客户端**

一些官方支持的客户提供帮助以协助批量请求，并将文件从一个索引重新索引到另一个索引：

Perl 
     请查看 [Search::Elasticsearch::Client::5_0::Bulk](https://metacpan.org/pod/Search::Elasticsearch::Client::5_0::Bulk)和[Search::Elasticsearch::Client::5_0::Scroll](https://metacpan.org/pod/Search::Elasticsearch::Client::5_0::Scroll)
Python 
     请查看 [elasticsearch.helpers.\*](http://elasticsearch-py.readthedocs.org/en/master/helpers.html)

批量操作的API是`/_bulk`,它支持使用换行符使用分隔符的JSON（NDJSON）数据结构：
  
    action_and_meta_data\n
    optional_source\n
    action_and_meta_data\n
    optional_source\n
    ....
    action_and_meta_data\n
    optional_source\n

 **提示** :最后一行必须有一个换行符（\\n）每一个换行符可能被当作一个回车`\\r`,当进行请求时，请求头应当被设置`Content-Type=application/x-ndjson` 

批量操作接口允许的操作有`建索引 index`,`建文档 create`,`删除文档 delete`跟`更新文档 update`,`index`跟`create`操作的参数要作为下一行，且要声明它的操作类型`op_type`(例如：如果索引或文档已经存在，`index`操作会失败，而`create`操作会更新文档)。`delete`操作不要求参数是下一行，跟标准的delete api格式一致。`update`操作要求文档结构的一部分或着upset\脚本（script）作为下一行。


如果您提供文本文件输入到`curl`，您必须使用`-data-binary`而不是`-d`选项。后者不保存新行。例子:
    
    $ cat requests
    { "index" : { "_index" : "test", "_type" : "type1", "_id" : "1" } }
    { "field1" : "value1" }
    $ curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/_bulk --data-binary "@requests"; echo
    {"took":7, "errors": false, "items":[{"index":{"_index":"test","_type":"type1","_id":"1","_version":1,"result":"created","forced_refresh":false} }]}

因为这种格式使用字面的`\n`作为分隔符，请确保JSON操作和参数不是格式化的数据。下面是一个正确的批量命令序列示例:
    
    POST _bulk
    { "index" : { "_index" : "test", "_type" : "type1", "_id" : "1" } }
    { "field1" : "value1" }
    { "delete" : { "_index" : "test", "_type" : "type1", "_id" : "2" } }
    { "create" : { "_index" : "test", "_type" : "type1", "_id" : "3" } }
    { "field1" : "value3" }
    { "update" : {"_id" : "1", "_type" : "type1", "_index" : "test"} }
    { "doc" : {"field2" : "value2"} }

请求的响应是：    
    
    {
       "took": 30,
       "errors": false,
       "items": [
          {
             "index": {
                "_index": "test",
                "_type": "type1",
                "_id": "1",
                "_version": 1,
                "result": "created",
                "_shards": {
                   "total": 2,
                   "successful": 1,
                   "failed": 0
                },
                "created": true,
                "status": 201
             }
          },
          {
             "delete": {
                "found": false,
                "_index": "test",
                "_type": "type1",
                "_id": "2",
                "_version": 1,
                "result": "not_found",
                "_shards": {
                   "total": 2,
                   "successful": 1,
                   "failed": 0
                },
                "status": 404
             }
          },
          {
             "create": {
                "_index": "test",
                "_type": "type1",
                "_id": "3",
                "_version": 1,
                "result": "created",
                "_shards": {
                   "total": 2,
                   "successful": 1,
                   "failed": 0
                },
                "created": true,
                "status": 201
             }
          },
          {
             "update": {
                "_index": "test",
                "_type": "type1",
                "_id": "1",
                "_version": 2,
                "result": "updated",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "status": 200
             }
          }
       ]
    }

接口有`/_bulk`, `/{index}/_bulk` 和 `{index}/{type}/_bulk`。当提供索引或索引/类型时，默认情况下将使用未显式提供它们的批量项目。

格式上的说明。这里的想法是尽可能快地处理这个问题。由于一些操作将被重定向到其他节点上的其他碎片，只有`action_meta_data`被解析到接收节点端。

使用此协议的客户端库应该尝试在客户端做一些类似的事情，尽可能减少缓存。

对批量操作的响应是一个大的JSON结构，每个操作的单个结果都执行了。单个动作的失败不会影响其余的动作。

在一个批量调用中执行的操作数没有`正确`的数量。您应该尝试不同的设置，以找到您的特定工作负载的最佳大小。

如果使用HTTP API，请确保客户端不发送大量的HTTP请求，因为这会减慢速度。

### 版本控制 Versioning

每个批量操作项都可以使用`\_version`/`version`字段包含版本值。它根据`\_version`映射自动跟踪索引/删除操作的行为。它还支持' version_type ' / '\_version_type '(参见[版本控制](docs-index_.html#index-versioning)))

### 路由 Routing

每个批量操作项都可以使用"\_routing"/"routing"字段包含路由值。它根据"\_routing"映射自动跟踪索引/删除操作的行为。


### 父文档参数 Parent

每个批量项目可以使用"\_parent"/"parent"字段包含父值。它根据"\_parent"/"\_routing"映射自动跟踪索引/删除操作的行为。

### 等待分片激活（请求超时） Wait For Active Shards

在进行批量调用时，可以设置`wait_for_active_shards`参数，在开始处理批量请求之前，需要使用最少的shard副本。请参阅[此处](docs-index_.html#index-wait-for-active-shards) ，了解更多细节和使用示例。

### 刷新 Refresh

当该请求所做的更改对搜索可见时，可以进行控制. 请参阅 [refresh](docs-refresh.html "?refresh").

### 更新 Update

在使用`update`操作时，可以将`_retry_on_conflict`作为操作本身中的字段(而不是在额外的负载行中)，指定在版本冲突的情况下，更新应该重新尝试多少次。

`更新`操作有效负载，支持以下选项:`doc`(部分文档)、`upsert`、`doc_as_upsert`、`script`和`_source`。有关选项的详细信息，请参阅[更新](docs-update.html)文档。例子与更新操作:
    
    POST _bulk
    { "update" : {"_id" : "1", "_type" : "type1", "_index" : "index1", "_retry_on_conflict" : 3} }
    { "doc" : {"field" : "value"} }
    { "update" : { "_id" : "0", "_type" : "type1", "_index" : "index1", "_retry_on_conflict" : 3} }
    { "script" : { "inline": "ctx._source.counter += params.param1", "lang" : "painless", "params" : {"param1" : 1} }, "upsert" : {"counter" : 1} }
    { "update" : {"_id" : "2", "_type" : "type1", "_index" : "index1", "_retry_on_conflict" : 3} }
    { "doc" : {"field" : "value"}, "doc_as_upsert" : true }
    { "update" : {"_id" : "3", "_type" : "type1", "_index" : "index1", "_source" : true} }
    { "doc" : {"field" : "value"} }
    { "update" : {"_id" : "4", "_type" : "type1", "_index" : "index1"} }
    { "doc" : {"field" : "value"}, "_source": true}

### 安全 Security

请查看[基于URL的访问控制](url-access-control.html)
