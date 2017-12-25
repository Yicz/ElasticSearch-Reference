## Text datatype

A field to index full-text values, such as the body of an email or the description of a product. These fields are `analyzed`, that is they are passed through an [analyzer](analysis.html) to convert the string into a list of individual terms before being indexed. The analysis process allows Elasticsearch to search for individual words _within_ each full text field. Text fields are not used for sorting and seldom used for aggregations (although the [significant terms aggregation](search-aggregations-bucket-significantterms-aggregation.html) is a notable exception).

If you need to index structured content such as email addresses, hostnames, status codes, or tags, it is likely that you should rather use a 
[`keyword`](keyword.html) field.

Below is an example of a mapping for a text field:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "full_name": {
              "type":  "text"
            }
          }
        }
      }
    }

Sometimes it is useful to have both a full text (`text`) and a keyword (`keyword`) version of the same field: one for full text search and the other for aggregations and sorting. This can be achieved with [multi-fields](multi-fields.html).

### Parameters for text fields

The following parameters are accepted by `text` fields:

[`analyzer`](analyzer.html)| The [analyzer](analysis.html) which should be used for 
[`analyzed`](mapping-index.html) string fields, both atindex-time and at search-time (unless overridden by the 
[`search_analyzer`](search-analyzer.html)). Defaults to thedefault index analyzer, or the [`standard` analyzer](analysis-standard-analyzer.html).     
---|---    
[`boost`](mapping-boost.html)| Mapping field-level query time boosting. Accepts a floating point number, defaults to `1.0`.     
[`eager_global_ordinals`](fielddata.html#global-ordinals)| Should global ordinals be loaded eagerly on refresh? Accepts `true` or `false` (default). Enabling this is a good ideaon fields that are frequently used for (significant) terms aggregations.     
[`fielddata`](fielddata.html)| Can the field use in-memory fielddata for sorting, aggregations, or scripting? Accepts `true` or `false` (default).     
[`fielddata_frequency_filter`](fielddata.html#field-data-filtering)| Expert settings which allow to decide which values to load in memory when `fielddata` is enabled. By default allvalues are loaded.     
[`fields`](multi-fields.html)| Multi-fields allow the same string value to be indexed in multiple ways for different purposes, such as one field forsearch and a multi-field for sorting and aggregations, or the same string value analyzed by different analyzers.     
[`include_in_all`](include-in-all.html)| Whether or not the field value should be included in the 
[`_all`](mapping-all-field.html) field? Accepts `true` or false`. Defaults to `false` if 
[`index`](mapping-index.html) is set to `no`, or if a parent 
[`object`](object.html)field sets `include_in_all` to `false`. Otherwise defaults to `true`.     
[`index`](mapping-index.html)| Should the field be searchable? Accepts `true` (default) or `false`.     
[`index_options`](index-options.html)| What information should be stored in the index, for search and highlighting purposes. Defaults to `positions`.     
[`norms`](norms.html)| Whether field-length should be taken into account when scoring queries. Accepts `true` (default) or `false`.     
[`position_increment_gap`](position-increment-gap.html)| The number of fake term position which should be inserted between each element of an array of strings. Defaults to the`position_increment_gap` configured on the analyzer which defaults to `100`. `100` was chosen because it preventsphrase queries with reasonably large slops (less than 100) from matching terms across field values.     
[`store`](mapping-store.html)| Whether the field value should be stored and retrievable separately from the 
[`_source`](mapping-source-field.html)field. Accepts `true` or `false` (default).     
[`search_analyzer`](search-analyzer.html)| The 
[`analyzer`](analyzer.html) that should be used at search time on 
[`analyzed`](mapping-index.html) fields.Defaults to the `analyzer` setting.     
[`search_quote_analyzer`](analyzer.html#search-quote-analyzer)| The 
[`analyzer`](analyzer.html) that should be used at search time when a phrase is encountered. Defaults to the search_analyzer` setting.     
[`similarity`](similarity.html)| Which scoring algorithm or _similarity_ should be used. Defaults to `BM25`.     
[`term_vector`](term-vector.html)| Whether term vectors should be stored for an 
[`analyzed`](mapping-index.html) field. Defaults to `no`.   
  
![Note](images/icons/note.png)

Indexes imported from 2.x do not support `text`. Instead they will attempt to downgrade `text` into `string`. This allows you to merge modern mappings with legacy mappings. Long lived indexes will have to be recreated before upgrading to 6.x but mapping downgrade gives you the opportunity to do the recreation on your own schedule.
