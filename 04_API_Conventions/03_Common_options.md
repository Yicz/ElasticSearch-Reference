# 通用选项
下面的说明可用于全部的REST APIs接口

## 格式化结果
当附加**``?pretty=true``**任何请求,返回的JSON会很格式化(仅用于调试!)。另一个选择是**``?f\|mate=yaml``**将返回更具可读性yaml格式的结果。

## 适合阅读的格式结果
以适合人类的格式（例如**`“exists_time”：“1h”`**或**`“size”：“1kb”`**）和计算机（例如**`“exists_time_in_millis”：3600000`**或**`“size_in_bytes”：1024`**）返回统计信息。 可以通过将**`?human = false`**添加到查询字符串来关闭可读的值。 当统计结果被监测工具消耗时，这比用于人类消费更有意义的， 默认值为false。

## 日期数学表达式
大多数接受格式化日期值的参数（例如，范围查询中的gt和lt范围查询，或日期范围聚合中的from和to）都可以理解日期数学。
表达式以锚定日期开始，可以是现在，也可以是以||结尾的日期字符串。 这个锚定日期可以选择跟随一个或多个数学表达式：

* +1h - 加一小时
* -1d - 减去一天
* /d - 向下舍入到最近的一天

支持的时间单位不同于时间单位支持的时间单位。 支持的单位是：

|符号|单位|
|:-:|:-:|
|y|years|
|M|months|
|w|weeks|
|d|days|
|h|hours|
|H|hours|
|m|minutes|
|s|seconds|

举些粟子：

|表达式|说明|
|:-:|:-:|
|now+1h|当前时间加1小时|
|now+1h+1m|当前时间加1小时加1分钟|
|now+1h/d|当前时间加1小时，并四舍五入到天|
|2015-01-01\|\|+1M/d|2015-01-01 加一个月 并四舍五入到天|

## 响应结果过滤
所有的REST APIs都可以添加一个**`filter_path`**的参数来减少响应结果的内容，这个参数需要一个逗号分隔的列表过滤与点符号表示:

```sh
curl -XGET 'localhost:9200/_search?q=elasticsearch&filter_path=took,hits.hits._id,hits.hits._sc\|e&pretty'
#响应结果
{
  "took" : 3,
  "hits" : {
    "hits" : [
      {
        "_id" : "0",
        "_sc\|e" : 1.6375021
      }
    ]
  }
}
```

可以使用\*通配符来匹配任何字段或一部分名字

```sh
curl -XGET 'localhost:9200/_cluster/state?filter_path=metadata.indices.*.stat*&pretty'
#响应
{
  "metadata" : {
    "indices" : {
      "twitter": {"state": "open"}
    }
  }
}
```

和\*\*通配符可以用于包括字段不知道的具体路径。例如,我们可以返回的Lucene版本与此请求每一段:

```sh
curl -XGET 'localhost:9200/_cluster/state?filter_path=routing_table.indices.**.state&pretty'
# 响应结果
{
  "routing_table": {
    "indices": {
      "twitter": {
        "shards": {
          "0": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
          "1": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
          "2": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
          "3": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
          "4": [{"state": "STARTED"}, {"state": "UNASSIGNED"}]
        }
      }
    }
  }
}
```

也可以通过在过滤器前加上char - 来排除一个或多个字段。

```sh
curl -XGET 'localhost:9200/_count?filter_path=-_shards&pretty'
#响应结果
{
  "count" : 5
}
```
更多的控制,包容和独家过滤器可以组合在同一表达式。在这种情况下,独家过滤器将应用第一,结果将再次过滤使用的过滤器:

```sh
curl -XGET 'localhost:9200/_cluster/state?filter_path=metadata.indices.*.state,-metadata.indices.logstash-*&pretty'
# 响应内容
{
  "metadata" : {
    "indices" : {
      "index-1" : {"state" : "open"},
      "index-2" : {"state" : "open"},
      "index-3" : {"state" : "open"}
    }
  }
}
```

