# Get API
Get API是根据一个文档的Id来返回一个json文档。下面的粟子是从索引“twitter”中获取了一个类型为“tweet”且主键ID为0:

```sh
curl -XGET 'localhost:9200/twitter/tweet/0?pretty'
#响应内容
{
    "_index" : "twitter",
    "_type" : "tweet",
    "_id" : "0",
    "_version" : 1,
    "found": true,
    "_source" : {
        "user" : "kimchy",
        "date" : "2009-11-15T14:12:12",
        "likes": 0,
        "message" : "trying out Elasticsearch"
    }
}
```
返回的结果包含了`_index`,`_type`,`_id`,`_version`,它们分别是索引类型，文档类型，主键，文档版本，也包含了文档的实际内容`_source`,`found`表是否查到这个文档，当`found=ture时`,才会返回`_source`字段的内容。

还有一个API是可以响应文档是否存在的

```sh
curl -XHEAD 'localhost:9200/twitter/tweet/0?pretty'
```

## 实时性

默认情况下，get API是实时的，并且不受索引刷新率的影响（当数据对于搜索可见时）。 如果文档已更新但尚未刷新，get API将发出刷新请求以使这文档可见。 这也会刷新后其他文档在修改后发生变化。 为了禁用实时GET，可以将实时参数`realtime`设置为false。

## 过虑_source 返回值
默认的返回值中，包含了一个——source字段（包含了原json内容），可以设置`_store_fields`或`_source=false`:

```sh
curl -XGET 'localhost:9200/twitter/tweet/0?_source=false&pretty'
```
如果您只需要_source中的一个或两个字段，则可以使用`_source_include`和`_source_exclude`参数来包含或过滤出所需的部分。 这对大型文档特别有用，在这种情况下，部分检索可以节省网络开销。 两个参数都采用逗号分隔的字段列表或通配符表达式。 例：

```sh
curl -XGET 'localhost:9200/twitter/tweet/0?_source_include=*.id&_source_exclude=entities&pretty'
```

你只想返回指定的内容,您可以使用一个更短的符号:

```sh
curl -XGET 'localhost:9200/twitter/tweet/0?_source=*.id,retweeted&pretty'
```

### Store Fields
将通过stored_fields返回参数,get操作允许指定一组存储字段,。如果所请求的字段不存储,它们将被忽略。考虑例如以下映射:

```sh
curl -XPUT 'localhost:9200/twitter?pretty' -H 'Content-Type: application/json' -d'
{
   "mappings": {
      "tweet": {
         "properties": {
            "counter": {
               "type": "integer",
               "store": false
            },
            "tags": {
               "type": "keyword",
               "store": true
            }
         }
      }
   }
}
'
#添加文档
curl -XPUT 'localhost:9200/twitter/tweet/1?pretty' -H 'Content-Type: application/json' -d'
{
    "counter" : 1,
    "tags" : ["red"]
}
# 查询结果
{
   "_index": "twitter",
   "_type": "tweet",
   "_id": "1",
   "_version": 1,
   "found": true,
   "fields": {
      "tags": [
         "red"
      ]
   }
}

```

字段值从文档中提取它自我总是作为一个数组返回。因为计数器字段不是存储get请求试图让stored_fields时只是忽略它。 　　 　　还可以检索元数据字段_routing和_parent字段:



