## Geo-Shape datatype

The `geo_shape` datatype facilitates the indexing of and searching with arbitrary geo shapes such as rectangles and polygons. It should be used when either the data being indexed or the queries being executed contain shapes other than just points.

You can query documents using this type using [geo_shape Query](query-dsl-geo-shape-query.html "GeoShape Query").

#### Mapping Options

The geo_shape mapping maps geo_json geometry objects to the geo_shape type. To enable it, users must explicitly map fields to the geo_shape type.

Option | Description|  Default  
---|---|---  
  
`tree`

| 

Name of the PrefixTree implementation to be used: `geohash` for GeohashPrefixTree and `quadtree` for QuadPrefixTree.

| 

`geohash`  
  
`precision`

| 

This parameter may be used instead of `tree_levels` to set an appropriate value for the `tree_levels` parameter. The value specifies the desired precision and Elasticsearch will calculate the best tree_levels value to honor this precision. The value should be a number followed by an optional distance unit. Valid distance units include: `in`, `inch`, `yd`, `yard`, `mi`, `miles`, `km`, `kilometers`, `m`,`meters`, `cm`,`centimeters`, `mm`, `millimeters`.

| 

`meters`  
  
`tree_levels`

| 

Maximum number of layers to be used by the PrefixTree. This can be used to control the precision of shape representations and therefore how many terms are indexed. Defaults to the default value of the chosen PrefixTree implementation. Since this parameter requires a certain level of understanding of the underlying implementation, users may use the `precision` parameter instead. However, Elasticsearch only uses the tree_levels parameter internally and this is what is returned via the mapping API even if you use the precision parameter.

| 

`50m`  
  
`strategy`

| 

