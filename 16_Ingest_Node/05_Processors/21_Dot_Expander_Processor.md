## Dot Expander Processor

Expands a field with dots into an object field. This processor allows fields with dots in the name to be accessible by other processors in the pipeline. Otherwise these <<accessing-data-in-pipelines,fields> can’t be accessed by any processor.

 **Table 34. Dot Expand Options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`field`

| 

yes

| 

-

| 

The field to expand into an object field  
  
`path`

| 

no

| 

-

| 

The field that contains the field to expand. Only required if the field to expand is part another object field, because the `field` option can only understand leaf fields.  
  
  

    
    
    {
      "dot_expander": {
        "field": "foo.bar"
      }
    }

For example the dot expand processor would turn this document:
    
    
    {
      "foo.bar" : "value"
    }

into:
    
    
    {
      "foo" : {
         "bar" : "value"
      }
    }

If there is already a `bar` field nested under `foo` then this processor merges the the `foo.bar` field into it. If the field is a scalar value then it will turn that field into an array field.

For example, the following document:
    
    
    {
      "foo.bar" : "value2",
      "foo" : {
        "bar" : "value1"
      }
    }

is transformed by the `dot_expander` processor into:
    
    
    {
      "foo" : {
        "bar" : ["value1", "value2"]
      }
    }

If any field outside of the leaf field conflicts with a pre-existing field of the same name, then that field needs to be renamed first.

Consider the following document:
    
    
    {
      "foo": "value1",
      "foo.bar": "value2"
    }

Then the the `foo` needs to be renamed first before the `dot_expander` processor is applied. So in order for the `foo.bar` field to properly be expanded into the `bar` field under the `foo` field the following pipeline should be used:
    
    
    {
      "processors" : [
        {
          "rename" : {
            "field" : "foo",
            "target_field" : "foo.bar""
          }
        },
        {
          "dot_expander": {
            "field": "foo.bar"
          }
        }
      ]
    }

The reason for this is that Ingest doesn’t know how to automatically cast a scalar field to an object field.
