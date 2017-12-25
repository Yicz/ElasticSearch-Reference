## Dynamic templates

Dynamic templates allow you to define custom mappings that can be applied to dynamically added fields based on:

  * the [datatype](dynamic-mapping.html) detected by Elasticsearch, with [`match_mapping_type`](dynamic-templates.html#match-mapping-type). 
  * the name of the field, with [`match` and `unmatch`](dynamic-templates.html#match-unmatch) or [`match_pattern`](dynamic-templates.html#match-pattern). 
  * the full dotted path to the field, with [`path_match` and `path_unmatch`](dynamic-templates.html#path-match-unmatch). 



The original field name `{name}` and the detected datatype `{dynamic_type`} [template variables](dynamic-templates.html#template-variables "{name} and {dynamic_type}") can be used in the mapping specification as placeholders.

![Important](images/icons/important.png)

Dynamic field mappings are only added when a field contains a concrete value — not `null` or an empty array. This means that if the `null_value` option is used in a `dynamic_template`, it will only be applied after the first document with a concrete value for the field has been indexed.

Dynamic templates are specified as an array of named objects:
    
    
      "dynamic_templates": [
        {
          "my_template_name": { ![](images/icons/callouts/1.png)
            ...  match conditions ... ![](images/icons/callouts/2.png)
            "mapping": { ... } ![](images/icons/callouts/3.png)
          }
        },
        ...
      ]

![](images/icons/callouts/1.png)

| 

The template name can be any string value.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The match conditions can include any of : `match_mapping_type`, `match`, `match_pattern`, `unmatch`, `path_match`, `path_unmatch`.   
  
![](images/icons/callouts/3.png)

| 

The mapping that the matched field should use.   
  
Templates are processed in order — the first matching template wins. New templates can be appended to the end of the list with the [PUT mapping](indices-put-mapping.html) API. If a new template has the same name as an existing template, it will replace the old version.

### `match_mapping_type`

The `match_mapping_type` matches on the datatype detected by [dynamic field mapping](dynamic-field-mapping.html), in other words, the datatype that Elasticsearch thinks the field should have. Only the following datatypes can be automatically detected: `boolean`, `date`, `double`, `long`, `object`, `string`. It also accepts `*` to match all datatypes.

For example, if we wanted to map all integer fields as `integer` instead of `long`, and all `string` fields as both `text` and `keyword`, we could use the following template:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "integers": {
                "match_mapping_type": "long",
                "mapping": {
                  "type": "integer"
                }
              }
            },
            {
              "strings": {
                "match_mapping_type": "string",
                "mapping": {
                  "type": "text",
                  "fields": {
                    "raw": {
                      "type":  "keyword",
                      "ignore_above": 256
                    }
                  }
                }
              }
            }
          ]
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "my_integer": 5, ![](images/icons/callouts/1.png)
      "my_string": "Some string" ![](images/icons/callouts/2.png)
    }

![](images/icons/callouts/1.png)

| 

The `my_integer` field is mapped as an `integer`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `my_string` field is mapped as a `text`, with a `keyword` [multi field](multi-fields.html).   
  
### `match` and `unmatch`

The `match` parameter uses a pattern to match on the fieldname, while `unmatch` uses a pattern to exclude fields matched by `match`.

The following example matches all `string` fields whose name starts with `long_` (except for those which end with `_text`) and maps them as `long` fields:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "longs_as_strings": {
                "match_mapping_type": "string",
                "match":   "long_*",
                "unmatch": "*_text",
                "mapping": {
                  "type": "long"
                }
              }
            }
          ]
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "long_num": "5", ![](images/icons/callouts/1.png)
      "long_text": "foo" ![](images/icons/callouts/2.png)
    }

![](images/icons/callouts/1.png)

| 

The `long_num` field is mapped as a `long`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `long_text` field uses the default `string` mapping.   
  
### `match_pattern`

The `match_pattern` parameter adjusts the behavior of the `match` parameter such that it supports full Java regular expression matching on the field name instead of simple wildcards, for instance:
    
    
      "match_pattern": "regex",
      "match": "^profit_\d+$"

