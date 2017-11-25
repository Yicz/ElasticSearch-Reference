## Modifying Your Data

Elasticsearch provides data manipulation and search capabilities in near real time. By default, you can expect a one second delay (refresh interval) from the time you index/update/delete your data until the time that it appears in your search results. This is an important distinction from other platforms like SQL wherein data is immediately available after a transaction is completed.

### Indexing/Replacing Documents

We’ve previously seen how we can index a single document. Let’s recall that command again:
    
    
    PUT /customer/external/1?pretty
    {
      "name": "John Doe"
    }

Again, the above will index the specified document into the customer index, external type, with the ID of 1. If we then executed the above command again with a different (or same) document, Elasticsearch will replace (i.e. reindex) a new document on top of the existing one with the ID of 1:
    
    
    PUT /customer/external/1?pretty
    {
      "name": "Jane Doe"
    }

The above changes the name of the document with the ID of 1 from "John Doe" to "Jane Doe". If, on the other hand, we use a different ID, a new document will be indexed and the existing document(s) already in the index remains untouched.
    
    
    PUT /customer/external/2?pretty
    {
      "name": "Jane Doe"
    }

The above indexes a new document with an ID of 2.

When indexing, the ID part is optional. If not specified, Elasticsearch will generate a random ID and then use it to index the document. The actual ID Elasticsearch generates (or whatever we specified explicitly in the previous examples) is returned as part of the index API call.

This example shows how to index a document without an explicit ID:
    
    
    POST /customer/external?pretty
    {
      "name": "Jane Doe"
    }

Note that in the above case, we are using the `POST` verb instead of PUT since we didn’t specify an ID.
