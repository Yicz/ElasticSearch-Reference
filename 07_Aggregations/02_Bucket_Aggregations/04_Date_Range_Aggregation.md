## Date Range Aggregation

A range aggregation that is dedicated for date values. The main difference between this aggregation and the normal [range](search-aggregations-bucket-range-aggregation.html "Range Aggregation") aggregation is that the `from` and `to` values can be expressed in [Date Math](common-options.html#date-math "Date Mathedit") expressions, and it is also possible to specify a date format by which the `from` and `to` response fields will be returned. Note that this aggregation includes the `from` value and excludes the `to` value for each range.

Example:
    
    
    POST /sales/_search?size=0
    {
        "aggs": {
            "range": {
                "date_range": {
                    "field": "date",
                    "format": "MM-yyy",
                    "ranges": [
                        { "to": "now-10M/M" }, ![](images/icons/callouts/1.png)
                        { "from": "now-10M/M" } ![](images/icons/callouts/2.png)
                    ]
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

< now minus 10 months, rounded down to the start of the month.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

>= now minus 10 months, rounded down to the start of the month.   
  
In the example above, we created two range buckets, the first will "bucket" all documents dated prior to 10 months ago and the second will "bucket" all documents dated since 10 months ago

Response:
    
    
    {
        ...
        "aggregations": {
            "range": {
                "buckets": [
                    {
                        "to": 1.4436576E12,
                        "to_as_string": "10-2015",
                        "doc_count": 7,
                        "key": "*-10-2015"
                    },
                    {
                        "from": 1.4436576E12,
                        "from_as_string": "10-2015",
                        "doc_count": 0,
                        "key": "10-2015-*"
                    }
                ]
            }
        }
    }

### Date Format/Pattern

![Note](images/icons/note.png)

this information was copied from [JodaDate](http://www.joda.org/joda-time/apidocs/org/joda/time/format/DateTimeFormat.html)

All ASCII letters are reserved as format pattern letters, which are defined as follows:

Symbol | Meaning | Presentation | Examples  
---|---|---|---  
  
G

| 

era

| 

text

| 

AD  
  
C

| 

century of era (>=0)

| 

number

| 

20  
  
Y

| 

year of era (>=0)

| 

year

| 

1996  
  
x

| 

weekyear

| 

year

| 

1996  
  
w

| 

week of weekyear

| 

number

| 

27  
  
e

| 

day of week

| 

number

| 

2  
  
E

| 

day of week

| 

text

| 

Tuesday; Tue  
  
y

| 

year

| 

year

| 

1996  
  
D

| 

day of year

| 

number

| 

189  
  
M

| 

month of year

| 

month

| 

July; Jul; 07  
  
d

| 

day of month

| 

number

| 

10  
  
a

| 

halfday of day

| 

text

| 

PM  
  
K

| 

hour of halfday (0~11)

| 

number

| 

0  
  
h

| 

clockhour of halfday (1~12)

| 

number

| 

12  
  
H

| 

hour of day (0~23)

| 

number

| 

0  
  
k

| 

clockhour of day (1~24)

| 

number

| 

24  
  
m

| 

minute of hour

| 

number

| 

30  
  
s

| 

second of minute

| 

number

| 

55  
  
S

| 

fraction of second

| 

number

| 

978  
  
z

| 

time zone

| 

text

| 

Pacific Standard Time; PST  
  
Z

| 

time zone offset/id

| 

zone

| 

-0800; -08:00; America/Los_Angeles  
  
'

| 

escape for text

| 

delimiter

| 

''  
  
The count of pattern letters determine the format.

Text 
     If the number of pattern letters is 4 or more, the full form is used; otherwise a short or abbreviated form is used if available. 
Number 
     The minimum number of digits. Shorter numbers are zero-padded to this amount. 
Year 
     Numeric presentation for year and weekyear fields are handled specially. For example, if the count of _y_ is 2, the year will be displayed as the zero-based year of the century, which is two digits. 
Month 
     3 or over, use text, otherwise use number. 
Zone 
     _Z_ outputs offset without a colon, _ZZ_ outputs the offset with a colon, _ZZZ_ or more outputs the zone id. 
Zone names 
     Time zone names ( _z_ ) cannot be parsed. 

Any characters in the pattern that are not in the ranges of [ _a_.. _z_ ] and [ _A_.. _Z_ ] will be treated as quoted text. For instance, characters like _:_ , _._ , ' _, '#_ and _?_ will appear in the resulting time text even they are not embraced within single quotes.

### Time zone in date range aggregations

Dates can be converted from another time zone to UTC by specifying the `time_zone` parameter.

Time zones may either be specified as an ISO 8601 UTC offset (e.g. +01:00 or -08:00) or as one of the [time zone ids](http://www.joda.org/joda-time/timezones.html) from the TZ database.

The `time_zone` parameter is also applied to rounding in date math expressions. As an example, to round to the beginning of the day in the CET time zone, you can do the following:
    
    
    POST /sales/_search?size=0
    {
       "aggs": {
           "range": {
               "date_range": {
                   "field": "date",
                   "time_zone": "CET",
                   "ranges": [
                      { "to": "2016/02/01" }, ![](images/icons/callouts/1.png)
                      { "from": "2016/02/01", "to" : "now/d" ![](images/icons/callouts/2.png)},
                      { "from": "now/d" }
                  ]
              }
          }
       }
    }

![](images/icons/callouts/1.png)

| 

This date will be converted to `2016-02-15T00:00:00.000+01:00`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

`now/d` will be rounded to the beginning of the day in the CET time zone.   
  
### Keyed Response

Setting the `keyed` flag to `true` will associate a unique string key with each bucket and return the ranges as a hash rather than an array:
    
    
    POST /sales/_search?size=0
    {
        "aggs": {
            "range": {
                "date_range": {
                    "field": "date",
                    "format": "MM-yyy",
                    "ranges": [
                        { "to": "now-10M/M" },
                        { "from": "now-10M/M" }
                    ],
                    "keyed": true
                }
            }
        }
    }

Response:
    
    
    {
        ...
        "aggregations": {
            "range": {
                "buckets": {
                    "*-10-2015": {
                        "to": 1.4436576E12,
                        "to_as_string": "10-2015",
                        "doc_count": 7
                    },
                    "10-2015-*": {
                        "from": 1.4436576E12,
                        "from_as_string": "10-2015",
                        "doc_count": 0
                    }
                }
            }
        }
    }

It is also possible to customize the key for each range:
    
    
    POST /sales/_search?size=0
    {
        "aggs": {
            "range": {
                "date_range": {
                    "field": "date",
                    "format": "MM-yyy",
                    "ranges": [
                        { "from": "01-2015",  "to": "03-2015", "key": "quarter_01" },
                        { "from": "03-2015", "to": "06-2015", "key": "quarter_02" }
                    ],
                    "keyed": true
                }
            }
        }
    }

Response:
    
    
    {
        ...
        "aggregations": {
            "range": {
                "buckets": {
                    "quarter_01": {
                        "from": 1.4200704E12,
                        "from_as_string": "01-2015",
                        "to": 1.425168E12,
                        "to_as_string": "03-2015",
                        "doc_count": 5
                    },
                    "quarter_02": {
                        "from": 1.425168E12,
                        "from_as_string": "03-2015",
                        "to": 1.4331168E12,
                        "to_as_string": "06-2015",
                        "doc_count": 2
                    }
                }
            }
        }
    }
