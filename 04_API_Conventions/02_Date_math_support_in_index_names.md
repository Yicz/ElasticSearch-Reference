## Date math support in index names

Date math index name resolution enables you to search a range of time-series indices, rather than searching all of your time-series indices and filtering the results or maintaining aliases. Limiting the number of indices that are searched reduces the load on the cluster and improves execution performance. For example, if you are searching for errors in your daily logs, you can use a date math name template to restrict the search to the past two days.

Almost all APIs that have an `index` parameter, support date math in the `index` parameter value.

A date math index name takes the following form:
    
    
    <static_name{date_math_expr{date_format|time_zone} }>

Where:

`static_name`

| 

is the static text part of the name   
  
---|---  
  
`date_math_expr`

| 

is a dynamic date math expression that computes the date dynamically   
  
`date_format`

| 

is the optional format in which the computed date should be rendered. Defaults to `YYYY.MM.dd`.   
  
`time_zone`

| 

is the optional time zone . Defaults to `utc`.   
  
You must enclose date math index name expressions within angle brackets, and all special characters should be URI encoded. For example:
    
    
    # GET /<logstash-{now/d}>/_search
    GET /%3Clogstash-%7Bnow%2Fd%7D%3E/_search
    {
      "query" : {
        "match": {
          "test": "data"
        }
      }
    }

![Note](images/icons/note.png)

### Percent encoding of date math characters

The special characters used for date rounding must be URI encoded as follows:

`<`

| 

`%3C`  
  
---|---  
  
`>`

| 

`%3E`  
  
`/`

| 

`%2F`  
  
`{`

| 

`%7B`  
  
`}`

| 

`%7D`  
  
`|`

| 

`%7C`  
  
`+`

| 

`%2B`  
  
`:`

| 

`%3A`  
  
`,`

| 

`%2C`  
  
The following example shows different forms of date math index names and the final index names they resolve to given the current time is 22rd March 2024 noon utc.

Expression | Resolves to  
---|---  
  
`<logstash-{now/d}>`

| 

`logstash-2024.03.22`  
  
`<logstash-{now/M}>`

| 

`logstash-2024.03.01`  
  
`<logstash-{now/M{YYYY.MM} }>`

| 

`logstash-2024.03`  
  
`<logstash-{now/M-1M{YYYY.MM} }>`

| 

`logstash-2024.02`  
  
`<logstash-{now/d{YYYY.MM.dd|+12:00} }>`

| 

`logstash-2024.03.23`  
  
To use the characters `{` and `}` in the static part of an index name template, escape them with a backslash `\`, for example:

  * `<elastic\\{ON\\}-{now/M}>` resolves to `elastic{ON}-2024.03.01`



The following example shows a search request that searches the Logstash indices for the past three days, assuming the indices use the default Logstash index name format, `logstash-YYYY.MM.dd`.
    
    
    # GET /<logstash-{now/d-2d}>,<logstash-{now/d-1d}>,<logstash-{now/d}>/_search
    GET /%3Clogstash-%7Bnow%2Fd-2d%7D%3E%2C%3Clogstash-%7Bnow%2Fd-1d%7D%3E%2C%3Clogstash-%7Bnow%2Fd%7D%3E/_search
    {
      "query" : {
        "match": {
          "test": "data"
        }
      }
    }
