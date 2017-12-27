## Keyword datatype

A field to index structured content such as email addresses, hostnames, status codes, zip codes or tags.

They are typically used for filtering ( _Find me all blog posts where`status` is `published`_ ), for sorting, and for aggregations. Keyword fields are only searchable by their exact value.

If you need to index full text content such as email bodies or product descriptions, it is likely that you should rather use a 
[`text`](text.html) field.

Below is an example of a mapping for a keyword field:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "tags": {
              "type":  "keyword"
            }
          }
        }
      }
    }

### Parameters for keyword fields

The following parameters are accepted by `keyword` fields:

[`boost`](mapping-boost.html)| Mapping field-level query time boosting. Accepts a floating point number, defaults to `1.0`.     
---|---    
[`doc_values`](doc-values.html)| Should the field be stored on disk in a column-stride fashion, so that it can later be used for sorting, aggregations,or scripting? Accepts `true` (default) or `false`.     
[`eager_global_ordinals`](fielddata.html#global-ordinals)| Should global ordinals be loaded eagerly on refresh? Accepts `true` or `false` (default). Enabling this is a good ideaon fields that are frequently used for terms aggregations.     
[`fields`](multi-fields.html)| Multi-fields allow the same string value to be indexed in multiple ways for different purposes, such as one field forsearch and a multi-field for sorting and aggregations.     
[`ignore_above`](ignore-above.html)| Do not index any string longer than this value. Defaults to `2147483647` so that all values would be accepted.     
[`include_in_all`](include-in-all.html)| Whether or not the field value should be included in the 
[`_all`](mapping-all-field.html) field? Accepts `true` or false`. Defaults to `false` if 
[`index`](mapping-index.html) is set to `no`, or if a parent 
[`object`](object.html)field sets `include_in_all` to `false`. Otherwise defaults to `true`.     
[`index`](mapping-index.html)| Should the field be searchable? Accepts `true` (default) or `false`.     
[`index_options`](index-options.html)| What information should be stored in the index, for scoring purposes. Defaults to `docs` but can also be set to `freqs to take term frequency into account when computing scores.     
[`norms`](norms.html)| Whether field-length should be taken into account when scoring queries. Accepts `true` or `false` (default).     
[`null_value`](null-value.html)| Accepts a string value which is substituted for any explicit `null` values. Defaults to `null`, which means the fieldis treated as missing.     
[`store`](mapping-store.html)| Whether the field value should be stored and retrievable separately from the 
[`_source`](mapping-source-field.html)field. Accepts `true` or `false` (default).     
[`similarity`](similarity.html)| Which scoring algorithm or _similarity_ should be used. Defaults to `BM25`.     
[`normalizer`](normalizer.html)| [ experimental] This functionality is experimental and may be changed or removed completely in a future release.Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features. How to pre-process the keyword prior to indexing. Defaults to `null`, meaning the keyword is kept as-is.   
  
![Note](/images/icons/note.png)

Indexes imported from 2.x do not support `keyword`. Instead they will attempt to downgrade `keyword` into `string`. This allows you to merge modern mappings with legacy mappings. Long lived indexes will have to be recreated before upgrading to 6.x but mapping downgrade gives you the opportunity to do the recreation on your own schedule.
