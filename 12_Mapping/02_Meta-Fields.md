## Meta-Fields

Each document has metadata associated with it, such as the `_index`, mapping [`_type`](mapping-type-field.html "_type field"), and `_id` meta-fields. The behaviour of some of these meta-fields can be customised when a mapping type is created.

### Identity meta-fields

[`_index`](mapping-index-field.html "_index field")

| 

The index to which the document belongs.   
  
---|---  
  
[`_uid`](mapping-uid-field.html "_uid field")

| 

A composite field consisting of the `_type` and the `_id`.   
  
[`_type`](mapping-type-field.html "_type field")

| 

The document’s [mapping type](mapping.html#mapping-type "Mapping Typesedit").   
  
[`_id`](mapping-id-field.html "_id field")

| 

The document’s ID.   
  
### Document source meta-fields

[`_source`](mapping-source-field.html "_source field")
     The original JSON representing the body of the document. 
[`_size`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-size.html)
     The size of the `_source` field in bytes, provided by the [`mapper-size` plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-size.html). 

### Indexing meta-fields

[`_all`](mapping-all-field.html "_all field")
     A _catch-all_ field that indexes the values of all other fields. 
[`_field_names`](mapping-field-names-field.html "_field_names field")
     All fields in the document which contain non-null values. 

### Routing meta-fields

[`_parent`](mapping-parent-field.html "_parent field")
     Used to create a parent-child relationship between two mapping types. 
[`_routing`](mapping-routing-field.html "_routing field")
     A custom routing value which routes a document to a particular shard. 

### Other meta-field

[`_meta`](mapping-meta-field.html "_meta field")
     Application specific metadata. 
