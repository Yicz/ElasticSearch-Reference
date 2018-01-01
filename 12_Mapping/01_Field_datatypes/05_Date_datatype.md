## 日期类型 Date datatype

JSON doesn’t have a date datatype, so dates in Elasticsearch can either be:

  * strings containing formatted dates, e.g. `"2015-01-01"` or `"2015/01/01 12:10:30"`. 
  * a long number representing _milliseconds-since-the-epoch_. 
  * an integer representing _seconds-since-the-epoch_. 



Internally, dates are converted to UTC (if the time-zone is specified) and stored as a long number representing milliseconds-since-the-epoch.

Date formats can be customised, but if no `format` is specified then it uses the default:
    
    
    "strict_date_optional_time||epoch_millis"

This means that it will accept dates with optional timestamps, which conform to the formats supported by 
[`strict_date_optional_time`](mapping-date-format.html#strict-date-time) or milliseconds-since-the-epoch.

For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "date": {
              "type": "date" <1>
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    { "date": "2015-01-01" } <2>
    
    PUT my_index/my_type/2
    { "date": "2015-01-01T12:10:30Z" } <3>
    
    PUT my_index/my_type/3
    { "date": 1420070400001 } <4>
    
    GET my_index/_search
    {
      "sort": { "date": "asc"} <5>
    }

<1>| The `date` field uses the default `format`.     
---|---  
<2>| This document uses a plain date.     
<3>| This document includes a time.    
<4>| This document uses milliseconds-since-the-epoch.     
<5>| Note that the `sort` values that are returned are all in milliseconds-since-the-epoch.   
  
### Multiple date formats

Multiple formats can be specified by separating them with `||` as a separator. Each format will be tried in turn until a matching format is found. The first format will be used to convert the _milliseconds-since-the-epoch_ value back into a string.
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "date": {
              "type":   "date",
              "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
            }
          }
        }
      }
    }

### Parameters for `date` fields

The following parameters are accepted by `date` fields:

[`boost`](mapping-boost.html)| Mapping field-level query time boosting. Accepts a floating point number, defaults to `1.0`.     
---|---    
[`doc_values`](doc-values.html)| Should the field be stored on disk in a column-stride fashion, so that it can later be used for sorting, aggregations,or scripting? Accepts `true` (default) or `false`.     
[`format`](mapping-date-format.html)| The date format(s) that can be parsed. Defaults to `strict_date_optional_time||epoch_millis`.     `locale`| The locale to use when parsing dates since months do not have the same names and/or abbreviations in all languages.The default is the [`ROOT` locale](https://docs.oracle.com/javase/8/docs/api/java/util/Locale.html#ROOT),     
[`ignore_malformed`](ignore-malformed.html)| If `true`, malformed numbers are ignored. If `false` (default), malformed numbers throw an exception and reject thewhole document.   
[`include_in_all`](include-in-all.html)| Whether or not the field value should be included in the 
[`_all`](mapping-all-field.html) field? Accepts `true` orfalse`. Defaults to `false` if 
[`index`](mapping-index.html) is set to `false`, or if a parent 
[`object`](object.htmlfield sets `include_in_all` to `false`. Otherwise defaults to `true`.   [`index`](mapping-index.html)| Should the field be searchable? Accepts `true` (default) and `false`.   
[`null_value`](null-value.html)| Accepts a date value in one of the configured `format`'s as the field which is substituted for any explicit `nullvalues. Defaults to `null`, which means the field is treated as missing.   
[`store`](mapping-store.html)| Whether the field value should be stored and retrievable separately from the 
[`_source`](mapping-source-field.htmlfield. Accepts `true` or `false` (default). 
