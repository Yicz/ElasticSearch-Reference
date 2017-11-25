## Set Processor

Sets one field and associates it with the specified value. If the field already exists, its value will be replaced with the provided one.

 **Table 29. Set Options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`field`

| 

yes

| 

-

| 

The field to insert, upsert, or update  
  
`value`

| 

yes

| 

-

| 

The value to be set for the field  
  
`override`

| 

no

| 

true

| 

If processor will update fields with pre-existing non-null-valued field. When set to `false`, such fields will not be touched.  
  
  

    
    
    {
      "set": {
        "field": "field1",
        "value": 582.1
      }
    }
