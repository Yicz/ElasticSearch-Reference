## 更新索引设置 Update Indices Settings

实时变更指定索引的设置.

接口是`_settings`(更新全部的索引)或`{index}/settings`,更新一个或者多个索引,`{index}`参数可以使用逗号进行分隔,更新设置API内容包含在的请求体中,例如:

    PUT /twitter/_settings
    {
        "index" : {
            "number_of_replicas" : 2
        }
    }

可以在[索引模块 index module](index-modules.html)中找到可以在动态索引上动态更新的每个索引设置的列表。 为了保持现有设置不被更新，可以将`preserve_existing`请求参数设置为`true`。

### 批量索引用法 Bulk Indexing Usage

例如，可以使用更新设置API动态更改索引，使其更适合批量索引，然后将其更改为更实时的索引状态。 批量索引开始之前，请使用：

    PUT /twitter/_settings
    {
        "index" : {
            "refresh_interval" : "-1"
        }
    }

（另一个优化选项是在没有任何副本的情况下启动索引，只在稍后添加它们，但这实际上取决于用例）。

然后，一旦批量索引完成，设置可以更新（例如回到默认值）：
    
    
    PUT /twitter/_settings
    {
        "index" : {
            "refresh_interval" : "1s"
        }
    }

而且，强制合并设置的请求为：    
    
    POST /twitter/_forcemerge?max_num_segments=5

### 更新索引分析器(添加) Updating Index Analysis

也可以为索引定义新的[分析器](analysis.html)。 但需要先[关闭](indices-open-close.html)索引，然后在更改之后[打开](indices-open-close.html)。

例如，如果“custom”分析器尚未在“myindex”上定义，您可以使用以下命令添加它：

    POST /twitter/_close
    
    PUT /twitter/_settings
    {
      "analysis" : {
        "analyzer":{
          "content":{
            "type":"custom",
            "tokenizer":"whitespace"
          }
        }
      }
    }
    
    POST /twitter/_open
