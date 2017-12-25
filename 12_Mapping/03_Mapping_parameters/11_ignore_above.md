## `ignore_above`

Strings longer than the `ignore_above` setting will not be indexed or stored.
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "message": {
              "type": "keyword",
              "ignore_above": 20 ![](images/icons/callouts/1.png)
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1 ![](images/icons/callouts/2.png)
    {
      "message": "Syntax error"
    }
    
    PUT my_index/my_type/2 ![](images/icons/callouts/3.png)
    {
      "message": "Syntax error with some long stacktrace"
    }
    
    GET _search ![](images/icons/callouts/4.png)
    {
      "aggs": {
        "messages": {
          "terms": {
            "field": "message"
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

This field will ignore any string longer than 20 characters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This document is indexed successfully.   
  
![](images/icons/callouts/3.png)

| 

This document will be indexed, but without indexing the `message` field.   
  
![](images/icons/callouts/4.png)

| 

Search returns both documents, but only the first is present in the terms aggregation.   
  
![Tip](images/icons/tip.png)

The `ignore_above` setting is allowed to have different settings for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html).

This option is also useful for protecting against Lucene’s term byte-length limit of `32766`.

![Note](images/icons/note.png)

The value for `ignore_above` is the _character count_ , but Lucene counts bytes. If you use UTF-8 text with many non-ASCII characters, you may want to set the limit to `32766 / 3 = 10922` since UTF-8 characters may occupy at most 3 bytes.
