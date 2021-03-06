## Groovy Scripting Language

![Warning](/images/icons/warning.png)

### Deprecated in 5.0.0. 

Groovy will be replaced by the new scripting language [`Painless`](modules-scripting-painless.html)

Groovy is available in Elasticsearch by default. Although limited by the [Java Security Manager](modules-scripting-security.html#java-security-manager), it is not a sandboxed language and only `file` scripts may be used by default.

Enabling `inline` or `stored` Groovy scripting is a security risk and should only be considered if your Elasticsearch cluster is protected from the outside world. Even a simple `while (true) { }` loop could behave as a denial-of- service attack on your cluster.

See [Scripting and Security](modules-scripting-security.html) for details on security issues with scripts, including how to customize class whitelisting.

### Doc value properties and methods

Doc values in Groovy support the following properties and methods (depending on the underlying field type):

`doc['field_name'].value`
     The native value of the field. For example, if its a short type, it will be short. 
`doc['field_name'].values`
     The native array values of the field. For example, if its a short type, it will be short[]. Remember, a field can have several values within a single doc. Returns an empty array if the field has no values. 
`doc['field_name'].empty`
     A boolean indicating if the field has no values within the doc. 
`doc['field_name'].lat`
     The latitude of a geo point type, or `null`. 
`doc['field_name'].lon`
     The longitude of a geo point type, or `null`. 
`doc['field_name'].lats`
     The latitudes of a geo point type, or an empty array. 
`doc['field_name'].lons`
     The longitudes of a geo point type, or an empty array. 
`doc['field_name'].arcDistance(lat, lon)`
     The `arc` distance (in meters) of this geo point field from the provided lat/lon. 
`doc['field_name'].arcDistanceWithDefault(lat, lon, default)`
     The `arc` distance (in meters) of this geo point field from the provided lat/lon with a default value for empty fields. 
`doc['field_name'].planeDistance(lat, lon)`
     The `plane` distance (in meters) of this geo point field from the provided lat/lon. 
`doc['field_name'].planeDistanceWithDefault(lat, lon, default)`
     The `plane` distance (in meters) of this geo point field from the provided lat/lon with a default value for empty fields. 
`doc['field_name'].geohashDistance(geohash)`
     The `arc` distance (in meters) of this geo point field from the provided geohash. 
`doc['field_name'].geohashDistanceWithDefault(geohash, default)`
     The `arc` distance (in meters) of this geo point field from the provided geohash with a default value for empty fields. 

### Groovy Built In Functions

There are several built in functions that can be used within scripts. They include:

Function | Description  
---|---    
`sin(a)`| Returns the trigonometric sine of an angle.    
`cos(a)`| Returns the trigonometric cosine of an angle.    
`tan(a)`| Returns the trigonometric tangent of an angle.    
`asin(a)`| Returns the arc sine of a value.    
`acos(a)`| Returns the arc cosine of a value.    
`atan(a)`| Returns the arc tangent of a value.    
`toRadians(angdeg)`| Converts an angle measured in degrees to an approximately equivalent angle measured in radians    
`toDegrees(angrad)`| Converts an angle measured in radians to an approximately equivalent angle measured in degrees.    
`exp(a)`| Returns Euler’s number _e_ raised to the power of value.    
`log(a)`| Returns the natural logarithm (base _e_ ) of a value.    
`log10(a)`| Returns the base 10 logarithm of a value.    
`sqrt(a)`| Returns the correctly rounded positive square root of a value.    
`cbrt(a)`| Returns the cube root of a double value.    
`IEEEremainder(f1, f2)`| Computes the remainder operation on two arguments as prescribed by the IEEE 754 standard.    
`ceil(a)`| Returns the smallest (closest to negative infinity) value that is greater than or equal to the argument and is equal to a mathematical integer.    
`floor(a)`| Returns the largest (closest to positive infinity) value that is less than or equal to the argument and is equal to a mathematical integer.    
`rint(a)`| Returns the value that is closest in value to the argument and is equal to a mathematical integer.    
`atan2(y, x)`| Returns the angle _theta_ from the conversion of rectangular coordinates ( _x_ , _y_ ) to polar coordinates (r, _theta_ ).    
`pow(a, b)`| Returns the value of the first argument raised to the power of the second argument.    
`round(a)`| Returns the closest _int_ to the argument.    
`random()`| Returns a random _double_ value.    
`abs(a)`| Returns the absolute value of a value.    
`max(a, b)`| Returns the greater of two values.    
`min(a, b)`| Returns the smaller of two values.    
`ulp(d)`| Returns the size of an ulp of the argument.    
`signum(d)`| Returns the signum function of the argument.    
`sinh(x)`| Returns the hyperbolic sine of a value.    
`cosh(x)`| Returns the hyperbolic cosine of a value.    
`tanh(x)`| Returns the hyperbolic tangent of a value.    
`hypot(x, y)`| Returns sqrt( _x2_ \+ _y2_ ) without intermediate overflow or underflow.
