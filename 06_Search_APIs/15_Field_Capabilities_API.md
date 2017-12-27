## Field Capabilities API

![Warning](/images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

The field capabilities API allows to retrieve the capabilities of fields among multiple indices.

The field capabilities api by default executes on all indices:
    
    
    GET _field_caps?fields=rating

  1. but the request can also be restricted to specific indices: 


    
    
    GET twitter/_field_caps?fields=rating

Alternatively the `fields` option can also be defined in the request body:
    
    
    POST _field_caps
    {
       "fields" : ["rating"]
    }

This is equivalent to the previous request.

Supported request options:

`fields`| A list of fields to compute stats for. The field name supports wildcard notation. For example, using `text_*` will cause all fields that match the expression to be returned.     
---|---   
`searchable`| Whether this field is indexed for search on all indices.     ---|---    
`aggregatable`| Whether this field can be aggregated on all indices.     
`indices`| The list of indices where this field has the same type, or null if all indices have the same type for the field.     
`non_searchable_indices`| The list of indices where this field is not searchable, or null if all indices have the same definition for the field.     
`non_aggregatable_indices`| The list of indices where this field is not aggregatable, or null if all indices have the same definition for the field.   
  
### Response format

Request:
    
    
    GET _field_caps?fields=rating,title
    
    
    {
        "fields": {
            "rating": { <1>
                "long": {
                    "searchable": true,
                    "aggregatable": false,
                    "indices": ["index1", "index2"],
                    "non_aggregatable_indices": ["index1"] <2>
                },
                "keyword": {
                    "searchable": false,
                    "aggregatable": true,
                    "indices": ["index3", "index4"],
                    "non_searchable_indices": ["index4"] <3>
                }
            },
            "title": { <4>
                "text": {
                    "searchable": true,
                    "aggregatable": false
    
                }
            }
        }
    }

<1>| The field `rating` is defined as a long in `index1` and `index2` and as a `keyword` in `index3` and `index4`.     
---|---    
<2>| The field `rating` is not aggregatable in `index1`.     
<3>| The field `rating` is not searchable in `index4`.     
<4>| The field `title` is defined as `text` in all indices. 
