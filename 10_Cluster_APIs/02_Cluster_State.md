## 集群状态 Cluster State

群集状态API允许获得整个群集的综合状态信息。    
    
    $ curl -XGET 'http://localhost:9200/_cluster/state'

缺省情况下，集群状态请求路由到主节点，以确保返回最新的集群状态。 出于调试目的，您可以通过在查询字符串中添加“local = true”来检索本地到特定节点的集群状态。


### 响应内容过滤 Response Filters

由于集群状态可以增长（取决于分片和索引的数量，映射，模板），因此可以指定URL中的部分过滤集群状态响应，。    
    
    $ curl -XGET 'http://localhost:9200/_cluster/state/{metrics}/{indices}'

`metrics` 可以接受如下的参数：


`version`

   集群状态的版本 

`master_node`

    显示响应的当选`master_node`部分

`nodes`

     显示响应的当选`nodes`部分

`routing_table`

    显示响应的`routing_table`部分。 如果您提供以逗号分隔的索引列表，则返回的输出将只包含列出的索引。

`metadata`

    显示响应的`metadata`部分。 如果您提供以逗号分隔的索引列表，则返回的输出将只包含列出的索引。

`blocks`

     显示响应的`blocks`部分

一些请求用例:
    
    
    # return only metadata and routing_table data for specified indices
    $ curl -XGET 'http://localhost:9200/_cluster/state/metadata,routing_table/foo,bar'
    
    # return everything for these two indices
    $ curl -XGET 'http://localhost:9200/_cluster/state/_all/foo,bar'
    
    # Return only blocks data
    $ curl -XGET 'http://localhost:9200/_cluster/state/blocks'
