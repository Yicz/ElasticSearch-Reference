## `search_analyzer`

Usually, the same [analyzer](analyzer.html) should be applied at index time and at search time, to ensure that the terms in the query are in the same format as the terms in the inverted index.

Sometimes, though, it can make sense to use a different analyzer at search time, such as when using the [`edge_ngram`](analysis-edgengram-tokenizer.html) tokenizer for autocomplete.

By default, queries will use the `analyzer` defined in the field mapping, but this can be overridden with the `search_analyzer` setting:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "filter": {
            "autocomplete_filter": {
              "type": "edge_ngram",
              "min_gram": 1,
              "max_gram": 20
            }
          },
          "analyzer": {
            "autocomplete": { <1>
              "type": "custom",
              "tokenizer": "standard",
              "filter": [
                "lowercase",
                "autocomplete_filter"
              ]
            }
          }
        }
      },
      "mappings": {
        "my_type": {
          "properties": {
            "text": {
              "type": "text",
              "analyzer": "autocomplete", <2>
              "search_analyzer": "standard" <3>
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "text": "Quick Brown Fox" <4>
    }
    
    GET my_index/_search
    {
      "query": {
        "match": {
          "text": {
            "query": "Quick Br", <5>
            "operator": "and"
          }
        }
      }
    }

<1> <1>| Analysis settings to define the custom `autocomplete` analyzer.     
---|---   
<2> <2> <3>| The `text` field uses the `autocomplete` analyzer at index time, but the `standard` analyzer at search time.     
<4>| This field is indexed as the terms: [ `q`, `qu`, `qui`, `quic`, `quick`, `b`, `br`, `bro`, `brow`, `brown`, `f`, `fo`, `fox` ]     
<5>| The query searches for both of these terms: [ `quick`, `br` ]   
  
See [Index time search-as-you- type](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/_index_time_search_as_you_type.html) for a full explanation of this example.

![Tip](/images/icons/tip.png)

The `search_analyzer` setting must have the same setting for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html).
