## 模板查询 Template Query

![Warning](/images/icons/warning.png)

### Deprecated in 5.0.0. 

Use the [_Search Template_](search-template.html) API 

A query that accepts a query template and a map of key/value pairs to fill in template parameters. Templating is based on Mustache. For simple token substitution all you provide is a query containing some variable that you want to substitute and the actual values:
    
    
    GET /_search
    {
        "query": {
            "template": {
                "inline": { "match": { "text": "{ {query_string} }" } },
                "params" : {
                    "query_string" : "all about search"
                }
            }
        }
    }

The above request is translated into:
    
    
    GET /_search
    {
        "query": {
            "match": {
                "text": "all about search"
            }
        }
    }

Alternatively passing the template as an escaped string works as well:
    
    
    GET /_search
    {
        "query": {
            "template": {
                "inline": "{ \"match\": { \"text\": \"{ {query_string} }\" } }", <1>
                "params" : {
                    "query_string" : "all about search"
                }
            }
        }
    }

<1>| New line characters (`\n`) should be escaped as `\\n` or removed, and quotes (`"`) should be escaped as `\\"`.     
---|---  
  
### Stored templates

You can register a template by storing it in the `config/scripts` directory, in a file using the `.mustache` extension. In order to execute the stored template, reference it by name in the `file` parameter:
    
    
    GET /_search
    {
        "query": {
            "template": {
                "file": "my_template", <1>
                "params" : {
                    "query_string" : "all about search"
                }
            }
        }
    }

<1>| Name of the query template in `config/scripts/`, i.e., `my_template.mustache`.     
---|---  
  
Alternatively, you can register a query template in the cluster state with:
    
    
    PUT /_search/template/my_template
    {
        "template": { "match": { "text": "{ {query_string} }" } }
    }

and refer to it in the `template` query with the `id` parameter:
    
    
    GET /_search
    {
        "query": {
            "template": {
                "stored": "my_template", <1>
                "params" : {
                    "query_string" : "all about search"
                }
            }
        }
    }

<1>| Name of the query template in `config/scripts/`, i.e., `my_template.mustache`.     
---|---  
  
There is also a dedicated `template` endpoint, allows you to template an entire search request. Please see [_Search Template_](search-template.html) for more details.
