## Rename Processor

Renames an existing field. If the field doesn’t exist or the new name is already used, an exception will be thrown.

 **Table 27. Rename Options**

Name |  Required |  Default |  Description  
---|---|---|---  
`field`| yes| -| The field to be renamed    
`target_field`| yes| -| The new name of the field    
`ignore_missing`| no| `false`| If `true` and `field` does not exist, the processor quietly exits without modifying the document  
  
  

    
    
    {
      "rename": {
        "field": "foo",
        "target_field": "foobar"
      }
    }