The strategy parameter defines the approach for how to represent shapes at indexing and search time. It also influences the capabilities available so it is recommended to let Elasticsearch set this parameter automatically. There are two strategies available: `recursive` and `term`. Term strategy supports point types only (the `points_only` parameter will be automatically set to true) while Recursive strategy supports all shape types. (IMPORTANT: see [Prefix trees](geo-shape.html#prefix-trees "Prefix treesedit") for more detailed information)

| 

`recursive`  
  
`distance_error_pct`

| 

Used as a hint to the PrefixTree about how precise it should be. Defaults to 0.025 (2.5%) with 0.5 as the maximum supported value. PERFORMANCE NOTE: This value will default to 0 if a `precision` or `tree_level` definition is explicitly defined. This guarantees spatial precision at the level defined in the mapping. This can lead to significant memory usage for high resolution shapes with low error (e.g., large shapes at 1m with < 0.001 error). To improve indexing performance (at the cost of query accuracy) explicitly define `tree_level` or `precision` along with a reasonable `distance_error_pct`, noting that large shapes will have greater false positives.

| 

`0.025`  
  
`orientation`

| 

Optionally define how to interpret vertex order for polygons / multipolygons. This parameter defines one of two coordinate system rules (Right-hand or Left-hand) each of which can be specified in three different ways. 1. Right-hand rule: `right`, `ccw`, `counterclockwise`, 2\. Left-hand rule: `left`, `cw`, `clockwise`. The default orientation (`counterclockwise`) complies with the OGC standard which defines outer ring vertices in counterclockwise order with inner ring(s) vertices (holes) in clockwise order. Setting this parameter in the geo_shape mapping explicitly sets vertex order for the coordinate list of a geo_shape field but can be overridden in each individual GeoJSON document.

| 

`ccw`  
  
`points_only`

| 

Setting this option to `true` (defaults to `false`) configures the `geo_shape` field type for point shapes only (NOTE: Multi-Points are not yet supported). This optimizes index and search performance for the `geohash` and `quadtree` when it is known that only points will be indexed. At present geo_shape queries can not be executed on `geo_point` field types. This option bridges the gap by improving point performance on a `geo_shape` field so that `geo_shape` queries are optimal on a point only field.

| 

`false`  
  
#### Prefix trees

To efficiently represent shapes in the index, Shapes are converted into a series of hashes representing grid squares (commonly referred to as "rasters") using implementations of a PrefixTree. The tree notion comes from the fact that the PrefixTree uses multiple grid layers, each with an increasing level of precision to represent the Earth. This can be thought of as increasing the level of detail of a map or image at higher zoom levels.

Multiple PrefixTree implementations are provided:

  * GeohashPrefixTree - Uses [geohashes](http://en.wikipedia.org/wiki/Geohash) for grid squares. Geohashes are base32 encoded strings of the bits of the latitude and longitude interleaved. So the longer the hash, the more precise it is. Each character added to the geohash represents another tree level and adds 5 bits of precision to the geohash. A geohash represents a rectangular area and has 32 sub rectangles. The maximum amount of levels in Elasticsearch is 24. 
  * QuadPrefixTree - Uses a [quadtree](http://en.wikipedia.org/wiki/Quadtree) for grid squares. Similar to geohash, quad trees interleave the bits of the latitude and longitude the resulting hash is a bit set. A tree level in a quad tree represents 2 bits in this bit set, one for each coordinate. The maximum amount of levels for the quad trees in Elasticsearch is 50. 



##### Spatial strategies

The PrefixTree implementations rely on a SpatialStrategy for decomposing the provided Shape(s) into approximated grid squares. Each strategy answers the following:

  * What type of Shapes can be indexed? 
  * What types of Query Operations and Shapes can be used? 
  * Does it support more than one Shape per field? 



The following Strategy implementations (with corresponding capabilities) are provided:

Strategy | Supported Shapes | Supported Queries | Multiple Shapes  
---|---|---|---  
  
`recursive`

| 

[All](geo-shape.html#input-structure "Input Structureedit")

| 

`INTERSECTS`, `DISJOINT`, `WITHIN`, `CONTAINS`

| 

Yes  
  
`term`

| 

[Points](geo-shape.html#point "Pointedit")

| 

`INTERSECTS`

| 

Yes  
  
##### Accuracy

Geo_shape does not provide 100% accuracy and depending on how it is configured it may return some false positives or false negatives for certain queries. To mitigate this, it is important to select an appropriate value for the tree_levels parameter and to adjust expectations accordingly. For example, a point may be near the border of a particular grid cell and may thus not match a query that only matches the cell right next to it — even though the shape is very close to the point.

##### Example
    
    
    PUT /example
    {
        "mappings": {
            "doc": {
                "properties": {
                    "location": {
                        "type": "geo_shape",
                        "tree": "quadtree",
                        "precision": "1m"
                    }
                }
            }
        }
    }

This mapping maps the location field to the geo_shape type using the quad_tree implementation and a precision of 1m. Elasticsearch translates this into a tree_levels setting of 26.

##### Performance considerations

Elasticsearch uses the paths in the prefix tree as terms in the index and in queries. The higher the level is (and thus the precision), the more terms are generated. Of course, calculating the terms, keeping them in memory, and storing them on disk all have a price. Especially with higher tree levels, indices can become extremely large even with a modest amount of data. Additionally, the size of the features also matters. Big, complex polygons can take up a lot of space at higher tree levels. Which setting is right depends on the use case. Generally one trades off accuracy against index size and query performance.

The defaults in Elasticsearch for both implementations are a compromise between index size and a reasonable level of precision of 50m at the equator. This allows for indexing tens of millions of shapes without overly bloating the resulting index too much relative to the input size.

#### Input Structure

The [GeoJSON](http://www.geojson.org) format is used to represent [shapes](http://geojson.org/geojson-spec.html#geometry-objects) as input as follows:

GeoJSON Type | Elasticsearch Type | Description  
---|---|---  
  
`Point`

| 

`point`

| 

A single geographic coordinate.  
  
`LineString`

| 

`linestring`

| 

An arbitrary line given two or more points.  
  
`Polygon`

| 

`polygon`

| 

A _closed_ polygon whose first and last point must match, thus requiring `n + 1` vertices to create an `n`-sided polygon and a minimum of `4` vertices.  
  
`MultiPoint`

| 

`multipoint`

| 

An array of unconnected, but likely related points.  
  
`MultiLineString`

| 

`multilinestring`

| 

An array of separate linestrings.  
  
`MultiPolygon`

| 

`multipolygon`

| 

An array of separate polygons.  
  
`GeometryCollection`

| 

`geometrycollection`

| 

A GeoJSON shape similar to the `multi*` shapes except that multiple types can coexist (e.g., a Point and a LineString).  
  
`N/A`

| 

`envelope`

| 

A bounding rectangle, or envelope, specified by specifying only the top left and bottom right points.  
  
`N/A`

| 

`circle`

| 

A circle specified by a center point and radius with units, which default to `METERS`.  
  
![Note](images/icons/note.png)

For all types, both the inner `type` and `coordinates` fields are required.

In GeoJSON, and therefore Elasticsearch, the correct **coordinate order is longitude, latitude (X, Y)** within coordinate arrays. This differs from many Geospatial APIs (e.g., Google Maps) that generally use the colloquial latitude, longitude (Y, X).

##### [Point](http://geojson.org/geojson-spec.html#id2)

A point is a single geographic coordinate, such as the location of a building or the current position given by a smartphone’s Geolocation API.
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "point",
            "coordinates" : [-77.03653, 38.897676]
        }
    }

##### [LineString](http://geojson.org/geojson-spec.html#id3)

A `linestring` defined by an array of two or more positions. By specifying only two points, the `linestring` will represent a straight line. Specifying more than two points creates an arbitrary path.
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "linestring",
            "coordinates" : [[-77.03653, 38.897676], [-77.009051, 38.889939]]
        }
    }

The above `linestring` would draw a straight line starting at the White House to the US Capitol Building.

##### [Polygon](http://www.geojson.org/geojson-spec.html#id4)

A polygon is defined by a list of a list of points. The first and last points in each (outer) list must be the same (the polygon must be closed).
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "polygon",
            "coordinates" : [
                [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
            ]
        }
    }

The first array represents the outer boundary of the polygon, the other arrays represent the interior shapes ("holes"):
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "polygon",
            "coordinates" : [
                [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
                [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
            ]
        }
    }

 **IMPORTANT NOTE:** GeoJSON does not mandate a specific order for vertices thus ambiguous polygons around the dateline and poles are possible. To alleviate ambiguity the Open Geospatial Consortium (OGC) [Simple Feature Access](http://www.opengeospatial.org/standards/sfa) specification defines the following vertex ordering:

  * Outer Ring - Counterclockwise 
  * Inner Ring(s) / Holes - Clockwise 



For polygons that do not cross the dateline, vertex order will not matter in Elasticsearch. For polygons that do cross the dateline, Elasticsearch requires vertex ordering to comply with the OGC specification. Otherwise, an unintended polygon may be created and unexpected query/filter results will be returned.

The following provides an example of an ambiguous polygon. Elasticsearch will apply OGC standards to eliminate ambiguity resulting in a polygon that crosses the dateline.
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "polygon",
            "coordinates" : [
                [ [-177.0, 10.0], [176.0, 15.0], [172.0, 0.0], [176.0, -15.0], [-177.0, -10.0], [-177.0, 10.0] ],
                [ [178.2, 8.2], [-178.8, 8.2], [-180.8, -8.8], [178.2, 8.8] ]
            ]
        }
    }

An `orientation` parameter can be defined when setting the geo_shape mapping (see [Mapping Options. This will define vertex order for the coordinate list on the mapped geo_shape field. It can also be overridden on each document. The following is an example for overriding the orientation on a document:
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "polygon",
            "orientation" : "clockwise",
            "coordinates" : [
                [ [-177.0, 10.0], [176.0, 15.0], [172.0, 0.0], [176.0, -15.0], [-177.0, -10.0], [-177.0, 10.0] ],
                [ [178.2, 8.2], [-178.8, 8.2], [-180.8, -8.8], [178.2, 8.8] ]
            ]
        }
    }

##### [MultiPoint](http://www.geojson.org/geojson-spec.html#id5)

A list of geojson points.
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "multipoint",
            "coordinates" : [
                [102.0, 2.0], [103.0, 2.0]
            ]
        }
    }

