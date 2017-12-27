## Parent Id Query

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

Added in 5.0.0. 

The `parent_id` query can be used to find child documents which belong to a particular parent. Given the following mapping definition:
    
    
    PUT /my_index
    {
        "mappings": {
            "blog_post": {
                "properties": {
                    "name": {
                        "type": "keyword"
                    }
                }
            },
            "blog_tag": {
                "_parent": {
                    "type": "blog_post"
                },
                "_routing": {
                    "required": true
                }
            }
        }
    }
    
    
    GET /my_index/_search
    {
        "query": {
            "parent_id" : {
                "type" : "blog_tag",
                "id" : "1"
            }
        }
    }

The above is functionally equivalent to using the following [`has_parent`](query-dsl-has-parent-query.html) query, but performs better as it does not need to do a join:
    
    
    GET /my_index/_search
    {
      "query": {
        "has_parent": {
          "parent_type": "blog_post",
            "query": {
              "term": {
                "_id": "1"
            }
          }
        }
      }
    }

### Parameters

This query has two required parameters:

`type`| The **child** type. This must be a type with `_parent` field.     
---|---    
`id`| The required parent id select documents must referrer to.     
`ignore_unmapped`| When set to `true` this will ignore an unmapped `type` and will not match any documents for this query. This can be useful when querying multiple indexes which might have different mappings. When set to `false` (the default value) the query will throw an exception if the `type` is not mapped. 
