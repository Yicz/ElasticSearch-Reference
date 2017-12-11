## Date math support in index names

日期数学索引名称解析使您可以搜索一系列时间序列索引，而不是搜索所有时间序列索引，并过滤结果或保留别名。 限制搜索索引的数量会减少集群的负载，并提高执行性能。 例如，如果要在日常日志中搜索错误，则可以使用日期数学名称模板将搜索限制在过去两天。

几乎所有具有`index`参数的API，都支持`index`参数值中的数学计算。

日期数学索引名称采用以下形式：
    
    
    <static_name{date_math_expr{date_format|time_zone} }>

Where:

`static_name`| is the static text part of the name   
---|---    
`date_math_expr`| is a dynamic date math expression that computes the date dynamically     
`date_format`| is the optional format in which the computed date should be rendered. Defaults to `YYYY.MM.dd`.     `time_zone`| is the optional time zone . Defaults to `utc`.   
  
您必须将日期数学索引名称表达式括在尖括号中，并且所有特殊字符都应该进行URI编码。 例如：
    
    # GET /<logstash-{now/d}>/_search
    GET /%3Clogstash-%7Bnow%2Fd%7D%3E/_search
    {
      "query" : {
        "match": {
          "test": "data"
        }
      }
    }

### Percent encoding of date math characters

用于日期舍入的特殊字符必须如下进行URI编码：

`<`| `%3C`  
---|---    
`>`| `%3E`    
`/`| `%2F`    
`{`| `%7B`    
`}`| `%7D`    
`|`| `%7C`    
`+`| `%2B`    
`:`| `%3A`    
`,`| `%2C`  
  

以下示例显示了不同形式的日期数学索引名称以及在当前时间为2024年3月22日中午utc时解析的最终索引名称。

Expression | Resolves to  
---|---  
`<logstash-{now/d}>`| `logstash-2024.03.22`    
`<logstash-{now/M}>`| `logstash-2024.03.01`    
`<logstash-{now/M{YYYY.MM} }>`| `logstash-2024.03`    
`<logstash-{now/M-1M{YYYY.MM} }>`| `logstash-2024.02`    
`<logstash-{now/d{YYYY.MM.dd|+12:00} }>`| `logstash-2024.03.23`  
  
要在索引名称模板的静态部分中使用字符“{”和“}”，请使用反斜杠“\”将其转义，例如：

  * `<elastic\\{ON\\}-{now/M}>` resolves to `elastic{ON}-2024.03.01`

以下示例显示了搜索Logstash索引过去三天的搜索请求，假定索引使用默认的Logstash索引名称格式logstash-YYYY.MM.dd。    
    
    # GET /<logstash-{now/d-2d}>,<logstash-{now/d-1d}>,<logstash-{now/d}>/_search
    GET /%3Clogstash-%7Bnow%2Fd-2d%7D%3E%2C%3Clogstash-%7Bnow%2Fd-1d%7D%3E%2C%3Clogstash-%7Bnow%2Fd%7D%3E/_search
    {
      "query" : {
        "match": {
          "test": "data"
        }
      }
    }
