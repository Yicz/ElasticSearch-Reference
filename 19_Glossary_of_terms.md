# 专业术语

## 分词（分析，分解） analysis 
    
分词是将[全文 full text](glossary.html#glossary-text)转换成[项 term](glossary.html#glossary-term)的过程。依赖于分析器的使用，例如：`FOO BAR`, `Foo-Bar`, `foo,bar`这些词，可能会分解成项`foo` 和 `bar`.这些项是实际保存在索引中的。一个全文查询（不是项（term）查询）查询`FoO:bAR`，将会分词成项 `foo`,`bar` 去匹配索引中保存的分词结果。分词过程（
ES会在查询和建立索引中用到）让ES在全文索引中表现更加优秀。参考[文本/全文 text](glossary.html#glossary-text)和[项 term](glossary.html#glossary-term)

## 集群 cluster 
    
一个集群是一群拥有共同`cluster.name`设置的ES[节点nodes](glossary.html#glossary-node)。每一个集群都有一个主节点（master）,它由集群进行选择，如果当前主节点宕机，主节点将由一个运行良好的节点替换。

## 文档 document 
    
ES中保存的文档（documet）是一个JSON格式的文档。像是关系数据库表的行。 每一个文档都是保存在[索引 index](glossary.html#glossary-index),并且属于一种[类型 type](glossary.html#glossary-type) 和拥有一个唯一标识[主键 id](glossary.html#glossary-id)，一个文档就是一个JSON
对象（就像其他语言中的hash/hashmap/array）包含了0到多个的[字段 feild](glossary.html#glossary-field)或键值对（key-value pairs）,原文档对象会被直接存储到`_source`字段[`_source` field](glossary.html#glossary-source_field)中，`_source`字段是查询获取默认返回的内容。

## 主键 id 
    
文档的主键（id）是文档的唯一的标识。`index/type/id`标识必须唯一，如果设置文档的时候没有给id赋值，ES会默认提供。 参考[ 路由 routing](glossary.html#glossary-routing)

## 字段 field 
    
一个文档包含了一个列表的字段或都是键值对。内容可以是一个可以计算的值（如，字符串，整型，日期），或者是一个嵌套的结构如数组和对象，字段很像是关系数据库表中定义的列（column）.[映射关系 mapping](glossary.html#glossary-mapping) 就是定义_type_的结构，修改关系数据库的建表语句。（每一个类型应该清晰，不容易混淆），映射关系（mapping）定义了_type_中哪些字段要分词（anaylysis）,哪些字段要保存，字段属于什么类型（integer,string,object).

## 索引 index 
    
索引就像是关系数据库中的表（***个人觉得理像是_shcema_,因为_type_才像table***）,它使用映射（mapping）定义了文档的字段定义，字段通过文档的类型来进行分组。一个索引就是一个逻辑命名空间包含了一个或多个主分片和0到多个的副本分片。 

## 映射关系 mapping 
    
映射就是是关系数据库中的模式[_schmea definition_]定义.每一个索引都有一个映射（mapping ）,定义了每一种文档的类型和索引的其他设置。映射可以显示地指定，也可使用建立文档进行动态生成。


## 节点 node 
    
节点是ES的一个实例，它属于一个ES集群。可以在一台服务器上运行多个节点进行测试使用，但理论上应该每台机子上部署一个节点。在节点启动的时候，它广播发现存在的相同`cluster.name`的ES集群并加入集群中。


主分片 primary shard 
    
每个索引都会保存[在主分片 `primary shard`](glossary.html#glossary-shard)中.当你进行索引一个文档的时候，ES首先会在主分片上进行存储。然后才会转发到主分片的其他[副本分片 replicas](glossary.html#glossary-replica-shard)。默认地，一个索引会有五个主分片。你可以指定一个索引的主分片存储多少文档。一旦索引建立了，你就不可以修改主分片的数量。参考[路由 routing](glossary.html#glossary-routing)


## 副本分片 replica shard 
    

每一个 [主分片 primary shard](glossary.html#glossary-primary-shard) 拥有0个到多个副本分片. 一个副本分片是主分片的拷贝，这样设置的理由有两个: 

  1. 增加容错: 当主分片失败的时候，副本分片可以提升为主分片。
  2. 增加性能: 获取和查询请求可以在主分片或着副本分片上处理。默认地每个主分片都会有一个副本分片。但副本分片的数量是可以在索引存在的时候进行动态修改的。跟主分片一样的副本分片不会跟主分片同时存在一个节点上。

##　路由 routing 
    
当你索引一个文档的时候，它会被存储到一个主分片上。是通过哈希值进行路由定主分片的，默认进行哈希运行定位的文档值是文档的主键（id）,如果一个文档指定了一个父文档，它会跟随父文档一直分配到同一个主分片上。路由的hash运算值可以使用`routing`参数进行指定或着是使用在映射（mapping）中`routing`字段进行指定。

## 分片 shard 
    
一个分片就是一个Lucene的实例，是低层的处理单位，由ES运行动态管理。一个索引是指向主分片和副本分片的逻辑命名空间。一个索引应该定义它的主分片和副本分片的数量。你并不会直接处理分片，而是操作索引，ES把分片分配到到集群的节点上。同时可以对节点上的分片进行移动。

## 源字段 source field 
    
默认地，JSON文档会保存在`_source`字段中，并会在获取和查询请求的时候进行返回。这就允诉可以直接对结果进行操作源对象。

## 项 term 
    
项是ES中索引的确切值。项`foo`, `Foo`, `FOO`是不相等的。确切值可以使用_term_查询条件。参考[全文 ](glossary.html#glossary-text) 和 [分词 analysis](glossary.html#glossary-analysis). 

## 文本 text 
    
文本或着叫全文，是普通无结构的文字内容，如整段的文字。默认地，文本会进行[分词 analyzed](glossary.html#glossary-analysis)成多个项，项是实际保存在索引中的内容。文本字段是需要进行分词成可以被查询到的文本和关键字，在进行索引和查询的时候生成的项理论上都是一致的。
glossary.html#glossary-analysis). 

## 类型 type 

类型是区分文档的标识。例如类型 `email`,`user`,`tweet`.查询APIs可以通过类型进行过滤文档。一个索引可以包含多个类型，一个类型又要叫含多个字段。在同索引不同类型的中同名称的字段必有相同的[映射关系 mapping]    

A type represents the _type_ of document, e.g. an `email`, a `user`, or a `tweet`. The search API can filter documents by type. An [index](glossary.html#glossary-index) can contain multiple types, and each type has a list of [fields](glossary.html#glossary-field) that can be specified for [documents](glossary.html#glossary-document) of that type. Fields with the same name in different types in the same index must have the same [mapping](glossary.html#glossary-mapping) (which defines how each field in the document is indexed and made searchable). 
