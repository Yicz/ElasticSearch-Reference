## Split Processor

Splits a field into an array using a separator character. Only works on string fields.

 **Table 30. Split Options**

Name |  Required |  Default |  Description  
---|---|---|---  
`field`| yes| -| The field to split    
`separator`| yes| -| A regex which matches the separator, eg `,` or `\s+`    
`ignore_missing`| no| `false`| If `true` and `field` does not exist, the processor quietly exits without modifying the document  
  
  

    
    
    {
      "split": {
        "field": "my_field",
        "separator": "\\s+" #1
      }
    }

#1| Treat all consecutive whitespace characters as a single separator     
---|---
