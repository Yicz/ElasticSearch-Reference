## Gsub Processor

Converts a string field by applying a regular expression and a replacement. If the field is not a string, the processor will throw an exception.

 **Table 21. Gsub Options**

Name |  Required |  Default |  Description  
---|---|---|---  
`field`| yes| -| The field to apply the replacement to    
`pattern`| yes| -| The pattern to be replaced    
`replacement`| yes| -| The string to replace the matching patterns with  
  
  

    
    
    {
      "gsub": {
        "field": "field1",
        "pattern": "\.",
        "replacement": "-"
      }
    }
