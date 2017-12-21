## Tune for disk usage

### Disable the features you do not need

By default elasticsearch indexes and adds doc values to most fields so that they can be searched and aggregated out of the box. For instance if you have a numeric field called `foo` that you need to run histograms on but that you never need to filter on, you can safely disable indexing on this field in your [mappings](indices-create-index.html#mappings "Mappingsedit"):
    
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "foo": {
              "type": "integer",
              "index": false
            }
          }
        }
      }
    }

[`text`](text.html "Text datatype") fields store normalization factors in the index in order to be able to score documents. If you only need matching capabilities on a `text` field but do not care about the produced scores, you can configure elasticsearch to not write norms to the index:
    
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "foo": {
              "type": "text",
              "norms": false
            }
          }
        }
      }
    }

[`text`](text.html "Text datatype") fields also store frequencies and positions in the index by default. Frequencies are used to compute scores and positions are used to run phrase queries. If you do not need to run phrase queries, you can tell elasticsearch to not index positions:
    
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "foo": {
              "type": "text",
              "index_options": "freqs"
            }
          }
        }
      }
    }

Furthermore if you do not care about scoring either, you can configure elasticsearch to just index matching documents for every term. You will still be able to search on this field, but phrase queries will raise errors and scoring will assume that terms appear only once in every document.
    
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "foo": {
              "type": "text",
              "norms": false,
              "index_options": "freqs"
            }
          }
        }
      }
    }

### Don’t use default dynamic string mappings

The default [dynamic string mappings](dynamic-mapping.html "Dynamic Mapping") will index string fields both as [`text`](text.html "Text datatype") and [`keyword`](keyword.html "Keyword datatype"). This is wasteful if you only need one of them. Typically an `id` field will only need to be indexed as a `keyword` while a `body` field will only need to be indexed as a `text` field.

This can be disabled by either configuring explicit mappings on string fields or setting up dynamic templates that will map string fields as either `text` or `keyword`.

For instance, here is a template that can be used in order to only map string fields as `keyword`:
    
    
    PUT index
    {
      "mappings": {
        "type": {
          "dynamic_templates": [
            {
              "strings": {
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

### Disable `_all`

The [`_all`](mapping-all-field.html "_all field") field indexes the value of all fields of a document and can use significant space. If you never need to search against all fields at the same time, it can be disabled.

### Use `best_compression`

The `_source` and stored fields can easily take a non negligible amount of disk space. They can be compressed more aggressively by using the `best_compression` [codec](index-modules.html#index-codec).

### Use the smallest numeric type that is sufficient

The type that you pick for [numeric data](number.html "Numeric datatypes") can have a significant impact on disk usage. In particular, integers should be stored using an integer type (`byte`, `short`, `integer` or `long`) and floating points should either be stored in a `scaled_float` if appropriate or in the smallest type that fits the use-case: using `float` over `double`, or `half_float` over `float` will help save storage.
