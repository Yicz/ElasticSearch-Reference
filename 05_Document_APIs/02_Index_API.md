# Index API
Index API 可以添加或更新一个json类型的文档到一个指定的索引中，使它可以被搜索。下面的粟子，是插入了一个josn数据到"twitter"索引中，并且它的类型是"tweet":

```sh
curl -XPUT 'localhost:9200/twitter/tweet/1?pretty' -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'
#响应
{
    "_shards" : {
        "total" : 2,
        "failed" : 0,
        "successful" : 2
    },
    "_index" : "twitter",
    "_type" : "tweet",
    "_id" : "1",
    "_version" : 1,
    "created" : true,
    "result" : created
}
```

对响应内的说明：

shards部分说明了建立索引操作中的全部分片信息

* total   
 在建立索引的过程中总共有多少个分片(包括主分片和复制分片)应该执行
* faild  
 建立索引过程中，失败的分片数
* successful  
建立索引过程上，成功的分片数

执行成功的定义successful不为0

# 自动索引创建
如果尚未创建索引，建立索引操作会自动创建一个索引（查看[创建索引API]()以手动创建索引），如果尚未创建类型，也会为指定类型，自动创建动态类型映射（查看[put mapping API]()手动创建类型映射）。

映射本身非常灵活，无模式。新的字段和对象将自动添加到指定类型的映射定义中。查看[映射部分]()了解映射定义的更多信息。

**通过在所有节点的配置文件中将action.auto_create_index设置为false，可以禁用索引自动创建。**

**通过将index.mapper.dynamic设置为false\可以禁用映射自动创建。**

自动索引创建可以包括基于模式的白/黑名单，例如设置 action.auto_create_index为+aaa*， -bbb*，+ccc*， -*（+意思是允许的，而-意思是不允许的）。

# 版本控制
每个索引文档都有一个版本号。 关联的版本号作为对索引API请求的响应的一部分返回。 当指定版本参数时，索引API可选地允许进行[乐观并发控制]()。 这将控制操作执行的文档的版本。 版本控制用例的一个很好的例子就是执行一个事务性的read-then-update。 从初始读取的文档中指定一个版本可确保在此期间没有发生变化（阅读时为了更新，建议将首选项设置为_primary）。 例如：

```sh
curl -XPUT 'localhost:9200/twitter/tweet/1?version=2&pretty' -H 'Content-Type: application/json' -d'
{
    "message" : "elasticsearch now has versioning support, double cool!"
}
'
```
注：版本控制是完全实时的，不受搜索操作的近实时方面的影响。如果没有提供版本，则操作在没有任何版本检查的情况下执行。

默认情况下，使用内部版本控制，从1开始，每增加一个更新，包括删除。可选地，版本号可以用外部值补充（例如，如果保存在数据库中）。要启用此功能，version_type应设置为外部。提供的值必须是数字，长整数值大于或等于0，小于大约9.2e + 18。当使用外部版本类型时，系统将检查传递给索引请求的版本号是否大于当前存储的文档的版本，而不是检查匹配的版本号。如果为true，则将文档编入索引并使用新的版本号。如果提供的值小于或等于存储文档的版本号，则会发生版本冲突，索引操作将失败。

> ### 警告
> 外部版本支持的值0作为一个有效的版本号。这允许版本与外部同步版本控制系统版本号从0开始,而不是一个地方。它有副作用,文档版本号等于零不能使用Update-By-Query API和使用Delete删除查询API,只要他们的版本号等于零。

# 版本类型
除上面解释的内部（internal）和外部(external)版本类型外，Elasticsearch还支持其他类型的特定用例。以下是不同版本类型及其语义的概述。

* **internal**  
如果给定版本与存储文档的版本相同，则只索引文档。
* **external或external\_gt**  
如果给定的版本严格高于存储的文档的版本或者没有存在的文档，则只索引文档。给定的版本将被用作新版本，并将与新文档一起存储。提供的版本必须是非负数的长整数。
* **external\_gte**  
如果给定版本等于或高于存储文档的版本，则只索引文档。如果没有现有的文件，操作也会成功。给定的版本将被用作新版本，并将与新文档一起存储。提供的版本必须是非负数的长整数。

注意：external\_gte版本类型是为特殊用途而设计的，应谨慎使用。如果使用不当，可能会导致数据丢失。还有另一个选项force，由于可能会导致主分片和副本分片分歧，因此不推荐使用。

# 操作类型

建立索引的操作，可以添加一个`op_type`的参数，去强制执行一个建立操作。当`op_type=create`的时候，如果目标文档的id已经存在，则会操作失败。

这里有一个粟子：

```sh
curl -XPUT 'localhost:9200/twitter/tweet/1?op_type=create&pretty' -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'
# 可以转成REST APIs 风格的形式
curl -XPUT 'localhost:9200/twitter/tweet/1/_create?pretty' -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'
```
# 主键（ID）

