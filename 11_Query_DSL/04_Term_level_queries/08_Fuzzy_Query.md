##  模糊查询 Fuzzy Query

模糊查询使用基于Levenshtein编辑距离(Levenshtein edit distance)的相似度。

### 字符查询 String fields

The `fuzzy` query generates all possible matching terms that are within the maximum edit distance specified in `fuzziness` and then checks the term dictionary to find out which of those generated terms actually exist in the index.

下面是一个简单的例子:
    
    
    GET /_search
    {
        "query": {
           "fuzzy" : { "user" : "ki" }
        }
    }

或者有参数高级用法:
    
    
    GET /_search
    {
        "query": {
            "fuzzy" : {
                "user" : {
                    "value" :         "ki",
                        "boost" :         1.0,
                        "fuzziness" :     2,
                        "prefix_length" : 0,
                        "max_expansions": 100
                }
            }
        }
    }

##### 参数 Parameters

`fuzziness`| 最大编辑距离，默认`AUTO`    
---|---    
`prefix_length`| 不会被“模糊化”的初始字符的数量。 这有助于减少必须检查的术语数量。 默认为“0”。    
`max_expansions`| “模糊”查询将扩展到的最大条数。 默认为`50`。  
  
![Warning](/images/icons/warning.png)

如果`prefix_length`设置为'0'并且'max_expansions`设置为一个较高的数字，这个查询可能非常重。 这可能会导致索引中的每个词条都被检查！
