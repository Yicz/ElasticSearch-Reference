## 查询模板 Search Template

`/_search/template`API允许使用`mustache`语言预渲染搜索请求，然后执行它们，并使用模板参数填充现有的模板。
    
    
    GET _search/template
    {
        "inline" : {
          "query": { "match" : { "{ {my_field} }" : "{ {my_value} }" } },
          "size" : "{ {my_size} }"
        },
        "params" : {
            "my_field" : "message",
            "my_value" : "some message",
            "my_size" : 5
        }
    }

有关Mustache模板以及可以使用哪种模板的更多信息，请查看[Mustache项目的在线文档]（http://mustache.github.io/mustache.5.html）。

![Note](/images/icons/note.png)

Mustache语言是在elasticsearch中作为沙盒脚本语言实现的，因此它遵从[脚本文档](modules-scripting-security.html#security-script-source)中描述的可用于启用或禁用每种语言，源和操作的脚本的设置

####更多模板示例  More template examples

##### 用单个值填充查询字符串
    
    
    GET _search/template
    {
        "inline": {
            "query": {
                "term": {
                    "message": "{ {query_string} }"
                }
            }
        },
        "params": {
            "query_string": "search for these words"
        }
    }

##### 将参数转换为JSON

{{#toJson}}参数{{/ toJson}}函数可以用来将地图和数组等参数转换为JSON表示形式：
    
    GET _search/template
    {
      "inline": "{ \"query\": { \"terms\": { {#toJson} }statuses{ {/toJson} } } }",
      "params": {
        "statuses" : {
            "status": [ "pending", "published" ]
        }
      }
    }

这是呈现为:
    
    
    {
      "query": {
        "terms": {
          "status": [
            "pending",
            "published"
          ]
        }
      }
    }

一个更复杂的例子替代了一个JSON对象的数组:
    
    
    GET _search/template
    {
        "inline": "{\"query\":{\"bool\":{\"must\": { {#toJson} }clauses{ {/toJson} } } } }",
        "params": {
            "clauses": [
                { "term": { "user" : "foo" } },
                { "term": { "user" : "bar" } }
            ]
       }
    }

这是呈现为:
    
    
    {
        "query" : {
          "bool" : {
            "must" : [
              {
                "term" : {
                    "user" : "foo"
                }
              },
              {
                "term" : {
                    "user" : "bar"
                }
              }
            ]
          }
        }
    }

##### 连接值的数组

可以使用{{#join}}数组{{/ join}}函数将数组的值连接为逗号分隔的字符串：
    
    
    GET _search/template
    {
      "inline": {
        "query": {
          "match": {
            "emails": "{ {#join} }emails{ {/join} }"
          }
        }
      },
      "params": {
        "emails": [ "username@email.com", "lastname@email.com" ]
      }
    }

这是呈现为:
    
    
    {
        "query" : {
            "match" : {
                "emails" : "username@email.com,lastname@email.com"
            }
        }
    }

该功能也接受自定义分隔符:
    
    
    GET _search/template
    {
      "inline": {
        "query": {
          "range": {
            "born": {
                "gte"   : "{ {date.min} }",
                "lte"   : "{ {date.max} }",
                "format": "{ {#join delimiter='||'} }date.formats{ {/join delimiter='||'} }"
                }
          }
        }
      },
      "params": {
        "date": {
            "min": "2016",
            "max": "31/12/2017",
            "formats": ["dd/MM/yyyy", "yyyy"]
        }
      }
    }

这是呈现为:
    
    
    {
        "query" : {
          "range" : {
            "born" : {
              "gte" : "2016",
              "lte" : "31/12/2017",
              "format" : "dd/MM/yyyy||yyyy"
            }
          }
        }
    }

##### 默认值

例如，默认值写为“{ {var} } { {var} } default { {/ var} }”    
    
    {
      "inline": {
        "query": {
          "range": {
            "line_no": {
              "gte": "{ {start} }",
              "lte": "{ {end} }{ {^end} }20{ {/end} }"
            }
          }
        }
      },
      "params": { ... }
    }

当`params`是`{“start”：10，“end”：15}`时，这个查询将会被显示为：    
    
    {
        "range": {
            "line_no": {
                "gte": "10",
                "lte": "15"
            }
      }
    }

但是当`params`是`{“start”：10}`时，这个查询将使用`end`的默认值：    
    
    {
        "range": {
            "line_no": {
                "gte": "10",
                "lte": "20"
            }
        }
    }

##### 有条件的语句

条件子句不能使用模板的JSON形式表示。 相反，模板**必须**作为字符串传递。 例如，假设我们想要在`line`字段上运行`match`查询，并且可以根据行号进行过滤，其中`start`和`end`是可选的。

“params”看起来像：    
    
    {
        "params": {
            "text":      "words to search for",
            "line_no": { <1>
                "start": 10, <2>
                "end":   20  <3>
            }
        }
    }

<1> <2> <3>| 所有这三个元素都是可选的。  
---|---  
  
我们可以将查询写为：    
    
    {
      "query": {
        "bool": {
          "must": {
            "match": {
              "line": "{ {text} }" <1>
            }
          },
          "filter": {
            { {#line_no} } <2>
              "range": {
                "line_no": {
                  { {#start} } <3>
                    "gte": "{ {start} }" <4>
                    { {#end} },{ {/end} } <5>
                  { {/start} } <6>
                  { {#end} } <7>
                    "lte": "{ {end} }" <8>
                  { {/end} } <9>
                }
              }
            { {/line_no} } <10>
          }
        }
      }
    }

<1>| 填入参数“text”的值 
---|---    
<2> <10>| 只有在指定了`line_no`的情况下才加入`range`过滤器    
<3> <6>| 仅当指定了`line_no.start`时才包含`gte`子句    
<4>| 填入参数`line_no.start`的值    
<5>| 仅当指定了`line_no.start`和`line_no.end`时，才在`gte`子句后面加逗号     
<7> <9>| 仅当指定了`line_no.end`时才包含`lte`子句    
<8>| 填入参数`line_no.end`的值 
  
![Note](/images/icons/note.png)

如上所述，这个模板不是有效的JSON，因为它包含像`{ {＃line_no} }`这样的_div_标记。 出于这个原因，模板应该存储在一个文件中（参见[预先注册的模板])，或者当通过REST API使用时，应该写成一个字符串：
    
    "inline": "{\"query\":{\"bool\":{\"must\":{\"match\":{\"line\":\"{ {text} }\"} },\"filter\":{ { {#line_no} }\"range\":{\"line_no\":{ { {#start} }\"gte\":\"{ {start} }\"{ {#end} },{ {/end} }{ {/start} }{ {#end} }\"lte\":\"{ {end} }\"{ {/end} } } }{ {/line_no} } } } } }"

##### 编码URL

可以使用`{ {#url} }`值`{ {/url} }`函数对HTML编码形式的字符串值进行编码，如[HTML规范](http://www.w3.org/TR/HTML4/)。

作为一个例子，编码一个URL是很有用的：
    
    
    GET _render/template
    {
        "inline" : {
            "query" : {
                "term": {
                    "http_access_log": "{ {#url} }{ {host} }/{ {page} }{ {/url} }"
                }
            }
        },
        "params": {
            "host": "https://www.elastic.co/",
            "page": "learn"
        }
    }

查询将呈现为：
    
    
    {
        "template_output" : {
            "query" : {
                "term" : {
                    "http_access_log" : "https%3A%2F%2Fwww.elastic.co%2F%2Flearn"
                }
            }
        }
    }

##### 预先注册的模板 Pre-registered template

您可以将搜索模板存储在`config/scripts`目录中，使用`.mustache`扩展名注册到一个文件中。 为了执行存储的模板，请在`template`键下使用它的名字来引用它：
    
    
    GET _search/template
    {
        "file": "storedTemplate", <1>
        "params": {
            "query_string": "search for these words"
        }
    }

<1>| `config/scripts/`文档下查询模板的名称，即`storedTemplate.mustache`。     
---|---    

您还可以通过将搜索模板存储在群集中。 有REST API来管理这些索引模板。

You can also register search templates by storing it in the cluster state. There are REST APIs to manage these indexed templates.
    
    
    POST _search/template/<templatename>
    {
        "template": {
            "query": {
                "match": {
                    "title": "{ {query_string} }"
                }
            }
        }
    }

这个模板可以通过
    
    
    GET _search/template/<templatename>

这是呈现为:
    
    
    {
        "_id" : "<templatename>",
        "lang" : "mustache",
        "found" : true,
        "template" : "{\"query\":{\"match\":{\"title\":\"{ {query_string} }\"} } }"
    }

这个模板可以被删除
    
    
    DELETE _search/template/<templatename>

To use an indexed template at search time use:
    
    
    GET _search/template
    {
        "id": "<templateName>", <1>
        "params": {
            "query_string": "search for these words"
        }
    }

<1>| 存储在`.scripts`索引中的查询模板的名称。    
---|---  
  
#### 验证模板

模板可以使用给定的参数在响应中呈现    
    
    GET _render/template
    {
      "inline": "{ \"query\": { \"terms\": { {#toJson} }statuses{ {/toJson} } } }",
      "params": {
        "statuses" : {
            "status": [ "pending", "published" ]
        }
      }
    }

This call will return the rendered template:
    
    
    {
      "template_output": {
        "query": {
          "terms": {
            "status": [ <1>
              "pending",
              "published"
            ]
          }
        }
      }
    }

<1>| `status`数组已经用“params”对象的值填充。   
---|---  
  
文件和索引模板也可以通过分别用`file`或`id`替换`inline`来渲染。 例如，呈现文件模板
    
    
    GET _render/template
    {
      "file": "my_template",
      "params": {
        "status": [ "pending", "published" ]
      }
    }

预先注册的模板也可以使用渲染    
    
    GET _render/template/<template_name>
    {
      "params": {
        "..."
      }
    }

##### 说明 Explain

运行模板时可以使用`explain`参数：    
    
    GET _search/template
    {
      "file": "my_template",
      "params": {
        "status": [ "pending", "published" ]
      },
      "explain": true
    }

##### 剖析 profiling

运行模板时可以使用`profile`参数：    
    
    GET _search/template
    {
      "file": "my_template",
      "params": {
        "status": [ "pending", "published" ]
      },
      "profile": true
    }
