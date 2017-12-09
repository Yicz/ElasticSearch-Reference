## 执行查询

现在我们对查询参数有了一个基本的了解，让我们更加深入挖掘Query DSL。我们先来看查询的返回结果的字段。默认地，整个文档会当作查询结果的一部分返回。可以参考`_source`字段，如果我们不想返回整个JSON文档的所有字段。我们可以请求设置一部分字段进行返回。

下面的查询例子，展示了只返回文档的两个字段，`account_number`和`balance`(在`_source`部分)：
    
    GET /bank/_search
    {
      "query": { "match_all": {} },
      "_source": ["account_number", "balance"]
    }

提示：在上面的例子中减少了`_source`字段的返回内容。但它仍然会内置地返回一个命名为`_source`的字段去包含返回结果。将`account_number`和`balancd`进行囊括。

如果你学习过SQL，上面的例子类似于`SQL SELECT FROM`语句。

现在让我们继续学习query部分的内容。在前面，我们展示使用了`match_all`查询条件去匹配所有的文档。现在我们介绍一个新的查询：[`match`查询](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-match-query.html)，这是一个基本的字段查询（例如：通过指定一个字段或者多个字段进行匹配查询）

下面的例子是匹配account_number=20:
    
    GET /bank/_search
    {
      "query": { "match": { "account_number": 20 } }
    }

下面的例子匹配address中包含了mill的文档：
    
    GET /bank/_search
    {
      "query": { "match": { "address": "mill" } }
    }

下面的例子匹配address中包含了mill或者lane的文档
    
    GET /bank/_search
    {
      "query": { "match": { "address": "mill lane" } }
    }

下面的例子是词组匹配（`match_phrase`）,返回的文档必须完全匹配"mill land":
    
    GET /bank/_search
    {
      "query": { "match_phrase": { "address": "mill lane" } }
    }

现在我们来介绍[bool(布隆|Boolean)查询](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-bool-query.html),bool查询使用boolean逻辑允许组合小查询（如上面）成为一个大的查询条件。

下面的例子组合了两个`match`查询并返回了文档的address字段中包含"mill"和“lane”的所有文档：
    
    GET /bank/_search
    {
      "query": {
        "bool": {
          "must": [
            { "match": { "address": "mill" } },
            { "match": { "address": "lane" } }
          ]
        }
      }
    }

在上面的例子中 `bool.must`子句指定了所有的查询条件必须为true，才认为这个文档匹配了。

对比上面的，下面的例子是组合两个`match`查询并返回address字段包含“mill”或“lane”的文档。：
    
    GET /bank/_search
    {
      "query": {
        "bool": {
          "should": [
            { "match": { "address": "mill" } },
            { "match": { "address": "lane" } }
          ]
        }
      }
    }

在上面的例子中，`bool.should`子句指定了一系列的查询条件，只要文档满足了其中一条，就认为文档匹配了。


对比上面的，下面的例子是组合两个`match`查询并返回address字段**不包含**“mill”或“lane”的文档。：

    
    
    GET /bank/_search
    {
      "query": {
        "bool": {
          "must_not": [
            { "match": { "address": "mill" } },
            { "match": { "address": "lane" } }
          ]
        }
      }
    }

在上面的例子中，`bool.must_not`子句指定了一系列的查询条件，只要文档不满足了所有条件，才认为文档匹配了。

我们还可以组合`must`,`should`和`must_not`子句成为一个`bool`查询。再者还可以组合一个`bool`查询成为一个大的`bool`查询，形成多层级的bool逻辑。

举例如下，匹配文档江西40岁并state=ID：    
    
    GET /bank/_search
    {
      "query": {
        "bool": {
          "must": [
            { "match": { "age": "40" } }
          ],
          "must_not": [
            { "match": { "state": "ID" } }
          ]
        }
      }
    }
