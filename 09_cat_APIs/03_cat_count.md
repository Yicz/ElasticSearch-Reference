## cat count

`count` provides quick access to the document count of the entire cluster, or individual indices.
    
    
    GET /_cat/count?v

Looks like:
    
    
    epoch      timestamp count
    1475868259 15:24:19  121

Or for a single index:
    
    
    GET /_cat/count/twitter?v
    
    
    epoch      timestamp count
    1475868259 15:24:20  120

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

The document count indicates the number of live documents and does not include deleted documents which have not yet been cleaned up by the merge process.
