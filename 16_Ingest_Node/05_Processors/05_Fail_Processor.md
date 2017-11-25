## Fail Processor

Raises an exception. This is useful for when you expect a pipeline to fail and want to relay a specific message to the requester.

 **Table 18. Fail Options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`message`

| 

yes

| 

-

| 

The error message of the `FailException` thrown by the processor  
  
  

    
    
    {
      "fail": {
        "message": "an error message"
      }
    }
