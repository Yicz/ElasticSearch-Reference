## Append Processor

Appends one or more values to an existing array if the field already exists and it is an array. Converts a scalar to an array and appends one or more values to it if the field exists and it is a scalar. Creates an array containing the provided values if the field doesn’t exist. Accepts a single value or an array of values.

 **Table 14. Append Options**

Name |  Required |  Default |  Description  
---|---|---|---    
`field`| yes| -| The field to be appended to    
`value`| yes| -| The value to be appended  
  
  

    
    
    {
      "append": {
        "field": "field1"
        "value": ["item2", "item3", "item4"]
      }
    }