### `path_match` and `path_unmatch`

The `path_match` and `path_unmatch` parameters work in the same way as `match` and `unmatch`, but operate on the full dotted path to the field, not just the final name, e.g. `some_object.*.some_field`.

This example copies the values of any fields in the `name` object to the top-level `full_name` field, except for the `middle` field:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "full_name": {
                "path_match":   "name.*",
                "path_unmatch": "*.middle",
                "mapping": {
                  "type":       "text",
                  "copy_to":    "full_name"
                }
              }
            }
          ]
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "name": {
        "first":  "Alice",
        "middle": "Mary",
        "last":   "White"
      }
    }

### `{name}` and `{dynamic_type}`

The `{name}` and `{dynamic_type}` placeholders are replaced in the `mapping` with the field name and detected dynamic type. The following example sets all string fields to use an [`analyzer`](analyzer.html) with the same name as the field, and disables [`doc_values`](doc-values.html) for all non-string fields:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "named_analyzers": {
                "match_mapping_type": "string",
                "match": "*",
                "mapping": {
                  "type": "text",
                  "analyzer": "{name}"
                }
              }
            },
            {
              "no_doc_values": {
                "match_mapping_type":"*",
                "mapping": {
                  "type": "{dynamic_type}",
                  "doc_values": false
                }
              }
            }
          ]
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "english": "Some English text", ![](images/icons/callouts/1.png)
      "count":   5 ![](images/icons/callouts/2.png)
    }

![](images/icons/callouts/1.png)

| 

The `english` field is mapped as a `string` field with the `english` analyzer.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `count` field is mapped as a `long` field with `doc_values` disabled   
  
### Template examples

Here are some examples of potentially useful dynamic templates:

#### Structured search

By default elasticsearch will map string fields as a `text` field with a sub `keyword` field. However if you are only indexing structured content and not interested in full text search, you can make elasticsearch map your fields only as `keyword`s. Note that this means that in order to search those fields, you will have to search on the exact same value that was indexed.
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "strings_as_keywords": {
                "match_mapping_type": "string",
                "mapping": {
                  "type": "keyword"
                }
              }
            }
          ]
        }
      }
    }

#### `text`-only mappings for strings

On the contrary to the previous example, if the only thing that you care about on your string fields is full-text search, and if you don’t plan on running aggregations, sorting or exact search on your string fields, you could tell elasticsearch to map it only as a text field (which was the default behaviour before 5.0):
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "strings_as_text": {
                "match_mapping_type": "string",
                "mapping": {
                  "type": "text"
                }
              }
            }
          ]
        }
      }
    }

#### Disabled norms

Norms are index-time scoring factors. If you do not care about scoring, which would be the case for instance if you never sort documents by score, you could disable the storage of these scoring factors in the index and save some space.
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "strings_as_keywords": {
                "match_mapping_type": "string",
                "mapping": {
                  "type": "text",
                  "norms": false,
                  "fields": {
                    "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                    }
                  }
                }
              }
            }
          ]
        }
      }
    }

The sub `keyword` field appears in this template to be consistent with the default rules of dynamic mappings. Of course if you do not need them because you don’t need to perform exact search or aggregate on this field, you could remove it as described in the previous div.

#### Time-series

When doing time series analysis with elasticsearch, it is common to have many numeric fields that you will often aggregate on but never filter on. In such a case, you could disable indexing on those fields to save disk space and also maybe gain some indexing speed:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_templates": [
            {
              "unindexed_longs": {
                "match_mapping_type": "long",
                "mapping": {
                  "type": "long",
                  "index": false
                }
              }
            },
            {
              "unindexed_doubles": {
                "match_mapping_type": "double",
                "mapping": {
                  "type": "float", ![](images/icons/callouts/1.png)
                  "index": false
                }
              }
            }
          ]
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Like the default dynamic mapping rules, doubles are mapped as floats, which are usually accurate enough, yet require half the disk space.   
  
---|---
