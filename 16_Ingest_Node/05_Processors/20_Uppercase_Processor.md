## Uppercase Processor

Converts a string to its uppercase equivalent.

 **Table 33. Uppercase Options**

Name |  Required |  Default |  Description  
---|---|---|---  
`field`| yes| -| The field to make uppercase    
`ignore_missing`| no| `false`| If `true` and `field` does not exist or is `null`, the processor quietly exits without modifying the document  
  
  

    
    
    {
      "uppercase": {
        "field": "foo"
      }
    }
