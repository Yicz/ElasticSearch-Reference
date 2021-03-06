##  字段类型 Field datatypes

Elasticsearch为文档中的字段支持许多不同的数据类型：

### 核心数据类型 Core datatypes

字符串 
     [`text`](text.html) and [`keyword`](keyword.html)
数值类型[Numeric datatypes](number.html)
     `long`, `integer`, `short`, `byte`, `double`, `float`, `half_float`, `scaled_float`
日期类型[Date datatype](date.html)
     `date`
布尔类型[Boolean datatype](boolean.html)
     `boolean`
二进制类型[Binary datatype](binary.html)
     `binary`
范围类型[Range datatypes](range.html)
     `integer_range`, `float_range`, `long_range`, `double_range`, `date_range`

### 复合类型 Complex datatypes

数组类型[Array datatype](array.html)
     Array support does not require a dedicated `type`
对象类型[Object datatype](object.html)
     `object` for single JSON objects 
嵌套类型[Nested datatype](nested.html)
     `nested` for arrays of JSON objects 

### Geo datatypes

[Geo-point datatype](geo-point.html)
     `geo_point` for lat/lon points 
[Geo-Shape datatype](geo-shape.html)
     `geo_shape` for complex shapes like polygons 

### Specialised datatypes

[IP datatype](ip.html)
     `ip` for IPv4 and IPv6 addresses 
[Completion datatype](search-suggesters-completion.html)
     `completion` to provide auto-complete suggestions 
[Token count datatype](token-count.html)
     `token_count` to count the number of tokens in a string 
[`mapper-murmur3`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-size.html)
     `murmur3` to compute hashes of values at index-time and store them in the index 
Attachment datatype 
     See the [`mapper-attachments`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-attachments.html) plugin which supports indexing `attachments` like Microsoft Office formats, Open Document formats, ePub, HTML, etc. into an `attachment` datatype. 
[Percolator type](percolator.html)
     Accepts queries from the query-dsl 

### Multi-fields

It is often useful to index the same field in different ways for different purposes. For instance, a `string` field could be mapped as a `text` field for full-text search, and as a `keyword` field for sorting or aggregations. Alternatively, you could index a text field with the [`standard` analyzer](analysis-standard-analyzer.html), the [`english`](analysis-lang-analyzer.html#english-analyzer) analyzer, and the [`french` analyzer](analysis-lang-analyzer.html#french-analyzer).

This is the purpose of _multi-fields_. Most datatypes support multi-fields via the [`fields`](multi-fields.html) parameter.
