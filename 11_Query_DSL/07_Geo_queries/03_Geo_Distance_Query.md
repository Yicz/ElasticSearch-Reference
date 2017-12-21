## Geo Distance Query

Filters documents that include only hits that exists within a specific distance from a geo point. Assuming the following mapping and indexed document:
    
    
    PUT /my_locations
    {
        "mappings": {
            "location": {
                "properties": {
                    "pin": {
                        "properties": {
                            "location": {
                                "type": "geo_point"
                            }
                        }
                    }
                }
            }
        }
    }
    
    PUT /my_locations/location/1
    {
        "pin" : {
            "location" : {
                "lat" : 40.12,
                "lon" : -71.34
            }
        }
    }

Then the following simple query can be executed with a `geo_distance` filter:
    
    
    GET /my_locations/location/_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_distance" : {
                        "distance" : "200km",
                        "pin.location" : {
                            "lat" : 40,
                            "lon" : -70
                        }
                    }
                }
            }
        }
    }

#### Accepted Formats

In much the same way the `geo_point` type can accept different representations of the geo point, the filter can accept it as well:

##### Lat Lon As Properties
    
    
    GET /my_locations/location/_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_distance" : {
                        "distance" : "12km",
                        "pin.location" : {
                            "lat" : 40,
                            "lon" : -70
                        }
                    }
                }
            }
        }
    }

##### Lat Lon As Array

Format in `[lon, lat]`, note, the order of lon/lat here in order to conform with [GeoJSON](http://geojson.org/).
    
    
    GET /my_locations/location/_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_distance" : {
                        "distance" : "12km",
                        "pin.location" : [-70, 40]
                    }
                }
            }
        }
    }

##### Lat Lon As String

Format in `lat,lon`.
    
    
    GET /my_locations/location/_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_distance" : {
                        "distance" : "12km",
                        "pin.location" : "40,-70"
                    }
                }
            }
        }
    }

##### Geohash
    
    
    GET /my_locations/location/_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_distance" : {
                        "distance" : "12km",
                        "pin.location" : "drm3btev3e86"
                    }
                }
            }
        }
    }

#### Options

The following are options allowed on the filter:

`distance`

| 

The radius of the circle centred on the specified location. Points which fall into this circle are considered to be matches. The `distance` can be specified in various units. See [Distance Units.   
  
---|---  
  
`distance_type`

| 

How to compute the distance. Can either be `arc` (default), or `plane` (faster, but inaccurate on long distances and close to the poles).   
  
`optimize_bbox`

| 

Whether to use the optimization of first running a bounding box check before the distance check. Defaults to `memory` which will do in memory checks. Can also have values of `indexed` to use indexed value check (make sure the `geo_point` type index lat lon in this case), or `none` which disables bounding box optimization.  [2.2] Deprecated in 2.2.   
  
`_name`

| 

Optional name field to identify the query   
  
`ignore_malformed`

| 

[5.0.0] Deprecated in 5.0.0. Use `validation_method` instead  Set to `true` to accept geo points with invalid latitude or longitude (default is `false`).   
  
`validation_method`

| 

Set to `IGNORE_MALFORMED` to accept geo points with invalid latitude or longitude, set to `COERCE` to additionally try and infer correct coordinates (default is `STRICT`).   
  
#### geo_point Type

The filter **requires** the `geo_point` type to be set on the relevant field.

#### Multi Location Per Document

The `geo_distance` filter can work with multiple locations / points per document. Once a single location / point matches the filter, the document will be included in the filter.

#### Ignore Unmapped

When set to `true` the `ignore_unmapped` option will ignore an unmapped field and will not match any documents for this query. This can be useful when querying multiple indexes which might have different mappings. When set to `false` (the default value) the query will throw an exception if the field is not mapped.
