## Geo queries

Elasticsearch supports two types of geo data: [`geo_point`](geo-point.html "Geo-point datatype") fields which support lat/lon pairs, and [`geo_shape`](geo-shape.html "Geo-Shape datatype") fields, which support points, lines, circles, polygons, multi-polygons etc.

The queries in this group are:

[`geo_shape`](query-dsl-geo-shape-query.html "GeoShape Query") query 
     Find document with geo-shapes which either intersect, are contained by, or do not intersect with the specified geo-shape. 
[`geo_bounding_box`](query-dsl-geo-bounding-box-query.html "Geo Bounding Box Query") query 
     Finds documents with geo-points that fall into the specified rectangle. 
[`geo_distance`](query-dsl-geo-distance-query.html "Geo Distance Query") query 
     Finds document with geo-points within the specified distance of a central point. 
[`geo_distance_range`](query-dsl-geo-distance-range-query.html "Geo Distance Range Query") query 
     Like the `geo_point` query, but the range starts at a specified distance from the central point. 
[`geo_polygon`](query-dsl-geo-polygon-query.html "Geo Polygon Query") query 
     Find documents with geo-points within the specified polygon. 
