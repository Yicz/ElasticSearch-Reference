## Meta-Fields

Each document has metadata associated with it, such as the `_index`, mapping [`_type`](mapping-type-field.html), and `_id` meta-fields. The behaviour of some of these meta-fields can be customised when a mapping type is created.

### Identity meta-fields

[`_index`](mapping-index-field.html)

| 

The index to which the document belongs.   
  
---|---  
  
[`_uid`](mapping-uid-field.html)

| 

A composite field consisting of the `_type` and the `_id`.   
  
[`_type`](mapping-type-field.html)

| 

The document’s [mapping type](mapping.html#mapping-type).   
  
[`_id`](mapping-id-field.html)

| 

The document’s ID.   
  
### Document source meta-fields

[`_source`](mapping-source-field.html)
     The original JSON representing the body of the document. 
[`_size`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-size.html)
     The size of the `_source` field in bytes, provided by the [`mapper-size` plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-size.html). 

### Indexing meta-fields

[`_all`](mapping-all-field.html)
     A _catch-all_ field that indexes the values of all other fields. 
[`_field_names`](mapping-field-names-field.html)
     All fields in the document which contain non-null values. 

### Routing meta-fields

[`_parent`](mapping-parent-field.html)
     Used to create a parent-child relationship between two mapping types. 
[`_routing`](mapping-routing-field.html)
     A custom routing value which routes a document to a particular shard. 

### Other meta-field

[`_meta`](mapping-meta-field.html)
     Application specific metadata. 
