## 范围查度 Range Query

Matches documents with fields that have terms within a certain range. The type of the Lucene query depends on the field type, for `string` fields, the `TermRangeQuery`, while for number/date fields, the query is a `NumericRangeQuery`. The following example returns all documents where `age` is between `10` and `20`:
    
    
    GET _search
    {
        "query": {
            "range" : {
                "age" : {
                    "gte" : 10,
                    "lte" : 20,
                    "boost" : 2.0
                }
            }
        }
    }

`range`查询可以使用如下的参数:

`gte`| 大于等于  
 ---|---    
`gt`| 大于     
`lte`| 小于等于   
`lt`| 小于     
`boost`| 提升因子，默认`1.0`  
  
### 日期字段的范围查询 Ranges on date fields

When running `range` queries on fields of type [`date`](date.html), ranges can be specified using [Date Math:
    
    
    GET _search
    {
        "query": {
            "range" : {
                "date" : {
                    "gte" : "now-1d/d",
                    "lt" :  "now/d"
                }
            }
        }
    }

#### 日期数据格式和四舍五入 Date math and rounding

When using [date math](common-options.html#date-math) to round dates to the nearest day, month, hour, etc, the rounded dates depend on whether the ends of the ranges are inclusive or exclusive.

Rounding up moves to the last millisecond of the rounding scope, and rounding down to the first millisecond of the rounding scope. For example:

`gt`| Greater than the date rounded up: `2014-11-18||/M` becomes `2014-11-30T23:59:59.999`, ie excluding the entire month.     
---|---    
`gte`| Greater than or equal to the date rounded down: `2014-11-18||/M` becomes `2014-11-01`, ie including the entire month     
`lt`| Less than the date rounded down: `2014-11-18||/M` becomes `2014-11-01`, ie excluding the entire month.     
`lte`| Less than or equal to the date rounded up: `2014-11-18||/M` becomes `2014-11-30T23:59:59.999`, ie including the entire month.   
  
#### Date format in range queries

Formatted dates will be parsed using the [`format`](mapping-date-format.html) specified on the [`date`](date.html) field by default, but it can be overridden by passing the `format` parameter to the `range` query:
    
    
    GET _search
    {
        "query": {
            "range" : {
                "born" : {
                    "gte": "01/01/2012",
                    "lte": "2013",
                    "format": "dd/MM/yyyy||yyyy"
                }
            }
        }
    }

#### 根据时区的范围查询 Time zone in range queries

Dates can be converted from another timezone to UTC either by specifying the time zone in the date value itself (if the [`format`](mapping-date-format.html) accepts it), or it can be specified as the `time_zone` parameter:
    
    
    GET _search
    {
        "query": {
            "range" : {
                "timestamp" : {
                    "gte": "2015-01-01 00:00:00", <1>
                    "lte": "now", <2>
                    "time_zone": "+01:00"
                }
            }
        }
    }

<1>| 日期会被转换成`2014-12-31T23:00:00 UTC`.     
---|---    
<2>| `now` 在 `time_zone` 参数下不生效 (日期一定要求UTC格式). 
