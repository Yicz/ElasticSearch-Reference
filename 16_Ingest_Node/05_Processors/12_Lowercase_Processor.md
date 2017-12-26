## Lowercase Processor

Converts a string to its lowercase equivalent.

 **Table 25. Lowercase Options**

Name |  Required |  Default |  Description  
---|---|---|---    
`field`| yes| -| The field to make lowercase    
`ignore_missing`| no| `false`| If `true` and `field` does not exist or is `null`, the processor quietly exits without modifying the document  
  
  

    
    
    {
      "lowercase": {
        "field": "foo"
      }
    }
