## 脚本字段 Script Fields

允许为每个匹配返回一个[脚本计算结果](modules-scripting.html)（基于不同的字段），例如：
    
    
    GET /_search
    {
        "query" : {
            "match_all": {}
        },
        "script_fields" : {
            "test1" : {
                "script" : {
                    "lang": "painless",
                    "inline": "doc['my_field_name'].value * 2"
                }
            },
            "test2" : {
                "script" : {
                    "lang": "painless",
                    "inline": "doc['my_field_name'].value * factor",
                    "params" : {
                        "factor"  : 2.0
                    }
                }
            }
        }
    }

脚本字段可以在未存储的字段上工作（在上面的例子中是`my_field_name`），并允许返回自定义值（脚本的计算结果）。


脚本字段也可以通过使用`params ['_source']`来访问实际的`_source`文件并从中提取特定的元素。 这里是一个例子：
    
    
    GET /_search
        {
            "query" : {
                "match_all": {}
            },
            "script_fields" : {
                "test1" : {
                    "script" : "params['_source']['message']"
                }
            }
        }

请注意`_source`关键字在这里代表类似json的模型。

理解`doc ['my_field'] .value`和`params ['_ source'] ['my_field']`之间的区别是很重要的。 首先，使用`doc`关键字，将导致该字段的条件被加载到内存（缓存），这将导致更多的内存消耗，但更快的执行。 此外，`doc`符号只允许简单值（不能从它返回一个json对象），只有在非分析或单一项的基本字段是有意义的。 然而，如果可能的话，使用`doc`仍然是从文档中访问值的推荐方式，因为每次使用`_source`时必须加载和解析。 使用`_source`非常慢。
