##  匹配全部查询 Match All Query

最简单的查询，匹配所有的文件，匹配的文档`_score`+`1.0`。    
    
    GET /_search
    {
        "query": {
            "match_all": {}
        }
    }

 `_score` 可以使用`boost` 参数进行修改:
    
    
    GET /_search
    {
        "query": {
            "match_all": { "boost" : 1.2 }
        }
    }

## 匹配空查询 Match None Query

这个跟`Match All Query`相反,返回空的文档:
    
    GET /_search
    {
        "query": {
            "match_none": {}
        }
    }
