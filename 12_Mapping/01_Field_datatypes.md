## Field datatypes

Elasticsearch supports a number of different datatypes for the fields in a document:

### Core datatypes

string 
     [`text`](text.html "Text datatype") and [`keyword`](keyword.html "Keyword datatype")
[Numeric datatypes](number.html "Numeric datatypes")
     `long`, `integer`, `short`, `byte`, `double`, `float`, `half_float`, `scaled_float`
[Date datatype](date.html "Date datatype")
     `date`
[Boolean datatype](boolean.html "Boolean datatype")
     `boolean`
[Binary datatype](binary.html "Binary datatype")
     `binary`
[Range datatypes](range.html "Range datatypes")
     `integer_range`, `float_range`, `long_range`, `double_range`, `date_range`

### Complex datatypes

[Array datatype](array.html "Array datatype")
     Array support does not require a dedicated `type`
[Object datatype](object.html "Object datatype")
     `object` for single JSON objects 
[Nested datatype](nested.html "Nested datatype")
     `nested` for arrays of JSON objects 

### Geo datatypes

[Geo-point datatype](geo-point.html "Geo-point datatype")
     `geo_point` for lat/lon points 
[Geo-Shape datatype](geo-shape.html "Geo-Shape datatype")
     `geo_shape` for complex shapes like polygons 

### Specialised datatypes

[IP datatype](ip.html "IP datatype")
     `ip` for IPv4 and IPv6 addresses 
[Completion datatype](search-suggesters-completion.html "Completion Suggester")
     `completion` to provide auto-complete suggestions 
[Token count datatype](token-count.html "Token count datatype")
     `token_count` to count the number of tokens in a string 
[`mapper-murmur3`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-size.html)
     `murmur3` to compute hashes of values at index-time and store them in the index 
Attachment datatype 
     See the [`mapper-attachments`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-attachments.html) plugin which supports indexing `attachments` like Microsoft Office formats, Open Document formats, ePub, HTML, etc. into an `attachment` datatype. 
[Percolator type](percolator.html "Percolator type")
     Accepts queries from the query-dsl 

### Multi-fields

It is often useful to index the same field in different ways for different purposes. For instance, a `string` field could be mapped as a `text` field for full-text search, and as a `keyword` field for sorting or aggregations. Alternatively, you could index a text field with the [`standard` analyzer](analysis-standard-analyzer.html "Standard Analyzer"), the [`english`](analysis-lang-analyzer.html#english-analyzer "english analyzer") analyzer, and the [`french` analyzer](analysis-lang-analyzer.html#french-analyzer "french analyzer").

This is the purpose of _multi-fields_. Most datatypes support multi-fields via the [`fields`](multi-fields.html "fields") parameter.