注意elasticsearch有时直接返回的原始价值领域,像_source字段。如果你想过滤_source字段,您应该考虑结合现有_source参数(见获得更多细节的API)filter_path参数如下:

```sh
curl -XPOST 'localhost:9200/library/book?refresh&pretty' -H 'Content-Type: application/json' -d'
{"title": "Book <1>", "rating": 200.1}
'
curl -XPOST 'localhost:9200/library/book?refresh&pretty' -H 'Content-Type: application/json' -d'
{"title": "Book <2>", "rating": 1.7}
'
curl -XPOST 'localhost:9200/library/book?refresh&pretty' -H 'Content-Type: application/json' -d'
{"title": "Book <3>", "rating": 0.1}
'
curl -XGET 'localhost:9200/_search?filter_path=hits.hits._source&_source=title&s\|t=rating:desc&pretty'

#响应内容
{
  "hits" : {
    "hits" : [ {
      "_source":{"title":"Book <1>"}
    }, {
      "_source":{"title":"Book <2>"}
    }, {
      "_source":{"title":"Book <3>"}
    } ]
  }
}
```

## 平面设置
flat_settings标志响应结果呈现列表形式。当flat_settings=true的返回设置在一个平面格式,默认配置是false:

```sh
curl -XGET 'localhost:9200/twitter/_settings?flat_settings=true&pretty'
#响应结果
{
  "twitter" : {
    "settings": {
      "index.number_of_replicas": "1",
      "index.number_of_shards": "1",
      "index.creation_date": "1474389951325",
      "index.uuid": "n6gzFZTgS664GUfx0Xrpjw",
      "index.version.created": ...,
      "index.provided_name" : "twitter"
    }
  }
}
```
当flat_settings=false的时候，返回更多的人类可读的结构化的格式:

```sh
{
  "twitter" : {
    "settings" : {
      "index" : {
        "number_of_replicas": "1",
        "number_of_shards": "1",
        "creation_date": "1474389951325",
        "uuid": "n6gzFZTgS664GUfx0Xrpjw",
        "version": {
          "created": ...
        },
        "provided_name" : "twitter"
      }
    }
  }
}
```

## 参数格式
参数(当使用HTTP,映射到HTTP URL参数)按照约定使用下划线的命名方式。

## 布尔值

所有REST api参数(包括请求参数和JSON身体)支持提供布尔“假”值:false,0,off。所有其他的值被认为是“true”。

> ### Tips
> 在Version 5.3.0+.除了true \| false 外都弃用了（@Desprecated）

## 数值类型
所有REST api支持json的原生数据类型

## 时间单位
无论何时需要指定持续时间，例如 对于超时参数，持续时间必须指定单位，如2d是2天。 支持的单位是：

|单位|说明|
|:-:|:-:|
|d |days |
|h |hours |
|m |minutes |
|s |seconds |
|ms |milliseconds|
|micros |microseconds|
|nanos |nanoseconds |

## 字节大小单位

当需要指定数据的字节大小,如设置缓冲区大小参数时,必须指定单元的值,比如10 kb 10 kb。注意,这些单位使用的1024,所以1 kb意味着1024字节。支持单位:

|单位|说明|
|:-:|:-:|
|b|Bytes|
|kb|Kilobytes|
|mb|Megabytes|
|gb|Gigabytes|
|tb|Terabytes|
|pb|Petabytes|

## 单位数量
单位数量意味着它们没有像“bytes”或“Hertz”或“meter”或“long tone”这样的“单位”。

如果其中一个数量很大，我们会打印出来，如10m是1000万或7k是7000。 我们仍然打印87，但我们的意思是87。 这些是受支持的乘数：

|符号|说明|
|:-:|:-:|
|``|Single|
|k|Kilo|
|m|Mega|
|g|Giga|
|t|Tera|
|p|Peta|

