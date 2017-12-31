## 检验API Validate API

`_validate`API允许用户在不执行的情况下验证潜在的消耗大的查询。 我们将使用以下测试数据来解释`_validate`API：
    
    PUT twitter/tweet/_bulk?refresh
    {"index":{"_id":1} }
    {"user" : "kimchy", "post_date" : "2009-11-15T14:12:12", "message" : "trying out Elasticsearch"}
    {"index":{"_id":2} }
    {"user" : "kimchi", "post_date" : "2009-11-15T14:12:13", "message" : "My username is similar to @kimchy!"}

当发送一个`_validate`查询:
    
    
    GET twitter/_validate/query?q=user:foo

响应包含 `valid:true`:
    
    
    {"valid":true,"_shards":{"total":1,"successful":1,"failed":0} }

### 请求参数

当使用查询参数`q`执行时，传递的查询是使用Lucene查询解析器的查询字符串。 还有其他可以传递的参数：

名称|描述 
---|---  
`df`| 在查询中未定义字段前缀时使用的默认字段。   
`analyzer`| 分析查询字符串时要使用的分析器名称。 
`default_operator`| 要使用的默认运算符可以是`AND`或`OR`。 默认为`OR`。
`lenient`| 如果设置为true将导致基于格式的失败（如提供文本到数字字段）被忽略。 默认为`false`。
`analyze_wildcard`| 是否应该分析通配符和前缀查询。 默认为`false`。    
  
  
该查询也可以在请求主体中发送：    
    
    GET twitter/tweet/_validate/query
    {
      "query" : {
        "bool" : {
          "must" : {
            "query_string" : {
              "query" : "*:*"
            }
          },
          "filter" : {
            "term" : { "user" : "kimchy" }
          }
        }
      }
    }

![Note](/images/icons/note.png)

正在发送的查询必须嵌套在`query`键中，与[search api]（search-search.html）相同

如果查询无效，`valid`将会是`false`。 这里的查询是无效的，因为Elasticsearch知道post_date字段应该是由于动态映射的日期，而_foo_不能正确地解析成日期：
    
    GET twitter/tweet/_validate/query?q=post_date:foo
    
    
    {"valid":false,"_shards":{"total":1,"successful":1,"failed":0} }

可以指定`explain`参数来获取有关查询失败原因的更多详细信息：    
    
    GET twitter/tweet/_validate/query?q=post_date:foo&explain=true

响应：
    
    {
      "valid" : false,
      "_shards" : {
        "total" : 1,
        "successful" : 1,
        "failed" : 0
      },
      "explanations" : [ {
        "index" : "twitter",
        "valid" : false,
        "error" : "twitter/IAEc2nIXSSunQA_suI0MLw] QueryShardException[failed to create query:...failed to parse date field [foo]"
      } ]
    }

当查询有效时，说明默认为该查询的字符串表示形式。 将`rewrite`设置为`true`，解释更加详细，显示将要执行的实际Lucene查询。
更多像这样的：
    
    
    GET twitter/tweet/_validate/query?rewrite=true
    {
      "query": {
        "more_like_this": {
          "like": {
            "_id": "2"
          },
          "boost_terms": 1
        }
      }
    }

响应:
    
    
    {
       "valid": true,
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "explanations": [
          {
             "index": "twitter",
             "valid": true,
             "explanation": "((user:terminator^3.71334 plot:future^2.763601 plot:human^2.8415773 plot:sarah^3.4193945 plot:kyle^3.8244398 plot:cyborg^3.9177752 plot:connor^4.040236 plot:reese^4.7133346 ... )~6) -ConstantScore(_uid:tweet<2>)) #(ConstantScore(_type:tweet))^0.0"
          }
       ]
    }

默认情况下，请求只在一个单独的分片上执行，这是随机选择的。 查询的详细解释可能取决于哪个分片正被击中，因此可能因请求而异。 所以，在查询重写的情况下，应该使用`all_shards`参数来获得所有可用分片的响应。

对于模糊查询：
    
    
    GET twitter/tweet/_validate/query?rewrite=true&all_shards=true
    {
      "query": {
        "match": {
          "user": {
            "query": "kimchy",
            "fuzziness": "auto"
          }
        }
      }
    }

响应:
    
    
    {
      "valid": true,
      "_shards": {
        "total": 5,
        "successful": 5,
        "failed": 0
      },
      "explanations": [
        {
          "index": "twitter",
          "shard": 0,
          "valid": true,
         ) #ConstantScore(MatchNoDocsQuery(\"empty BooleanQuery\"))"
        },
        {
          "index": "twitter",
          "shard": 1,
          "valid": true,
         ) #ConstantScore(MatchNoDocsQuery(\"empty BooleanQuery\"))"
        },
        {
          "index": "twitter",
          "shard": 2,
          "valid": true,
          "explanation": "(user:kimchi)^0.8333333"
        },
        {
          "index": "twitter",
          "shard": 3,
          "valid": true,
          "explanation": "user:kimchy"
        },
        {
          "index": "twitter",
          "shard": 4,
          "valid": true,
         ) #ConstantScore(MatchNoDocsQuery(\"empty BooleanQuery\"))"
        }
      ]
    }
