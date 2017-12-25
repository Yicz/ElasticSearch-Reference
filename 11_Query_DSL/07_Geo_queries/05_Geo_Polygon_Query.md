## Geo Polygon Query

A query allowing to include hits that only fall within a polygon of points. Here is an example:
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_polygon" : {
                        "person.location" : {
                            "points" : [
                            {"lat" : 40, "lon" : -70},
                            {"lat" : 30, "lon" : -80},
                            {"lat" : 20, "lon" : -90}
                            ]
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
`validation_method`| Set to `IGNORE_MALFORMED` to accept geo points with invalid latitude or longitude, `COERCE` to try and infer correctlatitude or longitude, or `STRICT` (default is `STRICT`).  
  
#### Allowed Formats

##### Lat Long as Array

Format in `[lon, lat]`, note, the order of lon/lat here in order to conform with [GeoJSON](http://geojson.org/).
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_polygon" : {
                        "person.location" : {
                            "points" : [
                                [-70, 40],
                                [-80, 30],
                                [-90, 20]
                            ]
                        }
                    }
                }
            }
        }
    }

##### Lat Lon as String

Format in `lat,lon`.
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                   "geo_polygon" : {
                        "person.location" : {
                            "points" : [
                                "40, -70",
                                "30, -80",
                                "20, -90"
                            ]
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
                   "geo_polygon" : {
                        "person.location" : {
                            "points" : [
                                "drn5x1g8cu2y",
                                "30, -80",
                                "20, -90"
                            ]
                        }
                    }
                }
            }
        }
    }

#### geo_point Type

The query **requires** the [`geo_point`](geo-point.html) type to be set on the relevant field.

#### Ignore Unmapped

When set to `true` the `ignore_unmapped` option will ignore an unmapped field and will not match any documents for this query. This can be useful when querying multiple indexes which might have different mappings. When set to `false` (the default value) the query will throw an exception if the field is not mapped.
