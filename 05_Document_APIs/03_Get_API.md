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
将通过stored_fields返回参数,get操作可以指定存储一组字段。如果所请求的字段不存储,它们将被忽略。考虑例如以下映射:

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
# 尝试获取结果
curl -XGET 'localhost:9200/twitter/tweet/1?stored_fields=tags,counter&pretty'
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

从文档中提取字段值，总是作为一个数组返回。尝试获取counter字段的时候，因为映射关系中设置了不存储counter值，所以返回值中，我们找不到counter字段。
还可以检索元数据字段`_routing`和`_parent`字段:

```sh
# 首先存放一个routing的文档，下面的值routing的内容是user1
curl -XPUT 'localhost:9200/twitter/tweet/2?routing=user1&pretty' -H 'Content-Type: application/json' -d'
{
    "counter" : 1,
    "tags" : ["white"]
}
'
# 在查找的时候也要相应地设置routing=user1,才可以确定到分片上，进行查找到相应的内容。
curl -XGET 'localhost:9200/twitter/tweet/2?routing=user1&stored_fields=tags,counter&pretty'
# 返回的内容为
{
   "_index": "twitter",
   "_type": "tweet",
   "_id": "2",
   "_version": 1,
   "_routing": "user1",
   "found": true,
   "fields": {
      "tags": [
         "white"
      ]
   }
}
```

在返回的store_filed中，有一个这样的限制：必须为文档的叶子字段，非叶子字段的请求将会失败。

### elastics生成的字段

当建立索引的时候，文档中的一些特殊字段是elasticsearch本身生成的，如果elasticseach在建立索引的过程中，如果还没有刷新索引，你请求了一个由elasticsearch生成的字段时，将会发生异常（默认设置），你可以通过设置：`ignore_errors_on_generated_fields=true.`去忽略这些由elasticsearch 自动生成的字段。

## 直接获取原文档`_source`
我们可以直接过能`/{index}/{type}/{id}/_source`接口，获取一个文档的原为json文档内容：

```sh
curl -XGET 'localhost:9200/twitter/tweet/2?routing=user1&pretty'
```    

我们还可以针对文档的内容字段进行过滤：

```sh
curl -XGET 'localhost:9200/twitter/tweet/1/_source?_source_include=*.id&_source_exclude=entities'&pretty'
```

`_source_include `是指定返回的内容，`_source_exclude `是指定排除的内容。

同时还提供了一个HEAD方法的查询_source字段是否存在，因为_source字段可以根据映射（mapping）中设置进行隐藏。详情请移步[映射内容](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/mapping-source-field.html)

## routing 
当我们设置了一个路由文档到分片位置的字段的时候，我们要查询这样的一个文档时，我们又也进行指定文档的routing字段。否则我们将查询不到这样的一个文档：

## 优先权
`perference`是这样的一个参数，它指定了请求优先去哪一种分片进行查找，它默认的设置是随机到各个分片之间进行查询。它可以有以下几种的设值内容：

* _primary  
顾名思义，它只在主分片进行为查询
* _local  
请未会尽量在请求本地的分片上进行查询
* 自定义值  
自定义值将用于保证自定义值相同的分片。这可以帮助与“jumping values”当触及不同的分片刷新状态。自定义值可以像web会话id,或者用户名。

# refresh 
`refresh`参数可以让elastic正在索引的内容可以被搜索到，原理是在请求执行之前，对正在进行建立索引的内容先保存到索引中。

# 分发 
get操作被hash到一个特定的分片id。然后被重定向到一个副本分片片id并计算后返回结果。分片组包含了主分片及其复制分片的id。这意味着更多的副本,elasticsearch可以进行大量的计算。

# 版本控制支持

可以使用`version`参数来检索特定版本的文档。___`FORCE`将会强制返回一个文档，不管指定的文档存不存在(已经弃用)___，在elasticsearch的内部原理中，旧版本的文档只是被标志成删除状态并没有立刻进行删除，只有ealsticsearch刷新了缓存区的内容，它才会彻底删除