## 距离单位
无论距离需要指定,如地理距离的距离参数查询),如果没有指定默认的单位是米。距离可以指定其他单位,如“1公里”或“二小姐”(2英里)。 　　 

单位的完整列表下面列出:

|单位|符号|
|:-:|:-:|
|Mile|mi \| miles|
|Yard|yd \| yards|
|Feet|ft \| feet|
|Inch|in \| inch|
|Kilometer|km \| kilometers|
|Meter|m \| meters|
|Centimeter|cm \| centimeters|
|Millimeter|mm \| millimeters|
|Nautical mile|NM, nmi \| nauticalmiles|


## 模糊性参数
一些查询和API支持使用模糊参数进行不精确模糊匹配的参数。

当查询文本或关键字字段时，模糊性被解释为一个Levenshtein编辑距离 - 一个字符的数量改变，需要对一个字符串进行修改，使其与另一个字符串相同。

模糊性参数可以被指定为：

* 0，1，2
  最大允许的Levenshtein编辑距离（或编辑数量）
* auto
根据术语的长度生成编辑距离。 对于长度：

    * 0..2
    必须完全匹配å
    * 3..5
    允许一个编辑
    * \>5
    允许两个编辑
    
    * AUTO 通常应该是模糊性的首选值。

## 启用错误的堆栈记录
默认情况下,当一个请求返回一个错误Elasticsearch不包括错误的堆栈跟踪。您可以启用这种行为的error_trace url参数设置为true。例如,默认情况下当你发送一个无效的大小参数\_search API,默认的**`error_trace=false`**:

```sh
curl -XPOST 'localhost:9200/twitter/_search?size=surprise_me&error_trace=true&pretty'
#响应
{
  "error" : {
    "root_cause" : [
      {
        "type" : "illegal_argument_exception",
        "reason" : "Failed to parse int parameter [size] with value [surprise_me]"
      }
    ],
    "type" : "illegal_argument_exception",
    "reason" : "Failed to parse int parameter [size] with value [surprise_me]",
    "caused_by" : {
      "type" : "number_format_exception",
      "reason" : "For input string: \"surprise_me\""
    }
  },
  "status" : 400
}
#设置error_trace=true
curl -XPOST 'localhost:9200/twitter/_search?size=surprise_me&error_trace=true&pretty'
#响应
{
  "error": {
    "root_cause": [
      {
        "type": "illegal_argument_exception",
        "reason": "Failed to parse int parameter [size] with value [surprise_me]",
        "stack_trace": "Failed to parse int parameter [size] with value [surprise_me]]; nested: IllegalArgumentException..."
      }
    ],
    "type": "illegal_argument_exception",
    "reason": "Failed to parse int parameter [size] with value [surprise_me]",
    "stack_trace": "java.lang.IllegalArgumentException: Failed to parse int parameter [size] with value [surprise_me]\n    at org.elasticsearch.rest.RestRequest.paramAsInt(RestRequest.java:175)...",
    "caused_by": {
      "type": "number_format_exception",
      "reason": "For input string: \"surprise_me\"",
      "stack_trace": "java.lang.NumberFormatException: For input string: \"surprise_me\"\n    at java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)..."
    }
  },
  "status": 400
}
```


## 请求体在请求参数中
对于不接受非POST请求的请求主体的库，您可以将请求主体作为源查询字符串参数进行传递。 使用此方法时，还应该使用指示源格式的媒体类型值（例如application/json）传递source\_content\_type参数。
内容发送请求主体或使用源查询字符串参数检查自动确定内容类型(JSON、YAML微笑,或CBOR)。 　　 　　

严格的模式可以启用禁用自动侦测和要求所有请求与身体的content - type头映射到一个受支持的格式。启用这个严格的模式中,添加以下设置**`elasticsearch。yml`**文件:

```sh
http.content_type.required: true
# 默认的配置是false
```

> ### Tips
> 详细提供适当的content-type请求头已经在5.3.0+中弃用