索引操作可以不指定id执行。在这种情况下,将自动生成一个ID。此外,op_type将自动设置为create。这里有一个例子(注意请求方式POST代替PUT):

```sh
curl -XPOST 'localhost:9200/twitter/tweet/?pretty' -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'
# 返回的结果
{
    "_shards" : {
        "total" : 2,
        "failed" : 0,
        "successful" : 2
    },
    "_index" : "twitter",
    "_type" : "tweet",
    "_id" : "6a8ca01c-7896-48e9-81cc-9f70661fcb32",
    "_version" : 1,
    "created" : true,
    "result": "created"
}
```

# 路由（Routing）
默认情况下，分片放置或路由是通过文档的id值的散列来控制的。 为了更明确的控制，路由使用的哈希函数的值可以直接使用参数进行指定一个文档字段进行使用。 例如：

```sh
curl -XPOST 'localhost:9200/twitter/tweet?routing=kimchy&pretty' -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'
```

在上面的例子中，“tweet”类型的文档设置了“routing=kimchy”，它将会基于kimcky字段的值来计算hash值确定分片位置。
设置显式映射时，可以选择使用_routing字段来指导索引操作从文档本身提取路由值。 这确实是以一个额外的文档解析过程（非常小的成本）来实现的。 如果_routing映射被定义并被设置为必需的，那么如果没有提供或提取路由选择值，则索引操作将失败。

# 父子关系
在进行索引的时候可以为一个文档指定一个父关系映射

```sh
curl -XPUT 'localhost:9200/blogs?pretty' -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "tag_parent": {},
    "blog_tag": {
      "_parent": {
        "type": "tag_parent"
      }
    }
  }
}
'
curl -XPUT 'localhost:9200/blogs/blog_tag/1122?parent=1111&pretty' -H 'Content-Type: application/json' -d'
{
    "tag" : "something"
}
'
```

# 分发

由[路由部分]()实现了主分片的定位，当主分片建立好索引后，在必要的条件下，它会负责向其实复制分片请求更新索引。

为了提高写入系统的性能，索引操作可以配置为在继续操作之前等待一定数量的活动分片副本。如果所需数量的活动分片副本不可用，则写入操作必须等待并重试，直到必要的分片副本已启动或发生超时。默认情况下，写入操作只能等待主分片在进行之前处于活动状态（即`wait_for_active_shards = 1`）。可以通过设置`index.write.wait_for_active_shards`动态地在索引设置中重写此默认值。要改变每个操作的这种行为，可以使用wait_for_active_shards请求参数。

有效值是任何正整数，直到索引中每个分片的配置副本总数（即number_of_replicas + 1）。指定负值或大于分片数量的数字将引发错误。

例如，假设我们有一个由三个节点A，B和C组成的群集，并且我们创建了一个索引索引，其副本数量设置为3（导致4个分片副本，比节点多一个副本）。如果我们尝试索引操作，默认情况下操作只会确保每个分片的主要副本可用，然后才能继续。这意味着，即使B和C发生故障，并且A托管了主分片副本，索引操作仍将继续进行，只有一个数据副本。如果请求中的wait_for_active_shards设置为3（并且所有3个节点都在运行），那么索引操作在继续之前将需要3个活动分片副本，这是一个需要满足的要求，因为集群中有3个活动节点，分片的副本。但是，如果我们将wait_for_active_shards设置为all（或者设置为4，则相同），索引操作将不会继续，因为索引中没有每个分片的所有4个副本都处于活动状态。该操作将超时，除非在集群中引入新节点来托管分片的第四个副本。

需要注意的是，这种设置大大降低了写操作不写入所需数量的分片副本的可能性，但是这并不能完全消除这种可能性，因为在写操作开始之前发生这种检查。一旦写入操作正在进行，仍然有可能复制在任何数量的分片副本上失败，但是仍然可以在主分区上成功。写操作响应的_shards部分显示复制成功/失败的分片副本的数量。

# 刷新
请查阅[刷新]()

# 无变更更新

使用索引api更新文档时，即使文档没有更改，总是会创建新版本的文档。 如果这是不可接受的，则使用带有detect_noop的_update api设置为true。 这个选项在索引api上不可用，因为索引api没有获取旧的源，也无法将它与新的源进行比较。

当noop更新不可接受时，并没有一个硬性规定。 这是很多因素的组合，例如数据源发送更新的频率实际上是否是noops，以及elasticsearch在接收更新时每秒运行多少个查询。

# 索引超时

当索引操作正在进行时，主分片可能并不是有有效的运行状态，一些原因（网关或正在重定位）可能会导致主分片当时不可用。默认的索引操作等待一个主分片可用的时间是1分钟，当超过1分钟的时候会失败并返回一个带错误信息的响应内容。明确指定一个超时参数可以设置它的等待时长，如于举了个等待时长5分钟的粟子：

```sh
curl -XPUT 'localhost:9200/twitter/tweet/1?timeout=5m&pretty' -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'

```
