## Explain Analyze

If you want to get more advanced details, set `explain` to `true` (defaults to `false`). It will output all token attributes for each token. You can filter token attributes you want to output by setting `attributes` option.

![Warning](/images/icons/warning.png)

The format of the additional detail information is experimental and can change at any time 
    
    
    GET _analyze
    {
      "tokenizer" : "standard",
      "filter" : ["snowball"],
      "text" : "detailed output",
      "explain" : true,
      "attributes" : ["keyword"] <1>
    }

<1>| Set "keyword" to output "keyword" attribute only     
---|---  
  
The request returns the following result:
    
    
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

<1> <2>

| 

Output only "keyword" attribute, since specify "attributes" in the request.   
  
---|---
