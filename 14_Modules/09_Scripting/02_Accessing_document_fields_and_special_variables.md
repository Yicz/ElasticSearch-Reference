## Accessing document fields and special variables

Depending on where a script is used, it will have access to certain special variables and document fields.

## Update scripts

A script used in the [update](docs-update.html "Update API"), [update-by-query](docs-update-by-query.html "Update By Query API"), or [reindex](docs-reindex.html "Reindex API") API will have access to the `ctx` variable which exposes:

`ctx._source`

| 

Access to the document [`_source` field](mapping-source-field.html "_source field").   
  
---|---  
  
`ctx.op`

| 

The operation that should be applied to the document: `index` or `delete`.   
  
`ctx._index` etc 

| 

Access to [document meta-fields](mapping-fields.html "Meta-Fields"), some of which may be read-only.   
  
## Search and Aggregation scripts

With the exception of [script fields](search-request-script-fields.html "Script Fields") which are executed once per search hit, scripts used in search and aggregations will be executed once for every document which might match a query or an aggregation. Depending on how many documents you have, this could mean millions or billions of executions: these scripts need to be fast!

Field values can be accessed from a script using [doc-values](modules-scripting-fields.html#modules-scripting-doc-vals "Doc Valuesedit"), or [stored fields or `_source` field](modules-scripting-fields.html#modules-scripting-stored "Stored Fields and _sourceedit"), which are explained below.

Scripts may also have access to the document’s relevance [`_score`](modules-scripting-fields.html#scripting-score "Accessing the score of a document within a scriptedit") and, via the experimental `_index` variable, to term statistics for [advanced text scoring](modules-advanced-scripting.html "Advanced text scoring in scripts").

### Accessing the score of a document within a script

Scripts used in the [`function_score` query](query-dsl-function-score-query.html "Function Score Query"), in [script-based sorting](search-request-sort.html "Sort"), or in [aggregations](search-aggregations.html "Aggregations") have access to the `_score` variable which represents the current relevance score of a document.

Here’s an example of using a script in a [`function_score` query](query-dsl-function-score-query.html "Function Score Query") to alter the relevance `_score` of each document:
    
    
    PUT my_index/my_type/1?refresh
    {
      "text": "quick brown fox",
      "popularity": 1
    }
    
    PUT my_index/my_type/2?refresh
    {
      "text": "quick fox",
      "popularity": 5
    }
    
    GET my_index/_search
    {
      "query": {
        "function_score": {
          "query": {
            "match": {
              "text": "quick brown fox"
            }
          },
          "script_score": {
            "script": {
              "lang": "expression",
              "inline": "_score * doc['popularity']"
            }
          }
        }
      }
    }

### Doc Values

By far the fastest most efficient way to access a field value from a script is to use the `doc['field_name']` syntax, which retrieves the field value from [doc values](doc-values.html "doc_values"). Doc values are a columnar field value store, enabled by default on all fields except for [analyzed `text` fields](text.html "Text datatype").
    
    
    PUT my_index/my_type/1?refresh
    {
      "cost_price": 100
    }
    
    GET my_index/_search
    {
      "script_fields": {
        "sales_price": {
          "script": {
            "lang":   "expression",
            "inline": "doc['cost_price'] * markup",
            "params": {
              "markup": 0.2
            }
          }
        }
      }
    }

Doc-values can only return "simple" field values like numbers, dates, geo- points, terms, etc, or arrays of these values if the field is multi-valued. It cannot return JSON objects.

![Note](images/icons/note.png)

### Doc values and `text` fields

The `doc['field']` syntax can also be used for [analyzed `text` fields](text.html "Text datatype") if [`fielddata`](fielddata.html "fielddata") is enabled, but **BEWARE** : enabling fielddata on a `text` field requires loading all of the terms into the JVM heap, which can be very expensive both in terms of memory and CPU. It seldom makes sense to access `text` fields from scripts.

### Stored Fields and `_source`

 _Stored fields_  — fields explicitly marked as [`"store": true`](mapping-store.html "store") — can be accessed using the `_fields['field_name'].value` or `_fields['field_name'].values` syntax.

The document [`_source`](mapping-source-field.html "_source field"), which is really just a special stored field, can be accessed using the `_source.field_name` syntax. The `_source` is loaded as a map-of-maps, so properties within object fields can be accessed as, for example, `_source.name.first`.

![Important](images/icons/important.png)

### Prefer doc-values to stored fields

Stored fields (which includes the stored `_source` field) are much slower than doc-values. They are optimised for returning several fields per result, while doc values are optimised for accessing the value of a specific field in many documents.

It makes sense to use `_source` or stored fields when generating a [script field](search-request-script-fields.html "Script Fields") for the top ten hits from a search result but, for other search and aggregation use cases, always prefer using doc values.

For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "title": { ![](images/icons/callouts/1.png)
              "type": "text"
            },
            "first_name": {
              "type": "text",
              "store": true
            },
            "last_name": {
              "type": "text",
              "store": true
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1?refresh
    {
      "title": "Mr",
      "first_name": "Barry",
      "last_name": "White"
    }
    
    GET my_index/_search
    {
      "script_fields": {
        "source": {
          "script": {
            "inline": "params._source.title + ' ' + params._source.first_name + ' ' + params._source.last_name" ![](images/icons/callouts/2.png)
          }
        },
        "stored_fields": {
          "script": {
            "inline": "params._fields['first_name'].value + ' ' + params._fields['last_name'].value"
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `title` field is not stored and so cannot be used with the `_fields[]` syntax.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `title` field can still be accessed from the `_source`.   
  
![Tip](images/icons/tip.png)

### Stored vs `_source`

The `_source` field is just a special stored field, so the performance is similar to that of other stored fields. The `_source` provides access to the original document body that was indexed (including the ability to distinguish `null` values from empty fields, single-value arrays from plain scalars, etc).

The only time it really makes sense to use stored fields instead of the `_source` field is when the `_source` is very large and it is less costly to access a few small stored fields instead of the entire `_source`.
