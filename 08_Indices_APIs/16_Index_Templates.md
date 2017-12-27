## Index Templates

Index templates allow you to define templates that will automatically be applied when new indices are created. The templates include both settings and mappings, and a simple pattern template that controls whether the template should be applied to the new index.

![Note](/images/icons/note.png)

Templates are only applied at index creation time. Changing a template will have no impact on existing indices.

For example:
    
    
    PUT _template/template_1
    {
      "template": "te*",
      "settings": {
        "number_of_shards": 1
      },
      "mappings": {
        "type1": {
          "_source": {
            "enabled": false
          },
          "properties": {
            "host_name": {
              "type": "keyword"
            },
            "created_at": {
              "type": "date",
              "format": "EEE MMM dd HH:mm:ss Z YYYY"
            }
          }
        }
      }
    }

![Note](/images/icons/note.png)

Index templates provide C-style /* */ block comments. Comments are allowed everywhere in the JSON document except before the initial opening curly bracket.

Defines a template named `template_1`, with a template pattern of `te*`. The settings and mappings will be applied to any index name that matches the `te*` pattern.

It is also possible to include aliases in an index template as follows:
    
    
    PUT _template/template_1
    {
        "template" : "te*",
        "settings" : {
            "number_of_shards" : 1
        },
        "aliases" : {
            "alias1" : {},
            "alias2" : {
                "filter" : {
                    "term" : {"user" : "kimchy" }
                },
                "routing" : "kimchy"
            },
            "{index}-alias" : {} <1>
        }
    }

<1>| the `{index}` placeholder in the alias name will be replaced with the actual index name that the template gets applied to, during index creation.     
---|---  
  
### Deleting a Template

Index templates are identified by a name (in the above case `template_1`) and can be deleted as well:
    
    
    DELETE /_template/template_1

### Getting templates

Index templates are identified by a name (in the above case `template_1`) and can be retrieved using the following:
    
    
    GET /_template/template_1

You can also match several templates by using wildcards like:
    
    
    GET /_template/temp*
    GET /_template/template_1,template_2

To get list of all index templates you can run:
    
    
    GET /_template

### Template exists

Used to check if the template exists or not. For example:
    
    
    HEAD _template/template_1

The HTTP status code indicates if the template with the given name exists or not. Status code `200` means it exists and `404` means it does not.

### Multiple Templates Matching

Multiple index templates can potentially match an index, in this case, both the settings and mappings are merged into the final configuration of the index. The order of the merging can be controlled using the `order` parameter, with lower order being applied first, and higher orders overriding them. For example:
    
    
    PUT /_template/template_1
    {
        "template" : "*",
        "order" : 0,
        "settings" : {
            "number_of_shards" : 1
        },
        "mappings" : {
            "type1" : {
                "_source" : { "enabled" : false }
            }
        }
    }
    
    PUT /_template/template_2
    {
        "template" : "te*",
        "order" : 1,
        "settings" : {
            "number_of_shards" : 1
        },
        "mappings" : {
            "type1" : {
                "_source" : { "enabled" : true }
            }
        }
    }

The above will disable storing the `_source` on all `type1` types, but for indices that start with `te*`, `_source` will still be enabled. Note, for mappings, the merging is "deep", meaning that specific object/property based mappings can easily be added/overridden on higher order templates, with lower order templates providing the basis.

### Template Versioning

Templates can optionally add a `version` number, which can be any integer value, in order to simplify template management by external systems. The `version` field is completely optional and it is meant solely for external management of templates. To unset a `version`, simply replace the template without specifying one.
    
    
    PUT /_template/template_1
    {
        "template" : "*",
        "order" : 0,
        "settings" : {
            "number_of_shards" : 1
        },
        "version": 123
    }

To check the `version`, you can [filter responses](common-options.html#common-options-response-filtering) using `filter_path` to limit the response to just the `version`:
    
    
    GET /_template/template_1?filter_path=*.version

This should give a small response that makes it both easy and inexpensive to parse:
    
    
    {
      "template_1" : {
        "version" : 123
      }
    }
