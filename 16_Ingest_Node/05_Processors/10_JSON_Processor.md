## JSON Processor

Converts a JSON string into a structured JSON object.

 **Table 23. Json Options**

Name |  Required |  Default |  Description  
---|---|---|---    
`field`| yes| -| The field to be parsed    
`target_field`| no| `field`| The field to insert the converted structured object into    
`add_to_root`| no| false| Flag that forces the serialized json to be injected into the top level of the document. `target_field` must not be set when this option is chosen.  
  
  


Suppose you provide this configuration of the `json` processor:
    
    
    {
      "json" : {
        "field" : "string_source",
        "target_field" : "json_target"
      }
    }

If the following document is processed:
    
    
    {
      "string_source": "{\"foo\": 2000}"
    }

after the `json` processor operates on it, it will look like:
    
    
    {
      "string_source": "{\"foo\": 2000}",
      "json_target": {
        "foo": 2000
      }
    }

If the following configuration is provided, omitting the optional `target_field` setting:
    
    
    {
      "json" : {
        "field" : "source_and_target"
      }
    }

then after the `json` processor operates on this document:
    
    
    {
      "source_and_target": "{\"foo\": 2000}"
    }

it will look like:
    
    
    {
      "source_and_target": {
        "foo": 2000
      }
    }

This illustrates that, unless it is explicitly named in the processor configuration, the `target_field` is the same field provided in the required `field` configuration.
