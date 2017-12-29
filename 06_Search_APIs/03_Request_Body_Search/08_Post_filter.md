## 后过滤器 Post filter

已经计算了聚合之后，`post_filter`应用于搜索请求最后的搜索`hits`。 其目的最好的例子是：

想象一下，你正在销售具有以下属性的衬衫：
    
    
    PUT /shirts
    {
        "mappings": {
            "item": {
                "properties": {
                    "brand": { "type": "keyword"},
                    "color": { "type": "keyword"},
                    "model": { "type": "keyword"}
                }
            }
        }
    }
    
    PUT /shirts/item/1?refresh
    {
        "brand": "gucci",
        "color": "red",
        "model": "slim"
    }

设想一个用户已经指定了两个过滤器：

`color:red` and `brand:gucci`. 

你只想让他们在搜索结果中显示由Gucci制作的红色衬衫。 通常你可以用[`bool` query](query-dsl-bool-query.html)来做到这一点：
    
    
    GET /shirts/_search
    {
      "query": {
        "bool": {
          "filter": [
            { "term": { "color": "red"   } },
            { "term": { "brand": "gucci" } }
          ]
        }
      }
    }

但是，您也想使用_面对面导航_来显示用户可以点击的其他选项列表。 也许你有一个`model`字段，可以让用户将他们的搜索结果限制在红色的古驰"T恤"或"礼服衬衫"上。

这可以通过[`terms` aggregation](search-aggregations-bucket-terms-aggregation.html)来完成：
    
    
    GET /shirts/_search
    {
      "query": {
        "bool": {
          "filter": [
            { "term": { "color": "red"   } },
            { "term": { "brand": "gucci" } }
          ]
        }
      },
      "aggs": {
        "models": {
          "terms": { "field": "model" } <1>
        }
      }
    }

<1>| 返回Gucci最受欢迎的红色衬衫款式。     
---|---  

但也许你也想告诉用户有多少种古奇衬衫可以用**其他颜色**。 如果你只是在`color`字段上添加`terms`聚合，你只会回到`red`颜色，因为你的查询只返回Gucci的红色衬衫。

相反，您希望在聚合过程中包括所有颜色的衬衫，然后仅将“颜色”过滤器应用于搜索结果。 这是`post_filter`的目的：
    
    
    GET /shirts/_search
    {
      "query": {
        "bool": {
          "filter": {
            "term": { "brand": "gucci" } <1>
          }
        }
      },
      "aggs": {
        "colors": {
          "terms": { "field": "color" } <2>
        },
        "color_red": {
          "filter": {
            "term": { "color": "red" } <3>
          },
          "aggs": {
            "models": {
              "terms": { "field": "model" } <4>
            }
          }
        }
      },
      "post_filter": { <5>
        "term": { "color": "red" }
      }
    }

<1>| 主查询现在可以找到所有Gucci衬衫，不管颜色。     
---|---    
<2>| `color`聚合返回Gucci的颜色。    
<3> <4>| `color_red` agg将`models`子集合限制为** red ** Gucci衬衫。     
<5>| 最后，`post_filter`从搜索结果中删除除红色以外的颜色。
