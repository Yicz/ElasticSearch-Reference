## Painless Debugging

![Warning](/images/icons/warning.png)

The Painless scripting language is new and is still marked as experimental. The syntax or API may be changed in the future in non-backwards compatible ways if required. 

### Debug.Explain

Painless doesn’t have a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) and while it’d be nice for it to have one one day, it wouldn’t tell you the whole story around debugging painless scripts embedded in Elasticsearch because the data that the scripts have access to or) to explore the context available to a [Script Query](query-dsl-script-query.html).
    
    
    PUT /hockey/player/1?refresh
    {"first":"johnny","last":"gaudreau","goals":[9,27,1],"assists":[17,46,0],"gp":[26,82,1]}
    
    POST /hockey/player/1/_explain
    {
      "query": {
        "script": {
          "script": "Debug.explain(doc.goals)"
        }
      }
    }

Which shows that the class of `doc.first` is `org.elasticsearch.index.fielddata.ScriptDocValues.Longs` by responding with:
    
    
    {
       "error": {
          "type": "script_exception",
          "to_string": "[1, 9, 27]",
          "painless_class": "org.elasticsearch.index.fielddata.ScriptDocValues.Longs",
          "java_class": "org.elasticsearch.index.fielddata.ScriptDocValues$Longs",
          ...
       },
       "status": 500
    }

You can use the same trick to see that `_source` is a `LinkedHashMap` in the `_update` API:
    
    
    POST /hockey/player/1/_update
    {
      "script": "Debug.explain(ctx._source)"
    }

The response looks like:
    
    
    {
      "error" : {
        "root_cause": ...,
        "type": "illegal_argument_exception",
        "reason": "failed to execute script",
        "caused_by": {
          "type": "script_exception",
          "to_string": "{gp=[26, 82, 1], last=gaudreau, assists=[17, 46, 0], first=johnny, goals=[9, 27, 1]}",
          "painless_class": "LinkedHashMap",
          "java_class": "java.util.LinkedHashMap",
          ...
        }
      },
      "status": 400
    }

Once you have a class you can go to [Appendix A, _Painless API Reference_](painless-api-reference.html) to see a list of available methods.
