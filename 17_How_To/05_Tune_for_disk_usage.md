## 磁盘利用直言 Tune for disk usage

### 禁用你不使用的特性 Disable the features you do not need

By default elasticsearch indexes and adds doc values to most fields so that they can be searched and aggregated out of the box. For instance if you have a numeric field called `foo` that you need to run histograms on but that you never need to filter on, you can safely disable indexing on this field in your [mappings](indices-create-index.html#mappings):
    
    
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

[`text`](text.html) fields store normalization factors in the index in order to be able to score documents. If you only need matching capabilities on a `text` field but do not care about the produced scores, you can configure elasticsearch to not write norms to the index:
    
    
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

[`text`](text.html) fields also store frequencies and positions in the index by default. Frequencies are used to compute scores and positions are used to run phrase queries. If you do not need to run phrase queries, you can tell elasticsearch to not index positions:
    
    
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

### 不使用动态字符映射 Don’t use default dynamic string mappings

The default [dynamic string mappings](dynamic-mapping.html) will index string fields both as [`text`](text.html) and [`keyword`](keyword.html). This is wasteful if you only need one of them. Typically an `id` field will only need to be indexed as a `keyword` while a `body` field will only need to be indexed as a `text` field.

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

### 禁用 `_all`

[`_all`](mapping-all-field.html)字段索引文档的所有字段的值，并且可以使用显着的空间。 如果您不需要同时搜索所有字段，则可以禁用它。

### 使用高压缩 `best_compression`

`_source`和存储的字段很容易占用不可忽视的磁盘空间。 可以通过使用`best_compression` [codec](index-modules.html#index-codec).来进一步压缩它们。

### Use the smallest numeric type that is sufficient

您为[数字数据](number.html)选择的类型可能会对磁盘使用产生重大影响。 特别的，整数应该使用整数类型（`byte`，`short`，`integer`或`long`）来存储，浮点数应该存储在`scaled_float`中，如果合适的话， 用例：在double上使用`float`，或在`float`上使用`half_float`将有助于节省存储空间。