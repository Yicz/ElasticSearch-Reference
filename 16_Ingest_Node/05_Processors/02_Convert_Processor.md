## Convert Processor

Converts an existing field’s value to a different type, such as converting a string to an integer. If the field value is an array, all members will be converted.

The supported types include: `integer`, `float`, `string`, `boolean`, and `auto`.

Specifying `boolean` will set the field to true if its string value is equal to `true` (ignore case), to false if its string value is equal to `false` (ignore case), or it will throw an exception otherwise.

Specifying `auto` will attempt to convert the string-valued `field` into the closest non-string type. For example, a field whose value is `"true"` will be converted to its respective boolean type: `true`. And a value of `"242.15"` will "automatically" be converted to `242.15` of type `float`. If a provided field cannot be appropriately converted, the Convert Processor will still process successfully and leave the field value as-is. In such a case, `target_field` will still be updated with the unconverted field value.

 **Table 15. Convert Options**

Name |  Required |  Default |  Description  
---|---|---|---  
`field`| yes| -| The field whose value is to be converted    
`target_field`| no| `field`| The field to assign the converted value to, by default `field` is updated in-place    
`type`| yes| -| The type to convert the existing value to    
`ignore_missing`| no| `false`| If `true` and `field` does not exist or is `null`, the processor quietly exits without modifying the document  
  
  

    
    
    {
      "convert": {
        "field" : "foo",
        "type": "integer"
      }
    }
