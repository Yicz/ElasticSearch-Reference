# 分词 Analysis

分词是转换文本的过程，就如任何的邮件（email）的内容都会分词成具体的 _符号(tokens)_ 或 _项(terms)_ 以方便可以索引可以被倒序查找。 分词要要求有一个[分词器_analyzer_](analysis-analyzers.html),可以使用内置的分词器，也可以[自定义分词器](analysis-custom-analyzer.html) 。

## 索引时分析

例如，在索引时，内置的[`english _分词器_`](analysis-lang-analyzer.html＃english-analyzer) 将会转换这个句子：
    
    "The QUICK brown foxes jumped over the lazy dog!"

变成具体的项（terms）或者符号（tokens），这将被添加到倒排索引。
    
    [ quick, brown, fox, jump, over, lazi, dog ]

### 指定一个索引的分词器

每一个[`text`](text.html) 类型的字段要在映射关系（mapping）中指定自己使用的[分词器 `analyzer`](analyzer.html):
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "title": {
              "type":     "text",
              "analyzer": "standard"
            }
          }
        }
      }
    }

在进行索引时，如果没有指定一个分词器，ES会查找一个`默认 defalut`的分词器。缺省的分词器是[`标准 standard` 分词器](analysis-standard-analyzer.html).

## 查询时分析

ES进行[全文查询 `full text queries`](full-text-queries.html)的时候也会到分词,如[`匹配 match` 查询](query-dsl-match-query.html) 会转换文档成索引时分成的具体的项（term）

例如，一个查询内容:
    
    "a quick fox"

如果使用的`english` 分词器 ,会分成如下具体的项：
    
    [ quick, fox ]

即使查询字符串中使用的确切单词不出现在原始文本（如`确切词`vs`原始文本` `quick` vs`QUICK`，`fox` vs`foxes`）中，因为我们已经将相同的分析器应用于文本和查询 字符串，查询字符串中的术语与倒排索引中的文本中的术语完全匹配，这意味着此查询将匹配我们的示例文档。


### 指定一个查询分词器

通常应该在索引时和搜索时使用相同的分析器，并使用[全文查询](full-text-queries.html)，如[match match query](query-dsl-match-query.html)将使用映射关系来查找每个字段使用的分析器。

用于搜索特定字段的分析器是通过查找：

  * 在查询体或查询字符串中指定一个分词器
  * [`search_analyzer`](search-analyzer.html)的映射参数. 
  * [`analyzer`](analyzer.html)映射参数. 
  * 索引指定的默认分词器 `default_search`. 
  * 在索引设置中的默认的分词器 `default`. 
  * `标准 standard` 分词器. 


