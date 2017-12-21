## Sort Processor

Sorts the elements of an array ascending or descending. Homogeneous arrays of numbers will be sorted numerically, while arrays of strings or heterogeneous arrays of strings + numbers will be sorted lexicographically. Throws an error when the field is not an array.

 **Table 31. Sort Options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`field`

| 

yes

| 

-

| 

The field to be sorted  
  
`order`

| 

no

| 

`"asc"`

| 

The sort order to use. Accepts `"asc"` or `"desc"`.  
  
  

    
    
    {
      "sort": {
        "field": "field_to_sort",
        "order": "desc"
      }
    }
