## 是否存在查询 Exists Query

返回*原始字段*值不为`null`的文档。
    
    GET /_search
    {
        "query": {
            "exists" : { "field" : "user" }
        }
    }

上面的查询，将返回下面的匹配到下面所有的返回结果    
    
    { "user": "jane" }
    { "user": "" } <1>
    { "user": "-" } <2>
    { "user": ["jane"] }
    { "user": ["jane", null ] } <3>

<1>| 空字符也是一个非`null`数据    
---|---  
<2>| 即使`standard`分析器会发出零标记，原始字段值也不是`null`。   
<3>| 数组内容中，至少有一个是非`null`的数据

下面的文档不会匹配到上面的查询语句：
    
    { "user": null }
    { "user": [] } <1>
    { "user": [null] } <2>
    { "foo":  "bar" } <3>

<1>| 该字段没有内容.     
---|---  
<2>| 数组内容中，至少有一个是非`null`的数据    
<3>| 没有`user`字段   
  
#### 空值映射 `null_value` mapping

如果字段映射包含[`null_value`](null-value.html)设置，则显式的`null`值将被替换为指定的`null_value`。 例如，如果`user`字段被映射如下：
    
      "user": {
        "type": "keyword",
        "null_value": "_null_"
      }

那么明确的`null`值将会被索引为字符串`_null_`，下面的文档将会匹配`exists`过滤器：    
    
    { "user": null }
    { "user": [null] }
但是，这些文档（没有显式的“null”值）在`user`字段中仍然没有值，因此不匹配`exists`过滤器：    

    { "user": [] }
    { "foo": "bar" }

### 没有值查询 `missing` query

 _missing_ query has been removed because it can be advantageously replaced by an `exists` query inside a must_not clause as follows:
    
    
    GET /_search
    {
        "query": {
            "bool": {
                "must_not": {
                    "exists": {
                        "field": "user"
                    }
                }
            }
        }
    }
    
此查询返回用户字段中没有值的文档。
