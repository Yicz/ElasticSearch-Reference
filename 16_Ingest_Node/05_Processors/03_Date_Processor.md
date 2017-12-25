## Date Processor

Parses dates from fields, and then uses the date or timestamp as the timestamp for the document. By default, the date processor adds the parsed date as a new field called `@timestamp`. You can specify a different field by setting the `target_field` configuration parameter. Multiple date formats are supported as part of the same date processor definition. They will be used sequentially to attempt parsing the date field, in the same order they were defined as part of the processor definition.

 **Table 16. Date options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`field`

| 

yes

| 

-

| 

The field to get the date from.  
  
`target_field`

| 

no

| 

@timestamp

| 

The field that will hold the parsed date.  
  
`formats`

| 

yes

| 

-

| 

An array of the expected date formats. Can be a Joda pattern or one of the following formats: ISO8601, UNIX, UNIX_MS, or TAI64N.  
  
`timezone`

| 

no

| 

UTC

| 

The timezone to use when parsing the date.  
  
`locale`

| 

no

| 

ENGLISH

| 

The locale to use when parsing the date, relevant when parsing month names or week days.  
  
  


Here is an example that adds the parsed date to the `timestamp` field based on the `initial_date` field:
    
    
    {
      "description" : "...",
      "processors" : [
        {
          "date" : {
            "field" : "initial_date",
            "target_field" : "timestamp",
            "formats" : ["dd/MM/yyyy hh:mm:ss"],
            "timezone" : "Europe/Amsterdam"
          }
        }
      ]
    }