##### [MultiLineString](http://www.geojson.org/geojson-spec.html#id6)

A list of geojson linestrings.
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "multilinestring",
            "coordinates" : [
                [ [102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0] ],
                [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0] ],
                [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8] ]
            ]
        }
    }

##### [MultiPolygon](http://www.geojson.org/geojson-spec.html#id7)

A list of geojson polygons.
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "multipolygon",
            "coordinates" : [
                [ [[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]] ],
                [ [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
                  [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]] ]
            ]
        }
    }

##### [Geometry Collection](http://geojson.org/geojson-spec.html#geometrycollection)

A collection of geojson geometry objects.
    
    
    POST /example/doc
    {
        "location" : {
            "type": "geometrycollection",
            "geometries": [
                {
                    "type": "point",
                    "coordinates": [100.0, 0.0]
                },
                {
                    "type": "linestring",
                    "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
                }
            ]
        }
    }

##### Envelope

Elasticsearch supports an `envelope` type, which consists of coordinates for upper left and lower right points of the shape to represent a bounding rectangle:
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "envelope",
            "coordinates" : [ [-45.0, 45.0], [45.0, -45.0] ]
        }
    }

##### Circle

Elasticsearch supports a `circle` type, which consists of a center point with a radius:
    
    
    POST /example/doc
    {
        "location" : {
            "type" : "circle",
            "coordinates" : [-45.0, 45.0],
            "radius" : "100m"
        }
    }

Note: The inner `radius` field is required. If not specified, then the units of the `radius` will default to `METERS`.

#### Sorting and Retrieving index Shapes

Due to the complex input structure and index representation of shapes, it is not currently possible to sort shapes or retrieve their fields directly. The geo_shape value is only retrievable through the `_source` field.
