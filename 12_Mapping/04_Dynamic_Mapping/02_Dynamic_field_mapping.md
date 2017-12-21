## Dynamic field mapping

By default, when a previously unseen field is found in a document, Elasticsearch will add the new field to the type mapping. This behaviour can be disabled, both at the document and at the [`object`](object.html "Object datatype") level, by setting the [`dynamic`](dynamic.html "dynamic") parameter to `false` (to ignore new fields) or to `strict` (to throw an exception if an unknown field is encountered).

Assuming `dynamic` field mapping is enabled, some simple rules are used to determine which datatype the field should have:

**JSON datatype**

| 

**Elasticsearch datatype**  
  
---|---  
  
`null`

| 

No field is added.   
  
`true` or `false`

| 

[`boolean`](boolean.html "Boolean datatype") field   
  
floating point number 

| 

[`float`](number.html "Numeric datatypes") field   
  
integer 

| 

[`long`](number.html "Numeric datatypes") field   
  
object 

| 

[`object`](object.html "Object datatype") field   
  
array 

| 

Depends on the first non-`null` value in the array.   
  
string 

| 

Either a [`date`](date.html "Date datatype") field (if the value passes [date detection](dynamic-field-mapping.html#date-detection "Date detection")), a [`double`](number.html "Numeric datatypes") or [`long`](number.html "Numeric datatypes") field (if the value passes [numeric detection](dynamic-field-mapping.html#numeric-detection "Numeric detection")) or a [`text`](text.html "Text datatype") field, with a [`keyword`](keyword.html "Keyword datatype") sub-field.   
  
These are the only [field datatypes](mapping-types.html "Field datatypes") that are dynamically detected. All other datatypes must be mapped explicitly.

Besides the options listed below, dynamic field mapping rules can be further customised with [`dynamic_templates`](dynamic-templates.html "Dynamic templates").

### Date detection

If `date_detection` is enabled (default), then new string fields are checked to see whether their contents match any of the date patterns specified in `dynamic_date_formats`. If a match is found, a new [`date`](date.html "Date datatype") field is added with the corresponding format.

The default value for `dynamic_date_formats` is:

[ [`"strict_date_optional_time"`](mapping-date-format.html#strict-date-time),`"yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"`]

For example:
    
    
    PUT my_index/my_type/1
    {
      "create_date": "2015/09/02"
    }
    
    GET my_index/_mapping ![](images/icons/callouts/1.png)

![](images/icons/callouts/1.png)

| 

The `create_date` field has been added as a [`date`](date.html "Date datatype") field with the [`format`](mapping-date-format.html "format"): `"yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"`.   
  
---|---  
  
#### Disabling date detection

Dynamic date detection can be disabled by setting `date_detection` to `false`:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "date_detection": false
        }
      }
    }
    
    PUT my_index/my_type/1 ![](images/icons/callouts/1.png)
    {
      "create": "2015/09/02"
    }

![](images/icons/callouts/1.png)

| 

The `create_date` field has been added as a [`text`](text.html "Text datatype") field.   
  
---|---  
  
#### Customising detected date formats

Alternatively, the `dynamic_date_formats` can be customised to support your own [date formats](mapping-date-format.html "format"):
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic_date_formats": ["MM/dd/yyyy"]
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "create_date": "09/25/2015"
    }

### Numeric detection

While JSON has support for native floating point and integer datatypes, some applications or languages may sometimes render numbers as strings. Usually the correct solution is to map these fields explicitly, but numeric detection (which is disabled by default) can be enabled to do this automatically:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "numeric_detection": true
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "my_float":   "1.0", ![](images/icons/callouts/1.png)
      "my_integer": "1" ![](images/icons/callouts/2.png)
    }

![](images/icons/callouts/1.png)

| 

The `my_float` field is added as a [`double`](number.html "Numeric datatypes") field.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `my_integer` field is added as a [`long`](number.html "Numeric datatypes") field. 
