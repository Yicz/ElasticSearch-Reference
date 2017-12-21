## Search Template

The `/_search/template` endpoint allows to use the mustache language to pre render search requests, before they are executed and fill existing templates with template parameters.
    
    
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

For more information on how Mustache templating and what kind of templating you can do with it check out the [online documentation of the mustache project](http://mustache.github.io/mustache.5.html).

![Note](images/icons/note.png)

The mustache language is implemented in elasticsearch as a sandboxed scripting language, hence it obeys settings that may be used to enable or disable scripts per language, source and operation as described in the [scripting docs](modules-scripting-security.html#security-script-source "Script source settingsedit")

#### More template examples

##### Filling in a query string with a single value
    
    
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

##### Converting parameters to JSON

The `{ {#toJson} }parameter{ {/toJson} }` function can be used to convert parameters like maps and array to their JSON representation:
    
    
    GET _search/template
    {
      "inline": "{ \"query\": { \"terms\": { {#toJson} }statuses{ {/toJson} } } }",
      "params": {
        "statuses" : {
            "status": [ "pending", "published" ]
        }
      }
    }

which is rendered as:
    
    
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

A more complex example substitutes an array of JSON objects:
    
    
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

which is rendered as:
    
    
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

##### Concatenating array of values

The `{ {#join} }array{ {/join} }` function can be used to concatenate the values of an array as a comma delimited string:
    
    
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

which is rendered as:
    
    
    {
        "query" : {
            "match" : {
                "emails" : "username@email.com,lastname@email.com"
            }
        }
    }

The function also accepts a custom delimiter:
    
    
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

which is rendered as:
    
    
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

##### Default values

A default value is written as `{ {var} }{ {^var} }default{ {/var} }` for instance:
    
    
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

When `params` is `{ "start": 10, "end": 15 }` this query would be rendered as:
    
    
    {
        "range": {
            "line_no": {
                "gte": "10",
                "lte": "15"
            }
      }
    }

But when `params` is `{ "start": 10 }` this query would use the default value for `end`:
    
    
    {
        "range": {
            "line_no": {
                "gte": "10",
                "lte": "20"
            }
        }
    }

##### Conditional clauses

Conditional clauses cannot be expressed using the JSON form of the template. Instead, the template **must** be passed as a string. For instance, let’s say we wanted to run a `match` query on the `line` field, and optionally wanted to filter by line numbers, where `start` and `end` are optional.

The `params` would look like:
    
    
    {
        "params": {
            "text":      "words to search for",
            "line_no": { ![](images/icons/callouts/1.png)
                "start": 10, ![](images/icons/callouts/2.png)
                "end":   20  ![](images/icons/callouts/3.png)
            }
        }
    }

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png) ![](images/icons/callouts/3.png)

| 

All three of these elements are optional.   
  
---|---  
  
We could write the query as:
    
    
    {
      "query": {
        "bool": {
          "must": {
            "match": {
              "line": "{ {text} }" ![](images/icons/callouts/1.png)
            }
          },
          "filter": {
            { {#line_no} } ![](images/icons/callouts/2.png)
              "range": {
                "line_no": {
                  { {#start} } ![](images/icons/callouts/3.png)
                    "gte": "{ {start} }" ![](images/icons/callouts/4.png)
                    { {#end} },{ {/end} } ![](images/icons/callouts/5.png)
                  { {/start} } ![](images/icons/callouts/6.png)
                  { {#end} } ![](images/icons/callouts/7.png)
                    "lte": "{ {end} }" ![](images/icons/callouts/8.png)
                  { {/end} } ![](images/icons/callouts/9.png)
                }
              }
            { {/line_no} } ![](images/icons/callouts/10.png)
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Fill in the value of param `text`  
  
---|---  
  
![](images/icons/callouts/2.png) ![](images/icons/callouts/10.png)

| 

Include the `range` filter only if `line_no` is specified   
  
![](images/icons/callouts/3.png) ![](images/icons/callouts/6.png)

| 

Include the `gte` clause only if `line_no.start` is specified   
  
![](images/icons/callouts/4.png)

| 

Fill in the value of param `line_no.start`  
  
![](images/icons/callouts/5.png)

| 

Add a comma after the `gte` clause only if `line_no.start` AND `line_no.end` are specified   
  
![](images/icons/callouts/7.png) ![](images/icons/callouts/9.png)

| 

Include the `lte` clause only if `line_no.end` is specified   
  
![](images/icons/callouts/8.png)

| 

Fill in the value of param `line_no.end`  
  
![Note](images/icons/note.png)

As written above, this template is not valid JSON because it includes the _div_ markers like `{ {#line_no} }`. For this reason, the template should either be stored in a file (see [Pre-registered template or, when used via the REST API, should be written as a string:
    
    
    "inline": "{\"query\":{\"bool\":{\"must\":{\"match\":{\"line\":\"{ {text} }\"} },\"filter\":{ { {#line_no} }\"range\":{\"line_no\":{ { {#start} }\"gte\":\"{ {start} }\"{ {#end} },{ {/end} }{ {/start} }{ {#end} }\"lte\":\"{ {end} }\"{ {/end} } } }{ {/line_no} } } } } }"

##### Encoding URLs

The `{ {#url} }value{ {/url} }` function can be used to encode a string value in a HTML encoding form as defined in by the [HTML specification](http://www.w3.org/TR/html4/).

As an example, it is useful to encode a URL:
    
    
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

The previous query will be rendered as:
    
    
    {
        "template_output" : {
            "query" : {
                "term" : {
                    "http_access_log" : "https%3A%2F%2Fwww.elastic.co%2F%2Flearn"
                }
            }
        }
    }

##### Pre-registered template

You can register search templates by storing it in the `config/scripts` directory, in a file using the `.mustache` extension. In order to execute the stored template, reference it by it’s name under the `template` key:
    
    
    GET _search/template
    {
        "file": "storedTemplate", ![](images/icons/callouts/1.png)
        "params": {
            "query_string": "search for these words"
        }
    }

![](images/icons/callouts/1.png)

| 

Name of the query template in `config/scripts/`, i.e., `storedTemplate.mustache`.   
  
---|---  
  
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

This template can be retrieved by
    
    
    GET _search/template/<templatename>

which is rendered as:
    
    
    {
        "_id" : "<templatename>",
        "lang" : "mustache",
        "found" : true,
        "template" : "{\"query\":{\"match\":{\"title\":\"{ {query_string} }\"} } }"
    }

This template can be deleted by
    
    
    DELETE _search/template/<templatename>

To use an indexed template at search time use:
    
    
    GET _search/template
    {
        "id": "<templateName>", ![](images/icons/callouts/1.png)
        "params": {
            "query_string": "search for these words"
        }
    }

![](images/icons/callouts/1.png)

| 

Name of the query template stored in the `.scripts` index.   
  
---|---  
  
#### Validating templates

A template can be rendered in a response with given parameters using
    
    
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
            "status": [ ![](images/icons/callouts/1.png)
              "pending",
              "published"
            ]
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

`status` array has been populated with values from the `params` object.   
  
---|---  
  
File and indexed templates can also be rendered by replacing `inline` with `file` or `id` respectively. For example, to render a file template
    
    
    GET _render/template
    {
      "file": "my_template",
      "params": {
        "status": [ "pending", "published" ]
      }
    }

Pre-registered templates can also be rendered using
    
    
    GET _render/template/<template_name>
    {
      "params": {
        "..."
      }
    }

##### Explain

You can use `explain` parameter when running a template:
    
    
    GET _search/template
    {
      "file": "my_template",
      "params": {
        "status": [ "pending", "published" ]
      },
      "explain": true
    }

##### Profiling

You can use `profile` parameter when running a template:
    
    
    GET _search/template
    {
      "file": "my_template",
      "params": {
        "status": [ "pending", "published" ]
      },
      "profile": true
    }
