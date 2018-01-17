##  元字段 Meta-Fields

每个文档都有与之相关的元数据，比如`_index`，mapping [`_type`](mapping-type-field.html)和`_id`元字段。 当创建映射类型时，可以自定义这些元字段中的一些的行为。

### 标识的元字段 Identity meta-fields

[`_index`](mapping-index-field.html)| 索引名称     
---|---    
[`_uid`](mapping-uid-field.html)| 一个复合类型包含`_type`和`_id`.   
[`_type`](mapping-type-field.html)| 文档 [mapping type](mapping.html#mapping-type).     
[`_id`](mapping-id-field.html)| 文档id   
  
### 文档源元数据 Document source meta-fields

[`_source`](mapping-source-field.html)

     原始的文档JSON内容. 
[`_size`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-size.html)
    
      `_source`字段内存的大小，单位byte

### 索引元数据 Indexing meta-fields

[`_all`](mapping-all-field.html)

     代表其他所有的字段
[`_field_names`](mapping-field-names-field.html)

     代表文档中所有非null值的字段

### 路由元数据 Routing meta-fields

[`_parent`](mapping-parent-field.html)

    有父子关系的文档，父方的字段
[`_routing`](mapping-routing-field.html)

     文档指定路由的字段
### 其他元数据 Other meta-field
[`_meta`](mapping-meta-field.html)

     应用指定元数据 
