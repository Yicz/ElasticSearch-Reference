## 覆盖默认模板 Override default template

You can override the default mappings for all indices and all types by specifying a `_default_` type mapping in an index template which matches all indices.

For example, to disable the `_all` field by default for all types in all new indices, you could create the following index template:
    
    
    PUT _template/disable_all_field
    {
      "order": 0,
      "template": "*", <1>
      "mappings": {
        "_default_": { <2>
          "_all": { <3>
            "enabled": false
          }
        }
      }
    }

<1>| Applies the mappings to an `index` which matches the pattern `*`, in other words, all new indices.     
---|---    <2>| Defines the `_default_` type mapping types within the index.     
<3>| Disables the `_all` field by default. 
