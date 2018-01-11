## 查询和过滤上下文 Query and filter context

查询语句的行为依赖于它是否使用了`查询上下文（query context）`和`过滤上下文(filter context)`


### 查询上下文 Query context 
    
使用了`查询上下文（query context）`的语句，像是回答`文档是否匹配条件以及匹配的相关程度是多少？`，即除了查询文档是否匹配之外还会根据`_score`字段计算文档的匹配相关度。

使用`查询上下文（query context）`是通过在`query`参数中传递一个查询语句，类似[`search`](search-request-query.html) API使用的`query`参数。


### 过滤器上下文 Filter context 
    
在过滤器的上下文中，一个查询就像是回答`文档是否匹配条件`,只是简单地回复是或否，不用计算相关度的分数。滤过上下文大多数使用于过滤结构性的数据，例如：

  * 过滤`timestamp` 在 2015 到 2016 范围?_
  * 状态`status` 字段是否是 `"published"`? 

常用的滤过器ES会自动进行缓存进而提升性能。

使用过滤器上下文是通过`filter`参数下设置参数，就像在[`bool`](query-dsl-bool-query.html) 查询中的`filter`或`must_not`参数，[常量分数 `constant_score`](query-dsl-constant-score-query.html)查询中使用的`filter`和`filter`的聚合。

下面的例子是在`search`API使用查询和过滤上下文的例子，通过查询进行匹配限制条件：

  *  `title` 字段包含 `search`. 
  *  `content` 字段包含 `elasticsearch`. 
  *  `status` 字段包含 `published`. 
  *  `publish_date` 是2015-01-01后的日期


    
    
    GET /_search
    {
      "query": { <1>
        "bool": { <2>
          "must": [
            { "match": { "title":   "Search"        } }, <3>
            { "match": { "content": "Elasticsearch" } }  <4>
          ],
          "filter": [ <5>
            { "term":  { "status": "published" } }, <6>
            { "range": { "publish_date": { "gte": "2015-01-01" } } } <7>
          ]
        }
      }
    }

<1>|`query` 指定查询上下文     
---|---    
<2> <3> <4>|  `bool` 和两个子句 `match` 包含在查询上来文中,意味着它们被来用计算文档相关度的分数.     
<5>| `filter` 参数指定过滤器上下文    
<6> <7>|  `term` 和 `range` 语句被包含在`filter`上下文中. 它们过滤不匹配的文档，但不会用于计算文档的相关度的分数。
  
![Tip](/images/icons/tip.png)
查询上下文中的查询子句，用于影响匹配文档分数的条件（即文档匹配程度如何），以及在过滤器上下文中使用所有其他查询子句。

