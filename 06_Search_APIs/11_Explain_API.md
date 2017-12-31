##  解释API Explain API

解释API计算查询和特定文档的分数解释。 这可以给出有用的反馈，无论文档是否匹配特定的查询。

`index`和`type`参数分别指定望单个索引和单个类型。

### 用例

完整查询示例:
    
    
    GET /twitter/tweet/0/_explain
    {
          "query" : {
            "match" : { "message" : "elasticsearch" }
          }
    }

这将产生以下结果：    
    
    {
       "_index": "twitter",
       "_type": "tweet",
       "_id": "0",
       "matched": true,
       "explanation": {
          "value": 1.55077,
          "description": "weight(message:elasticsearch in 0) [PerFieldSimilarity], result of:",
          "details": [
             {
                "value": 1.55077,
                "description": "score(doc=0,freq=1.0 = termFreq=1.0\n), product of:",
                "details": [
                   {
                      "value": 1.3862944,
                      "description": "idf, computed as log(1 + (docCount - docFreq + 0.5) / (docFreq + 0.5)) from:",
                      "details": [
                         {
                            "value": 1.0,
                            "description": "docFreq",
                            "details": []
                         },
                         {
                            "value": 5.0,
                            "description": "docCount",
                            "details": []
                          }
                       ]
                   },
                    {
                      "value": 1.1186441,
                      "description": "tfNorm, computed as (freq * (k1 + 1)) / (freq + k1 * (1 - b + b * fieldLength / avgFieldLength)) from:",
                      "details": [
                         {
                            "value": 1.0,
                            "description": "termFreq=1.0",
                            "details": []
                         },
                         {
                            "value": 1.2,
                            "description": "parameter k1",
                            "details": []
                         },
                         {
                            "value": 0.75,
                            "description": "parameter b",
                            "details": []
                         },
                         {
                            "value": 5.4,
                            "description": "avgFieldLength",
                            "details": []
                         },
                         {
                            "value": 4.0,
                            "description": "fieldLength",
                            "details": []
                         }
                      ]
                   }
                ]
             }
          ]
       }
    }

通过`q`参数指定查询也有一个更简单的方法。 然后解析指定的`q`参数值，就好像使用`query_string`查询一样。 解释API中`q`参数的使用示例：
       
    GET /twitter/tweet/0/_explain?q=message:search

这将产生与以前的请求相同的结果。

### 所有参数s:

`_source`| 设置为`true`来检索所解释文档的_source。 您还可以使用`_source_include`＆`_source_exclude`来获取部分文档（更多细节请参阅[获取API](docs-get.html＃get-source-filtering)）
---|---    
`stored_fields`| 允许控制哪些存储的字段作为所解释文档的一部分返回。   
`routing`| 在索引过程中使用路由的情况下控制路由。    
`parent`|与设置路由参数的效果相同。    
`preference`| 控制执行解释的分片。    
`source`|允许将请求的数据放入url的查询字符串中。     
`q`| 查询字符串（映射到query_string查询）.     
`df`| 在查询中未定义字段前缀时使用的默认字段。 默认为_all字段。     
`analyzer`| 分析查询字符串时要使用的分析器名称。 默认为全部字段的分析器。
`default_operator`| 要使用的默认运算符可以是“AND”或`OR`。 默认为`OR`。
`lenient`| 如果设置为true将导致基于格式的失败（如提供文本到数字字段）被忽略。 默认为`false`。
`analyze_wildcard`| 是否应该分析通配符和前缀查询。 默认为`false`。    
