# Mapping

Mapping is the process of defining how a document, and the fields it contains, are stored and indexed. For instance, use mappings to define:

  * which string fields should be treated as full text fields. 
  * which fields contain numbers, dates, or geolocations. 
  * whether the values of all fields in the document should be indexed into the catch-all [`_all`](mapping-all-field.html "_all field") field. 
  * the [format](mapping-date-format.html "format") of date values. 
  * custom rules to control the mapping for [dynamically added fields](dynamic-mapping.html "Dynamic Mapping"). 



## Mapping Types

Each index has one or more _mapping types_ , which are used to divide the documents in an index into logical groups. User documents might be stored in a `user` type, and blog posts in a `blogpost` type.

Each mapping type has:

[Meta-fields](mapping-fields.html "Meta-Fields")
     Meta-fields are used to customize how a document’s metadata associated is treated. Examples of meta-fields include the document’s [`_index`](mapping-index-field.html "_index field"), [`_type`](mapping-type-field.html "_type field"), [`_id`](mapping-id-field.html "_id field"), and [`_source`](mapping-source-field.html "_source field") fields. 
[Fields](mapping-types.html "Field datatypes") or _properties_
     Each mapping type contains a list of fields or `properties` pertinent to that type. A `user` type might contain `title`, `name`, and `age` fields, while a `blogpost` type might contain `title`, `body`, `user_id` and `created` fields. Fields with the same name in different mapping types in the same index [must have the same mapping](mapping.html#field-conflicts "Fields are shared across mapping typesedit"). 

## Field datatypes

Each field has a data `type` which can be:

  * a simple type like [`text`](text.html "Text datatype"), [`keyword`](keyword.html "Keyword datatype"), [`date`](date.html "Date datatype"), [`long`](number.html "Numeric datatypes"), [`double`](number.html "Numeric datatypes"), [`boolean`](boolean.html "Boolean datatype") or [`ip`](ip.html "IP datatype"). 
  * a type which supports the hierarchical nature of JSON such as [`object`](object.html "Object datatype") or [`nested`](nested.html "Nested datatype"). 
  * or a specialised type like [`geo_point`](geo-point.html "Geo-point datatype"), [`geo_shape`](geo-shape.html "Geo-Shape datatype"), or [`completion`](search-suggesters-completion.html "Completion Suggester"). 



It is often useful to index the same field in different ways for different purposes. For instance, a `string` field could be [indexed](mapping-index.html "index") as a `text` field for full-text search, and as a `keyword` field for sorting or aggregations. Alternatively, you could index a string field with the [`standard` analyzer](analysis-standard-analyzer.html "Standard Analyzer"), the [`english`](analysis-lang-analyzer.html#english-analyzer "english analyzer") analyzer, and the [`french` analyzer](analysis-lang-analyzer.html#french-analyzer "french analyzer").

This is the purpose of _multi-fields_. Most datatypes support multi-fields via the [`fields`](multi-fields.html "fields") parameter.

### Settings to prevent mappings explosion

The following settings allow you to limit the number of field mappings that can be created manually or dynamically, in order to prevent bad documents from causing a mapping explosion:

`index.mapping.total_fields.limit`
     The maximum number of fields in an index. The default value is `1000`. 
`index.mapping.depth.limit`
     The maximum depth for a field, which is measured as the number of inner objects. For instance, if all fields are defined at the root object level, then the depth is `1`. If there is one object mapping, then the depth is `2`, etc. The default is `20`. 
`index.mapping.nested_fields.limit`
     The maximum number of `nested` fields in an index, defaults to `50`. Indexing 1 document with 100 nested fields actually indexes 101 documents as each nested document is indexed as a separate hidden document. 

## Dynamic mapping

Fields and mapping types do not need to be defined before being used. Thanks to _dynamic mapping_ , new mapping types and new field names will be added automatically, just by indexing a document. New fields can be added both to the top-level mapping type, and to inner [`object`](object.html "Object datatype") and [`nested`](nested.html "Nested datatype") fields.

The [dynamic mapping](dynamic-mapping.html "Dynamic Mapping") rules can be configured to customise the mapping that is used for new types and new fields.

## Explicit mappings

You know more about your data than Elasticsearch can guess, so while dynamic mapping can be useful to get started, at some point you will want to specify your own explicit mappings.

You can create mapping types and field mappings when you [create an index](indices-create-index.html "Create Index"), and you can add mapping types and fields to an existing index with the [PUT mapping API](indices-put-mapping.html "Put Mapping").

## Updating existing mappings

Other than where documented, **existing type and field mappings cannot be updated**. Changing the mapping would mean invalidating already indexed documents. Instead, you should create a new index with the correct mappings and reindex your data into that index.

## Fields are shared across mapping types

Mapping types are used to group fields, but the fields in each mapping type are not independent of each other. Fields with:

  * the _same name_
  * in the _same index_
  * in _different mapping types_
  * map to the _same field_ internally, 
  * and **must have the same mapping**. 



If a `title` field exists in both the `user` and `blogpost` mapping types, the `title` fields must have exactly the same mapping in each type. The only exceptions to this rule are the [`copy_to`](copy-to.html "copy_to"), [`dynamic`](dynamic.html "dynamic"), [`enabled`](enabled.html "enabled"), [`ignore_above`](ignore-above.html "ignore_above"), [`include_in_all`](include-in-all.html "include_in_all"), and [`properties`](properties.html "properties") parameters, which may have different settings per field.

Usually, fields with the same name also contain the same type of data, so having the same mapping is not a problem. When conflicts do arise, these can be solved by choosing more descriptive names, such as `user_title` and `blog_title`.

## Example mapping

A mapping for the example described above could be specified when creating the index, as follows:
    
    
    PUT my_index ![](images/icons/callouts/1.png)
    {
      "mappings": {
        "user": { ![](images/icons/callouts/2.png)
          "_all":       { "enabled": false  }, ![](images/icons/callouts/3.png)
          "properties": { ![](images/icons/callouts/4.png)
            "title":    { "type": "text"  }, ![](images/icons/callouts/5.png)
            "name":     { "type": "text"  }, ![](images/icons/callouts/6.png)
            "age":      { "type": "integer" }  ![](images/icons/callouts/7.png)
          }
        },
        "blogpost": { ![](images/icons/callouts/8.png)
          "_all":       { "enabled": false  }, ![](images/icons/callouts/9.png)
          "properties": { ![](images/icons/callouts/10.png)
            "title":    { "type": "text"  }, ![](images/icons/callouts/11.png)
            "body":     { "type": "text"  }, ![](images/icons/callouts/12.png)
            "user_id":  {
              "type":   "keyword" ![](images/icons/callouts/13.png)
            },
            "created":  {
              "type":   "date", ![](images/icons/callouts/14.png)
              "format": "strict_date_optional_time||epoch_millis"
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Create an index called `my_index`.   
  
---|---  
  
![](images/icons/callouts/2.png) ![](images/icons/callouts/8.png)

| 

Add mapping types called `user` and `blogpost`.   
  
![](images/icons/callouts/3.png) ![](images/icons/callouts/9.png)

| 

Disable the `_all` [meta field](mapping-fields.html "Meta-Fields") for the `user` mapping type.   
  
![](images/icons/callouts/4.png) ![](images/icons/callouts/10.png)

| 

Specify fields or _properties_ in each mapping type.   
  
![](images/icons/callouts/5.png) ![](images/icons/callouts/6.png) ![](images/icons/callouts/7.png) ![](images/icons/callouts/11.png) ![](images/icons/callouts/12.png) ![](images/icons/callouts/13.png) ![](images/icons/callouts/14.png)

| 

Specify the data `type` and mapping for each field. 
