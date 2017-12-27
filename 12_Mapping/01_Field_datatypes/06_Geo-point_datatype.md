## Geo-point datatype

Fields of type `geo_point` accept latitude-longitude pairs, which can be used:

  * to find geo-points within a [bounding box](query-dsl-geo-bounding-box-query.html), within a certain [distance](query-dsl-geo-distance-query.html) of a central point, or within a [polygon](query-dsl-geo-polygon-query.html). 
  * to aggregate documents by [geographically](search-aggregations-bucket-geohashgrid-aggregation.html) or by [distance](search-aggregations-bucket-geodistance-aggregation.html) from a central point. 
  * to integrate distance into a document’s [relevance score](query-dsl-function-score-query.html). 
  * to [sort](search-request-sort.html#geo-sorting) documents by distance. 



There are four ways that a geo-point may be specified, as demonstrated below:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "location": {
              "type": "geo_point"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "text": "Geo-point as an object",
      "location": { <1>
        "lat": 41.12,
        "lon": -71.34
      }
    }
    
    PUT my_index/my_type/2
    {
      "text": "Geo-point as a string",
      "location": "41.12,-71.34" <2>
    }
    
    PUT my_index/my_type/3
    {
      "text": "Geo-point as a geohash",
      "location": "drm3btev3e86" <3>
    }
    
    PUT my_index/my_type/4
    {
      "text": "Geo-point as an array",
      "location": [ -71.34, 41.12 ] <4>
    }
    
    GET my_index/_search
    {
      "query": {
        "geo_bounding_box": { <5>
          "location": {
            "top_left": {
              "lat": 42,
              "lon": -72
            },
            "bottom_right": {
              "lat": 40,
              "lon": -74
            }
          }
        }
      }
    }

<1>

| 

Geo-point expressed as an object, with `lat` and `lon` keys.   
  
---|---  
  
<2>

| 

Geo-point expressed as a string with the format: `"lat,lon"`.   
  
<3>

| 

Geo-point expressed as a geohash.   
  
<4>

| 

Geo-point expressed as an array with the format: [ `lon`, `lat`]   
  
<5>

| 

A geo-bounding box query which finds all geo-points that fall inside the box.   
  
![Important](images/icons/important.png)

### Geo-points expressed as an array or string

Please note that string geo-points are ordered as `lat,lon`, while array geo-points are ordered as the reverse: `lon,lat`.

Originally, `lat,lon` was used for both array and string, but the array format was changed early on to conform to the format used by GeoJSON.

### Parameters for `geo_point` fields

The following parameters are accepted by `geo_point` fields:

[`ignore_malformed`](ignore-malformed.html)

| 

If `true`, malformed geo-points are ignored. If `false` (default), malformed geo-points throw an exception and reject the whole document.   
  
---|---  
  
### Using geo-points in scripts

When accessing the value of a geo-point in a script, the value is returned as a `GeoPoint` object, which allows access to the `.lat` and `.lon` values respectively:
    
    
    def geopoint = doc['location'].value;
    def lat      = geopoint.lat;
    def lon      = geopoint.lon;

For performance reasons, it is better to access the lat/lon values directly:
    
    
    def lat      = doc['location'].lat;
    def lon      = doc['location'].lon;
