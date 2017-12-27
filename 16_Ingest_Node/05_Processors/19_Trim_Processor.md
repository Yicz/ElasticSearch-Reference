## Trim Processor

Trims whitespace from field.

![Note](/images/icons/note.png)

This only works on leading and trailing whitespace.

 **Table 32. Trim Options**

Name |  Required |  Default |  Description  
---|---|---|---    
`field`| yes| -| The string-valued field to trim whitespace from    
`ignore_missing`| no| `false`| If `true` and `field` does not exist, the processor quietly exits without modifying the document  
  
  

    
    
    {
      "trim": {
        "field": "foo"
      }
    }
