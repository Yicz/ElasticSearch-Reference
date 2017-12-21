## Get Field Mapping

The get field mapping API allows you to retrieve mapping definitions for one or more fields. This is useful when you do not need the complete type mapping returned by the [_Get Mapping_](indices-get-mapping.html "Get Mapping") API.

For example, consider the following mapping:
    
    
    PUT publications
    {
        "mappings": {
            "article": {
                "properties": {
                    "id": { "type": "text" },
                    "title":  { "type": "text"},
                    "abstract": { "type": "text"},
                    "author": {
                        "properties": {
                            "id": { "type": "text" },
                            "name": { "type": "text" }
                        }
                    }
                }
            }
        }
    }

The following returns the mapping of the field `title` only:
    
    
    GET publications/_mapping/article/field/title

For which the response is:
    
    
    {
       "publications": {
          "mappings": {
             "article": {
                "title": {
                   "full_name": "title",
                   "mapping": {
                      "title": {
                         "type": "text"
                      }
                   }
                }
             }
          }
       }
    }

### Multiple Indices, Types and Fields

The get field mapping API can be used to get the mapping of multiple fields from more than one index or type with a single call. General usage of the API follows the following syntax: `host:port/{index}/{type}/_mapping/field/{field}` where `{index}`, `{type}` and `{field}` can stand for comma-separated list of names or wild cards. To get mappings for all indices you can use `_all` for `{index}`. The following are some examples:
    
    
    GET /twitter,kimchy/_mapping/field/message
    
    GET /_all/_mapping/tweet,book/field/message,user.id
    
    GET /_all/_mapping/tw*/field/*.id

### Specifying fields

The get mapping api allows you to specify a comma-separated list of fields.

For instance to select the `id` of the `author` field, you must use its full name `author.id`.
    
    
    GET publications/_mapping/article/field/author.id,abstract,name

returns:
    
    
    {
       "publications": {
          "mappings": {
             "article": {
                "author.id": {
                   "full_name": "author.id",
                   "mapping": {
                      "id": {
                         "type": "text"
                      }
                   }
                },
                "abstract": {
                   "full_name": "abstract",
                   "mapping": {
                      "abstract": {
                         "type": "text"
                      }
                   }
                }
             }
          }
       }
    }

The get field mapping API also supports wildcard notation.
    
    
    GET publications/_mapping/article/field/a*

returns:
    
    
    {
       "publications": {
          "mappings": {
             "article": {
                "author.name": {
                   "full_name": "author.name",
                   "mapping": {
                      "name": {
                         "type": "text"
                      }
                   }
                },
                "abstract": {
                   "full_name": "abstract",
                   "mapping": {
                      "abstract": {
                         "type": "text"
                      }
                   }
                },
                "author.id": {
                   "full_name": "author.id",
                   "mapping": {
                      "id": {
                         "type": "text"
                      }
                   }
                }
             }
          }
       }
    }

### Other options

`include_defaults`

| 

adding `include_defaults=true` to the query string will cause the response to include default values, which are normally suppressed.   
  
---|---
