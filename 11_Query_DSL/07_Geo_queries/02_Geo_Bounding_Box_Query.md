## Geo Bounding Box Query

A query allowing to filter hits based on a point location using a bounding box. Assuming the following indexed document:
    
    
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

Then the following simple query can be executed with a `geo_bounding_box` filter:
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_bounding_box" : {
                        "pin.location" : {
                            "top_left" : {
                                "lat" : 40.73,
                                "lon" : -74.1
                            },
                            "bottom_right" : {
                                "lat" : 40.01,
                                "lon" : -71.12
                            }
                        }
                    }
                }
            }
        }
    }

#### Query Options

Option | Description  
---|---  
`_name`| Optional name field to identify the filter    
`ignore_malformed`| [5.0.0] Deprecated in 5.0.0. Use `validation_method` instead  Set to `true` to accept geo points with invalid latitudeor longitude (default is `false`).    
`validation_method`| Set to `IGNORE_MALFORMED` to accept geo points with invalid latitude or longitude, set to `COERCE` to also try toinfer correct latitude or longitude. (default is `STRICT`).    
`type`| Set to one of `indexed` or `memory` to defines whether this filter will be executed in memory or indexed. See [Type](query-dsl-geo-bounding-box-query.html#geo-bbox-type) below for further details Default is `memory`.  
  
#### Accepted Formats

In much the same way the geo_point type can accept different representations of the geo point, the filter can accept it as well:

##### Lat Lon As Properties
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_bounding_box" : {
                        "pin.location" : {
                            "top_left" : {
                                "lat" : 40.73,
                                "lon" : -74.1
                            },
                            "bottom_right" : {
                                "lat" : 40.01,
                                "lon" : -71.12
                            }
                        }
                    }
                }
            }
        }
    }

##### Lat Lon As Array

Format in `[lon, lat]`, note, the order of lon/lat here in order to conform with [GeoJSON](http://geojson.org/).
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_bounding_box" : {
                        "pin.location" : {
                            "top_left" : [-74.1, 40.73],
                            "bottom_right" : [-71.12, 40.01]
                        }
                    }
                }
            }
        }
    }

##### Lat Lon As String

Format in `lat,lon`.
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_bounding_box" : {
                        "pin.location" : {
                            "top_left" : "40.73, -74.1",
                            "bottom_right" : "40.01, -71.12"
                        }
                    }
                }
        }
    }
    }

##### Geohash
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_bounding_box" : {
                        "pin.location" : {
                            "top_left" : "dr5r9ydj2y73",
                            "bottom_right" : "drj7teegpus6"
                        }
                    }
                }
            }
        }
    }

#### Vertices

The vertices of the bounding box can either be set by `top_left` and `bottom_right` or by `top_right` and `bottom_left` parameters. More over the names `topLeft`, `bottomRight`, `topRight` and `bottomLeft` are supported. Instead of setting the values pairwise, one can use the simple names `top`, `left`, `bottom` and `right` to set the values separately.
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_bounding_box" : {
                        "pin.location" : {
                            "top" : 40.73,
                            "left" : -74.1,
                            "bottom" : 40.01,
                            "right" : -71.12
                        }
                    }
                }
            }
        }
    }

#### geo_point Type

The filter **requires** the `geo_point` type to be set on the relevant field.

#### Multi Location Per Document

The filter can work with multiple locations / points per document. Once a single location / point matches the filter, the document will be included in the filter

#### Type

The type of the bounding box execution by default is set to `memory`, which means in memory checks if the doc falls within the bounding box range. In some cases, an `indexed` option will perform faster (but note that the `geo_point` type must have lat and lon indexed in this case). Note, when using the indexed option, multi locations per document field are not supported. Here is an example:
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_bounding_box" : {
                        "pin.location" : {
                            "top_left" : {
                                "lat" : 40.73,
                                "lon" : -74.1
                            },
                            "bottom_right" : {
                                "lat" : 40.10,
                                "lon" : -71.12
                            }
                        },
                        "type" : "indexed"
                    }
                }
            }
        }
    }

#### Ignore Unmapped

When set to `true` the `ignore_unmapped` option will ignore an unmapped field and will not match any documents for this query. This can be useful when querying multiple indexes which might have different mappings. When set to `false` (the default value) the query will throw an exception if the field is not mapped.
