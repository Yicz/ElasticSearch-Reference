## KV Processor

This processor helps automatically parse messages (or specific event fields) which are of the foo=bar variety.

For example, if you have a log message which contains `ip=1.2.3.4 error=REFUSED`, you can parse those automatically by configuring:
    
    
    {
      "kv": {
        "field": "message",
        "field_split": " ",
        "value_split": "="
      }
    }

 **Table 24. Kv Options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`field`

| 

yes

| 

-

| 

The field to be parsed  
  
`field_split`

| 

yes

| 

-

| 

Regex pattern to use for splitting key-value pairs  
  
`value_split`

| 

yes

| 

-

| 

Regex pattern to use for splitting the key from the value within a key-value pair  
  
`target_field`

| 

no

| 

`null`

| 

The field to insert the extracted keys into. Defaults to the root of the document  
  
`include_keys`

| 

no

| 

`null`

| 

List of keys to filter and insert into document. Defaults to including all keys  
  
`ignore_missing`

| 

no

| 

`false`

| 

If `true` and `field` does not exist or is `null`, the processor quietly exits without modifying the document  
  
  

