## Normalizers

![Warning](images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

Normalizers are similar to analyzers except that they may only emit a single token. As a consequence, they do not have a tokenizer and only accept a subset of the available char filters and token filters. Only the filters that work on a per-character basis are allowed. For instance a lowercasing filter would be allowed, but not a stemming filter, which needs to look at the keyword as a whole.

### Custom normalizers

Elasticsearch does not ship with built-in normalizers so far, so the only way to get one is by building a custom one. Custom normalizers take a list of char [character filters](analysis-charfilters.html) and a list of [token filters](analysis-tokenfilters.html).
    
    
    PUT index
    {
      "settings": {
        "analysis": {
          "char_filter": {
            "quote": {
              "type": "mapping",
              "mappings": [
                "« => \"",
                "» => \""
              ]
            }
          },
          "normalizer": {
            "my_normalizer": {
              "type": "custom",
              "char_filter": ["quote"],
              "filter": ["lowercase", "asciifolding"]
            }
          }
        }
      },
      "mappings": {
        "type": {
          "properties": {
            "foo": {
              "type": "keyword",
              "normalizer": "my_normalizer"
            }
          }
        }
      }
    }
