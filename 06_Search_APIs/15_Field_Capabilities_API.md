## Field Capabilities API

![Warning](images/icons/warning.png)

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

`fields`

| 

A list of fields to compute stats for. The field name supports wildcard notation. For example, using `text_*` will cause all fields that match the expression to be returned.   
  
---|---  
  
### Field Capabilities

The field capabilities api returns the following information per field:

`searchable`

| 

Whether this field is indexed for search on all indices.   
  
---|---  
  
`aggregatable`

| 

Whether this field can be aggregated on all indices.   
  
`indices`

| 

The list of indices where this field has the same type, or null if all indices have the same type for the field.   
  
`non_searchable_indices`

| 

The list of indices where this field is not searchable, or null if all indices have the same definition for the field.   
  
`non_aggregatable_indices`

| 

The list of indices where this field is not aggregatable, or null if all indices have the same definition for the field.   
  
### Response format

Request:
    
    
    GET _field_caps?fields=rating,title
    
    
    {
        "fields": {
            "rating": { ![](images/icons/callouts/1.png)
                "long": {
                    "searchable": true,
                    "aggregatable": false,
                    "indices": ["index1", "index2"],
                    "non_aggregatable_indices": ["index1"] ![](images/icons/callouts/2.png)
                },
                "keyword": {
                    "searchable": false,
                    "aggregatable": true,
                    "indices": ["index3", "index4"],
                    "non_searchable_indices": ["index4"] ![](images/icons/callouts/3.png)
                }
            },
            "title": { ![](images/icons/callouts/4.png)
                "text": {
                    "searchable": true,
                    "aggregatable": false
    
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

The field `rating` is defined as a long in `index1` and `index2` and as a `keyword` in `index3` and `index4`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The field `rating` is not aggregatable in `index1`.   
  
![](images/icons/callouts/3.png)

| 

The field `rating` is not searchable in `index4`.   
  
![](images/icons/callouts/4.png)

| 

The field `title` is defined as `text` in all indices. 
