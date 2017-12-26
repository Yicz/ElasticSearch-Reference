## Join Processor

Joins each element of an array into a single string using a separator character between each element. Throws an error when the field is not an array.

 **Table 22. Join Options**

Name |  Required |  Default |  Description  
---|---|---|---  
`field`| yes| -| The field to be separated  
`separator`| yes| -| The separator character  
  
  

    
    
    {
      "join": {
        "field": "joined_array_field",
        "separator": "-"
      }
    }
