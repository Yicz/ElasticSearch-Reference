## 滚动索引 Rollover Index

当现有索引被认为太大或太旧时，滚动索引API会将别名滚动到新的索引。

滚动索引API只接受一个别名参数和一系列的`conditions`(限定条件)，别名必须指向一个单索引。如果索引满足指定的条件，则创建一个新的索引，并将别名切换到指向新的索引。
    
    
    PUT /logs-000001 <1>
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
当文档数超过10000时
    
    POST /logs_write/_rollover <2>
    {
      "conditions": {
        "max_age":   "7d",
        "max_docs":  1000
      }
    }

<1>| 使用别名`logs_write`创建一个名为`logs-0000001`的索引。  
---|---    
<2>| 如果`logs_write`指向的索引是在7天或更多天前创建的，或者包含1,000个或更多的文档，则创建`logs-000002`索引，并且`logs_write`别名更新为指向`logs-000002`。   
  
上述请求可能会返回以下响应：    
    
    {
      "acknowledged": true,
      "shards_acknowledged": true,
      "old_index": "logs-000001",
      "new_index": "logs-000002",
      "rolled_over": true, <1>
      "dry_run": false, <2>
      "conditions": { <3>
        "[max_age: 7d]": false,
        "[max_docs: 1000]": true
      }
    }

<1>| 索引是否被滚动。     
---|---    
<2>| 翻车是否是空转。     
<3>| 每个条件的结果。   
  
### 新索引的命名 Naming the new index

如果名称是以`-`分隔并使用数字结尾，新索引的名称会遵循增加后缀数字的规则进行增加。无论旧的索引名称如何，该数字的长度为6且都是零填充的。

如果旧名称与此模式不匹配，则必须按如下所示为新索引指定名称：    
    
    POST /my_alias/_rollover/my_new_index_name
    {
      "conditions": {
        "max_age":   "7d",
        "max_docs":  1000
      }
    }

### 使用日期数学结合滚动API Using date math with the rollover API

使用[日期数学](date-math-index-names.html)根据索引滚动的日期命名滚动索引是有用的，例如，`logstash-2016.02.03`。 滚动API支持日期数学，但要求索引名称以短划线结尾，后跟数字，例如 `logstash-2016.02.03-1`每次索引被滚动时递增。 例如：

    
    
    # PUT /<logs-{now/d}-1> with URI encoding:
    PUT /%3Clogs-%7Bnow%2Fd%7D-1%3E     <1>
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
    PUT logs_write/log/1
    {
      "message": "a dummy log"
    }
    
    POST logs_write/_refresh
    
    # Wait for a day to pass
    
    POST /logs_write/_rollover <2>
    {
      "conditions": {
        "max_docs":   "1"
      }
    }

<1>| 创建一个以今天的日期命名的索引（例如 `logs-2016.10.31-1` )
---|---    
<2>| 在今天的日期，例如，滚动到一个新的索引。 `logs-2016.10.31-000002`如果立即运行，或者`logs-2016.11.01-000002`如果在24小时后运行  
  
然后可以按照[日期数学文档](date-math-index-names.html)中的描述引用这些索引。 例如，要搜索过去三天创建的索引，可以执行以下操作：
    
    
    # GET /<logs-{now/d}-*>,<logs-{now/d-1d}-*>,<logs-{now/d-2d}-*>/_search
    GET /%3Clogs-%7Bnow%2Fd%7D-*%3E%2C%3Clogs-%7Bnow%2Fd-1d%7D-*%3E%2C%3Clogs-%7Bnow%2Fd-2d%7D-*%3E/_search

### 定义新的索引 Defining the new index

新索引的`settings`，`mappings`和`aliases`来自任何匹配的[索引模板](indices-templates.html)。 另外，您可以在请求的主体中指定`settings`，`mappings`和`aliases`，就像[create index](indices-create-index.html)API一样。 请求中指定的值覆盖匹配索引模板中设置的任何值。 例如，下面的`rollover`请求覆盖`index.number_of_shards`设置：    
    
    PUT /logs-000001
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
    POST /logs_write/_rollover
    {
      "conditions" : {
        "max_age": "7d",
        "max_docs": 1000
      },
      "settings": {
        "index.number_of_shards": 2
      }
    }

### 空转 Dry run

滚动API支持`dry_run`模式，在这种模式下可以检查请求条件，而不需要执行实际的滚动：
    
    
    PUT /logs-000001
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
    POST /logs_write/_rollover?dry_run
    {
      "conditions" : {
        "max_age": "7d",
        "max_docs": 1000
      }
    }

### Wait For Active Shards/等待激活分片　

因为滚动操作会创建一个新的索引，因此在创建索引时的wait_for_active_shards 设置也适用于滚动操作。


