## Geo Centroid Aggregation

A metric aggregation that computes the weighted [centroid](https://en.wikipedia.org/wiki/Centroid) from all coordinate values for a [Geo-point datatype](geo-point.html) field.

Example:
    
    
    PUT /museums
    {
        "mappings": {
            "doc": {
                "properties": {
                    "location": {
                        "type": "geo_point"
                    }
                }
            }
        }
    }
    
    POST /museums/doc/_bulk?refresh
    {"index":{"_id":1} }
    {"location": "52.374081,4.912350", "city": "Amsterdam", "name": "NEMO Science Museum"}
    {"index":{"_id":2} }
    {"location": "52.369219,4.901618", "city": "Amsterdam", "name": "Museum Het Rembrandthuis"}
    {"index":{"_id":3} }
    {"location": "52.371667,4.914722", "city": "Amsterdam", "name": "Nederlands Scheepvaartmuseum"}
    {"index":{"_id":4} }
    {"location": "51.222900,4.405200", "city": "Antwerp", "name": "Letterenhuis"}
    {"index":{"_id":5} }
    {"location": "48.861111,2.336389", "city": "Paris", "name": "Musée du Louvre"}
    {"index":{"_id":6} }
    {"location": "48.860000,2.327000", "city": "Paris", "name": "Musée d'Orsay"}
    
    POST /museums/_search?size=0
    {
        "aggs" : {
            "centroid" : {
                "geo_centroid" : {
                    "field" : "location" ![](images/icons/callouts/1.png)
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

The `geo_centroid` aggregation specifies the field to use for computing the centroid. (NOTE: field must be a [Geo-point datatype](geo-point.html) type)   
  
---|---  
  
The above aggregation demonstrates how one would compute the centroid of the location field for all documents with a crime type of burglary

The response for the above aggregation:
    
    
    {
        ...
        "aggregations": {
            "centroid": {
                "location": {
                    "lat": 51.009829603135586,
                    "lon": 3.966213036328554
                }
            }
        }
    }

The `geo_centroid` aggregation is more interesting when combined as a sub-aggregation to other bucket aggregations.

Example:
    
    
    POST /museums/_search?size=0
    {
        "aggs" : {
            "cities" : {
                "terms" : { "field" : "city.keyword" },
                "aggs" : {
                    "centroid" : {
                        "geo_centroid" : { "field" : "location" }
                    }
                }
            }
        }
    }

The above example uses `geo_centroid` as a sub-aggregation to a [terms](search-aggregations-bucket-terms-aggregation.html) bucket aggregation for finding the central location for museums in each city.

The response for the above aggregation:
    
    
    {
        ...
        "aggregations": {
            "cities": {
                "sum_other_doc_count": 0,
                "doc_count_error_upper_bound": 0,
                "buckets": [
                   {
                       "key": "Amsterdam",
                       "doc_count": 3,
                       "centroid": {
                          "location": {
                             "lat": 52.371655656024814,
                             "lon": 4.909563269466162
                          }
                       }
                   },
                   {
                       "key": "Paris",
                       "doc_count": 2,
                       "centroid": {
                          "location": {
                             "lat": 48.86055544484407,
                             "lon": 2.331694420427084
                          }
                       }
                    },
                    {
                        "key": "Antwerp",
                        "doc_count": 1,
                        "centroid": {
                           "location": {
                              "lat": 51.222899928689,
                              "lon": 4.405199903994799
                           }
                        }
                     }
                ]
            }
        }
    }