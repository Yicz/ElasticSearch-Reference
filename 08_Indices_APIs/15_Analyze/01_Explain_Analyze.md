##  分析说明 Explain Analyze

如果想获得更加多的信息，可以通过设置`explain=true`(默认是`false`),将会输出更多每个符号的更多属性，同时你还可以通过设置`attributes`进行过滤这些符号的属性。

![Warning](/images/icons/warning.png) 额外信息的内容格式是体验属性的，在未来任何时间都可能会做出变更。 
    
    
    GET _analyze
    {
      "tokenizer" : "standard",
      "filter" : ["snowball"],
      "text" : "detailed output",
      "explain" : true,
      "attributes" : ["keyword"] <1>
    }

<1>| 限制了只输出`keyword`属性   
---|---  
  
响应内容如下：
    
    {
      "detail" : {
        "custom_analyzer" : true,
        "charfilters" : [ ],
        "tokenizer" : {
          "name" : "standard",
          "tokens" : [ {
            "token" : "detailed",
            "start_offset" : 0,
            "end_offset" : 8,
            "type" : "<ALPHANUM>",
            "position" : 0
          }, {
            "token" : "output",
            "start_offset" : 9,
            "end_offset" : 15,
            "type" : "<ALPHANUM>",
            "position" : 1
          } ]
        },
        "tokenfilters" : [ {
          "name" : "snowball",
          "tokens" : [ {
            "token" : "detail",
            "start_offset" : 0,
            "end_offset" : 8,
            "type" : "<ALPHANUM>",
            "position" : 0,
            "keyword" : false <1>
          }, {
            "token" : "output",
            "start_offset" : 9,
            "end_offset" : 15,
            "type" : "<ALPHANUM>",
            "position" : 1,
            "keyword" : false <2>
          } ]
        } ]
      }
    }

<1> <2>| 因为请求指定了只输出`keyword`属性，所以响应内容只有`keyword`的说明信息。
---|---
