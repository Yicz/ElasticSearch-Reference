## Put Mapping

The PUT mapping API allows you to add a new type to an existing index, or add new fields to an existing type:
    
    
    PUT twitter <1>
    {
      "mappings": {
        "tweet": {
          "properties": {
            "message": {
              "type": "text"
            }
          }
        }
      }
    }
    
    PUT twitter/_mapping/user <2>
    {
      "properties": {
        "name": {
          "type": "text"
        }
      }
    }
    
    PUT twitter/_mapping/tweet <3>
    {
      "properties": {
        "user_name": {
          "type": "text"
        }
      }
    }

<1>| [Creates an index](indices-create-index.html) called `twitter` with the `message` field in the `tweet` [mapping type](mapping.html#mapping-type).     
---|---    
<2>| Uses the PUT mapping API to add a new mapping type called `user`.     
<3>| Uses the PUT mapping API to add a new field called `user_name` to the `tweet` mapping type.   
  
More information on how to define type mappings can be found in the [mapping](mapping.html) div.

### Multi-index

The PUT mapping API can be applied to multiple indices with a single request. It has the following format:
    
    
    PUT /{index}/_mapping/{type}
    { body }

  * `{index}` accepts [multiple index names](multi-index.html) and wildcards. 
  * `{type}` is the name of the type to update. 
  * `{body}` contains the mapping changes that should be applied. 



![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

When updating the `_default_` mapping with the [PUT mapping](indices-put-mapping.html) API, the new mapping is not merged with the existing mapping. Instead, the new `_default_` mapping replaces the existing one.

### Updating field mappings

In general, the mapping for existing fields cannot be updated. There are some exceptions to this rule. For instance:

  * new [`properties`](properties.html) can be added to [Object datatype](object.html) fields. 
  * new [multi-fields](multi-fields.html) can be added to existing fields. 
  * the [`ignore_above`](ignore-above.html) parameter can be updated. 



For example:
    
    
    PUT my_index <1>
    {
      "mappings": {
        "user": {
          "properties": {
            "name": {
              "properties": {
                "first": {
                  "type": "text"
                }
              }
            },
            "user_id": {
              "type": "keyword"
            }
          }
        }
      }
    }
    
    PUT my_index/_mapping/user
    {
      "properties": {
        "name": {
          "properties": {
            "last": { <2>
              "type": "text"
            }
          }
        },
        "user_id": {
          "type": "keyword",
          "ignore_above": 100 <3>
        }
      }
    }

<1>| Create an index with a `first` field under the `name` [Object datatype](object.html) field, and a `user_id` field.     
---|---    
<2>| Add a `last` field under the `name` object field.     
<3>| Update the `ignore_above` setting from its default of 0.     

Each [mapping parameter](mapping-params.html) specifies whether or not its setting can be updated on an existing field.

### Conflicts between fields in different types

Fields in the same index with the same name in two different types must have the same mapping, as they are backed by the same field internally. Trying to [update a mapping parameter](indices-put-mapping.html#updating-field-mappings) for a field which exists in more than one type will throw an exception, unless you specify the `update_all_types` parameter, in which case it will update that parameter across all fields with the same name in the same index.

![Tip](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/tip.png)

The only parameters which are exempt from this rule — they can be set to different values on each field — can be found in [Fields are shared across mapping types.

For example, this fails:
    
    
    PUT my_index
    {
      "mappings": {
        "type_one": {
          "properties": {
            "text": { <1>
              "type": "text",
              "analyzer": "standard"
            }
          }
        },
        "type_two": {
          "properties": {
            "text": { <2>
              "type": "text",
              "analyzer": "standard"
            }
          }
        }
      }
    }
    
    PUT my_index/_mapping/type_one <3>
    {
      "properties": {
        "text": {
          "type": "text",
          "analyzer": "standard",
          "search_analyzer": "whitespace"
        }
      }
    }

<1> <2>| Create an index with two types, both of which contain a `text` field which have the same mapping.     
---|---   
<3>| Trying to update the `search_analyzer` just for `type_one` throws an exception like `"Merge failed with failures..."`.   
  
But this then running this succeeds:
    
    
    PUT my_index/_mapping/type_one?update_all_types <1>
    {
      "properties": {
        "text": {
          "type": "text",
          "analyzer": "standard",
          "search_analyzer": "whitespace"
        }
      }
    }

<1>| Adding the `update_all_types` parameter updates the `text` field in `type_one` and `type_two`.     
---|---
