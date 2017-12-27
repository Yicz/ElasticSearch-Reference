## `properties`

Type mappings, [`object` fields](object.html) and [`nested` fields](nested.html) contain sub-fields, called `properties`. These properties may be of any [datatype](mapping-types.html), including `object` and `nested`. Properties can be added:

  * explicitly by defining them when [creating an index](indices-create-index.html). 
  * explicitly by defining them when adding or updating a mapping type with the [PUT mapping](indices-put-mapping.html) API. 
  * [dynamically](dynamic-mapping.html) just by indexing documents containing new fields. 



Below is an example of adding `properties` to a mapping type, an `object` field, and a `nested` field:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": { <1>
          "properties": {
            "manager": { <2>
              "properties": {
                "age":  { "type": "integer" },
                "name": { "type": "text"  }
              }
            },
            "employees": { <3>
              "type": "nested",
              "properties": {
                "age":  { "type": "integer" },
                "name": { "type": "text"  }
              }
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1 <4>
    {
      "region": "US",
      "manager": {
        "name": "Alice White",
        "age": 30
      },
      "employees": [
        {
          "name": "John Smith",
          "age": 34
        },
        {
          "name": "Peter Brown",
          "age": 26
        }
      ]
    }

<1>| Properties under the `my_type` mapping type.     
---|---    
<2>| Properties under the `manager` object field.     
<3>| Properties under the `employees` nested field.     
<4>| An example document which corresponds to the above mapping.   
  
![Tip](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/tip.png)

The `properties` setting is allowed to have different settings for fields of the same name in the same index. New properties can be added to existing fields using the [PUT mapping API](indices-put-mapping.html).

### Dot notation

Inner fields can be referred to in queries, aggregations, etc., using _dot notation_ :
    
    
    GET my_index/_search
    {
      "query": {
        "match": {
          "manager.name": "Alice White" <1>
        }
      },
      "aggs": {
        "Employees": {
          "nested": {
            "path": "employees"
          },
          "aggs": {
            "Employee Ages": {
              "histogram": {
                "field": "employees.age", <2>
                "interval": 5
              }
            }
          }
        }
      }
    }

![Important](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/important.png)

The full path to the inner field must be specified.
