## `index_options`

`index_options`参数控制将什么信息添加到倒排索引中，以便搜索和高亮显示。 它接受以下值：

`docs`|只有文档编号被索引。可以回答这个问题_这个词是否存在于这个字段中？
---|---    
`freqs`| 文件编号和词条频率被编入索引。 词条频率被用来评分高于单个的重复词条。
`positions`| 文档编号，词条频率和词条位置（或顺序）被编入索引。 位置可用于[邻近词组查询 proximity orphrase queries](query-dsl-match-query-phrase.html).     
`offsets`| 文档编号，词条频率，位置和开始和结束字符偏移（将词条映射回原始字符串）进行索引。 偏移值由[postings高亮器 postings highlighter](search-request-highlighting.html#postings-highlighter)使用.   
  
[analysed](mapping-index.html)字符串字段使用`positions`作为默认值，其他所有字段都使用`docs`作为默认值。
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "text": {
              "type": "text",
              "index_options": "offsets"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "text": "Quick brown fox"
    }
    
    GET my_index/_search
    {
      "query": {
        "match": {
          "text": "brown fox"
        }
      },
      "highlight": {
        "fields": {
          "text": {} <1>
        }
      }
    }

<1>| 默认情况下，`text`字段将使用postings高亮器，因为`offsets`是在映射关系中被指定。 
---|---
