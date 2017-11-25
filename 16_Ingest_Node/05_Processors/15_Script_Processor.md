## Script Processor

Allows inline, stored, and file scripts to be executed within ingest pipelines.

See [How to use scripts](modules-scripting-using.html "How to use scripts") to learn more about writing scripts. The Script Processor leverages caching of compiled scripts for improved performance. Since the script specified within the processor is potentially re-compiled per document, it is important to understand how script caching works. To learn more about caching see [Script Caching](modules-scripting-using.html#modules-scripting-using-caching "Script Cachingedit").

 **Table 28. Script Options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`lang`

| 

no

| 

"painless"

| 

The scripting language  
  
`file`

| 

no

| 

-

| 

The script file to refer to  
  
`id`

| 

no

| 

-

| 

The stored script id to refer to  
  
`inline`

| 

no

| 

-

| 

An inline script to be executed  
  
`params`

| 

no

| 

-

| 

Script Parameters  
  
  


One of `file`, `id`, `inline` options must be provided in order to properly reference a script to execute.

You can access the current ingest document from within the script context by using the `ctx` variable.

The following example sets a new field called `field_a_plus_b_times_c` to be the sum of two existing numeric fields `field_a` and `field_b` multiplied by the parameter param_c:
    
    
    {
      "script": {
        "lang": "painless",
        "inline": "ctx.field_a_plus_b_times_c = (ctx.field_a + ctx.field_b) * params.param_c",
        "params": {
          "param_c": 10
        }
      }
    }
