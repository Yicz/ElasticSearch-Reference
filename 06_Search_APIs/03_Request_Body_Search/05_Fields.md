## Fields

![Warning](images/icons/warning.png)

The `stored_fields` parameter is about fields that are explicitly marked as stored in the mapping, which is off by default and generally not recommended. Use [source filtering](search-request-source-filtering.html "Source filtering") instead to select subsets of the original source document to be returned.

Allows to selectively load specific stored fields for each document represented by a search hit.
    
    
    GET /_search
    {
        "stored_fields" : ["user", "postDate"],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

`*` can be used to load all stored fields from the document.

An empty array will cause only the `_id` and `_type` for each hit to be returned, for example:
    
    
    GET /_search
    {
        "stored_fields" : [],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

If the requested fields are not stored (`store` mapping set to `false`), they will be ignored.

Stored field values fetched from the document itself are always returned as an array. On the contrary, metadata fields like `_routing` and `_parent` fields are never returned as an array.

Also only leaf fields can be returned via the `field` option. So object fields can’t be returned and such requests will fail.

Script fields can also be automatically detected and used as fields, so things like `_source.obj1.field1` can be used, though not recommended, as `obj1.field1` will work as well.

### Disable stored fields entirely

To disable the stored fields (and metadata fields) entirely use: `_none_`:
    
    
    GET /_search
    {
        "stored_fields": "_none_",
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

![Note](images/icons/note.png)

[`_source`](search-request-source-filtering.html "Source filtering") and [`version`](search-request-version.html "Version") parameters cannot be activated if `_none_` is used.
