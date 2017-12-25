## Field stats API

![Warning](images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

![Warning](images/icons/warning.png)

### Deprecated in 5.4.0. 

`_field_stats` is deprecated, use `_field_caps` instead or run an min/max aggregation on the desired fields 

The field stats api allows one to find statistical properties of a field without executing a search, but looking up measurements that are natively available in the Lucene index. This can be useful to explore a dataset which you don’t know much about. For example, this allows creating a histogram aggregation with meaningful intervals based on the min/max range of values.

The field stats api by defaults executes on all indices, but can execute on specific indices too.

All indices:
    
    
    GET _field_stats?fields=rating

Specific indices:
    
    
    GET twitter/_field_stats?fields=rating

Supported request options:

`fields`| A list of fields to compute stats for. The field name supports wildcard notation. For example, using `text_*` will cause all fields that match the expression to be returned.     
---|---    
`level`| Defines if field stats should be returned on a per index level or on a cluster wide level. Valid values are `indices` and `cluster` (default).   
  
Alternatively the `fields` option can also be defined in the request body:
    
    
    POST _field_stats?level=indices
    {
       "fields" : ["rating"]
    }

This is equivalent to the previous request.

### Field statistics

The field stats api is supported on string based, number based and date based fields and can return the following statistics per field:

`max_doc`| The total number of documents.     
---|---    
`doc_count`| The number of documents that have at least one term for this field, or -1 if this measurement isn’t available on one or more shards.     
`density`| The percentage of documents that have at least one value for this field. This is a derived statistic and is based on the `max_doc` and `doc_count`.     
`sum_doc_freq`| The sum of each term’s document frequency in this field, or -1 if this measurement isn’t available on one or more shards. Document frequency is the number of documents containing a particular term.     
`sum_total_term_freq`| The sum of the term frequencies of all terms in this field across all documents, or -1 if this measurement isn’t available on one or more shards. Term frequency is the total number of occurrences of a term in a particular document and field.   
  
`is_searchable`

True if any of the instances of the field is searchable, false otherwise.

`is_aggregatable`

True if any of the instances of the field is aggregatable, false otherwise.

`min_value`
     The lowest value in the field. 
`min_value_as_string`
     The lowest value in the field represented in a displayable form. All fields, but string fields returns this. (since string fields, represent values already as strings) 
`max_value`
     The highest value in the field. 
`max_value_as_string`
     The highest value in the field represented in a displayable form. All fields, but string fields returns this. (since string fields, represent values already as strings) 

![Note](images/icons/note.png)

Documents marked as deleted (but not yet removed by the merge process) still affect all the mentioned statistics.

### Cluster level field statistics example

Request:
    
    
    GET _field_stats?fields=rating,answer_count,creation_date,display_name

Response:
    
    
    {
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "indices": {
          "_all": { ![](images/icons/callouts/1.png)
             "fields": {
                "creation_date": {
                   "max_doc": 1326564,
                   "doc_count": 564633,
                   "density": 42,
                   "sum_doc_freq": 2258532,
                   "sum_total_term_freq": -1,
                   "min_value": "2008-08-01T16:37:51.513Z",
                   "max_value": "2013-06-02T03:23:11.593Z",
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "display_name": {
                   "max_doc": 1326564,
                   "doc_count": 126741,
                   "density": 9,
                   "sum_doc_freq": 166535,
                   "sum_total_term_freq": 166616,
                   "min_value": "0",
                   "max_value": "정혜선",
                   "is_searchable": "true",
                   "is_aggregatable": "false"
                },
                "answer_count": {
                   "max_doc": 1326564,
                   "doc_count": 139885,
                   "density": 10,
                   "sum_doc_freq": 559540,
                   "sum_total_term_freq": -1,
                   "min_value": 0,
                   "max_value": 160,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "rating": {
                   "max_doc": 1326564,
                   "doc_count": 437892,
                   "density": 33,
                   "sum_doc_freq": 1751568,
                   "sum_total_term_freq": -1,
                   "min_value": -14,
                   "max_value": 1277,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                }
             }
          }
       }
    }

![](images/icons/callouts/1.png)

| 

The `_all` key indicates that it contains the field stats of all indices in the cluster.   
  
---|---  
  
![Note](images/icons/note.png)

When using the cluster level field statistics it is possible to have conflicts if the same field is used in different indices with incompatible types. For instance a field of type `long` is not compatible with a field of type `float` or `string`. A div named `conflicts` is added to the response if one or more conflicts are raised. It contains all the fields with conflicts and the reason of the incompatibility.
    
    
    {
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "indices": {
          "_all": {
             "fields": {
                "creation_date": {
                   "max_doc": 1326564,
                   "doc_count": 564633,
                   "density": 42,
                   "sum_doc_freq": 2258532,
                   "sum_total_term_freq": -1,
                   "min_value": "2008-08-01T16:37:51.513Z",
                   "max_value": "2013-06-02T03:23:11.593Z",
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                }
             }
          }
       },
       "conflicts": {
            "field_name_in_conflict1": "reason1",
            "field_name_in_conflict2": "reason2"
       }
    }

#### Indices level field statistics example

Request:
    
    
    GET _field_stats?fields=rating,answer_count,creation_date,display_name&level=indices

Response:
    
    
    {
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "indices": {
          "stack": { ![](images/icons/callouts/1.png)
             "fields": {
                "creation_date": {
                   "max_doc": 1326564,
                   "doc_count": 564633,
                   "density": 42,
                   "sum_doc_freq": 2258532,
                   "sum_total_term_freq": -1,
                   "min_value": "2008-08-01T16:37:51.513Z",
                   "max_value": "2013-06-02T03:23:11.593Z",
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "display_name": {
                   "max_doc": 1326564,
                   "doc_count": 126741,
                   "density": 9,
                   "sum_doc_freq": 166535,
                   "sum_total_term_freq": 166616,
                   "min_value": "0",
                   "max_value": "정혜선",
                   "is_searchable": "true",
                   "is_aggregatable": "false"
                },
                "answer_count": {
                   "max_doc": 1326564,
                   "doc_count": 139885,
                   "density": 10,
                   "sum_doc_freq": 559540,
                   "sum_total_term_freq": -1,
                   "min_value": 0,
                   "max_value": 160,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "rating": {
                   "max_doc": 1326564,
                   "doc_count": 437892,
                   "density": 33,
                   "sum_doc_freq": 1751568,
                   "sum_total_term_freq": -1,
                   "min_value": -14,
                   "max_value": 1277,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                }
             }
          }
       }
    }

![](images/icons/callouts/1.png)

| 

The `stack` key means it contains all field stats for the `stack` index.   
  
---|---  
  
### Field stats index constraints

Field stats index constraints allows to omit all field stats for indices that don’t match with the constraint. An index constraint can exclude indices' field stats based on the `min_value` and `max_value` statistic. This option is only useful if the `level` option is set to `indices`. Fields that are not indexed (not searchable) are always omitted when an index constraint is defined.

For example index constraints can be useful to find out the min and max value of a particular property of your data in a time based scenario. The following request only returns field stats for the `answer_count` property for indices holding questions created in the year 2014:
    
    
    POST _field_stats?level=indices
    {
       "fields" : ["answer_count"], ![](images/icons/callouts/1.png)
       "index_constraints" : { ![](images/icons/callouts/2.png)
          "creation_date" : { ![](images/icons/callouts/3.png)
             "max_value" : { ![](images/icons/callouts/4.png)
                "gte" : "2014-01-01T00:00:00.000Z"
             },
             "min_value" : { ![](images/icons/callouts/5.png)
                "lt" : "2015-01-01T00:00:00.000Z"
             }
          }
       }
    }

![](images/icons/callouts/1.png)

| 

The fields to compute and return field stats for.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The set index constraints. Note that index constrains can be defined for fields that aren’t defined in the `fields` option.   
  
![](images/icons/callouts/3.png)

| 

Index constraints for the field `creation_date`.   
  
![](images/icons/callouts/4.png) ![](images/icons/callouts/5.png)

| 

Index constraints on the `max_value` and `min_value` property of a field statistic.   
  
For a field, index constraints can be defined on the `min_value` statistic, `max_value` statistic or both. Each index constraint support the following comparisons:

`gte`| Greater-than or equal to     
---|---    
`gt`| Greater-than     
lte`| Less-than or equal to     
`lt`| Less-than   
  
Field stats index constraints on date fields optionally accept a `format` option, used to parse the constraint’s value. If missing, the format configured in the field’s mapping is used.
    
    
    POST _field_stats?level=indices
    {
       "fields" : ["answer_count"],
       "index_constraints" : {
          "creation_date" : {
             "max_value" : {
                "gte" : "2014-01-01",
                "format" : "date_optional_time" ![](images/icons/callouts/1.png)
             },
             "min_value" : {
                "lt" : "2015-01-01",
                "format" : "date_optional_time"
             }
          }
       }
    }

![](images/icons/callouts/1.png)

| 

Custom date format   
  
---|---